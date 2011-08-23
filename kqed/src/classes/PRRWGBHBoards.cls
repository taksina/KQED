public class PRRWGBHBoards {
    public PRRWGBHBoards(ApexPages.StandardController controller) {
        PageLoad();
    }
    public PRRWGBHBoards() {
        PageLoad();
    }    
    public List<Classification__c> classifications {
        get {
             return this.getAllClassifications();
        }
        set;
    }
    public void PageLoad() {
        //id=ApexPages.CurrentPage().getParameters().get('id');
        List<Prospect_Research_Reports__c> lstPRR = new List<Prospect_Research_Reports__c>();
        
        lstPRR = [SELECT id, Contact__c FROM Prospect_Research_Reports__c WHERE ID=:ApexPages.CurrentPage().getParameters().get('id')];
        sObjectType='Contact';
        recordId=lstPRR[0].Contact__c;
        Delid='aaa';
        system.debug('------------------------------------->' + id);
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
    

    
    public Classification__c[] getAllClassifications() {
        List<Classification__c> classifications = null;
        
        if(sObjectType == 'Contact') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId];
        }
        else if(sObjectType == 'Account') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId];
        }
        else if(sObjectType == 'Household__c') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId];
        } 
        
        if(classifications != null) {// && classifications.size() > 0) {
            System.debug('found '+classifications.size()+' classifications');
            this.tabs = new TabData[] {
                this.createTab(classifications, 'Board', 'WGBH Boards'), 
                this.createTab(classifications, 'Committee')
            };
            System.debug('created '+this.tabs.size()+' tabs');
            
            Integer tabIndex = 0;
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
    
}