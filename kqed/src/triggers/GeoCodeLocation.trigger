trigger GeoCodeLocation on Location__c (after update, after insert) {
    Map<Id,Location__c> oldMap = trigger.oldMap;
    for(Location__c location : trigger.New) {
        LocationGeoCode.updateGeoCode((oldMap==null)?null:oldMap.get(location.id), location);
    }   
}