global class ScheduleInventoryStatistics implements Schedulable {
	
	// execute the following statement to schedule the job
	// System.schedule('Schedule Inventory Statistics', ScheduleInventoryStatistics.cronExpHourly, new ScheduleInventoryStatistics());
	
	public static String cronExpHourly = '0 0 0-23 * * ?';

	global void execute(SchedulableContext ctx) {
		system.debug('\n ### scheduled job ScheduleInventoryStatistics start time: ' + system.now());	
		updateUnshippedOLIs();
		system.debug('\n ### scheduled job ScheduleInventoryStatistics end time: ' + system.now());
	} 
  
	public static void updateUnshippedOLIs() {
		DateTime twoHoursAgo = DateTime.now().addHours(-2);
		Map<Id,OpportunityLineItem> olis_to_update = new Map<Id,OpportunityLineItem>([select Id from OpportunityLineItem where LastModifiedDate >: twoHoursAgo]);

		BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(olis_to_update.keySet(), 'ProductUnitsShipped');
		Database.executeBatch(scriptBatch);
	}
	
	static testmethod void testScheduleInventoryStatistics() {
		
		Test.startTest();
	   
		//create new Product
		Product2 product = TestUtil.Products[0];
			
		updateUnshippedOLIs();
				  
		// Schedule Inventory Statistics job
		String jobId = System.schedule('testScheduleInventoryStatistics', ScheduleInventoryStatistics.cronExpHourly, new ScheduleInventoryStatistics());
	 
		// Get the information from the CronTrigger API object
		CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
  
		// Verify the expressions are the same
		System.assertEquals(ScheduleInventoryStatistics.cronExpHourly, ct.CronExpression);
  
		// Verify the job has not run
		System.assertNotEquals(3, ct.TimesTriggered);
  
		// Verify the next time the job will run
		System.assertEquals(datetime.newInstance(system.today(), Time.newInstance(system.now().hour(), 0, 0, 0)).addHours(1), ct.NextFireTime);
  
		Test.stopTest();
	}
}