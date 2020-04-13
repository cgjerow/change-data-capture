public inherited sharing class ChangeDataCaptureEventBuilder
{
    private SObject record;
    private Map<String,Object> payload = new Map<String,Object>();
    private ChangeDataCaptureType changeType = new ChangeDataCaptureType();

    public ChangeDataCaptureEventBuilder(SObject record)
    {
        this.record = record;
    }

    public ChangeDataCaptureEventBuilder setChangeType(ChangeDataCaptureType changeType)
    {
        this.changeType = changeType;
        return this;
    }

    public ChangeDataCaptureEventBuilder setPayload(Map<String, Object> payload)
    {
        this.payload = payload;
        return this;
    }

    public SObject_Capture__e build()
    {
        return new SObject_Capture__e(
            Record_Id__c = record.Id,
            Entity_Name__c = String.valueOf(record.getSObjectType()),
            Change_Type__c = changeType.getChangeType(),
            Commit_Timestamp__c = (DateTime)record.get('SystemModStamp'),
            Commit_User__c = (String)record.get('LastModifiedById'),
            Payload__c = JSON.serialize(payload)
        );
    }
}