trigger trgCampaignMemberAfterInsert on CampaignMember (After Insert) {
    Set<ID> cMemberIDs = new Set<ID>();
    
    for(CampaignMember cm: Trigger.new) {
        cMemberIDs.add(cm.ID);
    }
    
    List<CampaignMember> lstCampaignMem = [Select ID,CampaignID,ContactID,
                Campaign.Channel_Technique__c,Campaign.Sub_Channel__c
                from CampaignMember where ID IN: cMemberIDs and ContactID!=null
                and Campaign.Channel_Technique__c = 'Telesales' and Campaign.Sub_Channel__c = 'Outbound'];


    List<Opportunity> lstOpp = new List<Opportunity>();
                    
    for(CampaignMember c: lstCampaignMem) {
        Opportunity opp = new Opportunity();
        opp.name = 'test';
        opp.Oppty_Related_Contact__c = c.ContactID;
        opp.StageName = 'Solicitation/Proposal';
        opp.CloseDate = system.today();
        lstOpp.add(opp);
    }
    if (lstOpp.size()>0) insert lstOpp;
}