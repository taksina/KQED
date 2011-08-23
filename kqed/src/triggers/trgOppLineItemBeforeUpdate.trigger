trigger trgOppLineItemBeforeUpdate on OpportunityLineItem (Before Update) { 
    for (OpportunityLineItem opp : [select ID,Sent_Number__c, Committed_Number__c,Pricebookentry.Product2.Premium_Category__c from OpportunityLineItem where ID in :Trigger.NewMap.keySet()]) {
        OpportunityLineItem oppTemp = Trigger.oldMap.get(opp.Id);
        if(oppTemp.Sent_Number__c == oppTemp.Committed_Number__c && 
            (oppTemp.Pricebookentry.Product2.Premium_Category__c==' Program Guide' || oppTemp.Pricebookentry.Product2.Premium_Category__c=='CD-ROM')) {
            oppTemp.Fulfillment_Status__c = 'Completed';
        }
    }
}