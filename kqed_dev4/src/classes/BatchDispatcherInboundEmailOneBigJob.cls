global class BatchDispatcherInboundEmailOneBigJob implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        // Capture and verify the sender's email address
        System.debug('from: '+envelope.fromAddress);
        System.debug('sub: '+email.subject);
        if(envelope.fromAddress.contains('admin@informaticaondemand.com')) {
            if(email.subject.contains('Task Flow') ){//&& email.subject.contains('completed')) {
                String taskFlowName = email.subject.substring(email.subject.indexOf('"')+1, email.subject.lastIndexOf('"'));
                System.debug('taskFlowName: '+taskFlowName);
                if(taskFlowName == 'One Big Incremental') {
                    this.startBatch('BatchRelationshipLink');
                }
            }
        }
        else {
            if(email.subject.contains('Batch Process Completed')) {
                String completedJob = email.subject.substring(email.subject.indexOf('"')+1, email.subject.lastIndexOf('"'));
                System.debug('job: '+completedJob);

                if(completedJob == 'BatchRelationshipLink') {
                    this.startBatch('BatchRelationshipPairing');
                }
                else if(completedJob == 'BatchRelationshipPairing') {
                    this.startBatch('BatchHouseholdAddressPref');
                }
                else if(completedJob == 'BatchHouseholdAddressPref') {
                    this.startBatch('BatchContactAddressPref');
                }
                else if(completedJob == 'BatchContactAddressPref') {
                    this.startBatch('BatchOppRdCloser');                 
                }
                else if(completedJob == 'BatchOppRdCloser') {                
                    this.startBatch('BatchOppRecurringDonationLink'); 
                }               
                else if(completedJob == 'BatchOppRecurringDonationLink') {
                    this.startBatch('BatchPaymentRecurringDonationLink');
                }
                else if(completedJob == 'BatchPaymentRecurringDonationLink') {
                    this.startBatch('BatchOppPaymentProcessor');
                }               
                else if(completedJob == 'BatchOppPaymentProcessor') {
                    this.startBatch('BatchPledgeBenefitLink');
                }
                else if(completedJob == 'BatchPledgeBenefitLink') {
                    this.startBatch('BatchPledgeBenefitParentUpdate');
                }
                else if(completedJob == 'BatchPledgeBenefitParentUpdate') {
                    this.startBatch('BatchTaskLink');
                }
                //else if(completedJob == 'BatchTaskLink') {
                //    this.startChainBatch('BatchBulkflagProcessor', BatchBulkflagProcessor.INTERACTION_CHAIN, 1);
                //    this.startChainBatch('BatchBulkflagProcessor', BatchBulkflagProcessor.HOUSEHOLD_CHAIN, 1);
                //    this.startChainBatch('BatchBulkflagProcessor', BatchBulkflagProcessor.TRANSACTION_CHAIN, 1);                                            
                //}                
                /**-----------------------------------------------------
                 * Others
                 */      
                else if(completedJob == 'BatchBulkflagProcessor') {
                    if(email.subject.indexOf('(') > -1) {
                        String processorData = email.subject.substring(email.subject.indexOf('(')+1, email.subject.lastIndexOf(')'));
                        String chainName = processorData.split('~')[0];
                        Integer objectNumber = Integer.valueOf(processorData.split('~')[1]);
                        System.debug('chainName: '+chainName+', objectNumber: '+objectNumber);
                        this.startChainBatch('BatchBulkflagProcessor', chainName, objectNumber);
                    }
                    else {
                        //next batch
                    }
                } 
            }
        }
        
        result.success = true;
        return result;
    }
    
    global void startBatch(String batchName) {
        Batch_Job__c bj = new Batch_Job__c(
            Batch_Job_Name__c = batchName
        );
        insert bj;
    }
    
    global void startChainBatch(String batchName, String chainName, Integer objectNumber) {
        Batch_Job__c bj = new Batch_Job__c(
            Batch_Job_Name__c = batchName, 
            Chain_Name__c = chainName, 
            Object_Index__c = objectNumber
        );
        insert bj;
    }
    
    global void dispatchBatch(String completedJob, Boolean chainFlag) {
        if(chainFlag) {
            this.sendEmail(completedJob, '', 0);
        }
    }
    
    global void dispatchChainBatch(String completedJob, String chainName, Integer objectNumber, Boolean chainFlag) {
        if(chainFlag || objectNumber > 0) {
            this.sendEmail(completedJob, chainName, objectNumber);
        }
    }
    
    global void sendEmail(String completedJob, String chainName, Integer objectNumber) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {ConfigAccess.getValue('BatchEmailDispatcher')});
        mail.setReplyTo(ConfigAccess.getValue('SalesForceAdmin'));
        mail.setSenderDisplayName('SFDC Apex Batch Process');
        if(objectNumber > 0) {
            mail.setSubject('Batch Process Completed - "' + completedJob + '" (' + chainName + '~' + objectNumber + ')');
        }
        else {
            mail.setSubject('Batch Process Completed - "' + completedJob + '"');
        }
        mail.setPlainTextBody('Batch Process completed successfully');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}