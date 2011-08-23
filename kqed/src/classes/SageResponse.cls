public class SageResponse
{

/*   static
   {
       try
       {
            System.debug('STATIC');
            String responseRawData = ApexPages.currentPage().getParameters().get('Response');
            String responseCleaned = responseRawData.replaceFirst('response=', '');
            String responseDecoded = EncodingUtil.urlDecode(responseCleaned, 'UTF-8');
            System.debug('responseRawData: ' + responseRawData);
            System.debug('responseCleaned: ' + responseRawData);
            System.debug('responseRawData: ' + responseRawData);
            Dom.Document doc = new Dom.Document();
            doc.load(responseDecoded);
            String responseMessage = doc.getRootElement()
                    .getChildElement('Response', null)
                    .getChildElement('ResponseMessage', null)
                    .getText();
                    
            System.debug('response=' + responseDecoded);
            SageData__c data = new SageData__c();
            data.RawData__c  = responseDecoded;
            insert data;
        }
        catch (Exception pageException)
        {
             System.debug('STATIC Exception: ' + pageException.getMessage());
            ApexPages.addMessages(pageException);
        }
    }*/

    public String responseRawData { set; get; }
    public String responseCleaned { set; get; }
    public String responseDecoded { set; get; }
    public String responseMessage { set; get; }

    public SageResponse()
    { 
	}
    
    public PageReference initialize()
    {
        try
        {
            System.debug('initialize');
            this.responseRawData = ApexPages.currentPage().getParameters().get('response');
            this.responseCleaned = responseRawData.replaceFirst('response=', '');
            this.responseDecoded = EncodingUtil.urlDecode(responseCleaned, 'UTF-8');

            System.debug('responseRawData: ' + responseRawData);
            System.debug('responseCleaned: ' + responseRawData);
            System.debug('responseRawData: ' + responseRawData);
            
            Dom.Document doc = new Dom.Document();
            doc.load(responseDecoded);
            responseMessage = doc.getRootElement()
                    .getChildElement('Response', null)
                    .getChildElement('ResponseMessage', null)
                    .getText();
                    
            System.debug('response=' + responseDecoded);
            SageData__c data = new SageData__c();
            data.RawData__c  = responseDecoded;
            insert data;
        }
        catch (Exception pageException)
        {
             System.debug('Exception: ' + pageException.getMessage());
            ApexPages.addMessages(pageException);
        }
        
        return null;
    
    }
     public static testMethod void testController(){
    	SageResponse sageResponse = new SageResponse();
    	PageReference page = new Pagereference('SageResponse');
    	Test.setCurrentPage(page);
    	sageResponse.responseRawData='response=%3c%3fxml+version%3d%221.0%22+encoding%3d%22utf-8%22%3f%3e%0d%0a%3cPaymentResponseType+xmlns%3axsi%3d%22http%3a%2f%2fwww.w3.org%2f2001%2fXMLSchema-instance%22+xmlns%3axsd%3d%22http%3a%2f%2fwww.w3.org%2f2001%2fXMLSchema%22%3e%0d%0a++%3cResponse%3e%0d%0a++++%3cResponseIndicator%3eX%3c%2fResponseIndicator%3e%0d%0a++++%3cResponseCode%3e900019%3c%2fResponseCode%3e%0d%0a++++%3cResponseMessage%3eINVALID+T_AMT+++++++++++++++++++%3c%2fResponseMessage%3e%0d%0a++%3c%2fResponse%3e%0d%0a++%3cTransactionResponse%3e%0d%0a++++%3cAVSResult%3e+%3c%2fAVSResult%3e%0d%0a++++%3cCVVResult%3eP%3c%2fCVVResult%3e%0d%0a++++%3cVANReference%3eA5IBILDKs0%3c%2fVANReference%3e%0d%0a++++%3cTransactionID%3etrans1%3c%2fTransactionID%3e%0d%0a++++%3cLast4%3eXXXXXXXXXXXX6666%3c%2fLast4%3e%0d%0a++++%3cPaymentDescription%3e566666XXXXXX6666%3c%2fPaymentDescription%3e%0d%0a++++%3cAmount%3e0%3c%2fAmount%3e%0d%0a++++%3cPaymentTypeID%3e5%3c%2fPaymentTypeID%3e%0d%0a++++%3cReference1%3ePO+123456%3c%2fReference1%3e%0d%0a++++%3cTransactionDate%3e5%2f18%2f2011+6%3a21%3a13+PM%3c%2fTransactionDate%3e%0d%0a++++%3cEntryMode%3eK%3c%2fEntryMode%3e%0d%0a++%3c%2fTransactionResponse%3e%0d%0a++%3cCustomer%3e%0d%0a++++%3cName%3e%0d%0a++++++%3cFirstName%3eJohn+A+Doe%3c%2fFirstName%3e%0d%0a++++%3c%2fName%3e%0d%0a++++%3cAddress%3e%0d%0a++++++%3cAddressLine1%3e12345+Street%3c%2fAddressLine1%3e%0d%0a++++++%3cAddressLine2+%2f%3e%0d%0a++++++%3cCity%3eSome+City%3c%2fCity%3e%0d%0a++++++%3cState%3eBDG%3c%2fState%3e%0d%0a++++++%3cZipCode%3e12345%3c%2fZipCode%3e%0d%0a++++++%3cCountry%3eAF%3c%2fCountry%3e%0d%0a++++++%3cEmailAddress%3ejohn.doe%40domain.com%3c%2fEmailAddress%3e%0d%0a++++++%3cTelephone%3e(123)+456-7891%3c%2fTelephone%3e%0d%0a++++++%3cFax%3e(123)+456-7890%3c%2fFax%3e%0d%0a++++%3c%2fAddress%3e%0d%0a++++%3cCompany%3e%0d%0a++++++%3cAddress+%2f%3e%0d%0a++++%3c%2fCompany%3e%0d%0a++%3c%2fCustomer%3e%0d%0a%3c%2fPaymentResponseType%3e'; 
    	System.assertEquals(sageResponse.initialize(),null);
    	/*SageData__c data = [Select s.SystemModstamp, s.RawData__c, s.OwnerId, s.Name, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById From SageData__c s where s.rawdata__c like 'response%'];
    	System.assertNotEquals(data, null);*/
    } 
}