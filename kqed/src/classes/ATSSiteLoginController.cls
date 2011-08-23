global class ATSSiteLoginController 
{
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        //String startUrl = System.currentPageReference().getParameters().get('startURL');
        //return Site.login(username, password, startUrl);
        //MODIFIED BRW 2/19/2011
        pagereference pg = new pagereference('/apex/openpositions');
        return Site.login(username, password, pg.geturl());
    }
    
   	global ATSSiteLoginController () {}
    
    global static testMethod void testATSSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        ATSSiteLoginController controller = new ATSSiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}