public class UploadRecordMatchingHouseHold{
    public static Account objHouse = new Account();
    public static String ProcessHousehold(WGBH_PB5_UPLOAD__c PB5){
        //String MatchingCriteria = 'ACCOUNT_ID_ARIA__c=PB5_ALT_ACCOUNT_ID_ARIA__c;ACCOUNT_ID_AUCTION__c=PB5_ALT_ACCOUNT_ID_AUCTION__c;ACCOUNT_ID_CARS__c=PB5_ALT_ACCOUNT_ID_CARS__c;ACCOUNT_ID_FDNDEV__c=PB5_ALT_ACCOUNT_ID_FDNDEV__c;ACCOUNT_ID_LOCKBOX__c=PB5_ALT_ACCOUNT_ID_LOCKBOX__c;ACCOUNT_ID_PBSD__c=PB5_ALT_ACCOUNT_ID_PBSD__c';
        String MatchingCriteria = 'UniqueID__c=PB5_SFDC_ID__c';
        List<sObject> lstTarget;
        lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Account',MatchingCriteria);
        if(lstTarget.size()==0){
            insertHousehold(PB5);
        }
        else if(lstTarget.size()==1){
            objHouse = (Account)lstTarget[0];
            updateHousehold(PB5);
        }
        else if(lstTarget.size()>1){
        }
        return String.valueOf(objHouse.Id);
    }
    public static boolean UpdateHousehold(WGBH_PB5_UPLOAD__c pb){
        boolean blnSuccess=false;        
        mapHouseholdField(pb);
        try{
            update objHouse;
            if(objHouse.Id != null && String.valueOf(objHouse.Id).length()>0)
                blnSuccess = true;
            else
                blnSuccess = false;
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
    }
    public static boolean InsertHousehold(WGBH_PB5_UPLOAD__c pb){
        boolean blnSuccess=false;
        mapHouseholdField(pb);
        try{
            insert objHouse;
            if(objHouse.Id != null && String.valueOf(objHouse.Id).length()>0)
                blnSuccess = true;
            else
                blnSuccess = false;
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
    }
    static string getValues(string val1, string val2){
        if(NVL(val1)=='')
            return NVL(val2);
        else
            return NVL(val1);
    }
    static string NVL(string val){
        if(val == null)
            return '';
        else
            return val.trim();
    }
    static ID getRecordTypeId(String developerName){
        ID recordTypeId = null;
        
        List<RecordType> lstRc = [Select Id, DeveloperName from RecordType Where DeveloperName =: DeveloperName];
        if(lstRc != null && lstRc.size()>0){
            recordTypeId = lstRc[0].Id;
        }
        return recordTypeId;
    }
    public static void mapHouseholdField(WGBH_PB5_UPLOAD__c pb){        
        objHouse.name = getValues(pb.PB5_FIRST_NAME__c, pb.PB5_FIRST_NAME_2__c) + ' ' + getValues(pb.PB5_LAST_NAME__c, pb.PB5_LAST_NAME_2__c);
        objHouse.recordTypeId = getRecordTypeId('Household');
        objHouse.MailingCity__c = pb.PB5_SHIP_TO_CITY__c;
        //objHouse.MailingCountry__c
        objHouse.MailingState__c = pb.PB5_SHIP_TO_STATE__c;
        objHouse.MailingStreet__c = pb.PB5_SHIP_TO_STREET_1__c;
        objHouse.MailingPostalCode__c = pb.PB5_SHIP_TO_ZIP_CODE__c;        
        return;
    }
    
    static testMethod void myTest() {
        WGBH_PB5_UPLOAD__c pb5 = new WGBH_PB5_UPLOAD__c();
        insert pb5;
        
        UploadRecordMatchingHouseHold.ProcessHousehold(pb5);
        UploadRecordMatchingHouseHold.UpdateHousehold(pb5);
        UploadRecordMatchingHouseHold.InsertHousehold(pb5);
        UploadRecordMatchingHouseHold.mapHouseholdField(pb5);



    }
    
}