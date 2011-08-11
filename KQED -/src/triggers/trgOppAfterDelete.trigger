trigger trgOppAfterDelete on Opportunity (after update, after delete) {
    Set<ID> accountIds = new Set<ID>();
    Set<ID> oppIds = new Set<ID>();
    Set<ID> processIds = new Set<ID>();
    Set<ID> parentIds = new Set<ID>();
    List<Opportunity> lstOpp = new List<Opportunity>();
    Map<ID,Opportunity> mapParentChild = new Map<ID,Opportunity>();
    Map<ID,List<Opportunity>> mapGiving = new Map<ID,List<Opportunity>>();
    
    for(Opportunity opp:Trigger.old){
        if(opp.AccountId != null)
            accountIds.add(opp.AccountId);
        if(opp.Recurring_Donation_Opportunity__c != null){
            parentIds.add(opp.Recurring_Donation_Opportunity__c);
            mapParentChild.put(opp.Recurring_Donation_Opportunity__c,opp);
            System.debug('###### ParentId : ' + opp.Recurring_Donation_Opportunity__c);
        }
        oppIds.add(opp.Id);        
    }
    system.debug('#### total Accounts ----> ' + accountIds);
    if((parentIds != null && parentIds.size()> 0) && (mapParentChild != null && mapParentChild.size()>0)){
        List<Opportunity> lstUpdate = new List<Opportunity>();
        List<Opportunity> lstParent = [Select Id, Recurring_Donation_Opportunity__c, Payment_Amount__c
        From Opportunity Where Id in:parentIds];
        if(lstParent != null && lstParent.size()>0){
            for(Opportunity parent:lstParent){
                if(mapParentChild.containsKey(parent.Id)){
                    Opportunity child = mapParentChild.get(parent.Id);
                    if(child != null && child.Payment_Amount__c != null){
                        if(Parent.Payment_Amount__c != null){
                            System.debug('#### Parent Payment Amount (before): ' + Parent.Payment_Amount__c);
                            System.debug('#### Child Payment Amount: ' + child.Payment_Amount__c);
                            Parent.Payment_Amount__c = Parent.Payment_Amount__c - child.Payment_Amount__c;
                            if(Parent.Payment_Amount__c < 0)
                                Parent.Payment_Amount__c = 0;
                            System.debug('#### Parent Payment Amount (after): ' + Parent.Payment_Amount__c);
                        }
                        lstUpdate.add(parent);
                    }
                }
            }
        }
        if(lstUpdate != null && lstUpdate.size()>0)
            update lstUpdate;
    }         
    
    if(accountIds != null && accountIds.size()>0){
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        Map<ID,List<Giving_Summary__c>> mapSummary = new Map<ID,List<Giving_Summary__c>>();
        lstSummary = [Select Id, Account__c, GivingIds__c, History__c, History_Date_Time__c,
        Summary_Count__c From Giving_Summary__c Where Account__c =: accountIds];
        
        if(lstSummary != null && lstSummary.size()>0){
            system.debug('##### Total summary found : ' + lstSummary.size());
            
            List<Giving_Summary__c> lstDeleteSummary = new List<Giving_Summary__c>();
            for(Giving_Summary__c summary:lstSummary){
                List<String> lstGivingIds = new List<String>();
                system.debug('##### Givingids in summary : ' + summary.GivingIds__c);
                if(summary.GivingIds__c != null && summary.GivingIds__c.trim().length()>0){
                    lstGivingIds = summary.GivingIds__c.trim().split('#');
                    if(lstGivingIds != null && lstGivingIds.size()>0){
                        Boolean blnAddtoDelete = true;
                        for(String GivingIds:lstGivingIds){
                            Boolean blnFound = false;
                            if(GivingIds != null && GivingIds.trim().length()>0){
                                for(Opportunity opp:Trigger.old){
                                    if(opp.Id == GivingIds){
                                        blnFound = true;
                                        break;
                                    }
                                }
                                ProcessIds.add(ID.ValueOf(GivingIds));
                            }
                            if(blnFound == false){
                                blnAddtoDelete = false;
                                system.debug('######## Giving id found for delete summary');
                                break;
                            }
                        }
                        if(blnAddtoDelete == true)
                            lstDeleteSummary.add(summary);
                    }
                    else{
                        lstDeleteSummary.add(summary);
                    }
                }
                else{
                    lstDeleteSummary.add(summary);
                }
            }
            if(Trigger.IsDelete && lstDeleteSummary != null && lstDeleteSummary.size()>0){
                system.debug('####### total summary to delete : ' + lstDeleteSummary.size());
                delete lstDeleteSummary;
            }
        }
    }
    if(Trigger.IsDelete && processIds != null && processIds.size()>0){
        ProcessGivingSummary.UpdateSummary(processIds,true);
    }
}