public with sharing class DisplayShipmentController {
        
        private set<id> setShipIds = new set<id>();
        public list<Shipment__c> shipments                        {get;set;}      
        
    public DisplayShipmentController() {
        system.debug('\n ### in DisplayShipmentController constructor ');
            
        String selected_ShipIds;        
        if (Apexpages.currentPage().getParameters().containsKey('shipIds')) {
                selected_ShipIds = Apexpages.currentPage().getParameters().get('shipIds');
                system.debug('\n ### selected_ShipIds ' + selected_ShipIds);
                for (String shipId : selected_ShipIds.split(',')) {
                        setShipIds.add(shipId);
                }
        }
        system.debug('\n ### selected_ShipIds ' + selected_ShipIds);            
        getShipments();
    }
    
    public PageReference createMore() {
        return Page.CreateShipmentOrder;
    }
    
    public void getShipments() {
        system.debug('\n ### setShipIds ' + setShipIds);
        
        shipments = new list<Shipment__c>();
                if (!setShipIds.isEmpty()) {
                        shipments = [select Id, Name, Carrier__c, Opportunity__c, Organization__c, Shipping_Contact__c, City__c, State__c from Shipment__c where id in :setShipIds order by Shipment_Number_Name__c];
                }
                system.debug('\n ### shipments.size ' + shipments.size() + ' => ' + shipments);
    }
}