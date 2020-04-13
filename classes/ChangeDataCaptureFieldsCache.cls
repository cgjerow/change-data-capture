public with sharing class ChangeDataCaptureFieldsCache {

    private static Map<SObjectType, Set<String>> whitelistedFields = new Map<SObjectType, Set<String>>();
    
    public static Set<String> getWhitelistedFields(SObjectType sObjectType)
    {
        if (whitelistedFields.get(sObjectType)==null)
            setWhitelistedFields(sObjectType);
        return whitelistedFields.get(sObjectType);
    }

    public static Map<SObjectType, Set<String>> getWhitelistedFields(Set<SObjectType> sObjectTypes)
    {
        Map<SObjectType, Set<String>> whitelistedFieldsMap = new Map<SObjectType, Set<String>>();
        for (SObjectType sObjectType : sObjectTypes)
            whitelistedFieldsMap.put(sObjectType, getWhitelistedFields(sObjectType));
        
        return whitelistedFieldsMap;
    }

    private static void setWhitelistedFields(SObjectType sObjectType)
    {
        Set<String> fields = new Set<String>();
        // Currently Set up to Pull in a single Field Set per object; 
        // however, this could be customized to be more dynamic
        Schema.FieldSet whitelistFieldSet = sObjectType.getDescribe().fieldSets.getMap().get('SObject_Capture_Event_Whitelist');
        
        if (whitelistFieldSet!=null)
        {
            for (Schema.FieldSetMember fsm : whitelistFieldSet.getFields())
                fields.add(fsm.getFieldPath());
        }

        whitelistedFields.put(sObjectType, fields);
    }
}
