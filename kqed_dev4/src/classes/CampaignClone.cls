global with sharing class CampaignClone implements Database.Batchable<sObject> {
	public Id campaignId;
	public Id newCampaignId;
	
	public CampaignClone(Id campaignId, Id newCampaignId) {
		this.campaignId = campaignId;
		this.newCampaignId = newCampaignId;
	}

   global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug(System.LoggingLevel.INFO, '\n**** campaignId: ' + this.campaignId); 
		return Database.getQueryLocator(getCreatableFieldsSOQL('CampaignMember', 'CampaignId=\''+ this.campaignId +'\''));
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug(System.LoggingLevel.INFO, '\n**** scope size: '+scope.size()); 
		List<CampaignMember> newCampaignMembers = cloneCampaignMembers(scope, this.newCampaignId);
		insert newCampaignMembers;		
	}
	
	global void finish(Database.BatchableContext BC) {}

	webservice static CloneCampaignResult cloneCampaign(Id campaignId) {
		Campaign sourceCampaign = Database.query(getCreatableFieldsSOQL('Campaign', 'id=\''+ campaignId +'\''));
		Campaign newCampaign = sourceCampaign.clone(false, true);
		newCampaign.Name += ' (copy)';
		insert newCampaign;
		
		// Clone CampaignMemberStatuses
		List<CampaignMemberStatus> sourceCampaignMemberStatuses = getCampaignMemberStatuses(campaignId);		
		List<CampaignMemberStatus> newCampaignMemberStatuses = new List<CampaignMemberStatus>();
		String defaultStatus;
		for (CampaignMemberStatus s : sourceCampaignMemberStatuses) {
			if (s.IsDefault) defaultStatus = s.Label;
			CampaignMemberStatus newStatus = s.clone(false, true);
			newStatus.CampaignId = newCampaign.Id;
			newCampaignMemberStatuses.add(newStatus);
		}
		Database.insert(newCampaignMemberStatuses, false);
		
		// Set the default status
		for (CampaignMemberStatus s : newCampaignMemberStatuses) {
			if (s.Label == defaultStatus) {
				s.isDefault = true;
				update s;
				break;
			}
		}
				
		AggregateResult res = [Select Count(Id)member_count From CampaignMember Where CampaignId =: campaignId];
		Integer member_count = (Integer) res.get('member_count');
		
		// Do the entire clone immediately if there are fewer than 10,000 campaign members.
		// Otherwise, kick off a batch process.
		Integer batch_limit = 10000;
		if (Test.isRunningTest()) batch_limit = 2000;

		CloneCampaignResult result = new CloneCampaignResult(newCampaign.Id);
		if (member_count < batch_limit) {
			result.isBatch = false;
			List<CampaignMember> sourceCampaignMembers = Database.query(getCreatableFieldsSOQL('CampaignMember', 'CampaignId=\''+ campaignId +'\''));
			List<sObject> newCampaignMembers = cloneCampaignMembers(sourceCampaignMembers, newCampaign.Id);
			insert newCampaignMembers;
		} else {
			// Clone campaign members 5,000 at a time
			result.isBatch = true;
			CampaignClone batch = new CampaignClone(campaignId, newCampaign.Id);
			Integer scope_size = 5000;
			if (Test.isRunningTest()) scope_size = 500;
			database.executeBatch(batch, 5000);
		}
		
		return result;
	}
	
	global class CloneCampaignResult {
		global CloneCampaignResult(Id campaignId) {
			this.newCampaignId = campaignId;
			this.returnURL = '/' + campaignId + '/e?retURL=%2F'+campaignId;
		}
		
		webservice Id newCampaignId;
		webservice String returnURL;
		webservice Boolean isBatch;
	}
	
	private static List<sObject> cloneCampaignMembers(List<sObject> members, Id newCampaignId) {
		List<sObject> newCampaignMembers = new List<sObject>();
		for (sObject m : members) {
			sObject memberClone = m.clone(false, true);
			memberClone.put('CampaignId', newCampaignId);
			newCampaignMembers.add(memberClone);
		}
		
		return newCampaignMembers;
	}

	private static List<CampaignMemberStatus> getCampaignMemberStatuses(Id campaignId) {
		return [Select Id, HasResponded, CampaignId, isDefault, SortOrder, Label From CampaignMemberStatus Where CampaignId =: campaignId];
	}

	// Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
	private static String getCreatableFieldsSOQL(String objectName, String whereClause) {
		String selects = '';

		if (whereClause == null || whereClause == ''){ return null; }

		// Get a map of field name and field token
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
		list<string> selectFields = new list<string>();

		if (fMap != null){
			for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
				Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
				if (fd.isCreateable()){ // field is creatable
					selectFields.add(fd.getName());
				}
			}
		}

		if (!selectFields.isEmpty()){
			for (string s:selectFields){
				selects += s + ',';
			}
			if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
		}

		return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;

	}
	
	private static testMethod void test_CampaignCloneWebservice() {
		campaignCloneTest(500);
	}

	private static testMethod void test_CampaignCloneBatch() {
		campaignCloneTest(4900);
	}
	
	private static void campaignCloneTest(Integer testSize) {
		List<Lead> leads = new List<Lead>();
		for (Integer i=0; i < testSize; i++) {
			Lead l = new Lead(LastName='Last '+i, Company='Company '+i);
			leads.add(l);
		}
		insert leads;

		Campaign c = new Campaign(
			Name = 'Test Campaign',
			isActive = true
		);
		insert c;
		List<CampaignMemberStatus> statuses = new List<CampaignMemberStatus>{
			new CampaignMemberStatus(CampaignId = c.Id, HasResponded=true, isDefault=false, Label='Status 3', SortOrder=3),
			new CampaignMemberStatus(CampaignId = c.Id, HasResponded=true, isDefault=false, Label='Status 4', SortOrder=4),
			new CampaignMemberStatus(CampaignId = c.Id, HasResponded=true, isDefault=false, Label='Status 5', SortOrder=5),
			new CampaignMemberStatus(CampaignId = c.Id, HasResponded=true, isDefault=false, Label='Status 6', SortOrder=6)
		};
		insert statuses;

		List<CampaignMember> members = new List<CampaignMember>();
		for (Lead l : leads) {
			CampaignMember m = new CampaignMember(
				CampaignId = c.Id,
				LeadId = l.Id,
				Status = 'Status 3'
			);
			members.add(m);
		}
		insert members;
		
		Test.startTest();
		CloneCampaignResult result = CampaignClone.cloneCampaign(c.Id);
		Test.stopTest();
		
		System.assert(result.newCampaignId != null);
		AggregateResult res = [Select Count(Id)member_count From CampaignMember Where CampaignId =: result.newCampaignId];
		System.assertEquals(testSize, (Integer) res.get('member_count'));
		System.assertEquals(getCampaignMemberStatuses(c.Id).size(), getCampaignMemberStatuses(result.newCampaignId).size());
		System.debug(System.LoggingLevel.INFO, '\n**** Original Statuses: '+getCampaignMemberStatuses(c.Id)); 
		System.debug(System.LoggingLevel.INFO, '\n**** New Statuses: '+getCampaignMemberStatuses(result.newCampaignId)); 
	}
	
}