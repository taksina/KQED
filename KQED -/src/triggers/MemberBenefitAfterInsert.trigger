trigger MemberBenefitAfterInsert on Member_Benefit__c (after insert) {
    
    Map<Id, Member_Benefit__c> accIdMemBenefitsMap = new Map<Id, Member_Benefit__c>();
    for(Member_Benefit__c memberBenefit : Trigger.new) {
        accIdMemBenefitsMap.put(memberBenefit.Business_Member_Partner__c, memberBenefit); 
    }
    
    List<Account> partners = 
                    [SELECT a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCity, a.phone, 
                          (Select Id, Name, Street__c, City__c, State__c, PostalCode__c, Phone__c From Locations__r) 
                     FROM Account a
                     WHERE a.id IN :accIdMemBenefitsMap.keySet()];
    
    List<Location__c> locations = new List<Location__c>();
    //List<Location__c> existingLocations = new List<Location__c>();
    for(Account partner : partners) {
        if(partner.locations__r == null || partner.locations__r.size() == 0) {
             Location__c location = new Location__c();
             location.Street__c = partner.ShippingStreet;
             location.City__c = partner.ShippingCity;
             location.State__c = partner.ShippingState;
             location.PostalCode__c = partner.ShippingPostalCode;
             location.Phone__c = partner.phone;
             location.Name = partner.ShippingCity + ' ' + partner.ShippingState;
             
             location.Account__c = partner.Id;
             locations.add(location);
        }
        else {
            //existingLocations.add(partner.locations__r);
        }
    }
    insert locations;
    
    /*locations.addAll(existingLocations);
    
    List<Member_benefit_Location__c> mblList = new List<Member_benefit_Location__c>();
    for(Location__c location : locations) {
         Member_Benefit__c memberBenefit = accIdMemBenefitsMap.get(location.Account__c);
         
         Member_benefit_Location__c mbl = new Member_benefit_Location__c(
               Name = memberBenefit.Name + ' in ' + location.Name,
               Member_Benefit__c = memberBenefit.Id,
               Location__c = location.Id
         );
         mblList.add(mbl);
    }
    insert mblList;
    */
}