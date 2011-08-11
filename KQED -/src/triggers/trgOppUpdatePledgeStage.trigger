trigger trgOppUpdatePledgeStage on Opportunity (Before Update, After Update, Before Insert, After Insert) {
    if(Trigger.IsBefore) {
        integer i=0;
        for(Opportunity opp: Trigger.New) {
            Double GivingAmount = 0;
            if(opp.Recurring_Donation_Opportunity__c == null)
                GivingAmount = opp.Giving_Amount__c;
            else
                GivingAmount = opp.Installment_Amount__c;
            String oldStage='';
            if(Trigger.IsUpdate)
                oldStage = Trigger.Old[i].StageName;
            else
                oldStage = opp.StageName;
            i++;
            if((oldStage == 'Pledged' || oldStage == 'Partially Fulfilled' || oldStage == 'Fulfilled') && opp.StageName!='Partially Collected' && opp.StageName!='Uncollectible'){
                if(opp.payment_amount__c > 0) {
                    if(opp.payment_amount__c < GivingAmount) {
                        opp.StageName = 'Partially Fulfilled';
                    }
                    else if(opp.payment_amount__c >= GivingAmount) {
                        opp.StageName = 'Fulfilled';
                    }
                }
            }
            if(opp.Gift_Date_Time__c != null)
            {
                opp.CloseDate = opp.Gift_Date_Time__c.date();
            }
        }
        /////////////
        if(Trigger.IsUpdate){
            Set<ID> setParentId = new Set<ID>();
            Map<ID,Date> mapPaymentDate = new Map<ID,Date>();
            for(Opportunity opp: Trigger.New) {
                if(opp.Recurring_Donation_Opportunity__c != null){
                    if(opp.payment_amount__c != null && opp.payment_amount__c > 0 && opp.Payment_Date__c != null){
                        setParentId.add(opp.Recurring_Donation_Opportunity__c);
                        mapPaymentDate.put(opp.Recurring_Donation_Opportunity__c,opp.Payment_Date__c);
                    }
                }
                if(setParentId != null && setParentId.size()>0){
                    List<Opportunity> lstParent = [Select Id, Gift_Kind__c, Payment_Date__c From Opportunity Where Id in:setParentId];
                    if(lstParent != null && lstParent.size()>0){
                        for(Opportunity parent:lstParent){
                            if(parent.Gift_Kind__c.trim().toUpperCase()=='INSTALLMENT' || parent.Gift_Kind__c.trim().toUpperCase()=='SUSTAINING GIFT'){
                                if(mapPaymentDate != null && mapPaymentDate.size()>0 && mapPaymentDate.containsKey(parent.id)){    
                                    Date childDate = mapPaymentDate.get(parent.id);
                                    if(parent.Payment_Date__c == null){
                                        parent.Payment_Date__c = childDate;
                                    }
                                    else if(parent.Payment_Date__c != null && parent.Payment_Date__c < childDate){
                                        parent.Payment_Date__c = childDate;
                                    }
                                }
                            }
                        }
                        update lstParent;
                    }
                }
            }
        }
        /////////////
    }
    if(Trigger.IsAfter) {
        Set<ID> OppIDs = new Set<ID>();
        Set<ID> ParentOppIDs = new Set<ID>();
        for(Opportunity opp: Trigger.New) {
            if(Opp.Recurring_Donation_Opportunity__c!=null) {
                if(!OppIds.contains(Opp.Recurring_Donation_Opportunity__c)) {
                    OppIDs.add(Opp.Id);
                    ParentOppIDs.add(Opp.Recurring_Donation_Opportunity__c);
                }
            }
        }
        

        AggregateResult[] groupedResults = 
        [SELECT Recurring_Donation_Opportunity__c,
        Sum(Payment_Amount__c) TotalAmount FROM Opportunity Where Recurring_Donation_Opportunity__c IN: ParentOppIDs 
        GROUP BY Recurring_Donation_Opportunity__c];
        
        Map<Id,Double> MapAmount = new Map<ID,Double>();

        for (AggregateResult ar : groupedResults) {
            MapAmount.put((ID)ar.get('Recurring_Donation_Opportunity__c'),(Double) ar.get('TotalAmount'));
        }
        
        List<Opportunity> lstOpp = [Select ID,Recurring_Donation_Opportunity__c,payment_amount__c,(Select StageName from Giving_Installments__r) from Opportunity where ID IN: ParentOppIDs];
        for(Opportunity o: lstOpp) {
            if(MapAmount.containsKey(o.Id)) {
                o.Payment_Amount__c = MapAmount.get(o.Id);
            }
            
            Boolean IsUNCOLLECTIBLE=false;
            for(Opportunity oppChild: o.Giving_Installments__r) {
                if(oppChild.StageName == 'Uncollectible') {
                    IsUnCollectible = true;
                    break;
                }
            }
            if(IsUnCollectible==true) {
                if(o.Payment_amount__c >0) {
                    o.StageName = 'Partially Collected';
                }
                else {
                    o.StageName = 'Uncollectible';
                }
            }
            
        }

        if(Trigger.IsUpdate) {
            Set<ID> sOpp = New Set<ID>();
            integer i = 0;
            for(Opportunity oppTemp : Trigger.New) {
                if((Trigger.old[i].StageName !='Fulfilled' && Trigger.New[i].StageName =='Fulfilled') 
                    || (Trigger.old[i].StageName !='Partially Fulfilled' && Trigger.New[i].StageName =='Partially Fulfilled')) {
                    sOpp.add(oppTemp.Id);
                }
                i++;
            }
            
            List<OpportunityLineItem> lstOppItem = [Select ID,Fulfillment_Status__c from OpportunityLineItem where OpportunityID IN: sOpp And Fulfillment_Status__c='Pending'];
            for(OpportunityLineItem oppLineItem: lstOppItem) {
                oppLineItem.Fulfillment_Status__c = 'Ready to Process';
            }            
            if(lstOppItem.size()>0) Update lstOppItem;
        }
        
        if(lstOpp.size()>0) Update lstOpp;
        
    }
    

}