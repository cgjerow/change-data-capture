@isTest
public class ChangeDataCaptureFieldsCacheTest 
{
    @isTest
    static void getFieldsForOneSObject()
    {
        Set<String> noFields = ChangeDataCaptureFieldsCache.getWhitelistedFields(Business_Unit__c.sObjectType);
        Set<String> accountFields = ChangeDataCaptureFieldsCache.getWhitelistedFields(Account.sObjectType);

        System.assertEquals(0,noFields.size());
        System.assertNotEquals(0,accountFields.size());
    }

    @isTest
    static void getFieldsForMultipleSObjects()
    {
        Map<SObjectType, Set<String>> fieldsMap = ChangeDataCaptureFieldsCache.getWhitelistedFields(
            new Set<SObjectType>{ Account.sObjectType, Business_Unit__c.sObjectType }
        );

        System.assertEquals(2,fieldsMap.size());
        System.assertEquals(0,fieldsMap.get(Business_Unit__c.sObjectType).size());
        System.assertNotEquals(0,fieldsMap.get(Account.sObjectType).size());
    }    
}
