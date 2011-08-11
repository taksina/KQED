trigger UpdateSummary on Opportunity (after insert, after update) {
    UpdateSummary.UpdateGivingSummary(Trigger.New,true);
}