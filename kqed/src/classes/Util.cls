global with sharing class Util {
		
	global static Boolean isNullOrEmpty(String x) {
		if (x == null || x == '') return true;
		return false;   
	}
	
	global static Boolean isNullOrZero(Integer x) {
		if (x == null || x == 0) return true;
		return false;   
	}
	
	global static Boolean isNullOrZero(decimal x) {
		if (x == null || x == 0) return true;
		return false;
	}
		
	global static String assignIfNotEmpty(String newVal, String defaultVal) {
		if (isNullOrEmpty(newVal)) return defaultVal;
		return newVal;
	}
	
	global static decimal assignIfNotNull(decimal newVal, decimal defaultVal) {
		if (isNullOrZero(newVal)) return defaultVal;
		return newVal;
	}
	
	global static Integer assignIfNotNull(Integer newVal, Integer defaultVal) {
		if (isNullOrZero(newVal)) return defaultVal;
		return newVal;
	}
	
	global static Id assignIfNotNull(Id newVal, Id defaultVal) {
		if (newVal == null) return defaultVal;
		return newVal;
	}

	global static list<Id> convertSetToList(set<id> setIds) {		
  		list<Id> lstIds = new list<Id>();
  		for(Id pid : setIds) {
  			lstIds.add(pid);
  		}
  		return lstIds;
	}

	global static string getSOQLDateFormat(Date soqlDate) {
		String soqlYear = String.Valueof(soqlDate.year());
		
	    String soqlMonth = '0' + String.ValueOf(soqlDate.month());
	    soqlMonth = soqlMonth.substring(soqlMonth.length()-2);
	    
	    String soqlDays = '0' + String.ValueOf(soqlDate.day());
	    soqlDays = soqlDays.substring(soqlDays.length()-2);
		
		return  soqlYear + '-' + soqlMonth + '-' + soqlDays;
	}

	private static testMethod void test_isNullOrEmptyString() {
		System.assertEquals(true, isNullOrEmpty((String) null));
		System.assertEquals(true, isNullOrEmpty(''));
		System.assertEquals(false, isNullOrEmpty('s'));
	}

	private static testMethod void test_isNullOrZeroInteger() {
		System.assertEquals(true, isNullOrZero((Integer) null));
		System.assertEquals(true, isNullOrZero(0));
		System.assertEquals(false, isNullOrZero(1));
	}
	
	private static testMethod void test_isNullOrZeroDecimal() {
		System.assertEquals(true, isNullOrZero((decimal) null));
		System.assertEquals(true, isNullOrZero(0));
		System.assertEquals(false, isNullOrZero(1.2));
	}
	
	private static testMethod void test_assignIfNotNullDecimal() {
		System.assertEquals(1.2, assignIfNotNull((decimal) null, 1.2));
		System.assertEquals(2.1, assignIfNotNull(2.1,3.1));		
	}
	
	private static testMethod void test_assignIfNotNullInteger() {
		System.assertEquals(0, assignIfNotNull((Integer) null, 0));
		System.assertEquals(2, assignIfNotNull(2,3));		
	}
	
	private static testMethod void test_assignIfNotEmptyString() {
		System.assertEquals('abcd', assignIfNotEmpty((String) null, 'abcd'));
		System.assertEquals('Round', assignIfNotEmpty('Round','Corner'));
	}
	
	private static testMethod void test_assignIfNotNull() {
		Id uid = UserInfo.getUserId();
		Id oid = UserInfo.getOrganizationId();
		Id nullId = null;
		System.assertEquals(uid, assignIfNotNull(nullId, uid));
		System.assertEquals(oid, assignIfNotNull(oid, uid));
	}
	
	private static testMethod void test_convertSetToList() {
		Set<Id> setIds = new Set<Id>{UserInfo.getUserId(), UserInfo.getOrganizationId()}; 
		System.assertEquals(2, convertSetToList(setIds).size());
	}
	
	private static testMethod void test_SOQLDateFormat() {
		System.assertNotEquals(system.today().format(), getSOQLDateFormat(system.today()));
	}	
}