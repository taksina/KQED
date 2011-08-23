@isTest 
private class TestCampaignSubProgram {
    static testMethod void TestCampaignSubProgram() {
        Campaign c = new Campaign();
        c.Name='TestCampaign';
        insert c;
        
        Campaign c1 = new Campaign();
        c1.Name='TestCampaign1';
        c1.Parentid = c.Id;
        insert c1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        
        CampaignSubProgram clsTest1 = new CampaignSubProgram();
        
        CampaignSubProgram clsTest = new CampaignSubProgram(controller);

        
        Campaign c2 = c1.clone(false,true);
        insert c2;
        clsTest = new CampaignSubProgram(controller);
        
        Campaign c3 = c1.clone(false,true);
        insert c3;
        clsTest = new CampaignSubProgram(controller);

        Campaign c4 = c1.clone(false,true);
        insert c4;
        clsTest = new CampaignSubProgram(controller);
        

        Campaign c5 = c1.clone(false,true);
        insert c5;
        clsTest = new CampaignSubProgram(controller);

        
        Campaign c6 = c1.clone(false,true);
        insert c6;
        clsTest = new CampaignSubProgram(controller);

        Campaign c7 = c1.clone(false,true);
        insert c7;
        clsTest = new CampaignSubProgram(controller);

        Campaign c8 = c1.clone(false,true);
        insert c8;
        clsTest = new CampaignSubProgram(controller);
        
        Campaign c9 = c1.clone(false,true);
        insert c9;
        clsTest = new CampaignSubProgram(controller);
        
        Campaign c10 = c1.clone(false,true);
        insert c10;
        clsTest = new CampaignSubProgram(controller);
        
        Campaign c11 = c1.clone(false,true);
        insert c11;
        clsTest = new CampaignSubProgram(controller);

        Campaign c12 = c1.clone(false,true);
        insert c12;
        clsTest = new CampaignSubProgram(controller);
        
        clsTest.PageLoad();
        clsTest.UpdateSubProgram();
        
        clsTest.SubPrograms = 1;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 2;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();

        clsTest.SubPrograms = 3;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 4;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 5;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 6;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 7;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 8;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 9;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 10;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 11;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.SubPrograms = 12;
        clsTest.SubProgramAdd();
        clsTest.CreateSubProgram();
        
        clsTest.chkProgramTitle = false;
        clsTest.chkParentProgramTitle = false;
        clsTest.chkProduct = false;
        clsTest.chkCampaign = false;
        clsTest.chkCampaignDesc = false;
        clsTest.chkFinancialSegementL1 = false;
        clsTest.chkAccountUnit = false;
        clsTest.chkAccountUnitActivity = false;
            
        clsTest.chkGivingSegment = false;
        clsTest.chkStation = false;
        clsTest.chkSolicitationType = false;
        clsTest.chkEffort = false;
        clsTest.chkChannel = false;
        clsTest.chkSubChannel = false;
            
        clsTest.chkIndustry = false;
        clsTest.chkCategory = false;
        clsTest.chkJobNumber = false;    
        clsTest.chkCreativePackage = false;
        clsTest.chkOfferMessage = false;
        clsTest.chkResponseMechanism = false;
        clsTest.chkAudienceSegment = false;
        clsTest.chkAgeRange = false;
        clsTest.chkGender = false;
            
        clsTest.chkSegmentNotes = false;
        clsTest.chkCostPerX = false;
        clsTest.chkTotalCost = false;
        clsTest.chkEmailResponse = false;
        clsTest.chkWebInbound = false;
        clsTest.chkInboundCalls = false;
            
        clsTest.chkROI = false;
        clsTest.chkStartDate = false;
        clsTest.chkEndDate = false;
        clsTest.chkStatus = false;
        clsTest.chkActive = false;

        clsTest.CreateSubProgram();
        
        clsTest.chkProgramTitle = true;
        clsTest.chkParentProgramTitle = true;
        clsTest.chkProduct = true;
        clsTest.chkCampaign = true;
        clsTest.chkCampaignDesc = true;
        clsTest.chkFinancialSegementL1 = true;
        clsTest.chkAccountUnit = true;
        clsTest.chkAccountUnitActivity = true;
            
        clsTest.chkGivingSegment = true;
        clsTest.chkStation = true;
        clsTest.chkSolicitationType = true;
        clsTest.chkEffort = true;
        clsTest.chkChannel = true;
        clsTest.chkSubChannel = true;
            
        clsTest.chkIndustry = true;
        clsTest.chkCategory = true;
        clsTest.chkJobNumber = true;    
        clsTest.chkCreativePackage = true;
        clsTest.chkOfferMessage = true;
        clsTest.chkResponseMechanism = true;
        clsTest.chkAudienceSegment = true;
        clsTest.chkAgeRange = true;
        clsTest.chkGender = true;
            
        clsTest.chkSegmentNotes = true;
        clsTest.chkCostPerX = true;
        clsTest.chkTotalCost = true;
        clsTest.chkEmailResponse = true;
        clsTest.chkWebInbound = true;
        clsTest.chkInboundCalls = true;
            
        clsTest.chkROI = true;
        clsTest.chkStartDate = true;
        clsTest.chkEndDate = true;
        clsTest.chkStatus = true;
        clsTest.chkActive = true;        
        
        clsTest.CreateSubProgram();
        
        clsTest.SaveSubProgram();
        clsTest.CancelSubProgram();
        //clsTest.LoadDefaultFields();

        clsTest.selectedColumnRemove = '1';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '2';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '3';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '4';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '5';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '6';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '7';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '8';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '9';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '10';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '11';
        clsTest.SubProgramRemove();
        
        clsTest.selectedColumnRemove = '12';
        clsTest.SubProgramRemove();        
        
        
        
    }    
}