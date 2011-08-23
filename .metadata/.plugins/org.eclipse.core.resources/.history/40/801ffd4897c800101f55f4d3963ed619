trigger PRR_PopulateData on Prospect_Research_Reports__c (before insert, before update) {

    List<RecordType> lstRecType = [Select ID from RecordType where (DeveloperName = 'Event_Bio' OR DeveloperName = 'Profile')];
    ID RecordTypeID_Bios;
    ID RecordTypeID_Profile;
    if(lstRecType.size()>0){
        RecordTypeID_Bios = lstRecType[0].id;
        RecordTypeID_Profile = lstRecType[1].id;
    }
    
    Set<ID> ContactIds = new Set<ID>();
    for(Prospect_Research_Reports__c objPRR:Trigger.new){
        if((objPRR.RecordTypeID == RecordTypeID_Bios || objPRR.RecordTypeID == RecordTypeID_Profile) && objPRR.Contact__c!=null){
            ContactIds.add(objPRR.Contact__c);
        }
    }
    
    Map<ID,Contact> MapContact = new Map<ID,Contact>
        ([Select ID,
        (Select ID,People__c, Related_To_People__c, Related_To_People__r.FirstName,Related_To_People__r.LastName from Relationships__r
        where relationship_type__c = 'Husband to Wife' OR relationship_type__c = 'Wife to Husband' limit 1) from Contact where ID IN: ContactIDs]);
    //School
    
    List<RecordType> lstRc = [select id from RecordType where developername =: 'Master'];
    
    Map<ID,Contact> MapBios = new Map<ID,Contact>
    ([Select ID, (Select Id, school_code__c FROM Bios__r Where RecordType.Id =: lstRc[0].Id 
    order by createddate desc limit 1) from Contact where ID IN: ContactIDs ]);


    for(Prospect_Research_Reports__c objPRR:Trigger.new){
        if((objPRR.RecordTypeID == RecordTypeID_Bios || objPRR.RecordTypeID == RecordTypeID_Profile) && objPRR.Contact__c!=null){
            if(MapContact.ContainsKey(objPRR.Contact__c)==true) {
                Contact c = MapContact.get(objPRR.Contact__c);
                
                List<Relationships__c> lstRelationships = c.Relationships__r;
                
                if(lstRelationships.size()>0) {
                    //objPRR.Spouse_Name__c = lstRelationships[0].Related_To_People__r.FirstName + ' ' + lstRelationships[0].Related_To_People__r.LastName;
                    objPRR.Spouse_Name__c = lstRelationships[0].Related_To_People__c;
                }
            }
            
            if(MapBios.ContainsKey(objPRR.Contact__c)==true) {
                Contact c = MapBios.get(objPRR.Contact__c);
                List<Bios__c> lstRelBios = c.Bios__r;
                If(lstRelBios.size()>0){
                    objPRR.Most_recent_College__c = lstRelBios[0].school_code__c;
                }
            }
        }
    }

   
}