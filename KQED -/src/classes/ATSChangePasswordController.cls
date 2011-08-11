public class ATSChangePasswordController 
{
	public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword()
    {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
   	public ATSChangePasswordController() {}
    
   	public static testMethod void testATSChangePasswordController()
   	{
        // Instantiate a new controller with all parameters in the page
        ATSChangePasswordController controller = new ATSChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }  

}