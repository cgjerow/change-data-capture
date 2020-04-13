@isTest
public class ChangeDataCaptureTypeTest
{
    @isTest
    static void checkTypes()
    {
        ChangeDataCaptureType changeType =  new ChangeDataCaptureType();
        System.assertEquals('Insert', changeType.captureInsert().getChangeType());
        System.assertEquals('Update', changeType.captureUpdate().getChangeType());
        System.assertEquals('Delete', changeType.captureDelete().getChangeType());
        System.assertEquals('Resync', changeType.captureResync().getChangeType());
    }
}
