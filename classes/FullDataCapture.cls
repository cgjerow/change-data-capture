public inherited sharing class FullDataCapture extends ChangeDataCapture
{
    Map<Id, SObject> records;
    
    public FullDataCapture(Map<Id, SObject> records, ChangeDataCaptureType changeType)
    {
        this.records = records;
        this.changeType = changeType;
    }

    protected override Map<Id, SObject_Capture__e> buildChangeEvents()
    {
        for (SObject record : records.values())
        {
            Map<String, Object> payload = buildPayload(record.Id, record.getPopulatedFieldsAsMap());
            
            events.put(
                record.Id,
                buildEvent(record, payload)
            );
        }

        if (Test.isRunningTest())
            FullDataCaptureTest.events = events;

        return events;
    }
}
