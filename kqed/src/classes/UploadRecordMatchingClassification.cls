public class UploadRecordMatchingClassification{
    public static void ProcessClassification(WGBH_PB5_UPLOAD__c PB5){
        List<sObject> lstTarget;
        List<Classification__c> lstClassification = new List<Classification__c>();
        List<Classification__c> lstInsert = new List<Classification__c>();
        List<Classification__c> lstUpdate = new List<Classification__c>();
        
        //UploadRecordMatchingProcess__c csMatchingFields = UploadRecordMatchingProcess__c.getOrgDefaults();
        //String MatchingCriteria = csMatchingFields.Matching_Criteria__c;
        //lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
        //ProcessContact(PB5, lstTarget, '1');
        //MatchingCriteria = csMatchingFields.Contact_Matching_Criteria_2__c;
        //lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
        //ProcessContact(PB5, lstTarget, '1');
        for(Integer i = 0; i < 10; i++){
            String MatchingCriteria = 'classification_code__c=PB5_CLASSIFICATION_CODE_' 
            + String.valueOf(i+1) 
            + '__c,classification_value__c=PB5_CLASSIFICATION_VALUE_' 
            + String.valueOf(i+1) + '__c';    
            lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Classification__c',MatchingCriteria);
            if(lstTarget.size()==0){
                //insert new
                lstInsert.addAll(mapClassificationField((sObject)PB5));
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'C';
            }            
            else if(lstTarget.size()==1){
                //update
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'C';
            }
            else if(lstTarget.size()>1){
                String duplicateId='';
                for(sObject t:lstTarget){
                    if(duplicateId.length()==0)
                        duplicateId = String.valueOf(t.get('Id')) + '#' + String.valueOf(t.get('name'));
                    else
                        duplicateId += +', ' + String.valueOf(t.get('Id')) + '#' + String.valueOf(t.get('name'));                        
                }
                PB5.SF_Duplicate_ID__c = duplicateId;
                PB5.Flag_for_Review__c = true;
                PB5.Flag_Review_Reason__c = 'MORE THAN 1 MATCH';                
            }
        }
        if(lstInsert.size()>0)
            insert lstInsert;
    }
    
    public static List<Classification__c> mapClassificationField(sObject pb){
        List<Classification__c> lstCls = new List<Classification__c>();
        Date startdate;
        Date enddate;
        for(integer i=1; i<=10; i++){
            Classification__c cls = new Classification__c();
            cls.active__c = true;
            cls.classification_code__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));
            //cls.Classification_Code_Value__c = String.valueOf(pb.get('PB5_CLASSIFICATION_VALUE_' + String.valueOf(i) + '__c')); //Lookup(Classification Code/Value) 
            //cls.classification_tabname__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));
            cls.classification_value__c = String.valueOf(pb.get('PB5_CLASSIFICATION_VALUE_' + String.valueOf(i) + '__c'));
            //cls.comments__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));
            //cls.Contact__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));            
            //cls.Household__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));
            //cls.Organization__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));
            //cls.record_seq__c = String.valueOf(pb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c'));
            startdate = Date.valueOf(pb.get('PB5_START_CDATE_' + String.valueOf(i) + '__c'));
            if(startdate == null)//If startdate null in upload data, apply current date as startdate.
                startdate = system.today();            
            cls.start_date__c = startdate;
            enddate = Date.valueOf(pb.get('PB5_END_CDATE_' + String.valueOf(i) + '__c'));
            if(enddate != null)
                cls.end_date__c = enddate;
            lstCls.add(cls);            
        }
        return lstCls;
    }
    
}