trigger RelationshipAfterDelete on Relationships__c (after delete) {
    List<Relationships__c>  deleteRelationship = new List<Relationships__c>();
    Set<String> recParentSet = new Set<String>();
    Set<String> parentSet = new Set<String>();
    for(Relationships__c relation : Trigger.old){
        if(relation.isReciprocal__c == false){
            recParentSet.add(relation.Id);
        }else{
            parentSet.add(relation.Parent__c);
        }
    }
    if(recParentSet.size() > 0){
        for(Relationships__c rel : [SELECT Id FROM Relationships__c where Parent__c in : recParentSet]){
            deleteRelationship.add(rel);
        }
        if(deleteRelationship.size() > 0) delete deleteRelationship;
    }
    if(parentSet.size() > 0){
        deleteRelationship.clear();
        for(Relationships__c relation : [SELECT Id FROM Relationships__c where Id in : parentSet]){
            deleteRelationship.add(relation);
        }
        if(deleteRelationship.size() > 0) delete deleteRelationship;
    }
}