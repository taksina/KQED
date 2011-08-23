public with sharing class HouseholdExtension {
    private final Account household;
    public HouseholdExtension(ApexPages.StandardController stdController) {
        this.household = (Account)stdController.getRecord();
    }
    public String getLastTransactionDate() {
        return Households.getHouseholdLastTransactionDate(household.ID);
    }
    public String getHouseholdTransactionTotal() {
        return Households.getHouseholdTransactionAmount(household.ID);
    }
        
}