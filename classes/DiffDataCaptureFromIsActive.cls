public inherited sharing class DiffDataCaptureFromIsActive extends ChangeDataCapture
{
    Map<Id, SObject> oldRecords;
    Map<Id, SObject> newRecords;

    public DiffDataCaptureFromIsActive(Map<Id, SObject> oldRecords, Map<Id, SObject> newRecords)
    {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
    }

    public override Map<Id, SObject_Capture__e> buildChangeEvents()
    {
        ActivationStatusSorter sorter = new ActivationStatusSorter(oldRecords, newRecords);

        if (!sorter.getNewActiveRecords().isEmpty() && !sorter.getOldActiveRecords().isEmpty())
            events.putAll( new DiffDataCapture(sorter.getOldActiveRecords(), sorter.getNewActiveRecords())
                .buildEvents() 
            );

        if (!sorter.getNewDeactivatedRecords().isEmpty())
            events.putAll( new DeleteDataCapture(sorter.getNewDeactivatedRecords()).buildEvents() );

        return events;
    }
}
