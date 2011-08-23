trigger trgOppBeforeInsertUpdate on Opportunity (Before Insert, Before Update) {
    for(Opportunity opp: Trigger.new) {
        if(opp.Gift_Date_Time__c!=null) {
            opp.Gift_Date_3_Month__c = opp.Gift_Date_Time__c.Date().addMonths(3);
            opp.Gift_Date_6_Month__c = opp.Gift_Date_Time__c.Date().addMonths(6);
            opp.Gift_Date_18_Month__c = opp.Gift_Date_Time__c.Date().addMonths(18);
        }
    }
}