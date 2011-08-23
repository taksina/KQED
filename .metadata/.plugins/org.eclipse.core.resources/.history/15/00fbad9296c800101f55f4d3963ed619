public class CampaignMemberClass_bkp {

    List<SelectOption> tempFieldList;
    
    List<SelectOption> tempOperators;

    public CampaignMemberClass_bkp (ApexPages.StandardController controller) {
        tempFieldList = getFieldList();
        
        tempOperators = getOperators();
            
        PopulateListCriteria();
    }
    
    public List<SelectOption> getSearchType() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Prospects/Leads','Prospects/Leads')); 
        options.add(new SelectOption('Contacts','Contacts')); 
        return options; 
    }
    
    String SelectedSearch = 'Prospects/Leads';
               
    public String getSelectedSearch() {
        return SelectedSearch;
    }
                    
    public void setSelectedSearch(String SelectedSearch) { this.SelectedSearch= SelectedSearch; }

    private List<SelectOption> getFieldList() {
        List<Campaign_Member_Criteria__c> lstCampaignCriteria = [Select ID,Name,Field_Name__c,Parent_Object__c,Parent_Object_API_Name__c,Field_Type__c from Campaign_Member_Criteria__c order by Parent_Object__c,Name];
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--'));
        
        for(Campaign_Member_Criteria__c c: lstCampaignCriteria) {
            options.add(new SelectOption(c.Parent_Object_API_Name__c + ';' + c.Field_Name__c + ';' + c.Field_Type__c,c.Parent_Object__c + '.' + c.Name));
        }
        
        /*options.add(new SelectOption('LEAD.SALUTATION','Salutation'));
        options.add(new SelectOption('LEAD.LAST_NAME','Last Name'));
        options.add(new SelectOption('LEAD.FIRST_NAME','First Name'));
        options.add(new SelectOption('LEAD.TITLE','Company Title'));
        options.add(new SelectOption('LEAD.EMAIL','Email'));
        
        options.add(new SelectOption('LEAD.COMPANY','Company'));
        options.add(new SelectOption('LEAD.URL','Company Website'));
        options.add(new SelectOption('LEAD.PHONE','Phone'));
        options.add(new SelectOption('LEAD.STREET','Street'));
        options.add(new SelectOption('LEAD.CITY','City'));
        options.add(new SelectOption('LEAD.STATE','State/Province'));
        options.add(new SelectOption('LEAD.ZIP','Zip/Postal Code'));
        options.add(new SelectOption('LEAD.COUNTRY','Country'));
        options.add(new SelectOption('LEAD.LEAD_SOURCE','Prospect/Lead Source'));
        
        options.add(new SelectOption('LEAD.STATUS','Prospect/Lead Status'));
        options.add(new SelectOption('LEAD.INDUSTRY','Industry'));
        options.add(new SelectOption('LEAD.RATING','Rating'));
        options.add(new SelectOption('LEAD.ANNUAL_REVENUE','Annual Gift'));
        options.add(new SelectOption('LEAD.EMPLOYEES','No. of Employees'));
        options.add(new SelectOption('LEAD.UNREAD','Unread By Owner'));
        options.add(new SelectOption('LEAD.CONVERTED','Converted'));
        options.add(new SelectOption('LEAD.LAST_ACTIVITY','Last Activity'));
        options.add(new SelectOption('LEAD.CREATED_DATE','Created Date'));
        
        options.add(new SelectOption('LEAD.LAST_UPDATE','Last Modified Date'));
        options.add(new SelectOption('CORE.USERS.ALIAS','Owner Alias'));
        options.add(new SelectOption('CORE.USERS.FIRST_NAME','Owner First Name'));
        options.add(new SelectOption('CORE.USERS.LAST_NAME','Owner Last Name'));
        options.add(new SelectOption('CREATEDBY_USER.ALIAS','Created By Alias'));
        options.add(new SelectOption('UPDATEDBY_USER.ALIAS','Last Modified By Alias'));
        options.add(new SelectOption('00NA0000006KQHk','Category'));
        options.add(new SelectOption('00NA0000005bdAT','Interests'));
        options.add(new SelectOption('00NA0000005bdAU','Personal Email'));
        
        options.add(new SelectOption('00NA0000005bdAV','Preferred Email'));
        options.add(new SelectOption('00NA0000005bdAW','Preferred Phone'));
        options.add(new SelectOption('00NA0000005bdAX','Stage of the Prospect'));
        options.add(new SelectOption('CAMPAIGN_MEMBER.STATUS','Campaign/Program Member Status'));
        options.add(new SelectOption('LEAD.EMAIL_BOUNCED_REASON','Email Bounced Reason'));
        options.add(new SelectOption('LEAD.EMAIL_BOUNCED_DATE','Email Bounced Date'));
        options.add(new SelectOption('IS_EMAIL_ADDRESS_BOUNCED','Is Email Bounced'));*/
             
        return options;
    }
    private List<SelectOption> getOperators() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('n','not equal to'));
        options.add(new SelectOption('s','starts with'));
        options.add(new SelectOption('c','contains'));
        options.add(new SelectOption('k','does not contain'));
        options.add(new SelectOption('l','less than'));
        options.add(new SelectOption('g','greater than'));
        options.add(new SelectOption('m','less or equal'));
        options.add(new SelectOption('h','greater or equal'));
        options.add(new SelectOption('u','includes'));
        options.add(new SelectOption('x','excludes'));
        
        return options;
    }
    
    public List<SelectOption> getExistingViews() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--'));
        return options;
    }    
    
    public List<SelectOption> ExistingViews;
    public string SelectedView{get;set;}
    
    public List<SearchingCriteria> ListCriteria{get;set;}
    
    private void PopulateListCriteria() {

    
        ListCriteria = new List<SearchingCriteria>();
        
        integer i;        
        for(i=1;i<=5;i++) {
            ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,''));
        }
        
    }
    public PageReference AddNewSearchRow() {

            
        ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,''));
        return null;
    }
        
    public List<CampaignMember> getNewCampaignMembers() {
        List<CampaignMember> lstMem = new List<CampaignMember>();
        return lstMem;
    }
    
    public PageReference CheckFieldType() {
        return null;
    }
    
    public class SearchingCriteria {
        public List<SelectOption> FieldList{get;set;}
        public string SelectedField{get;set;}
        
        public List<SelectOption> Operators{get;set;}
        public string SelectedOperator{get;set;}
        
        public string Value{get;set;}
        
        public SearchingCriteria (List<SelectOption> tempFieldList,List<SelectOption> tempOperators,string tempValue) {
            FieldList = tempFieldList;
            Operators = tempOperators;
            Value = tempValue;
        }
    }
    


}