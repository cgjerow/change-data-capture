// EXAMPLE for how the ChangeDataCapture events can be built and published from a trigger

public inherited sharing class AccountTriggerHandler extends TriggerHandler
{
    private list<Account> oldList;
    private list<Account> newList;
    private map<id,Account> oldMap;
    private map<id,Account> newMap;

    public AccountTriggerHandler(List<Account> oldList, 
                                List<Account> newList, 
                                Map<Id,Account> oldMap, 
                                Map<Id,Account> newMap,
                                Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete,
                                Boolean isBefore, Boolean isAfter ) 
    {
        this.enabled = EnableTriggers__c.getOrgDefaults();
        System.debug(LoggingLevel.Info, 'Account Trigger ENABLED? ' + enabled.Enabled__c);

        this.oldList=oldList;
        this.newList=newList;
        this.oldMap=oldMap;
        this.newMap=newMap;
        this.isInsert=isInsert; 
        this.isUpdate=isUpdate; 
        this.isDelete=isDelete; 
        this.isUndelete=isUndelete;
        this.isBefore=isBefore; 
        this.isAfter=isAfter;
    }

    public override void afterInsert()
    {
        new FullDataCapture(newMap, new ChangeDataCaptureType().captureInsert())
            .createEvents();
    }

    public override void afterUpdate()
    {
        new DiffDataCaptureFromIsActive(oldMap, newMap).createEvents();
    }

    public override void afterDelete()
    {
        new DeleteDataCapture(oldMap).createEvents();
    }
}