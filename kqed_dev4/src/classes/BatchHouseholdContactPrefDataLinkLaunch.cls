global class BatchHouseholdContactPrefDataLinkLaunch implements Schedulable {
    
    global void execute(SchedulableContext SC) {
      Database.executeBatch(new BatchHouseholdContactPrefDataLink()); 
   }
   
}