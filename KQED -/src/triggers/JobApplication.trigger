Trigger JobApplication on Job_Application__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {//Changed by LRT
    //BEFORE
    if (Trigger.isBefore){
        //INSERT UPDATE
        if (Trigger.isInsert || Trigger.isUpdate){
            //First we'll need the related Requisition and Candidate records
            Map<Id, String> mapReq = new Map<Id, String>();
            Map<Id, String> mapCand = new Map<Id, String>();
            for (Job_Application__c j : Trigger.new){
                mapReq.put(j.Position__c, null);
                mapCand.put(j.Candidate__c, null);
            }
            
            List<candidate__c> lstCandidate = new List<candidate__c>();
            lstCandidate = [Select Id, Name from candidate__c where Id IN: mapCand.keySet()];
            for (candidate__c c : lstCandidate){
                mapCand.put(c.Id, c.Name);
            }
            
            List<Position__c> lstPosition = new List<Position__c>();
            lstPosition = [Select Id, Name, position_Title__r.Description__c from Position__c where Id IN: mapReq.keySet()];
            for (Position__c p : lstPosition){
                mapReq.put(p.Id, p.position_Title__r.Description__c);
                System.debug('!!!!!!!!!!!!!!!!!!!!!!!Req title is ' +p.position_Title__r.Description__c);
            }
            for (Job_Application__c j : Trigger.new){
                
                    String strName = '';
                    
                    if (j.Position__c != null &&mapReq.get(j.Position__c) != null){
                        strName = mapReq.get(j.Position__c) +': ';
                        System.debug('!!!!!!!!!!!!!!!!!!!!!!!strName is ' +strName);
                    }
                    if (j.Candidate__c != null &&mapCand.get(j.Candidate__c) != null){
                        strName += mapCand.get(j.Candidate__c);
                    }
                    j.Name = strName; 
                    
                    
            }
        }
    }
}

/*trigger JobApplication on Job_Application__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) { //Old Trigger (Commented by LRT)
    //BEFORE
    if (Trigger.isBefore){
        //INSERT UPDATE
        if (Trigger.isInsert || Trigger.isUpdate){
            //First we'll need the related Requisition and Candidate records
            Map<Id, String> mapReq = new Map<Id, String>();
            Map<Id, String> mapCand = new Map<Id, String>();
            for (Job_Application__c j : Trigger.new){
                mapReq.put(j.Position__c, null);
                mapCand.put(j.Candidate__c, null);
            }
            
            for (candidate__c c : [Select Id, Name from candidate__c where Id IN: mapCand.keySet()]){
                mapCand.put(c.Id, c.Name);
            }
            for (Position__c p : [Select Id, Name, position_Title__r.Description__c from Position__c where Id IN: mapReq.keySet()]){
                mapReq.put(p.Id, p.position_Title__r.Description__c);
                System.debug('!!!!!!!!!!!!!!!!!!!!!!!Req title is ' +p.position_Title__r.Description__c);
            }
            for (Job_Application__c j : Trigger.new){
                
                    String strName = '';
                    
                    if (j.Position__c != null &&mapReq.get(j.Position__c) != null){
                        strName = mapReq.get(j.Position__c) +': ';
                        System.debug('!!!!!!!!!!!!!!!!!!!!!!!strName is ' +strName);
                    }
                    if (j.Candidate__c != null &&mapCand.get(j.Candidate__c) != null){
                        strName += mapCand.get(j.Candidate__c);
                    }
                    j.Name = strName; 
                    
                    
            }
        }
    }
}*/