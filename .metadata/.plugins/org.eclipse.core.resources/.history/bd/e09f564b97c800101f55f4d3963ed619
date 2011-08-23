trigger trgCampaignSourceCode on Campaign (Before Insert, Before Update) {
    CampaignSourceCode clsCampaign = new CampaignSourceCode();
    
    for (Campaign c: Trigger.New){
        String SourceCode = '';
        
        String Char1_2_3 = clsCampaign.Char1_2_3(c);
        
        String Char4 = clsCampaign.Char4(c);
        
        String Char5 = clsCampaign.Char5(c);
        
        String Char6 = clsCampaign.Char6(c);
        
        String Char7_8_9_10 = clsCampaign.Char7_8_9_10(c);
        
        String Char11_12 = clsCampaign.Char11_12(c);
        
        String Char13_14_15 = clsCampaign.Char13_14_15(c);
        
        SourceCode = Char1_2_3 + Char4 + Char5 + Char6 + Char7_8_9_10 + Char11_12 + Char13_14_15;
        
        c.Source_Code__c = SourceCode;
    }
}