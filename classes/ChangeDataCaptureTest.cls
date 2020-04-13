@isTest
public class ChangeDataCaptureTest 
{
    private static Integer count = 20;

    @isTest
    static void buildEvents()
    {
        SObjectFactory.create(EnableOutboundPlatformEvents__c.sObjectType);

        Map<Id,Account> accounts = new Map<Id,Account>( (List<Account>)SOBjectFactory.build(Account.sObjectType, count, new Map<SObjectField,Object>{
            Account.Id => SObjectFactory.provideDummyId(Account.sObjectType)
        }));

        ChangeDataCapture cdc = new BasicChangeDataCaptureTest(accounts);
        cdc.buildEvents();
        Database.SaveResult[] noResuls = cdc.getResults();
        Database.SaveResult[] results = cdc.createEvents().getResults();

        System.assertEquals(0, noResuls.size());
        System.assertEquals(count, results.size());
    }

    @isTest
    static void tryToBuildButDisabled()
    {
        Map<Id,Account> accounts = new Map<Id,Account>( (List<Account>)SOBjectFactory.build(Account.sObjectType, count, new Map<SObjectField,Object>{
            Account.Id => SObjectFactory.provideDummyId(Account.sObjectType)
        }));

        ChangeDataCapture cdc = new BasicChangeDataCaptureTest(accounts);
        cdc.buildEvents();
        Database.SaveResult[] noResuls = cdc.getResults();
        Database.SaveResult[] results = cdc.createEvents().getResults();

        System.assertEquals(0, noResuls.size());
        System.assertEquals(0, results.size());
    }

    private class BasicChangeDataCaptureTest extends ChangeDataCapture
    {
        Map<Id,SObject> records;

        public BasicChangeDataCaptureTest(Map<Id,SObject> records)
        {
            this.records = records;

            changeType = (ChangeDataCaptureType)MockProvider.createMock(
                ChangeDataCaptureType.class,
                new Map<String,Object>{'getChangeType' => 'Insert'});
        }

        protected override Map<Id,SObject_Capture__e> buildChangeEvents()
        {
            for (SObject record : records.values())
            {
                Map<String, Object> payload = buildPayload(record.Id, record.getPopulatedFieldsAsMap());
                events.put(
                    record.Id,
                    buildEvent(record, payload)
                );
            }
            return events;
        }
    }
}
