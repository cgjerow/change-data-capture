/**
 * Created by joannabak on 8/22/19.
 */

public with sharing class ResyncPEButton {

    @AuraEnabled
    public static void resyncButtonClick(Id recordId)
    {
        new FullDataCapture(
            new Map<Id,SObject>{ recordId => new ResyncSelector().selectRecord(recordId) },
            new ChangeDataCaptureType().captureResync()
        ).createEvents();
    }

    private without sharing class ResyncSelector
    {
        private SObject selectRecord(Id recordId)
        {
            String queryFormat = 'SELECT {0} FROM {1} WHERE Id = :recordId';
            List<String> queryFields = new List<String>();
            for (SObjectField fields : recordId.getSobjectType().getDescribe().fields.getMap().values())
                queryFields.add(fields.getDescribe().getName());
            
            return Database.query(
                String.format(
                    queryFormat,
                    new List<String>{ String.join(queryFields, ', '), String.valueOf(recordId.getSobjectType()) }
                )
            );
        }
    }

}