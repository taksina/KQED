@isTest
private class ConvioWSTest {
	private static testMethod void testConvioWS() {
		ConvioWS.DescribeRecordType_element drt= new ConvioWS.DescribeRecordType_element();
		ConvioWS.DescribeRecordTypeResponse_element drtr= new ConvioWS.DescribeRecordTypeResponse_element();
		ConvioWS.DescribeRecordTypeResult drtr2= new ConvioWS.DescribeRecordTypeResult();
		ConvioWS.Field f = new ConvioWS.Field();
		ConvioWS.FieldOption fo= new ConvioWS.FieldOption();
		ConvioWS.Find_element fe= new ConvioWS.Find_element();
		ConvioWS.FindResponse_element fre= new ConvioWS.FindResponse_element();
		ConvioWS.GetServerTime_element gst= new ConvioWS.GetServerTime_element();
		ConvioWS.GetServerTimeResponse_element gstr = new ConvioWS.GetServerTimeResponse_element();
		ConvioWS.GetServerTimeResult gstr2 = new ConvioWS.GetServerTimeResult();
		ConvioWS.Login_element l = new ConvioWS.Login_element();
		ConvioWS.LoginResult lr = new ConvioWS.LoginResult();
		ConvioWS.SupportedOperations so = new ConvioWS.SupportedOperations();
		ConvioWS.Session_element se = new ConvioWS.Session_element();
		ConvioWS.Soap s = new ConvioWS.Soap();
		try {
			s.Find('', new String[]{'4','5'}, new Integer[]{1,2});
		} catch(exception ex) {}
		try{
			s.GetServerTime();
		} catch(exception ex) {}
		try{	
			s.Login('', '');
		} catch(exception ex) {}
		try{
			s.Query('', 5, 5);
		} catch(exception ex) {}
		try{
			s.Query('', 5, 5, '');
		} catch(exception ex) {}
		ConvioWS.Query_element qe = new ConvioWS.Query_element();
		ConvioWS.QueryResponseDonation_element qrd = new ConvioWS.QueryResponseDonation_element();
		ConvioWS.QueryResponseProduct_element qrp = new ConvioWS.QueryResponseProduct_element();
		ConvioWS.QueryResponseProductOrder_element qrpo = new ConvioWS.QueryResponseProductOrder_element(); 
	}
}