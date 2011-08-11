trigger trgOppPreferenceHandler on Opportunity (After insert,After update) {
    List<Classification__c> lstUpdate = new List<Classification__c>();
    List<Classification__c> lstInsert = new List<Classification__c>();
    List<Classification__c> lstClass = new List<Classification__c>();
    
    Set<string> setStation = new Set<string>();
    Set<string> setPreference = new Set<string>();
    Set<string> setValue = new Set<string>();
    Set<ID> ContactIds = new Set<ID>();
    Set<ID> AccIDs = new Set<ID>();
    
    RecordType r = [Select ID from RecordType where DeveloperName='ongoing_membership' limit 1];
    
    for(opportunity a:Trigger.new){
        if((a.station__c == 'WGBH' || a.station__c == 'WGBY' || a.station__c == 'WCAI')
            && a.product__c == 'MEMBERSHIP'
            && a.campaign_name__c == 'ANNUAL'
            && a.gift_kind__c == 'Sustaining Gift' && a.Recurring_Donation_Opportunity__c==null
            ){
                
                Classification__c objclass = new Classification__c();
                
                objclass.station__c = a.station__c;
                objclass.Preference__c = 'Sustainer Type';
                objclass.RecordtypeId = r.Id;
                If (a.PAYMENT_METHOD__c == 'Check')
                    objclass.Preference_Value__c = 'Payment via Check';
                If (a.PAYMENT_METHOD__c == 'Charge Card')
                    objclass.Preference_Value__c = 'Payment via Credit Card';
                If (a.PAYMENT_METHOD__c == 'Electronic Funds Transfer')
                    objclass.Preference_Value__c = 'Payment via EFT';
                If (a.PAYMENT_METHOD__c == 'Complimentary')
                    objclass.Preference_Value__c = 'Complimentary';
                If (a.PAYMENT_METHOD__c == 'Payroll Deduction')
                    objclass.Preference_Value__c = 'Payment via Payroll Deduction';
                
                //objClass.RecordTypeID = '';
                objClass.start_date__c = a.closedate;
                if(a.AccountID!=null && a.Oppty_Related_Contact__c!=null) {
                    objClass.Contact__c = a.Oppty_Related_Contact__c;
                }
                else {
                    objClass.Account__c = a.AccountID;
                }
                
                
                if(a.Oppty_Related_Contact__c!=null) ContactIds.add(a.Oppty_Related_Contact__c);
                if(a.AccountID!=null) AccIDs.add(a.AccountID);
                setStation.add(a.Station__c);
                lstClass.add(objclass);
            }
    }
    
    List<Classification__c> lst = [Select Id, Account__c,Station__c, Preference__c, Preference_Value__c, Contact__c
                    from Classification__c 
                    Where recordTypeId =: r.Id and Station__c in: setStation And Preference__c ='Sustainer Type' AND
                    ((Account__c IN: AccIDs and Account__c!=null) OR (Contact__c IN: ContactIDs AND Contact__c!=null))
                    ];
    
    system.debug('##############' + lst.size());
    
    if(lstClass != null && lstClass .size()>0){
    
        for(classification__c current:lstClass){
    
            boolean blnfound = false;
    
            if(lst != null && lst.size()>0){
    
                for(classification__c existing:lst){
                    if(existing.station__c == current.station__c &&
                       existing.Preference__c == current.Preference__c &&
                       (existing.Account__c == current.Account__c ||
                       existing.Contact__c == current.Contact__c)){
                           blnfound = true;
                           break;
                    }
                }
            }
            //if(blnfound == true)
                //lstUpdate.add(current);
            //else
                 
                if(blnfound==false) lstInsert.add(current);
        }
    }
    //if(lstUpdate != null && lstUpdate.size() > 0)
        //update lstUpdate;
    if(lstInsert != null && lstInsert.size() > 0)
        insert lstInsert;
}