public class SageVaultResponseHandler {
static{
			String strtemp = ApexPages.currentPage().getParameters().get('response');
			Map<String, String> myMap = ApexPages.currentPage().getParameters();
			//Set<String> s = ApexPages.currentPage().getHeaders().keySet();
			//List<String> headerList = ApexPages.currentPage().getHeaders().values();
/*			for(String listVal : headerList){
				System.debug('listVal value: ' + listVal);
			}
			*/
			for(String strKey : myMap.keySet())
{
    String thisList = myMap.get(strKey);

        System.debug('key: '+ strKey +'  listVal value: ' + thisList);

}
	//	System.debug('strtemp: ' + strtemp + '  set size:' + s.size());		
	
}
    public String response_v1{get{System.debug('response value:' + response_v1); return this.response_v1;} set;}
    public String res{get; set;}
    public CC_Alias__c  vccAlias ;
    
    public SageVaultResponseHandler(){

        String strtemp = ApexPages.currentPage().getParameters().get('Response');
        System.debug('strtemp: ' + strtemp);
        res = strtemp;     
        vccAlias = new CC_Alias__c();
        
    /*  vccAlias = new CC_Alias__c();
        vccAlias.Response__c = this.response_v1;
        vccAlias.Card_Holder_Name__c = 'aaa';
        insert vccAlias;
        System.debug('constructor; '+ vccAlias.Id);*/
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'response value:' + response_v1));
    }
    public void Save(){
        System.debug('response value 222:' + this.response_v1);
        vccAlias.Response__c = this.response_v1;
        insert vccAlias;
    }
    
    public String doData()
    {
       return res;
    } 
    
    public void methodA(){
        System.debug('methodA');
        
    }

}