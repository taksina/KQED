trigger PackageItemAfter on Package_Item__c (after delete, after insert, after undelete, after update) {
	//
	// For any change to Package/Item assignment, write the name(s) of the packages that an item belongs to on the  
	//
	
	Set<Id> productIds = new Set<Id>();
	for (Package_Item__c pi : (Trigger.New == null ? Trigger.Old : Trigger.New)) productIds.add(pi.Item__c);
	
	List<Product2> products = [Select Id, Item_Packs__c, (Select Package__c From Packages_Items__r Order By Package__r.Name) From Product2 Where Id IN : productIds];
	for (Product2 product : products) {
		String packages = '';
		for (Package_Item__c pi : product.Packages_Items__r) {
			packages += pi.Package__c + ',';
		}
		
		if (packages.length() > 1) product.Item_Packs__c = packages.substring(0, packages.length()-1);
		else product.Item_Packs__c = packages;
	}
	
	
	Database.update(products, false);
}