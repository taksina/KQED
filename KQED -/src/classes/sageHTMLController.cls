public class sageHTMLController {

    public sageHTMLController(){}

    public String getSoapPost() {
    
         String soapRequest = '<input type="hidden" name="request" value="<?xml version=&quot;1.0&quot; encoding=&quot;utf-16&quot;?>\n';
                soapRequest += '<Request_v1 xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot;>\n';
                soapRequest += '<Application>\n';
                soapRequest += '<ApplicationID>ROUNSALE2011000CRMTAAF8USEN</ApplicationID>\n';
                soapRequest += '<LanguageID>EN</LanguageID>\n';
                soapRequest += '</Application>\n';
                soapRequest += '<Payments>\n';
                soapRequest += '<PaymentType>\n';
                soapRequest += '<Merchant>\n';
                soapRequest += '<MerchantID>479888405306</MerchantID>\n';
                soapRequest += '<MerchantKey>J6F7L8H7C6S7</MerchantKey>\n';
                soapRequest += '</Merchant>\n';
                soapRequest += '<TransactionBase>\n';
                soapRequest += '<TransactionID>trans1</TransactionID>\n';
                soapRequest += '<TransactionType>11</TransactionType>\n';
                soapRequest += '<Reference1>PO 123456</Reference1>\n';
                soapRequest += '<Amount>0.0</Amount>\n';
                soapRequest += '</TransactionBase>\n';
                soapRequest += '<Customer>\n';
                soapRequest += '<Name>\n';
                soapRequest += '<FirstName>John</FirstName>\n';
                soapRequest += '<MI>A</MI>\n';
                soapRequest += '<LastName>Doe</LastName>\n';
                soapRequest += '</Name>\n';
                soapRequest += '<Address>\n';
                soapRequest += '<AddressLine1>12345 Street</AddressLine1>\n';
                soapRequest += '<AddressLine2>Apt 2</AddressLine2>\n';
                soapRequest += '<City>Some City</City>\n';
                soapRequest += '<State>Some State</State>\n';
                soapRequest += '<ZipCode>12345</ZipCode>\n';
                soapRequest += '<Country>Some Country</Country>\n';
                soapRequest += '<EmailAddress>john.doe@domain.com</EmailAddress>\n';
                soapRequest += '<Telephone>1234567891</Telephone>\n';
                soapRequest += '<Fax>1234567890</Fax>\n';
                soapRequest += '</Address>\n';
                soapRequest += '<Company>\n';
                soapRequest += '<Name>John\'s Company</Name>\n';
                soapRequest += '<Address>\n';
                soapRequest += '<AddressLine1>12345 Street</AddressLine1>\n';
                soapRequest += '<AddressLine2>Apt 2</AddressLine2>\n';
                soapRequest += '<City>Some City</City>\n';
                soapRequest += '<State>Some State</State>\n';
                soapRequest += '<ZipCode>12345</ZipCode>\n';
                soapRequest += '<Country>Some Country</Country>\n';
                soapRequest += '<EmailAddress>john.doe@domain.com</EmailAddress>\n';
                soapRequest += '<Telephone>1234567891</Telephone>\n';
                soapRequest += '<Fax>1234567890</Fax>\n';
                soapRequest += '</Address>\n';
                soapRequest += '</Company>\n';
                soapRequest += '</Customer>\n';
                soapRequest += '<Postback>\n';
                soapRequest += '<HttpsUrl>https://c.cs3.visual.force.com/apex/SageResponseHandler</HttpsUrl>\n';
                soapRequest += '</Postback>\n';
                soapRequest += '</PaymentType>\n';
                soapRequest += '</Payments>\n';
                soapRequest += '</Request_v1>\n';
                soapRequest += '" />';
    
        return soapRequest;
    
    }
    
    public static testmethod void sageHTMLControllerTest() {
        sageHTMLController con  = new sageHTMLController();
        con.getSoapPost();
    }
    
}