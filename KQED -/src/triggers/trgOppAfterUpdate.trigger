trigger trgOppAfterUpdate on Opportunity (After Update) {
    Set<ID> OppIDs = new Set<ID>();
    
    for(Opportunity opp: Trigger.New) {
        if(opp.Remove_Opportunity__c == true) {
            OppIDs.add(opp.id);
        }
    }
    
    List<Opportunity> lstOppDelete = [Select ID from Opportunity where ID IN:OppIDs];
    
    if(lstOppDelete.size()>0) delete lstOppDelete;
}