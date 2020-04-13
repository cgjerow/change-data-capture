public inherited sharing class DeleteDataCapture extends ChangeDataCapture
{
    private Map<Id, SObject> records;
    private Map<SObjectType, SObjectField> MasterRecordIdFieldCache = new Map<SObjectType, SObjectField>
        {
            Account.sObjectType => Account.MasterRecordId,
            Contact.sObjectType => Contact.MasterRecordId,
            Clinic_Location__c.sObjectType => Clinic_Location__c.MasterRecordId__c,
            HCP_Clinic_Location__c.sObjectType => HCP_Clinic_Location__c.MasterRecordId__c
        };

    public DeleteDataCapture(Map<Id, SObject> records)
    {
        this.records = records;
        this.changeType = new ChangeDataCaptureType().captureDelete();
    }

    protected override Map<Id, SObject_Capture__e> buildChangeEvents()
    {
        for (Id recordId : records.keySet())
        {
            Map<String, Object> payload = new Map<String, Object>();

            SObjectField masterRecordIdField = MasterRecordIdFieldCache.get(recordId.getSobjectType());
            if (masterRecordIdField!=null && records.get(recordId).get(masterRecordIdField)!=null)
                payload.put('MasterRecordId', records.get(recordId).get(masterRecordIdField));

            events.put(
                recordId,
                buildEvent(records.get(recordId), payload)
            );
        }

        if (Test.isRunningTest())
            DeleteDataCaptureTest.events = events;
        
        return events;
    }
}
