public inherited sharing class ChangeDataCaptureType
{
    private static final String CAPTURE_INSERT = 'Insert';
    private static final String CAPTURE_UPDATE = 'Update';
    private static final String CAPTURE_DELETE = 'Delete';
    public static final String CAPTURE_RESYNC = 'Resync';

    private String changeType = '';

    public String getChangeType() {
        return changeType;
    }

    public ChangeDataCaptureType captureInsert()
    {
        changeType = CAPTURE_INSERT;
        return this;
    }

    public ChangeDataCaptureType captureUpdate()
    {
        changeType = CAPTURE_UPDATE;
        return this;
    }

    public ChangeDataCaptureType captureDelete()
    {
        changeType = CAPTURE_DELETE;
        return this;
    }

    public ChangeDataCaptureType captureResync()
    {
        changeType = CAPTURE_RESYNC;
        return this;
    }
}