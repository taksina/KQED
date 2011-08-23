public class TabsClassificationsController {

    public List<Classification__c> classifications {
        get {
             return this.getAllClassifications();
        }
        set;
    }
    public TabData[] tabs {get; set;}
    
    public class TabData {
        public String tabName {
            get {
                return (this.classifications != null && this.classifications.size() > 0 ? this.tabName + ' [' + this.classifications.size() + ']' : this.tabName);
            }
            set;
        }
        public List<Classification__c> classifications {get; set;}
        
        public TabData(String tabName, List<Classification__c> classifications) {
            this.tabName = tabName;
            this.classifications = classifications;
            System.debug('creating '+tabName+' tab with '+classifications.size()+' classifications.');
        }
    }
    
    public TabData dataTagging {get; set;}
    public TabData bbaScores {get; set;}
    public TabData email {get; set;}
    public TabData misc {get; set;}
    public TabData nationalProgramming {get; set;}
    public TabData benefit {get; set;}
    public TabData appeal {get; set;}
    public TabData discount {get; set;}
    public TabData clubs {get; set;}
    public TabData autoRenew {get; set;}
    public TabData membershipType {get; set;}
    public TabData mgProspects {get; set;}
    public TabData board {get; set;}
    public TabData committee {get; set;}
    
    
    public String Delid{get;set;} 
    public string id{get;set;}
    
    public String recordId {get; set;}
    public String sObjectType {get; set;}
    
    public TabsClassificationsController() {
        id=ApexPages.CurrentPage().getParameters().get('id');
        Delid='aaa';
    }
    
    public Classification__c[] getAllClassifications() {
        List<Classification__c> classifications = null;
        
        if(sObjectType == 'Contact') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId and c.Contact__c!=null];
        }
        else if(sObjectType == 'Account') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null];
        }
        
        if(classifications != null) {// && classifications.size() > 0) {
            System.debug('found '+classifications.size()+' classifications');
            this.tabs = new TabData[] {
                this.createTab(classifications, 'Data Tagging'), 
                this.createTab(classifications, 'BBA Scores'), 
                this.createTab(classifications, 'Email', 'Emails'), 
                this.createTab(classifications, 'Misc'), 
                this.createTab(classifications, 'National Programming'), 
                this.createTab(classifications, 'Benefit', 'Benefits'), 
                this.createTab(classifications, 'Appeal', 'Appeals'), 
                this.createTab(classifications, 'Discount'), 
                this.createTab(classifications, 'Clubs'), 
                this.createTab(classifications, 'Auto-Renew', 'Auto Renewal'), 
                this.createTab(classifications, 'Membership Type', 'Member Type'), 
                this.createTab(classifications, 'MG Prospects', 'MG Prospect'), 
                this.createTab(classifications, 'Board', 'WGBH Boards'), 
                this.createTab(classifications, 'Committee')
            };
            System.debug('created '+this.tabs.size()+' tabs');
            
            Integer tabIndex = 0;
            dataTagging = this.tabs[tabIndex ++];
            bbaScores = this.tabs[tabIndex ++];
            email = this.tabs[tabIndex ++];
            misc = this.tabs[tabIndex ++];
            nationalProgramming = this.tabs[tabIndex ++];
            benefit = this.tabs[tabIndex ++];
            appeal = this.tabs[tabIndex ++];
            discount = this.tabs[tabIndex ++];
            clubs = this.tabs[tabIndex ++];
            autoRenew = this.tabs[tabIndex ++];
            membershipType = this.tabs[tabIndex ++];
            mgProspects = this.tabs[tabIndex ++];
            board = this.tabs[tabIndex ++];
            committee = this.tabs[tabIndex ++];
        }
        else {
            System.debug('found no classifications');
        }
        
        return classifications;
    }
    
    public List<Classification__c> getClassifications(List<Classification__c> classifications, String tabName) {
        List<Classification__c> cList = new List<Classification__c>();
        for(Classification__c c : classifications) {
            if(c.classification_tabname__c == tabName) {
                cList.add(c);
            }
        }
        return cList;
    }
    
    public TabData createTab(List<Classification__c> classifications, String tabName) {
        System.debug('in ct 1');
        return this.createTab(classifications, tabName, null);
    }
    
    public TabData createTab(List<Classification__c> classifications, String tabName, String tabLabel) {
        System.debug('in ct 2');
        return new TabData(tabLabel == null ? tabName : tabLabel, this.getClassifications(classifications, tabName));
    }



    public PageReference Delmet() {
        System.debug('Deleteing classification: '+Delid);
        try {
            Classification__c c= [SELECT Id from Classification__c where id=:DelId];
            delete c;
        }
        catch(Exception e) {
            System.debug('Unable to delete classification: '+Delid+', ex: '+e);
        }
        pagereference pg = ApexPages.currentPage();
        return pg;
    }
    
    public static testmethod void test(){
        Contact c = new Contact();
        c.Lastname='test';
        insert c;
        
        List<Classification__c> bb = [Select id from Classification__c limit 1];
        
        //Apexpages.CurrentPage().getParameters().put('id', c.id);
        TabsClassificationsController tcc = new TabsClassificationsController();
        
        
        tcc.sobjectType='Contact';
        Classification__c[] cc= tcc.getAllClassifications();
        
        if(Cc!=null)
        {
        try{
        tcc.delid=cc[0].id;
        
        tcc.delmet();
        }catch(Exception e)
        {
        }
        
        
        }
        
        
        tcc.sobjectType='Account';
        Classification__c[] acc= tcc.getAllClassifications();
        
        tcc.sobjectType='Account';
        Classification__c[] hcc= tcc.getAllClassifications();
        
        List<Classification__c> lc =tcc.classifications; 
        
        tcc.classifications = lc;
        
        //tcc.getClassifications('Appeal');

        //List<Classification__c> b = new List<Classification__c>([SELECT id from Classification__c limit 1]); 
        //tcc.delId = b[0].id;
 }
 
}