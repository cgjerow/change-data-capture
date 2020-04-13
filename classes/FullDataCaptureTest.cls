@isTest
public class FullDataCaptureTest
{
    public static Map<Id,SObject_Capture__e> events;

    private static Integer count = 20;

    @isTest
    static void buildEvents()
    {
        SObjectFactory.create(EnableOutboundPlatformEvents__c.sObjectType);

        Map<Id,Account> accounts = new Map<Id,Account>( (List<Account>)SOBjectFactory.build(Account.sObjectType, count, new Map<SObjectField,Object>{
            Account.Id => SObjectFactory.provideDummyId(Account.sObjectType)
        }));

        ChangeDataCapture cdc = new FullDataCapture(
            accounts, 
            (ChangeDataCaptureType)MockProvider.createMock(
                ChangeDataCaptureType.class,
                new Map<String,Object>{'getChangeType' => 'Insert'})
            );
        cdc.buildEvents();
        Database.SaveResult[] noResuls = cdc.getResults();
        Database.SaveResult[] results = cdc.createEvents().getResults();

        Integer successCount = 0;
        for (Database.SaveResult result : results)
        {
            if (result.isSuccess())
                successCount ++;
        }
        
        System.assertEquals(0, noResuls.size());
        System.assertEquals(count, results.size());
        System.assertEquals(count, successCount);
        System.assertEquals(count, events.size());
    }
}
