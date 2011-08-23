Public Class ProspectResearchReport{

    Public String ID;
    
    Public List<Prospect_Research_Reports__c> lstEventBios{get;set;}
    Public List<Prospect_Research_Reports__c> lstResearchNote{get;set;}
    Public List<Prospect_Research_Reports__c> lstProfile{get;set;}
    
    Public String SizeEventBios{get;set;}
    Public String SizeResearchNote{get;set;}//Research Note
    Public String SizeProfile{get;set;}//Profile
    
    Public String EventBioId{get;set;}
    Public String ResearchNoteId{get;set;}
    Public String ProfileId{get;set;}
    
    String getRecordTypeId(String RcName){
        return [Select id from recordtype where name =: RcName][0].id;
    }
    
    Private void PageLoad(){
        lstEventBios = new List<Prospect_Research_Reports__c>();
        lstResearchNote = new List<Prospect_Research_Reports__c>();
        lstProfile = new List<Prospect_Research_Reports__c>();
        
        ID=ApexPages.CurrentPage().getParameters().get('id');
                
        EventBioId = getRecordTypeId('Event Bio');
        ResearchNoteId = getRecordTypeId('Research Note');
        ProfileId = getRecordTypeId('Profile');
        
        //Event Bio
        lstEventBios = getPRRs(ID, EventBioId);
        SizeEventBios = 'Event Bios [' + lstEventBios.size() + ']';     
        
        //Research Note        
        lstResearchNote = getPRRs(ID, ResearchNoteId);
        SizeResearchNote = 'Research Note [' + lstResearchNote.size() + ']';             
        
        //Profile       
        lstProfile = getPRRs(ID, ProfileId);
        SizeProfile = 'Profile [' + lstProfile.size() + ']';             
    }
    
    List<Prospect_Research_Reports__c> getPRRs(String strID, String RecordTypeId){
        List<Prospect_Research_Reports__c> lstPRRTemp = new List<Prospect_Research_Reports__c>();
        String strObject = CommonApex.getObjectNameById(strID);
        If(strObject == 'Account__c')
            lstPRRTemp = [SELECT Id, Name, RecordType.Name, Author__r.Name, Contact__r.Name, Account__r.Name, Notes__c, Spouse_Name__r.Name, City__c, State__c, Born_Day__c, Born_Month__c, Born_Year__c FROM Prospect_Research_Reports__c WHERE Account__c =: strID AND RecordType.Id =: RecordTypeId];
        Else If(strObject == 'Contact')            
            lstPRRTemp = [SELECT Id, Name, RecordType.Name, Author__r.Name, Contact__r.Name, Account__r.Name, Notes__c, Spouse_Name__r.Name, City__c, State__c, Born_Day__c, Born_Month__c, Born_Year__c FROM Prospect_Research_Reports__c WHERE Contact__c =: strID AND RecordType.Id =: RecordTypeId];        
        return lstPRRTemp;
    }
    
    Public ProspectResearchReport(){
        PageLoad();
    }
    Public ProspectResearchReport(ApexPages.StandardController controller) {
        PageLoad();
    }

}