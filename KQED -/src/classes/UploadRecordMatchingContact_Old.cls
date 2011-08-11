public class UploadRecordMatchingContact_Old{
    public static void ProcessContact(WGBH_PB5_UPLOAD__c PB5){
        List<sObject> lstTarget;
        UploadRecordMatchingProcess__c csMatchingFields = UploadRecordMatchingProcess__c.getOrgDefaults();
        system.debug('########################' + csMatchingFields);
        String MatchingCriteria;
        if(csMatchingFields != null)
            MatchingCriteria = csMatchingFields.Matching_Criteria__c;
        else
            MatchingCriteria = 'LastName=PB5_LAST_NAME__c,Email=PB5_EMAIL_ADDRESS_1__c;FirstName=PB5_FIRST_NAME__c,LastName=PB5_LAST_NAME__c,MailingStreet=PB5_SHIP_TO_STREET_1__c,MailingCity=PB5_SHIP_TO_CITY__c,MailingState=PB5_SHIP_TO_STATE__c,MailingPostalCode=PB5_SHIP_TO_ZIP_CODE__c';
        lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
        ProcessContact(PB5, lstTarget, '1');
        if(csMatchingFields != null)
            MatchingCriteria = csMatchingFields.Contact_Matching_Criteria_2__c;
        else
            MatchingCriteria = 'LastName=PB5_LAST_NAME_2__c,Email=PB5_EMAIL_ADDRESS_2__c;FirstName=PB5_FIRST_NAME_2__c,LastName=PB5_LAST_NAME_2__c,MailingStreet=PB5_STREET_1__c,MailingCity=PB5_CITY__c,MailingState=PB5_STATE__c,MailingPostalCode=PB5_ZIP_CODE__c';
        lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
        ProcessContact(PB5, lstTarget, '1');
    }
    public static void ProcessContact(WGBH_PB5_UPLOAD__c PB5,List<sObject> lstTarget, String flag){
        //List<sObject> lstTarget = getMatchingRows(PB5,'Contact');
        if(lstTarget.size()==0){//Contact Info not exist -> Create new contact
            //insert Contact
            if(InsertContact(PB5, flag)==true){
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'B';
            }
            else{
                PB5.Flag_for_Review__c = true;
                PB5.PB5_Stage__c = 'A';
            }
        }
        else if(lstTarget.size()==1){//Contact Info Exists -> Apend data to existing contact
            //update Contact
            if(UpdateContact((Contact) lstTarget[0], PB5, flag)==true){
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'B';
            }
            else{
                PB5.Flag_for_Review__c = true;
                PB5.PB5_Stage__c = 'A';
            }
        }
        else if(lstTarget.size()>1){//Multiple Contact found
            //multiple matches found
            String duplicateId='';
            for(sObject t:lstTarget){
                if(duplicateId.length()==0)
                    duplicateId = String.valueOf(t.get('Id'));// + '#' + String.valueOf(t.get('name'));
                else
                    duplicateId += +', ' + String.valueOf(t.get('Id'));// + '#' + String.valueOf(t.get('name'));                        
            }
            PB5.SF_Duplicate_ID__c = duplicateId;
            PB5.Flag_for_Review__c = true;
            PB5.Flag_Review_Reason__c = 'MORE THAN 1 MATCH';
        }
        Update PB5;    
    }
    
    public static boolean InsertContact(WGBH_PB5_UPLOAD__c pb, String flag){
        boolean blnSuccess=false;
        Contact objContact = new Contact();
        objContact = mapContactField(pb, flag);
        try{
            insert objContact;
            if(objContact.Id != null && String.valueOf(objContact.Id).length()>0)
                blnSuccess = true;
            else
                blnSuccess = false;
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
    }
    public static boolean UpdateContact(Contact objContact, WGBH_PB5_UPLOAD__c pb, String flag){
        boolean blnSuccess=false;        
        objContact = mapContactField(pb, flag);
        try{
            update objContact;
            if(objContact.Id != null && String.valueOf(objContact.Id).length()>0)
                blnSuccess = true;
            else
                blnSuccess = false;
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
    }
    
    public static Contact mapContactField(WGBH_PB5_UPLOAD__c pb, String flag){
        Contact objContact = new Contact();
        if(flag == '1'){
            objContact.FirstName = pb.PB5_FIRST_NAME__c;//PB5_FIRST_NAME_2__c
            objContact.LastName = pb.PB5_LAST_NAME__c;//PB5_LAST_NAME_2__c
            //objContact.MiddleName = pb.PB5_MIDDLE_NAME__c;//PB5_MIDDLE_NAME_2__c
            objContact.Email = pb.PB5_EMAIL_ADDRESS_1__c;//PB5_EMAIL_ADDRESS_2__c
            //objContact.DoNotCall = pb.PB5_NO_PHONE_PREFERRED__c;
            //objContact.WorkEmail__c = pb.PB5_EMAIL_ADDRESS_2__c;
            objContact.Salutation = pb.PB5_SUFFIX__c;//PB5_SUFFIX_2__c
            objContact.PreferredPhone__c = pb.PB5_TELEPHONE_TYPE_1__c;//PB5_TELEPHONE_TYPE_2__c
            objContact.Phone = pb.PB5_TELEPHONE_NUMBER_1__c;//PB5_TELEPHONE_NUMBER_2__c
            //objContact.OtherPhone = pb.PB5_TELEPHONE_NUMBER_2__c;
            objContact.MailingStreet = pb.PB5_SHIP_TO_STREET_1__c;//PB5_STREET_1__c
            objContact.MailingCity = pb.PB5_SHIP_TO_CITY__c;//PB5_CITY__c
            objContact.MailingState = pb.PB5_SHIP_TO_STATE__c;//PB5_STATE__c
            objContact.MailingPostalCode = pb.PB5_SHIP_TO_ZIP_CODE__c;//PB5_ZIP_CODE__c
        }else{
            objContact.FirstName = pb.PB5_FIRST_NAME_2__c;
            objContact.LastName = pb.PB5_LAST_NAME_2__c;
            //objContact.MiddleName = pb.PB5_MIDDLE_NAME__c;//PB5_MIDDLE_NAME_2__c;
            objContact.Email = pb.PB5_EMAIL_ADDRESS_2__c;
            //objContact.DoNotCall = pb.PB5_NO_PHONE_PREFERRED__c;
            //objContact.WorkEmail__c = pb.PB5_EMAIL_ADDRESS_2__c;
            objContact.Salutation = pb.PB5_SUFFIX_2__c;
            objContact.PreferredPhone__c = pb.PB5_TELEPHONE_TYPE_2__c;
            objContact.Phone = pb.PB5_TELEPHONE_NUMBER_2__c;
            //objContact.OtherPhone = pb.PB5_TELEPHONE_NUMBER_2__c;
            objContact.MailingStreet = pb.PB5_STREET_1__c;
            objContact.MailingCity = pb.PB5_CITY__c;
            objContact.MailingState = pb.PB5_STATE__c;
            objContact.MailingPostalCode = pb.PB5_ZIP_CODE__c;        
        }            
        return objContact;
    }
}