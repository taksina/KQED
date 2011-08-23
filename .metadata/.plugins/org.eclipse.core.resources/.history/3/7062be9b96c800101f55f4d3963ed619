@isTest
private class ConvioServiceTest {

    static testMethod void myConvioService() {
    	
    	Account acc = new Account(Name = 'Test', alt_account_id__c = '1');
    	insert acc;
    	
    	Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
		insert con;
		
		Opportunity rd = 
							new Opportunity(
								alt_transaction_id__c = '1',
								//gift_date__c = ????????,
								source__c = 'INTERNET', 
								payment_frequency__c = '1',
								pledge_number__c = '80000000',
								Amount = 1,
								RecordTypeId = ConvioService.DONATION_REC_TYPE_ID,
								CloseDate = date.today(),
								StageName = 'Partial Close',
								AccountId = acc.Id,
								Name = acc.Name);
		insert rd;
		
        ConvioService cs = new ConvioService();
        System.debug(cs.dummyCont);
        cs.dummyCont.Birthdate = Date.today();
        cs.testRunConvio();
        
        ConvioService.processTodaysConvioProductOrdersAsynch();
        ConvioService.processTodaysConvioDonationsAsynch();
    }
}