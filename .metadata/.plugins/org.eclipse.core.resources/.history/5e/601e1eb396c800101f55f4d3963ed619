public class RelationshipEditController {

    public Relationships__c relation{get;set;}
    public boolean renderUserSection{get;set;}
    public boolean renderAccSection{get;set;}
    public boolean renderContactSection{get;set;}
    public boolean renderHouseholdSection{get;set;}
    public boolean renderOrgSection{get;set;}
    public boolean renderConSection{get;set;}
    public boolean renderHouseholdRSection{get;set;}
    public String subTitle{get;set;}
    
    public String retId{
        get{
            if(ApexPages.currentPage().getParameters().get('retURL')==null) {
                return this.retId; // test uses setter.
            }
            return ApexPages.currentPage().getParameters().get('retURL').subString(1, ApexPages.currentPage().getParameters().get('retURL').length());
        }
        set;
    }

    public RelationshipEditController(ApexPages.StandardController controller) {
        this.relation = (Relationships__c)controller.getRecord();
        if(relation <> null){
            relation = [Select r.isReciprocal__c, r.User__c, r.User__r.Name,r.Type__c, r.Strength__c, r.Relationship_type__c, r.Reverse_Relationship_Type__c, 
                        r.Relationship_To__c, r.Related_To_People__r.Name, r.Related_To_Organization__r.Name, r.Related_To_accHousehold__c, r.Related_To_accHousehold__r.Name, r.People__r.LastName, r.People__r.FirstName,
                        r.Related_Relationship__c, r.Primary_Rel__c, r.People__c, r.Account_Household__c, r.Account_Household__r.Name,
                        r.Organization__c,r.Organization__r.Name, r.Name, r.Id, r.Comments__c, r.People__r.Name From Relationships__c r where Id = : relation.Id];
        }else{
            relation = new Relationships__c();
        }        
        if(relation.User__c <> null){
            renderUserSection = true;  
            renderAccSection = false;
            renderContactSection = false;  
            renderHouseholdSection = false;
        }else if(relation.Related_To_Organization__c <> null){
            renderUserSection = false;  
            renderContactSection = false;
            renderAccSection = true;   
            renderHouseholdSection = false;
        }else if(relation.Related_To_People__c <> null){
            renderUserSection = false;  
            renderContactSection = true;
            renderAccSection = false;   
            renderHouseholdSection = false;
        }else if(relation.Related_To_People__c <> null){
            renderUserSection = false;  
            renderContactSection = false;
            renderAccSection = false;   
            renderHouseholdSection = true;
        }
        buildSubTitle();
    }
    
    // This method would set the subtitle displayed in the section header
    // of the visualforce page.    
    
    public void buildSubTitle(){
        this.subTitle = 'Relation between' + ' ';
        if(relation.Organization__c <> null){
            this.renderOrgSection = true;
            this.renderConSection = false;
            this.renderHouseholdRSection = false;
            this.subTitle = subTitle + relation.Organization__r.Name + ' ';
        }else if(relation.People__c <> null){
            this.subTitle = subTitle + ' ' + relation.People__r.FirstName + ' ' + relation.People__r.LastName + ' ';
            System.debug(subTitle);
            this.renderOrgSection = false;
            this.renderConSection = true;
            this.renderHouseholdRSection = false;
        }else if(relation.Account_Household__c <> null){
            this.subTitle = subTitle + ' ' + relation.Account_Household__r.Name + ' ';
            this.renderOrgSection = false;
            this.renderConSection = false;
            this.renderHouseholdRSection = true;
        }
        
        if(relation.Related_To_People__c <> null){
            this.subTitle = subTitle + '&' + ' ' + relation.Related_To_People__r.Name;
        }else if(relation.Related_To_Organization__c <> null){
            this.subTitle = subTitle + '&' + ' ' + relation.Related_To_Organization__r.Name;
        }else if(relation.User__c <> null){
            this.subTitle = subTitle + '&' + ' ' + relation.User__r.Name;
        }else if(relation.Related_To_accHousehold__c <> null){
            this.subTitle = subTitle + '&' + ' ' + relation.Related_To_accHousehold__r.Name;
        }
    }
    
    public pageReference save(){
        try{
            if(relation <> null){
                update relation;
            }
        }catch(DMLException dme){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, dme.getMessage()));
            return  null;
        }
        return new pageReference('/'+retId);
    }
    
    public pageReference cancel(){
        return new pageReference('/'+retId); 
    }
    
    

}