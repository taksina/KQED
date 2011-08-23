public class UploadRecordMatchingContact{
    public static void ProcessContact(WGBH_PB5_UPLOAD__c PB5, String HouseholdId){
        List<sObject> lstTarget;
        UploadRecordMatchingProcess__c csMatchingFields = UploadRecordMatchingProcess__c.getOrgDefaults();
        system.debug('########################' + csMatchingFields);
        String MatchingCriteria;
        //if(csMatchingFields != null)
        //    MatchingCriteria = csMatchingFields.Matching_Criteria__c;
        //else
        //    MatchingCriteria = 'LastName=PB5_LAST_NAME__c,Email=PB5_EMAIL_ADDRESS_1__c;FirstName=PB5_FIRST_NAME__c,LastName=PB5_LAST_NAME__c,MailingStreet=PB5_SHIP_TO_STREET_1__c,MailingCity=PB5_SHIP_TO_CITY__c,MailingState=PB5_SHIP_TO_STATE__c,MailingPostalCode=PB5_SHIP_TO_ZIP_CODE__c';
        //lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
        //ProcessContact(PB5, lstTarget, '1');
        /*
        if(csMatchingFields != null)
            MatchingCriteria = csMatchingFields.Contact_Matching_Criteria_2__c;
        else
            MatchingCriteria = 'LastName=PB5_LAST_NAME_2__c,Email=PB5_EMAIL_ADDRESS_2__c;FirstName=PB5_FIRST_NAME_2__c,LastName=PB5_LAST_NAME_2__c,MailingStreet=PB5_STREET_1__c,MailingCity=PB5_CITY__c,MailingState=PB5_STATE__c,MailingPostalCode=PB5_ZIP_CODE__c';
        */  
        MatchingCriteria = 'LastName=PB5_LAST_NAME__c,Email=PB5_EMAIL_ADDRESS_1__c;LastName=PB5_LAST_NAME_2__c,Email=PB5_EMAIL_ADDRESS_2__c;FirstName=PB5_FIRST_NAME__c,LastName=PB5_LAST_NAME__c,MailingStreet=PB5_STREET_1__c,MailingCity=PB5_CITY__c,MailingState=PB5_STATE__c,MailingPostalCode=PB5_ZIP_CODE__c;FirstName=PB5_FIRST_NAME_2__c,LastName=PB5_LAST_NAME_2__c,MailingStreet=PB5_STREET_1__c,MailingCity=PB5_CITY__c,MailingState=PB5_STATE__c,MailingPostalCode=PB5_ZIP_CODE__c';            
        system.debug('################ MatchingCriteria ' + MatchingCriteria);
        lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
        ProcessContact(PB5, lstTarget,HouseholdId, '2');
    }
    public static void ProcessContact(WGBH_PB5_UPLOAD__c PB5,List<sObject> lstTarget, String HouseholdId, String flag){
        //List<sObject> lstTarget = getMatchingRows(PB5,'Contact');
        if(lstTarget.size()==0){//Contact Info not exist -> Create new contact
            //insert Contact
            if(InsertContact(PB5, flag, HouseholdId)==true){
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'B';
                PB5.PB5_IS_PROCESSED__c = true;
                PB5.PB5_IS_NEW__c = false;
            }
            else{
                PB5.Flag_for_Review__c = true;
                PB5.PB5_Stage__c = 'A';
                PB5.PB5_IS_PROCESSED__c = false;
                PB5.PB5_IS_NEW__c = true;
            }
        }
        else if(lstTarget.size()==1){//Contact Info Exists -> Apend data to existing contact
            //update Contact
            if(UpdateContact((Contact) lstTarget[0], PB5, flag,HouseholdId)==true){
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'B';
                PB5.PB5_IS_PROCESSED__c = true;
                PB5.PB5_IS_NEW__c = false;
            }
            else{
                PB5.Flag_for_Review__c = true;
                PB5.PB5_Stage__c = 'A';
                PB5.PB5_IS_PROCESSED__c = false;
                PB5.PB5_IS_NEW__c = true;
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
            //PB5.SF_Duplicate_ID__c = duplicateId;
            PB5.Flag_for_Review__c = true;
            PB5.PB5_IS_PROCESSED__c = false;
            PB5.PB5_IS_NEW__c = true;
            PB5.Flag_Review_Reason__c = 'MORE THAN 1 MATCH';
        }
        Update PB5;    
    }
    
    public static boolean InsertContact(WGBH_PB5_UPLOAD__c pb, String flag, String HouseholdId){
        boolean blnSuccess=false;
        Contact objContact = new Contact();
        objContact = mapContactField(pb, flag);
        try{
            system.debug('########## Contact to Insert : ' + objContact);
            objContact.AccountId = HouseholdId;
            insert objContact;
            if(objContact.Id != null && String.valueOf(objContact.Id).length()>0){
                blnSuccess = true;
                Address__c objAdd = new Address__c();
                objAdd.Address_Type__c = NVL(pb.PB5_ADDRESS_TYPE__c);
                objAdd.Street_1__c = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
                objAdd.Street_2__c = getValues(pb.PB5_EXTRA_LINE_1__c, pb.PB5_SHIP_TO_EXTRA_LINE_1__c);
                objAdd.City__c = getValues(pb.PB5_CITY__c, pb.PB5_SHIP_TO_CITY__c);
                objAdd.State__c = getValues(pb.PB5_STATE__c, pb.PB5_SHIP_TO_STATE__c);
                objAdd.Postal_Code__c = getValues(pb.PB5_ZIP_CODE__c, pb.PB5_SHIP_TO_ZIP_CODE__c);
                objAdd.Country__c = NVL(pb.PB5_COUNTRY__c);    
                objAdd.Contact__c = objContact.Id;
                objAdd.Account_Household__c = HouseholdId;   
                Insert objAdd;      
                //processClassification(pb, objContact.Id, householdId);   
            }
            else{
                blnSuccess = false;
            }
            UploadRecordMatchingGiving.processGiving(pb, objContact.Id, householdId);
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
    }
    public static boolean UpdateContact(Contact objContact, WGBH_PB5_UPLOAD__c pb, String flag, string householdid){
        boolean blnSuccess=false;        
        //objContact = mapContactField(pb, flag);
        objContact.FirstName = getValues(pb.PB5_FIRST_NAME__c, pb.PB5_FIRST_NAME_2__c);
        objContact.LastName = getValues(pb.PB5_LAST_NAME__c, pb.PB5_LAST_NAME_2__c);
        //objContact.MiddleName = getValues(pb.PB5_MIDDLE_NAME__c, pb.PB5_MIDDLE_NAME__c);
        
        //objContact.DoNotCall = getValues(pb.PB5_NO_PHONE_PREFERRED__c, pb.PB5_NO_PHONE_PREFERRED__c);
        //objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_2__c, pb.PB5_EMAIL_ADDRESS_2__c);
        objContact.Salutation = getValues(pb.PB5_SUFFIX__c, pb.PB5_SUFFIX_2__c);
        objContact.PreferredPhone__c = getValues(pb.PB5_TELEPHONE_TYPE_1__c, pb.PB5_TELEPHONE_TYPE_2__c);
        if(NVL(objContact.PreferredPhone__c) == 'H' || NVL(objContact.PreferredPhone__c) == 'Home'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        if(NVL(objContact.PreferredPhone__c) == 'W' || NVL(objContact.PreferredPhone__c) == 'Work'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        objContact.Preferred_Email__c = NVL(pb.PB5_EMAIL_TYPE_2__c);
        if(NVL(objContact.Preferred_Email__c) == 'Work'){
            objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Home'){
            objContact.HomeEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Assistant'){
            objContact.Assistant_Email__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Default Email'){
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else{
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        objContact.Phone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        //objContact.OtherPhone = getValues(pb.PB5_TELEPHONE_NUMBER_2__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        objContact.MailingStreet = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
        objContact.MailingCity = getValues(pb.PB5_SHIP_TO_CITY__c, pb.PB5_CITY__c);
        objContact.MailingState = getValues(pb.PB5_SHIP_TO_STATE__c, pb.PB5_STATE__c);
        objContact.MailingPostalCode = getValues(pb.PB5_SHIP_TO_ZIP_CODE__c, pb.PB5_ZIP_CODE__c);        
        try{
            update objContact;
            if(objContact.Id != null && String.valueOf(objContact.Id).length()>0){
                blnSuccess = true;
                if(objContact.Id != null && String.valueOf(objContact.Id).length()>0){
                    blnSuccess = true;
                    Address__c objAdd;
                    List<Address__c> lstAdd = [Select Id, Address_Type__c, Street_1__c, Street_2__c, City__c, State__c,
                    Postal_Code__c, Country__c, Contact__c, Account_Household__c From Address__c
                    Where Contact__c =: objContact.Id];
                    if(lstAdd != null && lstAdd.size()>0){
                        objAdd = lstAdd[0];
                    }else{
                         objAdd = new Address__c();
                    }
                    objAdd.Address_Type__c = NVL(pb.PB5_ADDRESS_TYPE__c);
                    objAdd.Street_1__c = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
                    objAdd.Street_2__c = getValues(pb.PB5_EXTRA_LINE_1__c, pb.PB5_SHIP_TO_EXTRA_LINE_1__c);
                    objAdd.City__c = getValues(pb.PB5_CITY__c, pb.PB5_SHIP_TO_CITY__c);
                    objAdd.State__c = getValues(pb.PB5_STATE__c, pb.PB5_SHIP_TO_STATE__c);
                    objAdd.Postal_Code__c = getValues(pb.PB5_ZIP_CODE__c, pb.PB5_SHIP_TO_ZIP_CODE__c);
                    objAdd.Country__c = NVL(pb.PB5_COUNTRY__c);    
                    //objAdd.Account_Household__c = HouseholdId;   
                    if(objAdd.Id == null){
                        objAdd.Contact__c = objContact.Id;
                        Insert objAdd;      
                    }
                    else{
                        Update objAdd;
                    }
                    //processClassification(pb, objContact.Id, householdId);   
                }
                else{
                    blnSuccess = false;
                }
                UploadRecordMatchingGiving.processGiving(pb, objContact.Id, objContact.AccountId);
            }
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
    public static Contact mapContactField(WGBH_PB5_UPLOAD__c pb, String flag){
        Contact objContact = new Contact();
        objContact.FirstName = getValues(pb.PB5_FIRST_NAME__c, pb.PB5_FIRST_NAME_2__c);
        objContact.LastName = getValues(pb.PB5_LAST_NAME__c, pb.PB5_LAST_NAME_2__c);
        //objContact.MiddleName = getValues(pb.PB5_MIDDLE_NAME__c, pb.PB5_MIDDLE_NAME__c);
        
        //objContact.DoNotCall = getValues(pb.PB5_NO_PHONE_PREFERRED__c, pb.PB5_NO_PHONE_PREFERRED__c);
        //objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_2__c, pb.PB5_EMAIL_ADDRESS_2__c);
        objContact.Salutation = getValues(pb.PB5_SUFFIX__c, pb.PB5_SUFFIX_2__c);
        objContact.PreferredPhone__c = getValues(pb.PB5_TELEPHONE_TYPE_1__c, pb.PB5_TELEPHONE_TYPE_2__c);
        if(NVL(objContact.PreferredPhone__c) == 'H' || NVL(objContact.PreferredPhone__c) == 'Home'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        if(NVL(objContact.PreferredPhone__c) == 'W' || NVL(objContact.PreferredPhone__c) == 'Work'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        objContact.Preferred_Email__c = NVL(pb.PB5_EMAIL_TYPE_2__c);
        if(NVL(objContact.Preferred_Email__c) == 'Work'){
            objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Home'){
            objContact.HomeEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Assistant'){
            objContact.Assistant_Email__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Default Email'){
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else{
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        objContact.Phone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        //objContact.OtherPhone = getValues(pb.PB5_TELEPHONE_NUMBER_2__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        objContact.MailingStreet = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
        objContact.MailingCity = getValues(pb.PB5_SHIP_TO_CITY__c, pb.PB5_CITY__c);
        objContact.MailingState = getValues(pb.PB5_SHIP_TO_STATE__c, pb.PB5_STATE__c);
        objContact.MailingPostalCode = getValues(pb.PB5_SHIP_TO_ZIP_CODE__c, pb.PB5_ZIP_CODE__c);
        /*
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
        */
        return objContact;
    }

    static testMethod void myTest() {
        WGBH_PB5_UPLOAD__c objPB5 = New WGBH_PB5_UPLOAD__c();
        insert objPB5;
        
/*
        UploadRecordMatchingContact.ProcessContact(objPB5);
        UploadRecordMatchingContact.ProcessContact(objPB5,new List<sObject>(),'true');
        UploadRecordMatchingContact.InsertContact(objPB5,'true');
        UploadRecordMatchingContact.UpdateContact(new Contact(),objPB5,'true');
        UploadRecordMatchingContact.mapContactField(objPB5,'true');
  */            
    }    
    
}