/**
* @author Matias Menafra
* @createdate 05/07/2010
*/
public with sharing class ActionPlanSelectController{
	
	public List<ActionPlanTemplate__c> actionPlanTemplates;
	
	/**
	* Constructor
	*/
	public ActionPlanSelectController( ApexPages.StandardController stdController ){
	}
	
	/**
	* 
	* @return List<ActionPlanTemplate__c>
	*/
	public List<ActionPlanTemplate__c> getActionPlanTemplates(){
	
		return [ select a.Id, a.Name, a.Description__c, a.SkipWeekends__c, a.LastModifiedDate, a.LastModifiedBy.Name, 
					a.LastModifiedById, a.CreatedDate, a.CreatedBy.Name, a.CreatedById 
					from ActionPlanTemplate__c a 
					order by a.Name ASC limit 1000 ]; 
	}
	
	public static testMethod void checkActionPlanTemplateListEmpty(){
	
		Test.StartTest();
		
		//Delete any previous templates you might have
		List<ActionPlanTemplate__c> templateList = [ select Id from ActionPlanTemplate__c ]; 
		delete templateList;
		
		ActionPlanSelectController apSelectController = new ActionPlanSelectController( new ApexPages.StandardController( new ActionPlan__c() ) ); 		
		List<ActionPlanTemplate__c> APTemplates = apSelectController.getActionPlanTemplates();
		
		// verifies list is empty
		System.assert( APTemplates.isEmpty(), 'Action Plan Template List not Empty' );
		
		Test.StopTest();
	}
	
	public static testMethod void checkActionPlanTemplateListNotEmpty(){
	
		Test.StartTest();
		
		ActionPlansTestUtilities testUtil = new ActionPlansTestUtilities();
		
		ActionPlanTemplate__c auxTemplate;
		auxTemplate = testUtil.createNewActionPlanTemplate( 1 );
		auxTemplate = testUtil.createNewActionPlanTemplate( 1 );
		
		ActionPlanSelectController apSelectController = new ActionPlanSelectController( new ApexPages.StandardController( new ActionPlan__c() ) ); 		
		List<ActionPlanTemplate__c> APTemplates = apSelectController.getActionPlanTemplates();
		
		// verifies list is not empty
		System.assert( !APTemplates.isEmpty(), 'Action Plan template is empty' );
		
		Test.StopTest();
	}
}