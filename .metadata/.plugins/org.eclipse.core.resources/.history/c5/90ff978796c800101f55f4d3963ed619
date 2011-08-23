/**********************************************************************
Name:  AddRelationshipController 
RoundCorner, INC
======================================================
Purpose:                                                            
This is a controller class for the VF page which controls the creation of new Relationship with the Account(People/ Organization)

Related Page : CreateRelationship

======================================================
History:   
                                                         
VERSION   AUTHOR       DATE       DETAIL      
1.0 -    Arijit R   05/08/2010  Created
2.0 -    Raghuram K 10/21/2010  Modified to support Households
3.0 -    LogicRain Technologies 07/18/2011 Adding new columns to result.
***********************************************************************/

public class AddRelationshipController {
    
    // Type selected by the user in the screen  
    // Top level variable declaration
    public String searchObj{get;set;}
    public String searchString{get;set;}
    public List<List<SObject>> searchResult = new List<List<SObject>>();
    public List<Relationships__c> selectedRelationList{get;set;}
    public List<DisplayElement> displayList{get;set;}
    public List<DisplayElement> finalDisplayList{get;set;}
    public Account acc{get;set;}
    public Contact con{get;set;}
    public Account household {get; set;}
    public boolean selOrgOption{get;set;}
    public String displayName{get;set;}
    
    // Setting the accountId from the URL
    public String urlParam{
        get{
            return ApexPages.currentPage().getParameters().get('id');
        }
        set;    
    }
    // Constructor for the class
    public AddRelationshipController(){
        displayList = new List<DisplayElement>();
        selectedRelationList = new List<Relationships__c>();
        finalDisplayList = new List<DisplayElement>();
        if(acc == null){
            if(urlParam.subString(0,3) == '001'){
                acc = [SELECT Name, Preferred_Address__r.name, Phone from Account where Id = : urlParam]; 
                displayName = acc.Name;
                this.selOrgOption = true;
            } else if(urlParam.subString(0,3) == '003') {
                con = [SELECT Id, FirstName, LastName, Phone, Email, Preferred_Address__r.name, SFDC_CONTACT_ID__c from Contact where Id = : urlParam];
                displayName = con.FirstName + ' ' + con.LastName;   
                this.selOrgOption = false;
            } else {
                household = [SELECT Id, Name, Phone, Preferred_Address__r.name from Account where Id = : urlParam];
                displayName = household.Name;   
                this.selOrgOption = false;
            }   
        }
    }
  
    // This  method makes a SOSL call and bring result from Account or User
    // This method prepares the SOSL string based on the option user has selected in the VF page.
    public void search(){ 
        try{
            String queryString = '';    
            system.debug('###########searchObj ' + searchObj);
            if(searchObj == 'Organization'){    
                queryString = 'FIND\''+searchString+'*\'IN ALL FIELDS RETURNING Account(Id,Name,Preferred_Address__r.Name,Phone)';
            }else if(searchObj == 'People'){
                queryString = 'FIND\''+searchString+'*\'IN ALL FIELDS RETURNING Contact(Id,Name,Preferred_Address__r.Name,Phone,Email,SFDC_CONTACT_ID__c)';
            }else if(searchObj == 'Household'){
                queryString = 'FIND\''+searchString+'*\'IN ALL FIELDS RETURNING Account(Id, Name,Preferred_Address__r.Name,Phone)';
            }else if(searchObj == 'Users' || searchObj == 'User'){
                queryString = 'FIND\''+searchString+'*\'IN ALL FIELDS RETURNING User(Id, FirstName, LastName, Email, Phone)';
            }        
            system.debug('############queryString ' + queryString);
            if(queryString <> null) searchResult = search.query(queryString); 
            System.debug('sosl result : '+searchResult);
            constructDisplayList();
        }catch(Exception ex){
            displayList.clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+ex.getMessage())); 
        }     
    }
    
    public List<SelectOption> getrelationshipType(){
        List<SelectOption> relationTypeList = new List<SelectOption>();
        Schema.DescribeFieldResult F = Relationships__c.relationship_type__c.getDescribe();
        List<Schema.PickListEntry> fieldValues = F.getPickListValues();
        for(Schema.PickListEntry s : fieldValues){
            relationTypeList.add(new SelectOption(s.getLabel(), s.getValue())); 
        }   
        return relationTypeList;
    }
    
    public List<SelectOption> getReciprocalRelationshipType(){
        List<SelectOption> relationTypeList = new List<SelectOption>();
        Schema.DescribeFieldResult F = Relationships__c.Reciprocal_Relationship__c.getDescribe();
        List<Schema.PickListEntry> fieldValues = F.getPickListValues();
        for(Schema.PickListEntry s : fieldValues){
            relationTypeList.add(new SelectOption(s.getLabel(), s.getValue())); 
        }   
        return relationTypeList;
    }    
    
    public List<SelectOption> getrelationStrength(){
        List<SelectOption> relationStrengthList = new List<SelectOption>();
        Schema.DescribeFieldResult F = Relationships__c.Strength__c.getDescribe();
        List<Schema.PickListEntry> strengthValues = F.getPickListValues();
        for(Schema.PickListEntry s : strengthValues){
            relationStrengthList.add(new SelectOption(s.getLabel(), s.getValue())); 
        }       
        return relationStrengthList;
        
    }
    
    // Prepare the displayList from the query returned
    public void constructDisplayList(){
        displayList.clear();
        if(searchResult.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Your search returned 0 result'));         
        }else{  
            for(List<SObject> sobList : searchResult){
                for(SObject so : sobList){
                    DisplayElement elem;                
                    if(so.getSObjectType() == Account.sObjectType){
                        Account acc = (Account)so;
                        String typeTo = 'Organization';
                        elem = new DisplayElement(acc.Name, typeTo, acc.Id);
                        elem.AddressName = acc.Preferred_Address__r.name;
                        elem.PhoneNo = acc.Phone;
                    }else if(so.getSObjectType() == User.SObjectType){
                        User user = (User)so;
                        String typeTo = 'User';
                        elem = new DisplayElement(user.FirstName + user.LastName, typeTo, user.Id);
                    }else if(so.getSObjectType() == Contact.sObjectType){
                        Contact con = (Contact)so;
                        String typeTo = 'People';
                        elem = new DisplayElement(con.Name, typeTo, con.Id);    
                        elem.AddressName = con.Preferred_Address__r.name;
                        elem.PhoneNo = con.Phone;
                        elem.Email = con.Email;
                        elem.ContactSFDCId = con.SFDC_CONTACT_ID__c;
                    } else if(so.getSObjectType() == Account.sObjectType){
                        Account hh = (Account)so;
                        String typeTo = 'Household';
                        elem = new DisplayElement(hh.Name, typeTo, hh.Id);    
                        elem.AddressName = hh.Preferred_Address__r.name;
                        elem.PhoneNo = hh.Phone;
                    }
                    System.debug('url parameter : '+urlParam);
                    System.debug('accid in the display element : '+elem.accId);
                    if(urlParam <> elem.accId.subString(0,15)){               
                        displayList.add(elem);
                    }
                }   
            }   
        }
    }
 
    public void prepareRelations(){
        selectedRelationList.clear();
        System.debug('finalDisplayList size:' + finalDisplayList.size() + '   displayList.size:' + displayList.size());
        finalDisplayList.clear(); //TODO: SHOULD WE REMOVE THIS???
        if(displayList.size() > 0){
            for(DisplayElement de : displayList){
                if(de.selected){
                    DisplayElement elem = new DisplayElement(de.name, de.relTo, de.accId, de.strength, de.relationType,de.ReciprocalRelationType);
                    finalDisplayList.add(elem); 
                }
            }       
        }   
    }
    
    List<RecordType> lstRecordType = new List<RecordType>();
    Map<String, ID> mapRecordType;
    
    String NVL(String val){
        if(val == null)
            return null;
        else
            return val.trim();
    }
    
    ID getRecordType(String relatedTo){
        ID recordTypeID = null;
        try{
            if(lstRecordType.size() == 0){
                lstRecordType = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Relationships__c'];
                if(lstRecordType != null && lstRecordType.size() > 0){
                    mapRecordType = new Map<String, ID>();
                    for(RecordType rc:lstRecordType){
                        mapRecordType.put(rc.DeveloperName, rc.Id);
                    }
                }
            }
            if(lstRecordType != null && lstRecordType.size() > 0){
                relatedTo = NVL(relatedTo).toUpperCase();
                String developerName = '';
                if(relatedTo == 'ORGANIZATION' || relatedTo == 'HOUSEHOLD'){//People to Organization
                    developerName = 'Person_record_to_Organization_Record';
                }
                else if(relatedTo == 'PEOPLE'){//People to People
                    developerName = 'Person_record_to_Person_Record';
                }
                else if(relatedTo == 'USER'){//People to User
                    developerName = 'Person_record_to_User_Record';
                }
                if(developerName.length()>0){
                    if(mapRecordType != null && mapRecordType.size()>0 && mapRecordType.containsKey(developerName)){
                        recordTypeID = mapRecordType.get(developerName);
                    }
                }
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            recordTypeID = null;
        }
        Return recordTypeID;
    }
    // save the selected relations        
    public pageReference saveRelations(){
        if(finalDisplayList.size() > 0){
            //for(DisplayElement de : displayList){  
            for(DisplayElement de : finalDisplayList){  
                             
                Relationships__c relation = new Relationships__c();
                //relation.Account__c = accId;
                //added by Hirok on 4th April to handel people to user
                String urlPrefix = urlParam.subString(0,3);
                if(urlPrefix == '001'){
                    relation.Organization__c = urlParam;    
                }else if(urlPrefix == '003'){
                    relation.People__c = urlParam;
                }else { //household
                    relation.Account_household__c = urlParam;
                }
                
                if(de.relTo == 'People'){
                    relation.Related_To_People__c = de.accId;   
                }else if(de.relTo == 'Organization'){
                    relation.Related_To_Organization__c = de.accId; 
                }else if(de.relTo == 'User'){
                    relation.User__c = de.accId;    
                }else if(de.relTo == 'Household'){
                    relation.Related_To_accHousehold__c = de.accId;    
                }
                relation.recordTypeId = getRecordType(de.relTo);
                relation.Strength__c = de.strength;
                relation.relationship_type__c = de.relationType;
                relation.Reciprocal_Relationship__c = de.ReciprocalRelationType;
                System.debug('***************************************************' + de.relationtype);
                try
                {
                    List<Relationship_Type__c> rt =[Select Reverse_Relationship_Type__c From Relationship_Type__c Where Relationship_Type__c =: de.relationtype LIMIT 1];
                    if(rt!=null)
                    relation.reverse_relationship_type__c = rt[0].Reverse_Relationship_Type__c;
                }catch(Exception ex)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                }
                relation.Type__c = de.relTo;
                relation.Primary_Rel__c = true;                
                selectedRelationList.add(relation);             
                
            }   
            if(selectedRelationList.size() > 0){
                 insert selectedRelationList;
                 createReciprocalRelationship();
            }
        }else{
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please Select a Relationship'));
            return null;    
        }
        return new pageReference('/'+urlParam);    
    }
    
    
    //create a reciprocal relation
    public void createReciprocalRelationship(){
        List<Relationships__c> newReciprocalList = new List<Relationships__c>();
        Map<Id, Relationships__c> reciprocalRelatinshipsMap = new Map<Id, Relationships__c>();      
        List<Relationships__c> updatedOriginalRelationList = new List<Relationships__c>();
        try{                        
            for(Relationships__c rel : selectedRelationList){
                    System.debug('Relationship Name  : '+rel.Name);
                    Relationships__c reciprocal = new Relationships__c();
                    reciprocal.relationship_type__c = rel.reverse_relationship_type__c;
                    reciprocal.reverse_relationship_type__c = rel.relationship_type__c;
                    reciprocal.Strength__c = rel.Strength__c;
                    if(rel.People__c <> null) reciprocal.Related_To_People__c = rel.People__c;
                    if(rel.Organization__c <> null) reciprocal.Related_To_Organization__c = rel.Organization__c;
                    if(rel.Account_Household__c <> null) reciprocal.Related_To_accHousehold__c = rel.Account_Household__c;
                    if(rel.Related_To_Organization__c <> null) reciprocal.Organization__c = rel.Related_To_Organization__c;
                    if(rel.Related_To_People__c <> null) reciprocal.People__c = rel.Related_To_People__c;          
                    if(rel.Related_To_accHousehold__c <> null) reciprocal.Account_Household__c = rel.Related_To_accHousehold__c;
                    
                    if(rel.People__c <> null){
                        reciprocal.Type__c = 'People';
                    }else if(rel.Organization__c <> null){
                        reciprocal.Type__c = 'Organization';
                    }else {
                        reciprocal.Type__c = 'Household';    
                    }
                    reciprocal.isReciprocal__c = true;
                    reciprocal.Parent__c = rel.Id;
                    newReciprocalList.add(reciprocal);
            }
            if(newReciprocalList.size() > 0){
                insert newReciprocalList;
                for(Relationships__c recRel : newReciprocalList){
                    reciprocalRelatinshipsMap.put(recRel.Related_Relationship__c, recRel);      
                }
                for(Relationships__c orgRelation : selectedRelationList){
                    orgRelation.Related_Relationship__c = reciprocalRelatinshipsMap.get(orgRelation.Id).Id;     
                    updatedOriginalRelationList.add(orgRelation);
                }
                if(updatedOriginalRelationList.size() > 0) update updatedOriginalRelationList;  
            }
            
            if(newReciprocalList.size() > 0){
                System.debug('reciprocal relationship list : '+newReciprocalList);
                 insert newReciprocalList;
            }
        }catch(Exception ex){
            System.debug('Exception has occured' +ex.getMessage());
        }
    }
    
  
    

    public Integer selectedListSize{
        get{
            return finalDisplayList.size();
        }
        set;    
    }
    
    // Wrapper class for the elements that needs to be displayed in the VF page.
    public class DisplayElement{
        public boolean selected{get;set;}
        public String accId{get;set;}
        public String name{get;set;}
        public String relationType{get;set;}
        public String ReciprocalRelationType{get;set;}
        public String strength{get;set;}
        public String relTo{get;set;}   
        
        public String AddressName{get;set;}
        public String PhoneNo{get;set;}
        public String Email{get;set;}
        public String ContactSFDCId{get;set;}
        
        // contructor for the class
        public DisplayElement(String name, String relTo,String relationId){
            this.name = name;
            this.relTo = relTo;
            this.accId = relationId;
        }
        //Overloaded Constructor    
        public DisplayElement(String Name, String relTo, String relationId, String Strength, String relationType,String ReciprocalRelationType){
            this.Name = Name;
            this.relTo = relTo;
            this.accId = relationId;
            this.strength = Strength;
            this.relationType = relationType;
            this.ReciprocalRelationType = ReciprocalRelationType;
        }
        //Overloaded Constructor    
        public DisplayElement(String Name, String relTo, String relationId, String Strength, String relationType,
        String ReciprocalRelationType,
        String AddressName, String PhoneNo, String Email, String ContactSFDCId){
            this.Name = Name;
            this.relTo = relTo;
            this.accId = relationId;
            this.strength = Strength;
            this.relationType = relationType;
            this.ReciprocalRelationType= ReciprocalRelationType;
            
            this.AddressName = AddressName;
            this.PhoneNo = PhoneNo;
            this.Email = Email;
            this.ContactSFDCId = ContactSFDCId;
        }
    }
    
    // Will redirect the user back to the Account page
    public pageReference redirectBack(){
        return new pageReference('/'+urlParam);    
    }
}