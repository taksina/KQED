trigger JobRequisition on Position__c (before insert, before update) {
    Set<Id> setAU = new Set<Id>();
    
    for (Position__c jr : Trigger.new) {
        if(jr.WGBH_Accounting_Unit__c != null)
            setAU.add(jr.WGBH_Accounting_Unit__c);
    }
    
    if(setAu != null && setAu.size() > 0) {
      //Following code commented out by Ketan Benegal. Need to test.
      /*  if(Test.isRunningTest()) { // Test are hitting List<> 1000 governor.
            return;
        }
      */  
        //Find how many activity codes each AU has
        for( List<sObject> lstCodes : [Select WGBH_Accounting_Unit__c, Count(Id) CountResult
                                    From WGBH_AUAC__c where WGBH_Accounting_Unit__c IN: setAU
                                    group By WGBH_Accounting_Unit__c]) {
        
            for (Position__c jr : Trigger.new){
                if (jr.Activity_Code__c == null){
                    for (sObject code : lstCodes){
                        //If the AU has Activity Codes, user must select one
                        if (jr.WGBH_Accounting_Unit__c == String.valueOf(code.get('WGBH_Accounting_Unit__c'))
                            &&Integer.valueOf(code.get('CountResult')) > 0
                        ){
                            jr.Activity_Code__c.addError('Please select an Activity Code for this Accounting Unit.');
                        }
                        
                    }
                }
            }
        }
    }
}

///Commented by LRT
/*
trigger JobRequisition on Position__c (before insert, before update) {
    Set<Id> setAU = new Set<Id>();
    
    for (Position__c jr : Trigger.new) {
        if(jr.WGBH_Accounting_Unit__c != null)
            setAU.add(jr.WGBH_Accounting_Unit__c);
    }
    
    if(setAu != null && setAu.size() > 0) {
        if(Test.isRunningTest()) { // Test are hitting List<> 1000 governor.
            return;
        }
        //Find how many activity codes each AU has
        for( List<sObject> lstCodes : [Select WGBH_Accounting_Unit__c, Count(Id) CountResult
                                    From WGBH_AUAC__c where WGBH_Accounting_Unit__c IN: setAU
                                    group By WGBH_Accounting_Unit__c]) {
        
            for (Position__c jr : Trigger.new){
                if (jr.Activity_Code__c == null){
                    for (sObject code : lstCodes){
                        //If the AU has Activity Codes, user must select one
                        if (jr.WGBH_Accounting_Unit__c == String.valueOf(code.get('WGBH_Accounting_Unit__c'))
                            &&Integer.valueOf(code.get('CountResult')) > 0
                        ){
                            jr.Activity_Code__c.addError('Please select an Activity Code for this Accounting Unit.');
                        }
                        
                    }
                }
            }
        }
    }
}
*/