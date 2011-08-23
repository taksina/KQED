trigger trgOppLineAfterInsert on OpportunityLineItem (After Insert) {
    Set<ID> AccIDs = new Set<ID>();
    Set<ID> ContactIDs = new Set<ID>();
    Set<ID> OppLineitemIDs = new Set<ID>();
    
    
    for(OpportunityLineItem oppline: Trigger.new) {
        OppLineitemIDs.add(oppline.id);
    }
    
    List<OpportunityLineItem> lstOppItem = [Select ID,OpportunityID,Opportunity.AccountID,Opportunity.Station__c,Opportunity.Oppty_Related_Contact__c,Pricebookentry.Product2.Club__c
            from OpportunityLineItem where ID IN: OppLineItemIDs and Pricebookentry.Product2.Club__c!=null];

    for(OpportunityLineItem opplineitem: lstOppItem) {
    
        if(!AccIDs.contains(opplineitem.Opportunity.AccountID)) {
            AccIDs.add(opplineitem.Opportunity.AccountID);
        }
        if(!ContactIDs.contains(opplineitem.Opportunity.Oppty_Related_Contact__c)) {
            ContactIDs.add(opplineitem.Opportunity.Oppty_Related_Contact__c);
        }

    }

    /*
    List<Classification__c> lstCls = [Select ID,Account__c,Contact__c,Preference_Value__c from Classification__c 
                    where RecordType.DeveloperName='benefit' 
                    AND ((Account__c IN: AccIDs and Account__c!=null) OR (Contact__c IN: ContactIDs AND Contact__c!=null))
                    AND Preference__c = 'Club Type'];// AND Preference_Value__c IN: Clubs];
    */
    List<Classification__c> lstCls = [Select ID,Station__c,Account__c,Contact__c,Preference_Value__c from Classification__c 
                    where RecordType.DeveloperName='benefit'
                    AND ((Account__c IN: AccIDs and Account__c!=null) OR (Contact__c IN: ContactIDs AND Contact__c!=null))
                    AND Preference__c = 'Club Type'];
    
    RecordType r = [Select ID from RecordType where DeveloperName='benefit' limit 1];
    
    List<Classification__c> lstNewCls = new List<Classification__c>();
    
    for(OpportunityLineItem o: lstOppItem) {
        String[] Clubs = o.Pricebookentry.Product2.Club__c.split(';');
        
        for(String clb : Clubs) {
            boolean IsClubExist = false;
            for(Classification__c c: lstCls) {

                
                if(o.Opportunity.Station__c==c.Station__c && o.Opportunity.AccountID == c.Account__c && o.Opportunity.Oppty_Related_Contact__c == null 
                        && clb.trim()==c.Preference_Value__c.trim()) {
                    IsClubExist = true;
                }
                else if(o.Opportunity.Station__c==c.Station__c && o.Opportunity.Oppty_Related_Contact__c != null && clb.trim()==c.Preference_Value__c.trim()) {
                    IsClubExist = true;
                }

            }
            if(IsClubExist==false) {
                Classification__c objC = new Classification__c();
                objC.RecordTypeID = r.ID;
                objC.Station__c = o.Opportunity.Station__c;
                if(o.Opportunity.Oppty_Related_Contact__c==null) objC.Account__c = o.Opportunity.AccountID;
                if(o.Opportunity.Oppty_Related_Contact__c!=null) objC.Contact__c = o.Opportunity.Oppty_Related_Contact__c;
                objC.Preference__c = 'Club Type';
                objC.Preference_Value__c = clb;
                lstNewCls.add(objC);
            }
    
        }    
    
    }
    
    if(lstNewCls.size()>0) insert lstNewCls;
}