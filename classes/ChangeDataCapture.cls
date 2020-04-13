public inherited sharing abstract class ChangeDataCapture
{
    protected Map<Id, SObject_Capture__e> events;
    protected ChangeDataCaptureType changeType;
    protected EnableOutboundPlatformEvents__c config;
    private Database.SaveResult[] results;

    public ChangeDataCapture()
    {
        config = EnableOutboundPlatformEvents__c.getOrgDefaults();
        events = new Map<Id, SObject_Capture__e>();
        results = results = new List<Database.SaveResult>();
        changeType = new ChangeDataCaptureType();
    }

    protected abstract Map<Id, SObject_Capture__e> buildChangeEvents();

    public Map<Id, SObject_Capture__e> buildEvents() 
    {
        if (!config.Enabled__c)
            return events;

        return buildChangeEvents();
    }

    public ChangeDataCapture publishEvents()
    {
        if (config.Enabled__c && events.size() > 0)
        {
            results = EventBus.publish(events.values());   
            IntegrationLogger.logPlatformEventError(results);
        }

        return this;
    }

    public ChangeDataCapture createEvents()
    {
        buildEvents();
        publishEvents();
        
        return this;
    }

    public Database.SaveResult[] getResults()
    {
        return results;
    }

    protected Map<String, Object> buildPayload(Id recordId, Map<String, Object> record)
    {
        Map<String, Object> payload = new Map<String, Object>();
        for (String field : ChangeDataCaptureFieldsCache.getWhitelistedFields(recordId.getSobjectType()))
        {
            if (record.containsKey(field))
                payload.put(field, record.get(field));
        }

        return payload;
    }

    protected SObject_Capture__e buildEvent(SObject record, Map<String, Object> payload)
    {
        return new ChangeDataCaptureEventBuilder(record)
            .setChangeType(changeType)
            .setPayload(payload)
            .build();
    }
}
