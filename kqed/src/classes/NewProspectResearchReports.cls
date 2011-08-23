Public Class NewProspectResearchReports{
    public String testURL{get;set;}
    String strRecordType='';
    String strObject='';
    
    public NewProspectResearchReports(ApexPages.StandardController controller) {

    }    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;
    }
    String getSchoolName(String strID){
        String autoData='';
        List<Bios__c> lstBio = new List<Bios__c>();
        try{
            List<RecordType> lstRc = [select id from RecordType where developername =: 'Master'];
            lstBio = [SELECT Id, school_code__c FROM Bios__c WHERE Related_To__c =: strID AND RecordType.Id =: lstRc[0].Id order by createddate desc limit 1];        
            if(lstBio != null && lstBio.size()>0){
                autoData = '&00NQ0000000mKsL=' + lstBio[0].school_code__c;
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        return autoData;
    }
    
    String getSpouse(String strId){
        //if(strRecordType != 'Event_Bio') return '';
        if(strRecordType == 'Research_Note') return '';
        List<Relationships__c> lstRel = new List<Relationships__c>();
        string strSpouse='';
        if(strObject == 'Contact'){
         //Related_To_People__c, People__c
            lstRel = [Select id, name from Relationships__c Where Related_To_People__c =: strId OR People__c =: strId order by createddate desc limit 1];             
        }
        else if(strObject == 'Account'){
         //Related_To_Account, Account
            lstRel = [Select id, name from Relationships__c Where Related_To_AccHousehold__c =: strId OR Account_Household__c =: strId order by createddate desc limit 1];                      
        }
        if(lstRel != null && lstRel.size()>0){
            strSpouse = '&CF00NQ0000000mKsS=' + lstRel[0].name;
        }
        return strSpouse;
    }    
    
    Public String AutoPopulateData(String strId){
        String autoData='';
        List<Bios__c> lstBio = new List<Bios__c>();
        strId = strId.replace('/' , '');
        strId = strId.replace('%2F' , '');
        String HouseHoldName='';
        DateTime HouseHoldDate=null;
        //strObject = CommonApex.getObjectNameById(strID);
        if(strId.trim().substring(0,3)=='003')
            strObject = 'Contact';
        else if(strId.trim().substring(0,3)=='001')
            strObject = 'Account';
        system.debug('#######strobject : ' + strObject);
        if(strObject == 'Contact'){
            //Getting most recent collage name
            if(strRecordType=='Event_Bio' || strRecordType=='Profile')
                //autoData += getSchoolName(strId);
            //Contact
            try{
                List<Contact> lstContact = [SELECT firstname, lastname, AccountID, Account_Household__r.name, Account_Household__r.createddate FROM Contact WHERE Id =: strId];
                if(lstContact != null && lstContact.size()>0){
                    autoData += '&CF00NQ0000000mKsE_lkid=' + strID;    
                    autoData += '&CF00NQ0000000mKsE=' + lstContact[0].firstname + '+' + lstContact[0].lastname;
                    
                    //system.debug('Household name--------------------->' + lstContact[0].Household__r.name);
                    system.debug('Household id--------------------->' + lstContact[0].Account);
                    //Household name
                    if(lstContact[0].Account != null){
                        autoData += '&CF00NQ0000000mKrc_lkid=' + lstContact[0].AccountID;    
                        autoData += '&CF00NQ0000000mKrc=' + lstContact[0].Account_Household__r.name;
                        //autoData += '&Name=' + getPRRName(lstContact[0].Household__r.name, lstContact[0].Household__r.createddate);
                        HouseHoldName = lstContact[0].Account_Household__r.name;
                        HouseHoldDate = lstContact[0].Account_Household__r.createddate;
                    }
                }
            }catch(Exception ex1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex1.getMessage()));
            }
        } 
        system.debug('############## AccountId : ' + strId);
        if(strObject == 'Account'){
            List<Account> lstHO = [SELECT id, name, createddate FROM Account WHERE Id =: strId];
            if(lstHO != null && lstHO.size()>0){
                autoData += '&CF00NQ0000000mKrc_lkid=' + lstHO[0].id;    
                autoData += '&CF00NQ0000000mKrc=' + lstHO[0].name;
                HouseHoldName = lstHO[0].name;
                HouseHoldDate = lstHO[0].createddate;
            }
        }
        autoData += '&Name=' + getPRRName(HouseHoldName, HouseHoldDate);
        //System.debug('COLLAGE------------------------>' + collegeName);
        //autoData += getSpouse(strId);
        return autoData;
    }


    String getPRRName(String HouseHoldName, DateTime dtCreated){
        String PRRName = HouseHoldName;
        String dt;
        if(dt != null && dt.trim().length()>0){
            dt = String.valueOf(date.valueOf(String.valueOf(dtCreated)));
        }
        else{
            dt = String.valueOf(System.today());
        }
        dt = dt.replace('00:00:00','').trim().replace('-','/');
        
        PRRName += ' ' + dt;
        
        system.debug('PRR NAME--------------------->' + PRRName);
        return PRRName.trim();
    }
    public PageReference RedirectToStandardPage() {
        string URL='';
        string retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        string RecordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new= ApexPages.CurrentPage().getParameters().get('save_new');
        RecordType r = [Select DeveloperName from RecordType where ID=:RecordType];
        strRecordType = r.DeveloperName;
        URL += '/a17/e?retURL=' + retURL + '&RecordType=' + RecordType + '&ent=' + ent;
        //if(r.DeveloperName == 'Event_Bio'){
            URL += '&CF00NQ0000000mKs9=' + UserInfo.getName();  
            URL += AutoPopulateData(retURL.replace('%2F',''));
        //}
        URL += '&nooverride=1';        
        system.debug('URL----------------------->' + URL);
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);  
        return P;
    }   
}