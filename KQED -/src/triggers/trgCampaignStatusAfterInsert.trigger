trigger trgCampaignStatusAfterInsert on Campaign (After Insert) {
    List<CampaignMemberStatus> lstStatus = new List<CampaignMemberStatus>();
    Boolean blnInsertedFound = false;
    Integer sortOrder = 1;
    String CampaignId = Trigger.New[0].Id;
    lstStatus = [Select Id, Label, IsDefault, SortOrder From CampaignMemberStatus Where CampaignId =: CampaignId];
    if(lstStatus != null && lstStatus.size()>0){
        for(CampaignMemberStatus status:lstStatus){
            sortOrder++;
            if(status.Label.trim().toUpperCase() == 'INSERTED')
                blnInsertedFound = true;
        }
    }
    If(blnInsertedFound == false){
        CampaignMemberStatus objInserted = new CampaignMemberStatus();
        objInserted.Label = 'Inserted';
        objInserted.IsDefault = true;
        objInserted.CampaignId = CampaignId;
        objInserted.SortOrder = SortOrder;
        insert objInserted;
    }
}