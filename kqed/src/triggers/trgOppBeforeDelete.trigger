trigger trgOppBeforeDelete on Opportunity (before delete) {
    Boolean blnRemoveChilds = false;
    Set<ID> delParentIds = new Set<ID>();
    Set<ID> accountIds = new Set<ID>();
    List<Opportunity> lstOpp = new List<Opportunity>();
    for(Opportunity opp:Trigger.old){
        if(opp.Recurring_Donation_Opportunity__c == null && (opp.Gift_Kind__c != null && 
        (opp.Gift_Kind__c.trim().toUpperCase() == 'INSTALLMENT' ||
         opp.Gift_Kind__c.trim().toUpperCase() == 'SUSTAINING GIFT'))){
            blnRemoveChilds = true;
            delParentIds.add(opp.Id);
            
        }
    }
    system.debug('Has childs : ' + blnRemoveChilds);
    system.debug('Delete parent Id: ' + delParentIds);
    if(blnRemoveChilds == true && delParentIds != null && delParentIds.size()>0){
        List<Opportunity> lstChildDel = new List<Opportunity>();
        lstChildDel = [Select Id From Opportunity Where Recurring_Donation_Opportunity__c in:delParentIds];
        if(lstChildDel != null && lstChildDel.size()>0){
            system.debug('Total number of childs: ' + lstChildDel.size());
            Delete lstChildDel;
        }
    }
    Map<ID,List<Opportunity>> mapAccountGiving = new Map<ID,List<Opportunity>>();
    if(accountIds != null && accountIds.size() > 0){
        if(lstOpp != null && lstOpp.size()>0){
            for(ID accId:accountIds){
                List<Opportunity> lstGiving = new List<Opportunity>();
                for(Opportunity opp:lstOpp){
                    if(opp.AccountId == accId){
                        lstGiving.add(opp);
                    }
                }
                mapAccountGiving.put(accId,lstGiving);
            }
        }
        List<Giving_Summary__c> lstSummary;
        List<Giving_Summary__c> lstDelSummary = new List<Giving_Summary__c>();
        lstSummary = [Select Id From Giving_Summary__c Where Account__c in:accountIds];
        if(lstSummary != null && lstSummary.size()>0){
            for(Giving_Summary__c summary:lstSummary){
                if(mapAccountGiving != null && mapAccountGiving.size()>0 &&
                    mapAccountGiving.containsKey(summary.Account__c)){
                    List<Opportunity> temp = new List<Opportunity>();
                    temp = mapAccountGiving.get(summary.Account__c);
                    if(temp == null || temp.size() <= 0){
                        lstDelSummary.add(summary);
                    }
                }
            }
            if(lstDelSummary != null && lstDelSummary.size()>0)
                delete lstDelSummary;
        }
    }
}