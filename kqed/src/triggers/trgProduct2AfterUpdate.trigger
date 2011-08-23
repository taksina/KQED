trigger trgProduct2AfterUpdate on Product2 (After Update) {
    Set<ID> sProductIDs = new Set<ID>();
    
    integer i=0;
    
    for(Product2 p: Trigger.New) {
        if(Trigger.old[i].IsActive != p.IsActive && p.IsActive==false) {
            sProductIds.add(p.Id);
        }
        i++;
    }
    
    List<Package_Item__c> lstPackage = [Select ID,Item__c,Package__c from Package_Item__c where Item__c IN:sProductIDs];
        
    List<Product2> lstProduct = [Select ID,IsActive from Product2 where ID IN (Select Package__c from Package_Item__c where Item__c IN:sProductIDs)];

    for(Product2 p: lstProduct) {
        p.IsActive=false;
    }
    
    if(lstProduct.size()>0) {
        Update lstProduct;
    }
}