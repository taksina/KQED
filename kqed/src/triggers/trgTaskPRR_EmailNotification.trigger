trigger trgTaskPRR_EmailNotification on Task (After Insert) {
    
    List<EmailTemplate> emailTemplate = [SELECT id, name,subject,body FROM emailTemplate WHERE DeveloperName ='Prospect_Research_Report_Request'];

    if(emailTemplate.size()==0) return;

    List<Group> lstGroup = [Select ID from Group where Name='Prospect Research' limit 1];

    List<GroupMember> lstGroupMember = new List<GroupMember>();
    
    if(lstGroup.size()>0) {
        lstGroupMember = [Select Id, UserOrGroupId FROM GroupMember Where GroupID =: lstGroup[0].Id];
    }
    
    Set<ID> UserIDs = new Set<ID>();
    
    for(GroupMember g: lstGroupMember) {
        UserIDs.add(g.UserOrGroupId);
    }
    
    List<User> lstUser = [Select ID,Email from User where ID IN: UserIds];
    
    String[] strToEmailAddresses = new String[]{};
    
    for(User u: lstUser) {
        strToEmailAddresses.add(u.Email);
    }
    
    Set<ID> sCreatorIDs = new Set<ID>();
    
    for(Task t:Trigger.New) {
        if(t.Type=='Prospect Research Report Request') {
            sCreatorIDs.add(t.CreatedById);
        }
    }
    
    Map<Id,User> MapCreatorUser = new Map<ID,User>([Select ID,Email from User where ID IN: sCreatorIDs]);

    for(Task t:Trigger.New) {
        
        if(t.Type=='Prospect Research Report Request') {
            String[] toAddresses = strToEmailAddresses.Clone();
            
            if(MapCreatorUser.containsKey(t.CreatedById)==true) {
                User tempUser = MapCreatorUser.get(t.CreatedById);
                toAddresses.add(tempUser.Email);
            }
    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setToAddresses(toAddresses);

            mail.setSubject(emailTemplate[0].Subject);

            mail.setBccSender(false);

            mail.setUseSignature(false);

            mail.setPlainTextBody(emailTemplate[0].Body);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('###Email Sent '+ toAddresses);
        }
    }
    
}