@isTest 
private class Test_trgAddressBeforeUpdate {
    static testMethod void myTest() {
        Address__c a = new Address__c();
        a.Name = 'Test';
        insert a;
        a.undeliverable_count__c = 2;
        update a;
    }
}