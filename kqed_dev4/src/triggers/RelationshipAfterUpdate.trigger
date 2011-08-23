trigger RelationshipAfterUpdate on Relationships__c (after update) {
    Set<Id> reciprocalRelationIdSet = new Set<Id>();
    Set<Id> primaryRelationId = new Set<Id>();
    Map<Id, Relationships__c> relationshipIdMap = new Map<Id, Relationships__c>();
    List<Relationships__c> updatePrimaryRelationships = new List<Relationships__c>();
    List<Relationships__c> updateReciprocalRelationList = new List<Relationships__c>();
    if(RelationshipUtility.firtupdateRun){
        for(Relationships__c relationship : Trigger.new){
            if(relationship.isReciprocal__c){
                primaryRelationId.add(relationship.Parent__c);
                relationshipIdMap.put(relationship.Parent__c, relationship);
            }else{
                reciprocalRelationIdSet.add(relationship.Id);
                relationshipIdMap.put(relationship.Id, relationship);
            }
        }
        if(primaryRelationId.size() > 0){
            for(Relationships__c relation : [SELECT Id, Primary_Rel__c, Relationship_type__c, Reverse_Relationship_Type__c, Strength__c FROM Relationships__c where Id in : primaryRelationId]){
                relation.Primary_Rel__c = relationshipIdMap.get(relation.Id).Primary_Rel__c;
                //relation.Reciprocal_Relationship__c = relationshipIdMap.get(relation.Id).Reciprocal_Relationship__c;
                relation.Reverse_Relationship_Type__c = relationshipIdMap.get(relation.Id).Relationship_type__c;
                relation.Relationship_type__c = relationshipIdMap.get(relation.Id).Reverse_Relationship_Type__c;
                relation.Strength__c = relationshipIdMap.get(relation.Id).Strength__c;
                updatePrimaryRelationships.add(relation);  
            }
            if(updatePrimaryRelationships.size() > 0){
                RelationshipUtility.firtupdateRun = false;
                update updatePrimaryRelationships;
            }
        }
        if(reciprocalRelationIdSet.size() > 0){
            for(Relationships__c relation : [SELECT Id, Primary_Rel__c, Relationship_type__c, Reverse_Relationship_Type__c, Strength__c, Parent__c FROM Relationships__c where Parent__c in : reciprocalRelationIdSet]){
                relation.Reverse_Relationship_Type__c = relationshipIdMap.get(relation.Parent__c).Relationship_type__c;
                relation.Relationship_type__c = relationshipIdMap.get(relation.Parent__c).Reverse_Relationship_Type__c;              
                relation.Strength__c = relationshipIdMap.get(relation.Parent__c).Strength__c;
                updateReciprocalRelationList.add(relation);  
            }
            if(updateReciprocalRelationList.size() > 0){
                RelationshipUtility.firtupdateRun = false;
                update updateReciprocalRelationList;
            }
        }
    }
}