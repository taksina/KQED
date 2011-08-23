public class ATSForgotPasswordController 
{
    public String username {get; set;}   
       
    public ATSForgotPasswordController() {}
        
	public PageReference forgotPassword() 
	{
		boolean success = Site.forgotPassword(username);
		PageReference pr = Page.ATS_Forgot_Password_Confirm;
		pr.setRedirect(true);
		
		if (success) 
		{                          
	    	return pr;
		}
		return null;
	}
        
	public static testMethod void testATSForgotPasswordController() 
	{
	    // Instantiate a new controller with all parameters in the page
	    ATSForgotPasswordController controller = new ATSForgotPasswordController();
	    controller.username = 'test@salesforce.com';            
	
	    System.assertEquals(controller.forgotPassword(),null); 
	}
}