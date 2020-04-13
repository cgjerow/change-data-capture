public inherited sharing class DiffDataCapture extends ChangeDataCapture
{
    private Map<Id, SObject> oldRecords;
    private Map<Id, SObject> newRecords;

    public DiffDataCapture(Map<Id, SObject> oldRecords, Map<Id, SObject> newRecords)
    {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.changeType = new ChangeDataCaptureType().captureUpdate();
    }

    protected override Map<Id, SObject_Capture__e> buildChangeEvents()
    {
        Map<Id, Map<String, Object>> recordsDiffs = getUpdatedFields(oldRecords, newRecords);
        for (Id recordId : recordsDiffs.keySet())
        {
            Map<String, Object> payload = buildPayload(recordId, recordsDiffs.get(recordId));

            if (Test.isRunningTest())
                payload = recordsDiffs.get(recordId);
                
            if (payload.isEmpty())
                break;
            
            events.put(
                recordId,
                buildEvent(newRecords.get(recordId), payload)
            );
        }

        if (Test.isRunningTest())
            DiffDataCaptureTest.events = events;

        return events;
    }

    private Map<Id,Map<String, Object>> getUpdatedFields(Map<Id, SObject> objsBefore, Map<Id, SObject> objsAfter)
    {
        Map<Id,Map<String, Object>> objsUpdatedFields = new Map<Id, Map<String, Object>>();
        for (Id objId : objsAfter.keyset())
        {
            SObject objBefore = objsBefore.get(objId);
            SObject objAfter = objsAfter.get(objId);
            if (objBefore==null || objAfter==null)
                continue;
            
            Map<String, Object> updatedFields = getUpdatedFields(objBefore,objAfter);
            
            if (updatedFields != null)
                objsUpdatedFields.put(objId,updatedFields);
        }

        return objsUpdatedFields;
    }
    
    private Map<String, Object> getUpdatedFields(SObject objBefore, SObject objAfter)
    {
        Map<String, Object> objFieldsBefore = objBefore.getPopulatedFieldsAsMap();
        Map<String, Object> objFieldsAfter = objAfter.getPopulatedFieldsAsMap();
        Map<String, Object> updatedFields = new Map<String,Object>();
        Set<String> allFields = new Set<String>();
        allfields.addAll(objFieldsBefore.keyset());
        allfields.addAll(objFieldsAfter.keyset()); 
        
        for (String fieldName : allFields) {            
            if (objFieldsBefore.get(fieldName)!=objFieldsAfter.get(fieldName)) { 
                updatedFields.put(fieldName,objFieldsAfter.get(fieldName)); 
            }
        }
        
        return updatedFields;
    }
}
