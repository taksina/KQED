trigger trgAddressBeforeUpdate on address__c (before update) {
      
    for(address__c adr:Trigger.new){
        if(adr.undeliverable_count__c>=2){
            adr.address_status__c='Undeliverable';
        }
    }
    
}