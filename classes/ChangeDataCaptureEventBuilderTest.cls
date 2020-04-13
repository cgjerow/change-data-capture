@isTest
public class ChangeDataCaptureEventBuilderTest
{
    @isTest
    static void buildEvent()
    {
        Map<String,Object> payload = new Map<String,Object>{'key' => 'value'};
        SObject_Capture__e event = 
            new ChangeDataCaptureEventBuilder(SObjectFactory.build(Account.sObjectType))
            .setChangeType(
                (ChangeDataCaptureType) MockProvider.createMock(
                    ChangeDataCaptureType.class, 
                    new Map<String,Object>{'getChangeType' => 'Insert'}
            ))
            .setPayload(payload)
            .build();

        System.assertEquals('Insert', event.Change_Type__c);
        System.assertEquals('Account', event.Entity_Name__c);
        System.assertEquals(null, event.Record_Id__c);
        System.assertEquals(null, event.Commit_Timestamp__c);
        System.assertEquals(null, event.Commit_User__c);
        System.assertEquals(JSON.serialize(payload), event.Payload__c);
    }
}