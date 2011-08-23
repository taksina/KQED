trigger JobCode on Position__c (after insert) {//Changed by LRT
    List<Position__c> pos = Trigger.new;
    List<String> idsToUpdate = new List<String>();    
    //collect all the list of position ids of the records that needs to be auto populated.
    for(Position__c p :pos){    
        if (p.position_title__c!=null|| p.billing_accounting_unit__c!=null){         
            try{                
                idsToUpdate.add(p.id);
            }
            catch(Exception e){
                System.debug(e.getmessage());
            }         
        }                                  
    }
    if(idsToUpdate.size()>0)
        update_job_level.met_new(idsToUpdate);     
}

/*trigger JobCode on Position__c (after insert) {//Old Trigger (Commented by LRT)
    List<Position__c> pos = Trigger.new;
    List<String> idsToUpdate = new List<String>();    
    //collect all the list of position ids of the records that needs to be auto populated.
    for(Position__c p :pos)
    {    
         if (p.position_title__c!=null|| p.billing_accounting_unit__c!=null)
         {         
             try{                
                    idsToUpdate.add(p.id);
                }
                catch(Exception e)
                {
                    System.debug(e.getmessage());
                }         
         }             
         if(idsToUpdate.size()>0)
            update_job_level.met(idsToUpdate);                      
    }
}*/