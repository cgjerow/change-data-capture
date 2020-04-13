# change-data-capture
Custom Salesforce Change Data Capture solution leveraging Platform Events that allows for Whitelisting fields which trigger events

Includes an example for how to invoke the change data capture framework from Account trigger handler.

## Supports three major event types: Full Data Capture, Diff Data Capture, and Delete Data Capture.
### Full Data Capture
This event type will capture all whitelisted fields for a Record. Common use cases included: After Insert events & Resyncing Events

Example Invocations: 
```
new FullDataCapture(newMap, new ChangeDataCaptureType().captureInsert())
    .createEvents();
```
```
new FullDataCapture(
            new Map<Id,SObject>{ recordId => new ResyncSelector().selectRecord(recordId) },
            new ChangeDataCaptureType().captureResync()
        ).createEvents();
```
Note: SF Apex does not support enums with reserved keywords as values. The ChangeDataCaptureType() class is a common workaround for this Enum limitation.

### Diff Data Capture
This event type will capture only the whitelisted fields which have changed. Common use case: After Update events

Example Invocation: 
```
new DiffDataCaptureFromIsActive(oldMap, newMap).createEvents();
```

### Delete Data Capture
This event type will capture metadata about the record (including: record Id, deletion datetime, etc.), but does not include any other whitelisted field information. Common use case: ... you get the idea :) 
```
new DeleteDataCapture(oldMap).createEvents();
```
