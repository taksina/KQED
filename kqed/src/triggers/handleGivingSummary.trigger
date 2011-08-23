trigger handleGivingSummary on Giving_Summary__c (before insert, before update) {
    List<account> lstupdated = new List<account>();
    set<id> lstaccountid = new set<id>();
    for(giving_summary__c b : Trigger.new){
         if(b.History__c==false) lstaccountid.add(b.account__c);
    }
    map<id,account> mapaccount = new map<id,account>([select id,WGBH_Major_Donor_flag__c,WGBY_Major_Donor_Flag__c,WCAI_Major_Donor_Flag__c
                                                            from account where id in :lstaccountid]);
    for(giving_summary__c gs:Trigger.new){
        if(gs.station__c=='WGBH' && gs.giving_level__c=='Ralph Lowell Society' && gs.shopper__c==false && gs.History__c==false){
            if(mapaccount.containskey(gs.account__c)){
                account acctmp = mapaccount.get(gs.account__c);
                acctmp.WGBH_Major_Donor_flag__c=true;
                lstupdated.add(acctmp);
            }
        }else
        if(gs.station__c=='WGBY' && gs.giving_level__c=='Murrow Society' && gs.shopper__c==false && gs.History__c==false){
            if(mapaccount.containskey(gs.account__c)){
                account acctmp = mapaccount.get(gs.account__c);
                acctmp.WGBY_Major_Donor_Flag__c=true; 
                lstupdated.add(acctmp);
            }
        }else
        if(gs.station__c=='WCAI' && gs.giving_level__c=='Major Donor' && gs.shopper__c==false && gs.History__c==false){
            if(mapaccount.containskey(gs.account__c)){
                account acctmp = mapaccount.get(gs.account__c);
                acctmp.WCAI_Major_Donor_Flag__c=true; 
                lstupdated.add(acctmp);
            }
        }
    }
    
    if(lstupdated.size()>0){
        update lstupdated;
    }
}