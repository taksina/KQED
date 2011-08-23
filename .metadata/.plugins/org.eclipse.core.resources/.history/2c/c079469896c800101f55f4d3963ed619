public class ConfigAccess {
    public static String getValue(String property) {
    	List<Config__c> properties = [Select value__c FROM config__c WHERE name = :property];
    	return (properties.size() == 0) ? null : properties[0].value__c;
    }
    
    public static testMethod void testBatch() {
    	Config__c c = new Config__c(
    	   name = 'foo', 
    	   value__c = 'bar'
    	);
    	insert c;
        System.assertEquals(ConfigAccess.getValue('foo'), 'bar');
        System.assertEquals(ConfigAccess.getValue('fooooo'), null);
    }
}