trigger trgClassificationAfterInsert on Classification__c (After Insert) {
    Set<ID> AccIDs = new Set<ID>();
    Set<ID> ContactIDs = new Set<ID>();

    for(Classification__c c: Trigger.new) {
        if((c.Contact__c!=null || c.Account__c!=null) && c.Classification_Type__c == 'Member Category' && c.Preference__c == 'Member Type' && c.Preference_Value__c == 'Great Blue Hill Society') {
            if(c.Account__c!=null) {
                if(AccIDs.contains(c.Account__c)==false) AccIDs.add(c.Account__c);
            }
            if(c.Contact__c!=null) {
                if(ContactIDs.contains(c.Contact__c)==false) ContactIDs.add(c.Contact__c);
            }
        }
    }
    
    List<Contact> lstContact = [Select ID, AccountID from Contact where ID IN: ContactIDs];
    
    for(Contact c1: lstContact) {
        if(c1.AccountID!=null) {
            if(AccIDs.contains(c1.AccountID)==false) AccIDs.add(c1.AccountID);
        }        
    }
    
    List<Account> lstAccount = [Select ID, Great_Blue_Hill_Society__c from Account where ID IN: AccIDs];
    
    for(Account a: lstAccount) {
        a.Great_Blue_Hill_Society__c = true;
    }
    
    if(lstAccount.size()>0) update lstAccount;

//Great_Blue_Hill_Society__c
}