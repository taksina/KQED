trigger trgAccount on Account (Before Insert,Before Update) {
    for(Account a: Trigger.new) {
        if(a.Acquired_Date__c==null) {
            if(Trigger.IsUpdate) {
                a.Acquired_Date__c = Date.NewInstance(a.CreatedDate.year(),a.CreatedDate.Month(),a.CreatedDate.Day());
            }
            else {
                a.Acquired_Date__c = system.Today();
            }            
        }

    }



}