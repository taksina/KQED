//MODIFIED BY BRW 2/2/2011

public class loginuser
{
	public String username {get; set;}
    public String password {get; set;}
    public string posid{get;set;}
       
	public loginuser()
	{
	    posid=apexpages.currentpage().getparameters().get('thisid');
	
	} 
     
    public PageReference validatelogin() 
    {
        String StartUrl;
       /*Ketan Benegal - following line commented out. Page redirects to member benefits page from ATS site.*/     
        //startUrl = System.currentPageReference().getParameters().get('startURL');
        /*The following line redirects to the application wizard.*/
        PageReference pg = new Pagereference('/apex/appwizard?id='+posid);
        startUrl = pg.getUrl();
        
        /*if (profileName[0].Name != 'Hiring Managers'){
            startUrl = System.currentPageReference().getParameters().get('startURL');
        }*/
        return Site.login(username, password, startUrl);
    }

	public pagereference signup()
	{
		pagereference pg = new pagereference('/apex/siteregister?redirect=1&posid='+posid);
		return pg;
	}
	
	public static testMethod void testLogin()
	{	
		Test.startTest();
		loginUser log   = new loginUser();
		log.posid       = '1234';
		String username = 'username';
		String password = 'password';
		log.username    = username;
		log.password    = password;
		System.assertEquals(log.username, username);
		System.assertEquals(log.password, password);
		System.assertEquals(log.validatelogin(), null);
		
		Test.stopTest();
	}
}