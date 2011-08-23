public class AtsCreatePortalUser_Util {
    public Boolean registerUser(String firstname, String lastname, String username, String password) {
        User u = new User();
        u.Username = username;
        u.Email =  username;
        u.Candidate_first_name__c = firstName;
        u.Candidate_last_name__c = lastName;
        u.CommunityNickname = username;      
        u.FirstName = firstName;
        u.LastName = lastName;
        //?? u.security_question__c= question;
        //?? u.answer__c= ans;
        
        String accountId = '060A0000000HOXp';

        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        String userId = Site.createPortalUser(u, accountId, password);
        if (userId != null) { 
            return true;
        }
        return false;
    }
    public Boolean go() {
        Contact[] contacts = [Select c.middle_name__c, c.bulk_load__c, c.TaContactId__c, c.OtherCity, c.MailingCity, c.LastName, c.FirstName, c.Email From Contact c  where email = 'janeapplicantwgbh@gmail.com'];             
        //Contact[] contacts = [Select c.middle_name__c, c.bulk_load__c, c.TaContactId__c, c.OtherCity, c.MailingCity, c.LastName, c.FirstName, c.Email From Contact c  where othercity = 'Timbukto'];      
        for(Contact cnt : contacts) {
            registeruser(cnt.firstname, cnt.lastname, cnt.email, 'fr3dfr3d');
        } 
        return true;    
    }
    
    static testMethod void Mytest() {
        AtsCreatePortalUser_Util clsTest = new AtsCreatePortalUser_Util();
        clsTest.registerUser('test','test','test','test');
        clsTest.go();
        
    }
}

//new AtsCreatePortalUser_Util().go();