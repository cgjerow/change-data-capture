@isTest
public class DeleteDataCaptureTest
{
    public static Map<Id,SObject_Capture__e> events;

    private static Integer count = 20;

    @isTest
    static void buildDeleteAndMergeEvents()
    {
        SObjectFactory.create(EnableOutboundPlatformEvents__c.sObjectType);

        Map<Id,SObject> sObjects = new Map<Id,SObject>();
        sObjects.putAll(
            SObjectFactory.build(Account.sObjectType, count, new Map<SObjectField,Object>{
                Account.Id => SObjectFactory.provideDummyId(Account.sObjectType)
            })
        );
        sObjects.putAll(
            SObjectFactory.build(Clinic_Location__c.sObjectType, count, new Map<SObjectField,Object>{
                Clinic_Location__c.Clinic__c => SObjectFactory.provideDummyId(Account.sObjectType),
                Clinic_Location__c.Id => SObjectFactory.provideDummyId(Clinic_Location__c.sObjectType),
                Clinic_Location__c.MasterRecordId__c => SObjectFactory.provideDummyId(Clinic_Location__c.sObjectType)
            })
        );

        ChangeDataCapture cdc = new DeleteDataCapture(sObjects).createEvents();

        Integer validEvents = 0;
        for (SObject_Capture__e event : events.values())
        {
            System.debug(event);
            if (event.Entity_Name__c=='Account' && !event.Payload__c.contains('MasterRecordId'))
                validEvents++;
            else if (event.Entity_Name__c=='Clinic_Location__c' && event.Payload__c.contains('MasterRecordId'))
                validEvents++;
        }

        System.assertEquals(count*2, validEvents, 'Not all events meet validation criteria.');
        System.assertEquals(count*2, cdc.getResults().size(), 'Incorrect save results list size. Not enough events published.');
    }
}