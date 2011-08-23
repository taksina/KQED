/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestContactCaseTrigger {
/*
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    }
    */
    /** Create Contacts at Household level.
        Create Case at Contact level and check if it is attached to the Household.
        
    */
    static testMethod void createContactCaseTest(){

        Account h = new Account(
           Name = 'Mr. & Mrs. Joe Dirt', 
           TaAccountId__c = 23456
        );  
        insert h;     

        Contact c = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '23456_01_I',
           Account_Household__c = h.id
        );
        insert c;   


        Case case1 = new Case(
           ta_interactions_Id__c = '23456_01_I_SO_BAR',
           Origin='Email',
           Station__c='WGBH',
           Type='Jazz',
           Status='Open',
           ContactId = c.id,
           contact_date__c=System.today()
        );      
        insert case1; 
        Case case2 = new Case(
           ta_interactions_Id__c = '23456_00_I_SO_BAR',
           Origin='Email',
           Station__c='WGBH',
           Type='Jazz',
           Status='Open',
           Account_Household__c = h.id,
           contact_date__c=System.today()
        );      
        insert case2;  
        
        Case tcase2 = [SELECT ContactId, Account_Household__c FROM Case WHERE Id = :case2.id];
        System.AssertEquals(tcase2.Account_Household__c, h.id);     
         
    }
}