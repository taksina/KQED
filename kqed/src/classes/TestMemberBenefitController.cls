/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestMemberBenefitController {

    static testMethod void initMemberBenefitController() {
        
        Account bmp = new Account(
           Name = 'Whiskeys Smokehouse', 
           Logo_Url__c = ''
        );
        insert bmp;
        
        Location__c loc = new Location__c(
           Name = 'Boylston St', 
           Account__c = bmp.id, 
           Street__c = '885 Boylston Street', 
           City__c = 'Boston', 
           State__c = 'MA', 
           PostalCode__c = '02116', 
           Phone__c = '(617) 262-5551', 
           Latitude__c = 42.348442,
           Longitude__c = -71.083608
        );
        insert loc;
        
        Member_Benefit__c mb = new Member_Benefit__c(
           Name = 'Test', 
           Offer__c = 'Get 15 cent wings at Whiskeys Smokehouse, Boylston Street, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Benefit_Link__c = 'http://www.whiskeysmokehouseboston.com', 
           Business_Member_Partner__c =  bmp.id
        );
        insert mb;
        
        Member_Benefit__c mbf = new Member_Benefit__c(
           Name = 'Test', 
           Offer__c = 'Get $1 Pizza at Whiskeys Smokehouse, Boylston Street, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Benefit_Link__c = 'http://www.whiskeysmokehouseboston.com', 
           Business_Member_Partner__c =  bmp.id, 
           featured__c = true, 
           Top_Two_Featured__c = true
        );
        
        insert mbf;
        
        Member_benefit_Location__c mbl1 = new Member_benefit_Location__c(
           Name = '15 cent wings at Boylston St', 
           Location__c = loc.id, 
           Member_Benefit__c = mb.id
        ); 
        insert mbl1;
        
        Member_benefit_Location__c mbl2 = new Member_benefit_Location__c(
           Name = '$1 Pizza at Boylston St', 
           Location__c = loc.id, 
           Member_Benefit__c = mb.id
        ); 
        insert mbl2;
        
        MemberBenefitController mbc = new MemberBenefitController();
        mbc.isTest = true;
        
        // All Member benefits
        mbc.showMemberBenefits();
        System.assertEquals(mbc.memberBenefitMap.get(mb.Id).Id, mb.Id);
        System.assertEquals(mbc.memberBenefitMap.get(mbf.Id).Id, mbf.Id);
        
        // Only whiskeys member benefits
        PageReference mbPage = Page.MemberBenefits;
        mbPage.getParameters().put('searchTerm', 'Whiskeys Smokehouse');
        Test.setCurrentPageReference(mbPage);
        mbc.showMemberBenefits();
        System.assertEquals(mbc.memberBenefitMap.get(mb.Id).Id, mb.Id);
        System.assertEquals(mbc.memberBenefitMap.get(mbf.Id).Id, mbf.Id);
        
        // searching member benefits, search term is set above
        mbc.searchMemberBenefits();
        System.assertEquals(mbc.memberBenefitMap.get(mb.Id).Id, mb.Id);
        System.assertEquals(mbc.memberBenefitMap.get(mbf.Id).Id, mbf.Id);
        
        // wings and category = food & drink
        mbc.getCategories();
        mbc.category = 'Food & Drink';
        mbc.searchMemberBenefits();
        System.assertEquals(mbc.memberBenefitMap.get(mb.Id).Id, mb.Id);
        System.assertEquals(mbc.memberBenefitMap.get(mbf.Id).Id, mbf.Id);
        
        // member benefit detail for MB
        PageReference mbdPage = Page.MemberBenefitDetail;
        mbdPage.getParameters().put('memberBenefitId', mb.Id);
        Test.setCurrentPageReference(mbdPage);
        //mbc.memberBenefitId = mb.Id;
        mbc.showMemberBenefit();
        System.assertEquals(mbc.memberBenefitWrapper.memberBenefit.Id, mb.Id);
        System.assertNotEquals(mbc.memberBenefitWrapper.memberBenefit.Id, mbf.Id);
        
        // printing MB
        PageReference ppage1 = mbc.printDetail();
        System.assert(ppage1.getParameters().get('idsToPrint').indexOf(mb.Id) >= 0);
        System.assert(ppage1.getParameters().get('idsToPrint').indexOf(mbf.Id) == -1);
        
        // selective printing member benefits (printing all pages now)
        for(MemberBenefitWrapper mbw : mbc.memberBenefitWrappers) {
            mbw.checked = true;
        }
        PageReference ppage2 = mbc.printDetails();
        ppage2.getParameters().put('idsToPrint', '-'+mb.Id+'-');
        //System.assert(ppage2.getParameters().get('idsToPrint').indexOf(mb.Id) >= 0);
        //System.assert(ppage2.getParameters().get('idsToPrint').indexOf(mbf.Id) >= 0);
        
        
        // selective printing featured benefits
        for(MemberBenefitWrapper mbw : mbc.topTwofeaturedMemberBenefitWrappers) {
            if(mbw.memberBenefit.Id == mbf.Id) {
                mbw.checked = true;
            }
        }
        //PageReference ppage3 = mbc.printFeaturedDetails();
        //System.assert(ppage3.getParameters().get('idsToPrint').indexOf(mb.Id) == -1);
        //System.assert(ppage3.getParameters().get('idsToPrint').indexOf(mbf.Id) >= 0);
        
        
        // printing all benefits
        Test.setCurrentPageReference(ppage2);
        mbc.print();
        MemberBenefitWrapper mbToPrint = null;
        MemberBenefitWrapper mbfToPrint = null;
        for(MemberBenefitWrapper mbw : mbc.memberBenefitsToPrint) {
            if(mbw.memberBenefit.Id == mb.Id) {
                mbToPrint = mbw;
            }
            if(mbw.memberBenefit.Id == mbf.Id) {
                mbfToPrint = mbw;
            }
        }
        if(mbToPrint == null) mbToPrint = new MemberBenefitWrapper(new Member_Benefit__c(),new  List<Member_benefit_Location__c>());
        if(mbfToPrint == null) mbfToPrint = new MemberBenefitWrapper(new Member_Benefit__c(),new  List<Member_benefit_Location__c>());
        
        System.assertEquals(mbToPrint.memberBenefit.Id, mb.Id);
        //System.assertEquals(mbfToPrint.memberBenefit.Id, mbf.Id);
        
        MemberBenefitWs.isTest = true;
        MemberBenefitWs.MemberBenefitWs_Result result = MemberBenefitWs.getMemberBenfits();
        //System.assert(result.status=='Success');
        //XMLDom dom = new XMLDom(result.xml);
        //XMLDom.Element root = dom.root;
        //System.assert(root.nodeName == 'underwriters');           
    }   
}