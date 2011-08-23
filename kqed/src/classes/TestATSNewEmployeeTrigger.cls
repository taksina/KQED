/**
 * This class contains unit tests for validating the behavior of creating new Candidates, Job Requisitions
 * and Job Applications. It tests the hiring and rejection of candidates as well as the 
 * approval of job requisitions. 
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestATSNewEmployeeTrigger 
{

    static testMethod void testNewEmployeeTriggerAfterUpdate() 
    {
        // TO DO: implement unit test
        //first create a job req
        Position__c jobReq                 = new Position__c();
        
        //set all the pick list values
        jobReq.Status__c                   = 'Open - Approved';
        jobReq.Affiliation__c              = 'Management';
        jobReq.Type__c                     = 'Full-Time';
        jobReq.Classification__c           = 'Staff';
        jobReq.New_Existing_Position__c    = 'New Position';
        jobReq.Location__c                 = 'Boston';
        jobReq.Building_Location__c        = '10 Guest St';
        jobReq.Building_Location_Code__c   = '10 GUEST';
        
        //set all the text values
        jobReq.Hours_Per_Week__c           = '40';
        jobReq.Created_By_Email__c         = 'brian_wainwright@wgbh.org';
        jobReq.Open_Date__c                = System.today();
        jobReq.Publish_OpenDate__c         = System.today();
        jobReq.HR_Consult__c               = true;
        jobReq.Active__c                   = true;
        jobReq.Min_Pay__c                  = 50000.00;
        jobReq.Max_Pay__c                  = 60000.00;
        jobReq.Job_Description__c          = 'This is a test department overview';
        jobReq.Responsibilities__c         = 'This is a test position overview';
        jobReq.Skills_Required__c          = 'This is a test skills required';
        jobReq.Educational_Requirements__c = 'This is a test education requirements';
        jobReq.Billing_Account_Category__c = 'A100';
        
        //set the lookup values
        //get the title
        WGBH_Job_Titles__c title = new WGBH_Job_Titles__c(
            name = 'Apex code hacker',
            is_exempt__c = true,
            is_active__c = true,
            EEO_Category__c = 'Professionals',
            Description__c = 'SalesForce VisualForce Apex hacker',
            code__c = 'X123',
            affiliation__c = 'SAG'
        );
        
        insert title; 
        jobReq.Position_Title__c  = title.id;
        
        //get the department
        //Department__c dept        = [SELECT id FROM Department__c WHERE Department_Code__c = 'WWW']; //the interactive department
        Department__c dept = new Department__c(name = 'Foreign Affairs',
                                                department_code__c = 'FA',
                                                is_active__c       = true,
                                                process_level__c   = 'AB12',
                                                wgbh_id__c         = 'WGBH FA');
        insert dept;
        jobReq.Departments__c     = dept.id;
        
        //get the supervisor
        WGBH_Supervisor__c sup = new WGBH_Supervisor__c(name = 'The super',
                                                        code__c = 'M4567',
                                                        description__c = 'The super for the team',
                                                        employee_id__c = '12345',
                                                        first_name__c  = 'Joe',
                                                        last_name__c   = 'Supervisor',
                                                        is_active__c   = true);
        insert sup;
        jobReq.Supervisor_Name__c = sup.id;
        
        //get the dotted line
        jobReq.Dotted_Line_Reporting_Relationship__c = sup.id;
        
        //get the paperwork contact
        WGBH_Paperwork_Contact__c ppc  = new WGBH_Paperwork_Contact__c(name = 'Paperwork Contact',
                                                        code__c = 'C345',
                                                        description__c = 'The paperwork contact for the team',
                                                        first_name__c  = 'Joe',
                                                        last_name__c   = 'Paperwork',
                                                        is_active__c   = true); 
        insert ppc;
        // = [SELECT id FROM WGBH_Paperwork_Contact__c WHERE Code__c = 'LANDRIGAN'];
        jobReq.WGBH_Paperwork_Contact__c = ppc.id;
        
        //get the auth signer
        jobReq.AuthorizedSigner_For_This_Requisition__c = sup.id;
        
        //get the checksort
        WGBH_CheckSort_Contact__c userLevel = new WGBH_CheckSort_Contact__c(name = 'Checksort Contact',
                                                        code__c = 'CS345',
                                                        first_name__c  = 'Steve',
                                                        last_name__c   = 'Checksort',
                                                        is_active__c   = true);
        
        //[SELECT id FROM WGBH_CheckSort_Contact__c WHERE Code__c = '30655'];
        insert userLevel;
        jobReq.Person_who_issues_paychecks_to_thishire__c = userLevel.id;
        
        //get the accounting unit
        WGBH_Accounting_Unit__c au        = new WGBH_Accounting_Unit__c(name = '907654 WGBH IT',
                                                                        accounting_unit__c = '907654',
                                                                        Description__c = 'WGBH IT',
                                                                        is_active__c = true);
        insert au;
        //[SELECT id FROM WGBH_Accounting_Unit__c WHERE Accounting_Unit__c = '252006'];
        jobReq.WGBH_Accounting_Unit__c = au.id;
        
        //insert the req
        insert jobReq;
        
        //second create a candidate
        Candidate__c can                   = new Candidate__c();
        can.First_Name__c                  = 'Norm';
        can.Last_Name__c                   = 'Abrams';
        can.Phone__c                       = '(617) 300-3434';
        can.Email__c                       = 'brwainwright@gmail.com';
        can.Ethnic_Group__c                = 'Non-Hispanic/Latino';
        can.Street_Address1__c             = '10 Main Street';
        can.City__c                        = 'Mohawk';
        can.Zip_Postal_Code__c             = '13407';
        can.US_Citizen__c                  = true;
        can.approved_to_work__c            = 'Yes';
        can.Previously_employed_at_WGBH__c = 'No';
        can.Gender__c                      = 'Male';
        can.EEO_Diversity__c               = 'White (Not Hispanic or Latino)';
        can.Veteran_information__c         = 'Not a Veteran';
        can.Handicapped__c                 = 'No';
        can.Recent_Salary__c               = 48000.00;
        
        //get candidate lookup values
        //get the state
        State__c state     = new State__c(name = 'Of Grace',
                                            code__c = 'OG');
        insert state;
        can.State_lkp__c   = state.Id;
        
        //get the country
        Country__c country = new Country__c(name = 'Xenu',
                                            code__c = 'XM');
        insert country;
        can.Country_lkp__c = country.id;
        can.Desired_Salary__c = 1000.0;
        //insert the candidate
        insert can;
        
        //third create a job applicaiton
        Job_application__c jobApp = new Job_application__c();
        jobApp.Position__c        = jobReq.id;
        jobApp.Candidate__c       = can.id;
        jobApp.Picklist__c        = 'New';
        
        insert jobApp;
        
        //START THE TEST
        //Test.startTest();
        
        //fourth set the status of the job application to hire
        jobApp.Final_Salary__c       = 52000.00;
        jobApp.Work_Schedule__c      = 'FT_5_08';
        jobApp.Picklist__c           = 'Hired';
        //also set the letter to be sent to the applicant
        //this will test the  EmailToApplicant trigger
        jobApp.Email_To_Applicant__c = 'Full Time';
        
        //UPDATE - THE TRIGGER SHOULD FIRE
        update jobApp;
        
        //NOW UPDATE THE JOB APP AS A REJECTION TO TEST THE REJECTION EMAIL
        jobApp.Picklist__c           = 'Rejected';
        jobApp.email_to_applicant__c = 'Rejection';
        
        update jobApp;
        
        //STOP THE TEST
        //Test.stopTest(); 
        
    }
}