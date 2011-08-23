trigger Household_Case on Case (after insert, before insert) {
       if(Trigger.isBefore && Trigger.isInsert){
        if ((Trigger.new[0].Account_Household__c == Null ) && (Trigger.new[0].ContactId != Null)){
         Contact cont = [Select c.id, c.FirstName, c.Account_Household__c from Contact c where c.id = :Trigger.new[0].ContactId];
         Trigger.new[0].Account_Household__c = cont.Account_Household__c;
        }
      }
 }