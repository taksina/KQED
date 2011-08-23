Public Class DeleteSummary{
    @future
    Public Static void DeleteRelatedSummary(Set<Id> setAccountIds){
        List<Opportunity> lstGiving = getGivingByAccount(setAccountIds);
        
    }
    public Static List<Opportunity> getGivingByAccount(Set<ID> sAccIds){
        List<Opportunity> lstTempGiving = new List<Opportunity>();
        lstTempGiving = [Select Id, IsDeleted, AccountId, RecordTypeId, IsPrivate, Name, Description, StageName, Amount, Probability, 
        Campaign.name, Campaign.Campaign_Name__c, Campaign.Channel_Technique__c, Campaign.Sub_Channel__c,
        ExpectedRevenue, TotalOpportunityQuantity, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, 
        ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, 
        Campaign_Type__c, CombinedRollupFieldset__c, Contact_Id_for_Role__c, CurrentGenerators__c, 
        DeliveryInstallationStatus__c, MainCompetitors__c, Oppty_Related_Contact__c, OrderNumber__c, 
        SFDC_Opportunity_ID__c, Station__c, TrackingNumber__c, alt_transaction_id__c, batch_number__c, 
        bequest__c, caller__c, effort__c, fund__c, gift_kind__c, gift_type__c, installment_amount__c, payment_amount__c, 
        payment_frequency__c, Close_Month__c, payment_number__c, payments_in_schedule__c, pledge_amount__c, pledge_number__c, 
        program__c, project_del__c, purpose__c, schedule_start_date__c, source__c, systemHouseholdContactRoleProcessor__c, 
        ta_campaign__c, ta_campaign_value__c, bulk_load__c, new_install_ment_date__c, payment_method__c, batch_process_count__c,
        New_Balance__c, Product__c, Ack_Sent_Date__c, Foundation_Name__c, Foundation_Pay__c, Installment_Period__c, 
        Installments__c, Matching_Gift__c, Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
        Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, Payment_Method_Description__c, 
        Charge_Card_Type__c, Matching_Company__c, Support_Designation__c, Anonymous__c, Restricted__c, Override_Gift_Type__c, 
        Payment_Date__c, Revenue_Date__c, Giving_Segment__c, CC_EFT_Alias__c, Gift_Date_Time__c, Response_Mechanism__c, 
        Closed_Lost_Reasons__c, Source_Code__c, Matching_Gift_Status__c, Giving_Amount__c, Campaign_Name__c, 
        Remove_Opportunity__c, Gift_Date_3_Month__c, Gift_Date_6_Month__c, Gift_Date_18_Month__c, Parent_Giving_Stage__c, 
        Refused_Reason__c, Last_Payment_Date__c, Last_Payment_Date_1_Year__c, Last_Payment_Date_18_Month__c, 
        SFDC_GIVING_NUMBER__c, Ack_Sent__c, Reminder_Sent__c, Reminder_Sent_Date__c, Solicitation_Type__c, 
        Refund_Type__c, Fund_Lookup__c 
        FROM Opportunity
        where AccountId In: sAccIds Order by CreatedDate desc];
        
        Return lstTempGiving;
    }
    Public DeleteSummary(){
    }
        
    static testMethod void DeleteSummary()
    {
        Account a = new Account(Name = 'Test');
        insert a;
        Set<ID> aid = new Set<ID>();
        aid.add(a.Id);
        DeleteSummary.DeleteRelatedSummary(aid);
        
        DeleteSummary objdel = new DeleteSummary();
        
    }
}