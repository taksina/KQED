@isTest 
private class TesttrgProduct2AfterUpdate {
    static testMethod void myTest() {
        Product2 objProduct = new Product2();        
        objProduct.name = 'TestProduct';        
        objProduct.Family = 'Test';        
        objProduct.ProductCode = 'TESTPRODUCT';        
        objProduct.Description = 'TestProduct';        
        objProduct.IsActive = True;
        Insert objProduct;

        Product2 objProduct2 = new Product2();        
        objProduct2.name = 'TestProduct1';        
        objProduct2.Family = 'Test1';        
        objProduct2.ProductCode = 'TESTPRODUCT1';        
        objProduct2.Description = 'TestProduct1';        
        objProduct2.IsActive = True;
        Insert objProduct2;
        
        Package_Item__c  P = new Package_Item__c();
        P.Item__c = objProduct.Id;
        P.Package__c = objProduct2.Id;
        Insert P;
                
        objProduct.IsActive = False;
        Update objProduct;
    }
}