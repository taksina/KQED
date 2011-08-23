trigger Candidate on candidate__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    //BEFORE E
    if (Trigger.isBefore){
        //INSERT UPDATE
        if (Trigger.isInsert || Trigger.isUpdate){
            List<Account> lstAcc = [Select Id, Name from Account where Name = 'WGBH' or Name = 'Hiring Organization'];
            Id idWGBH;
            Id idHiring;
            for (Account a : lstAcc){
                if (a.Name == 'WGBH'){
                    idWGBH = a.Id;
                } else {
                    idHiring = a.Id;
                }
            }
            for (candidate__c c : Trigger.new){
                /*if (Trigger.isInsert || (Trigger.isUpdate
                    &&(c.First_Name__c != Trigger.oldMap.get(c.Id).First_Name__c
                    || c.Last_Name__c != Trigger.oldMap.get(c.Id).Last_Name__c))
                ){*/
                    String strName = '';
                    
                    if (c.Last_Name__c != null){
                        strName = c.Last_Name__c;
                    }
                    if (c.First_Name__c != null){
                        strName += (strName != '' ? ', ' : '') +c.First_Name__c;
                    } 
                    c.Name = strName;
                    
                    //Can't change the account on an update because it's a master detail relationship
                    if (Trigger.isInsert){
                        if (c.Current_employee_of_WGBH__c && idWGBH != null){
                            c.Organization__c = idWGBH;
                        }
                        if (!c.Current_employee_of_WGBH__c && idHiring != null){
                            c.Organization__c = idHiring;
                        }
                    }
                //}
            }
        }
    }
}