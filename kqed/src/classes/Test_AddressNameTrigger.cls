@isTest
private class Test_AddressNameTrigger {
    static testMethod void myTest() {
        Address__c a = new Address__c(street_1__c='test',city__c='test',state__c='test',Postal_Code__c='test');
        insert a;
    }
}