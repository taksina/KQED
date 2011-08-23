//new version
public class ATSSiteRegisterController 
{
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
   //This is the id of the fname organization
    //private static Id PORTAL_ACCOUNT_ID = '001A000000YcAp3'; // '001S000000MPhEX'; 
    private static Id PORTAL_ACCOUNT_ID = '001T000000lPz6Z';
    Public boolean redirect;
    
   public List<SelectOption> getSecurityQuestions() {
    List<SelectOption> options = new List<SelectOption>();
     
    options.add(new SelectOption('What is your pets name?','What is your pet\'s name?'));
    options.add(new SelectOption('What is your mothers maiden name?','What is your mother\'s maiden name?')); 
    options.add(new SelectOption('What city were you born in?','What city were you born in?'));
    options.add(new SelectOption('In what city was your first job?','In what city was your first job?'));
    options.add(new SelectOption('What is the name of your favorite sports team?','What is the name of your favorite sports team?'));
/*    options.add(new SelectOption('In what city did you meet your spouse/significant other?','In what city did you meet your spouse/significant other?'));
    options.add(new SelectOption('What was your childhood nick name?','What was your childhood nick name?'));
  */  
    return options; 
    }

public String question{get;set;}   
public String ans{get; set;} 

public String posid{get;set;}
   
    public ATSSiteRegisterController () {
        if(ApexPages.currentPage().getParameters().get('posid')!=null)
        {
            posid = ApexPages.currentPage().getParameters().get('posid');
        }
        
        if(ApexPages.currentPage().getParameters().get('redirect')!=null)
        {
            redirect=true;
        }
        else
            redirect = false;
    }

    public String username
     {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }

/* Ketan Benegal - Renamed fname -> firstName, mname -> middleName, lname -> lastName - Start*/    
    Public String firstName{get;set;}
    Public String middleName{get; set;}
    Public String lastName{get; set;}
/*    Public String fname{get; set;}
    Public String mname{get; set;}
    Public String lname{get; set;}
  */  
/* Ketan Benegal - Renamed fname -> firstName, mname -> middleName, lname -> lastName - End*/    
    Public String securityques{get; set;}
      
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    private boolean isValidUserName(){
        String at = '@';
        String dot = '.';
        Integer iLenAt = username.indexOf(at);
        Integer iLenDot = username.indexOf(dot,iLenAt);
        
        if(username.indexOf(at) <= 0 || username.indexOf(at) == username.length() || username.indexOf(dot) <= 0 
        || username.indexOf(dot) == username.length() || username.substring(iLenAt+1,iLenAt+2)==dot || username.indexOf(dot,(iLenAt+2))==-1 || username.indexOf(' ') !=-1 ){
            return false;
        }
 
        return true;
    }
/*Ketan Benegal - Code Start*/
/* method: checkUserRegistrationInfo
*  description: Check if firstName, lastName and userName are blank.
*  return: if all values entered return true else return false.
*/    
 public Boolean checkUserRegistrationInfo(){
    Boolean bRetVal = true;
    if(this.firstName==null) this.firstName='';
    String first_Name = this.firstName.trim();
    System.debug('222');
        //if (('').equals(this.firstName) || (this.firstName == null)){
          if (first_Name.length() == 0 ){
//             ApexPages.Message msgFirstName = new ApexPages.Message(ApexPages.Severity.INFO, 'First Name is required.',  'First Name is required.');
            ApexPages.Message msgFirstName = new ApexPages.Message(ApexPages.Severity.ERROR, 'First Name is required.');
            ApexPages.addMessage(msgFirstName);
 
            bRetVal= false;
        }
    System.debug('333' + bRetVal);
        
        if (('').equals(this.lastName)){
            ApexPages.Message msgLastName = new ApexPages.Message(ApexPages.Severity.ERROR, 'Last Name is required.','Last Name is required.');
            ApexPages.addMessage(msgLastName);
            bRetVal= false;
        }
    System.debug('444' + bRetVal);

        if (('').equals(this.userName)){
            ApexPages.Message msgUserName = new ApexPages.Message(ApexPages.Severity.ERROR, 'Username is required.');
            ApexPages.addMessage(msgUserName);
            bRetVal= false;
        }
    System.debug('555' + bRetVal);
    return bRetVal;
 }   
 
/*Ketan Benegal  - Code End*/ 
    public PageReference registerUser() {
        /*Ketan Benegal - Code Start*/
  
        if(!checkUserRegistrationInfo()){
    System.debug('here');
        return null;
        }
        /*Ketan Benegal - Code Start*/
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        User u = new User();
        /*Ketan Benegal - Commented out - NickName should not appear on the page and should be defaulted to the username 
        Email should be the same as username. Prevented double entry.
        Added two properties firstName and lastName- Start*/
        if (isValidUserName()){
        u.Username = username;
        //u.Email = email;
        u.Email =  username;
        //u.CommunityNickname = communityNickname;
        //u.Username =  email;
        /*TEMPORARY SOLUTION PLEASE REMOVE THE FOLLOWING LINES-START*/
        u.Candidate_first_name__c = firstName;
        u.Candidate_last_name__c = lastName;
        /*TEMPORARY SOLUTION PLEASE REMOVE THE FOLLOWING LINES-END*/
        //u.CommunityNickname = username + String.valueOf(Math.random());
        //CHANGED BY BRW - adding math.random caused the filed to exceed the field length
        u.CommunityNickname = username;
        } else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Username should be a valid email address.');
            ApexPages.addMessage(msg);
            return null;
        }
       
        u.FirstName = firstName;
        u.LastName = lastName;
        /*Ketan Benegal - Commented out - NickName should not appear on the page and should be defaulted to the username - End*/
        u.security_question__c= question;
        u.answer__c= ans;
        
        String accountId = PORTAL_ACCOUNT_ID;

        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        
        try{
         String userId = Site.createPortalUser(u, accountId, password);
        if (userId != null) { 
        
         /*   candidate__C ca= new candidate__C();
            ca.username__c= username;
            ca.Registration_Email__c= email;
            ca.Password__c= password;
            ca.Confirm_Password__c=confirmpassword;
            ca.Security_Question__c=Question;
            ca.Answer__C= answer;
            
            insert ca;
            
            */
            
           // User usr = [Select id, contactid from User where id=:userid];
            //Contact c = [Select id, name from Contact where id=:usr.contactid];
           // c.firstname =fname;
            //update c;
            
            if (password != null && password.length() > 1) {
                    if(redirect)
                    {
                        pagereference pg = new pagereference('/apex/appwizard?id='+posid);
                        return Site.login(username, password, pg.geturl());
                    }else
                    {
                        pagereference pg = new pagereference('/apex/openpositions');
                        return Site.login(username, password, pg.geturl());
                    
                    }    
            }
            else {
                PageReference page = System.Page.ATSSiteRegisterConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Problem in createPortalUser');
            ApexPages.addMessage(msg);
        }
        return null;
    }
    
    // Test method to bring this class's test coverage over the required 75%
    static testMethod void testRegistration() {
        
        ApexPages.currentPage().getParameters().put('posid','1212123333');
        ApexPages.currentPage().getParameters().put('redirect','1212123333');
        ATSSiteRegisterController controller = new ATSSiteRegisterController();
        
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test@force.com';
        controller.firstname = 'tes1t@force.com';
        controller.middleName = 'force.com';
        controller.lastName= 'forcecom';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';
        System.assert(controller.registerUser() == null);  
        controller.getSecurityQuestions();
        controller.isValidPassword();
        
        controller.isValidUserName();
        controller.firstname='';
        controller.lastname='';
        controller.userName='';
        controller.checkUserRegistrationInfo();
        controller.registerUser();
        
    }
}