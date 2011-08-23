public with sharing class HouseholdTransactionHistory_EXT {
    private final Account household;
    public HouseholdTransactionHistory_EXT(ApexPages.StandardController stdController) {
        this.household = (Account)stdController.getRecord();
    }
    public String getLastTransactionDate() {
        return Households.getHouseholdLastTransactionDate(household.ID);
    }
    public String getHouseholdTransactionTotal() {
        return Households.getHouseholdTransactionAmount(household.ID);
    }
}