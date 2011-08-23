global with sharing class EventSignupController {
	
	public String memberId			{get;set;}
	public String firstName			{get;set;}
	public String lastName			{get;set;}
	public String email	  			{get;set;}  
	public Integer numguests	   {get;set;}
	public Campaign Campaign		{ get; set; }
	
	private final String campaignId;
	private Id campaignMemberId;		
	
	public EventSignupController() {
		this.numguests = 2;
		
		if (Apexpages.currentPage().getParameters().containsKey('eid')) {
			this.campaignId = Apexpages.currentPage().getParameters().get('eid');
			this.Campaign = getCampaign(campaignId);
		} else {
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Missing required event information.'));			
		}
	}
	
	private static Campaign getCampaign(Id campaignId) {
		Campaign c = [Select Id, Name From Campaign Where Id =: campaignId];
		return c;
	}
	
	@RemoteAction
	global static Boolean validateMemberNumber(String memberNo) {
		if (memberNo == '0') return false;

		List<Contact> c = [Select Id, Account.Member_Number__c From Contact Where Account.Member_Number__c =: memberNo And Account.RecordType.DeveloperName = 'Household'];
		return (!c.isEmpty());
	}
	
	public PageReference register() {
		system.debug('\n ### memberId ' + memberId);				
		if (memberId == null || memberId == '') {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Member ID must be entered.'));
			return null;
		}
		
		List<Contact> lstContacts = [Select Id, FirstName, LastName, Email 
			From Contact 
			Where Account.Member_Number__c = : memberId 
			Order by CreatedDate];
		CampaignMember cm;
		
		system.debug('\n ### lstContacts.size ' + lstContacts.size() + ' => ' + lstContacts);
		if (!lstContacts.isEmpty()) {
			
			// find the matching last name and email address in Account contacts
			for (Contact c : lstContacts) {
				if (c.LastName == lastName && c.Email == email) {
					system.debug('\n ### Member # and Contact found.');
					cm = new CampaignMember(ContactId=c.Id, CampaignId=campaignId, Additional_Guests__c=numguests-1, Registered_Email__c = email);  //Source__c
					break;
				}
			}
			
			// add the first Account contact if no matches found
			if (cm == null) {
				system.debug('\n ### Member # found but not the contact, create Campaign Member for the first contact.');
				cm = new CampaignMember(ContactId=lstContacts[0].Id, CampaignId=campaignId, Additional_Guests__c=numguests-1, Registered_Email__c = email); //Source__c
			}
			
			//see if this member is already registered.
			Integer cmCount = [select count() from CampaignMember where CampaignId = :campaignId and ContactId = :cm.ContactId];
			if (cmCount > 0) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, this member has already registered for this event. To change your registration, contact KCRW.'));
				return null;
			}
			
			insert cm;
			this.campaignMemberId = cm.Id;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Thank you! Your registration has been received.'));
			
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Unable to find Member Id. Please use the link below to sign up.'));
			return null;			
		}
		
		return null;
	}
	
	private static testMethod void test_EventSignup() {
		RecordType household = [Select Id From RecordType Where sObjectType='Account' AND DeveloperName='Household'];
		Account a = new Account(name = 'test account', RecordTypeId=household.Id);
		insert a;
		a = [Select Id, Member_Number__c, Member_Number_hidden__c From Account Where Id =: a.Id];
		System.assertNotEquals(null, a.Member_Number__c);
		System.assertNotEquals('0', a.Member_Number__c);
		
		Contact p = new Contact(AccountId = a.Id, FirstName = 'F', LastName = 'L', Email='f@l.com');
		insert p;
		
		Campaign c = new Campaign(Name='campaign name');
		insert c;
		
		PageReference pg = new PageReference('');
		pg.getParameters().put('eid', c.Id);
		Test.setCurrentPage(pg);
		EventSignupController ctrl = new EventSignupController();
		System.debug(System.LoggingLevel.INFO, '\n**** ENTERING TEST'); 
		System.assertEquals(c.Id, ctrl.Campaign.Id);
		
		System.assertEquals(false, EventSignupController.validateMemberNumber('23487sdkjhsfkjh3sfijwn'));
		System.assertEquals(true, EventSignupController.validateMemberNumber(a.Member_Number__c), 'Member #: '+a.Member_Number__c+'/Member # (hidden): ' + a.Member_Number_hidden__c);
		
		// complete form
		ctrl.memberId = '23487sdkjhsfkjh3sfijwn';
		ctrl.firstName = 'f';
		ctrl.lastName = 'l';
		ctrl.email = 'x@l.com';
		ctrl.numguests = 2;
		
		System.debug(System.LoggingLevel.INFO, '\n**** REGISTER 1'); 
		PageReference result = ctrl.register();
		System.assertEquals(false, ApexPages.hasMessages(ApexPages.Severity.Confirm));
		
		ctrl.email = 'f@l.com';
		ctrl.memberId = a.Member_Number__c;
		System.debug(System.LoggingLevel.INFO, '\n**** REGISTER 2'); 
		result = ctrl.register();
		System.assertEquals(true, ApexPages.hasMessages(ApexPages.Severity.Confirm));
		System.assertNotEquals(null, ctrl.campaignMemberId);
	}   
}