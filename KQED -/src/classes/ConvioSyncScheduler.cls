global class ConvioSyncScheduler implements Schedulable {
	global void execute(SchedulableContext sc){ 
		init();
	}
	
	private void init() {
		ConvioService.processTodaysConvioDonationsAsynch();
	}
	
	private static testMethod void testConvioProductOrderSyncScheduler() {
	 	ConvioProductOrderSyncScheduler s = new ConvioProductOrderSyncScheduler();
	 	s.init();
	}
}