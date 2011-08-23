trigger AddressNameTrigger on Address__c (before insert, before update) {
    for(Address__c addr :  Trigger.new) {
        addr.Name = addr.street_1__c + ', ' + addr.city__c + ', ' + addr.state__c + ' - ' + addr.Postal_Code__c;      
    }
}