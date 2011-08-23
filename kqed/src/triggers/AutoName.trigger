trigger AutoName on Location__c (before insert) {
    for(Location__c location : Trigger.new) {
        String partnerName = [SELECT Name FROM Account WHERE Id = :location.Account__c][0].Name;
        location .Name = partnerName + ' at ' + location .City__c;
    }
}