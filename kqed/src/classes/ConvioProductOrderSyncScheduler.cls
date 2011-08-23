global class ConvioProductOrderSyncScheduler implements Schedulable {
	global void execute(SchedulableContext sc){
		init();
	}
	
	public void init() {
		ConvioService.processTodaysConvioProductOrdersAsynch();
	}
	
	 private static testMethod void testConvioProductOrderSyncScheduler() {
	 	ConvioProductOrderSyncScheduler s = new ConvioProductOrderSyncScheduler();
	 	s.init();
	 }
}