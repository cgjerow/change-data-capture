@isTest
public class DiffDataCaptureFromIsActiveTest
{
    private static Integer count = 20;

    @TestSetup
    static void makeData()
    {
        SObjectFactory.create(EnableOutboundPlatformEvents__c.sObjectType);
    }

    @isTest
    static void publishUpdatesAndDeletesFromUpdate()
    {
        Map<Id,SObject_Capture__e> updateEvents = 
        new DiffDataCaptureFromIsActive(buildMockAccounts('before',true),buildMockAccounts('after',true))
            .buildEvents();
        Integer validUpdateEvents = 0;
        for (SObject_Capture__e event : updateEvents.values())
            if (event.Change_Type__c == 'Update') validUpdateEvents++;

        System.assertEquals(count,validUpdateEvents,'Update events should be of size {count}');
    }

    @isTest
    static void publishUpdatesAndDeletesFromDelete()
    {
        Map<Id,SObject_Capture__e> deleteEvents =
        new DiffDataCaptureFromIsActive(buildMockAccounts('before',true),buildMockAccounts('after',false))
            .buildEvents();
        Integer validDeleteEvents = 0;
        for (SObject_Capture__e event : deleteEvents.values())
            if (event.Change_Type__c == 'Delete') validDeleteEvents++;
        System.assertEquals(count,validDeleteEvents,'Delete events should be of size {count}');
    }

    @isTest
    static void publishUpdatesAndDeletesFromInactive()
    {
        Map<Id,SObject_Capture__e> inactiveEvents =
        new DiffDataCaptureFromIsActive(buildMockAccounts('before',false),buildMockAccounts('after',false))
            .buildEvents();
        System.assertEquals(0,inactiveEvents.size(),'Inactive events should be empty');
    }

    private static Map<Id,Account> buildMockAccounts(String name, Boolean active)
    {
        return new Map<Id,Account>(
            (List<Account>) SObjectFactory.build(Account.sObjectType, count, new Map<SObjectField,Object>{
                Account.Id => SObjectFactory.provideDummyId(Account.sObjectType),
                Account.Name => name,
                Account.Is_Active__c => active
            })
        );
    }
}
