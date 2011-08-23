trigger EmailToApplicant on Job_Application__c (after update) 
{
//MODIFIED BY BRW 1/31/2011
    Job_application__c[] newJA = trigger.new;
    Job_application__c[] oldJA = trigger.old;
    
    /**
        TO-DO: REFACTOR THIS TO ONE QUERY AND CONDITIONAL BASED ON TEMPLATE
    **/
    if(newja[0].email_to_applicant__c!=oldja[0].email_to_applicant__c)
    {
        if((newja[0].email_to_applicant__c == 'Full Time' || 
            newja[0].email_to_applicant__c == 'Part Time')
            && newja[0].Picklist__c == 'Hired')
        {
            
            String email;
            Candidate__c can;
            Position__c pos;
            String positionTitle;
            String positionDept;
            String reqNumber;
            try
            {
                 
                 can = [Select id, First_Name__c, email__c from Candidate__c where id = :newja[0].candidate__c]; 
                 pos = [SELECT id, name, Position_Title__r.Description__c, Departments__r.name FROM Position__c WHERE id = :newja[0].Position__c];          
            }
            catch(Exception ex)
            {
                System.debug(ex.getmessage());
            }
            
            if (can == null || can.Email__c == null)
            {
                System.debug('ERROR: Candidate does not have a specfied email address.');
            }
            
            email = can.email__c;
            System.debug(newja[0].candidate__r.email__c);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            /*if(email == '' || email == null)
            {
                email = can.email__c;
            }*/
            String[] toAddresses = new String[] { email };
            /* TODO: REMOVE AT GO-LIVE */
            String[] ccAddresses = new String[] {'brian_wainwright@wgbh.org'}; 
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            
            System.debug(Userinfo.getuserid());
            
            mail.setTargetObjectId(Userinfo.getuserid());
            mail.setSaveAsActivity(false);
            /** TODO: REFACTOR OUT **/
            if( newja[0].email_to_applicant__c == 'Full Time' )
            {
                List<EmailTemplate> templates = [SELECT id FROM EmailTemplate WHERE name = 'Full Time Offer Letter'];
                if(templates != null && templates.size() > 0) {
                    mail.setTemplateid(templates[0].id);
                }
            }
            else if( newja[0].email_to_applicant__c == 'Part Time' )
            {
                List<EmailTemplate> templates = [SELECT id FROM EmailTemplate WHERE name = 'Part Time Offer Letter'];
                if(templates != null && templates.size() > 0) {
                    mail.setTemplateid(templates[0].id);
                }
            }
            
            if(mail.getTemplateId() != null) {
                Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
            }
        }
        //TO_DO REFACTOR
        if ( (newja[0].email_to_applicant__c == 'Rejection') && newja[0].Picklist__c == 'Rejected' )
        {
            
            String email;
            Candidate__c can;
            Position__c pos;
            String positionTitle;
            String positionDept;
            String reqNumber;
            try
            {
                 
                 can = [Select id, First_Name__c, email__c from Candidate__c where id = :newja[0].candidate__c]; 
                 pos = [SELECT id, name, Position_Title__r.Description__c, Departments__r.name FROM Position__c WHERE id = :newja[0].Position__c];          
            }
            catch(Exception ex)
            {
                System.debug(ex.getmessage());
            }
            
            if (can == null || can.Email__c == null)
            {
                System.debug('ERROR: Candidate does not have a specfied email address.');
            }
            
            email = can.email__c;
            positionTitle  = pos.Position_Title__r.Description__c;
            positionDept   = pos.Departments__r.name;
            reqNumber      = pos.name;
            
            System.debug(newja[0].candidate__r.email__c);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            /*if(email == '' || email == null)
            {
                email = can.email__c;
            }*/
            String[] toAddresses = new String[] { email };
            /* TODO: REMOVE AT GO-LIVE */
            String[] ccAddresses = new String[] {'brian_wainwright@wgbh.org'}; 
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            mail.setReplyTo('no-reply@wgbh.org');
            mail.setSenderDisplayName('WGBH Human Resources');
            mail.setSubject('Your Application to WGBH');
            mail.setPlainTextBody('Dear ' + can.First_Name__c + ', \r\r' +
                    'Thank you for applying for the ' + positionTitle + ' position, ' +
                    '(Req#: ' + reqNumber + ') in our ' + positionDept + ' department ' +
                    'at the WGBH Educational Foundation. \r\r' +
                    'After careful review of all applicants for this position, interviews, ' +
                    'and follow-up discussions with management staff, another candidate was ' +
                    'selected to fill this position. As is often the case, the choice was ' + 
                    'difficult; each candidate offered a unique combination of skills and experience. \r\r' +
                    'We appreciate your interest in employment at the WGBH Educational Foundation and ' +
                    'your patience with this process. We encourage you to visit our website at www.wgbh.org ' +
                    'and view our current job opportunities and use our online application to apply for any ' + 
                    'of our posted positions.\r\r' +
                    'Again, thank you for your interest in employment at the WGBH Educational Foundation.\r\r' +
                    'Sincerely, \r\r' + 'WGBH Human Resources');
                    
            System.debug(Userinfo.getuserid());
            
            mail.setTargetObjectId(Userinfo.getuserid());
            mail.setSaveAsActivity(false);
            /** TODO: REFACTOR OUT **/
            //mail.setTemplateid([SELECT id FROM EmailTemplate WHERE name ='Candidate Rejection'].id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}