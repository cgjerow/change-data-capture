@isTest
public class DiffDataCaptureTest
{
    public static Map<Id, SObject_Capture__e> events;
    private static Integer count = 20;

    @isTest
    static void buildEvents()
    {
        SObjectFactory.create(EnableOutboundPlatformEvents__c.sObjectType);
        Map<Id,SObject> before = new Map<Id,SObject>(
            SObjectFactory.build(Account.sObjectType, count, new Map<SObjectField,Object>{
                Account.Id => SObjectFactory.provideDummyId(Account.sObjectType),
                Account.Name => 'Before'
            })
        );
        Map<Id,SObject> after = before.deepClone();
        for (Account a : (List<Account>)after.values())
            a.Name = 'After';

        ChangeDataCapture cdc = new DiffDataCapture(before, after).createEvents();

        Integer validEvents = 0;
        for (SObject_Capture__e event : events.values())
        {
            if (event.Payload__c.contains('Name'))
                validEvents++;
        }

        System.assertEquals(count, validEvents, 'Events did not meet validations.');
        System.assertEquals(count, cdc.getResults().size(), 'Incorrect number of save results. Not all events published.');
    }

    @isTest
    static void checkMapsWithoutMatchingRecords()
    {
        SObjectFactory.create(EnableOutboundPlatformEvents__c.sObjectType);
        Map<Id,SObject> before = new Map<Id,SObject>();
        Map<Id,SObject> after = new Map<Id,SObject>();

        Integer i = 0;
        for (SObject acc : SObjectFactory.build(Account.sObjectType, count*2, new Map<SObjectField,Object>{
                Account.Id => SObjectFactory.provideDummyId(Account.sObjectType),
                Account.Name => 'Before'
            }))
        {
            if (i<count)
                before.put(acc.Id, acc);
            else 
                after.put(acc.Id, acc);
            i++;
        }

        System.debug(before.keySet());
        System.debug(after.keySet());

        ChangeDataCapture cdc = new DiffDataCapture(before, after).createEvents();

        System.assertEquals(0, cdc.getResults().size(), 'No events should be generated');
    }
}