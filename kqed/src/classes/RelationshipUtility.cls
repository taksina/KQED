public with sharing class RelationshipUtility {
    public static boolean relationshipCloned = false;
    public static boolean firstRun = true;
    public static boolean firtupdateRun = true;
    public static boolean firstAfterUpdateRun = true;
    public static boolean updatedFromAddress = false;

	/**
	 * Statics don't have getter/setters defined? {get;set;} Test passes!
	 */    
	public static testMethod void testRelationshipProperties() {
		System.assert(!relationshipCloned, 'Bad default value for relationshipCloned');
		System.assert(firstRun, 'Bad default value for firstRun');
		System.assert(firtupdateRun, 'Bad default value for firtupdateRun');
		System.assert(firstAfterUpdateRun, 'Bad default value for firstAfterUpdateRun');
		System.assert(!updatedFromAddress, 'Bad default value for updatedFromAddress');								
	} 	    
}