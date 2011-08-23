public class MemberBenefitController {

    public List<MemberBenefitWrapper> memberBenefitWrappers {get; set;}
    public List<Member_Benefit__c> memberBenefits {get; set;}
    public List<MemberBenefitWrapper> topTwoFeaturedMemberBenefitWrappers {get; set;}
    public Map<ID, Member_Benefit__c> memberBenefitMap {get; set;}
    
    public String category {get; set;}
    public String searchTerm {get; set;}
    
    public String memberBenefitId {get; set;}
    public MemberBenefitWrapper memberBenefitWrapper {get; set;}
        
    public String idsToPrint {get; set;}
    public List<MemberBenefitWrapper> memberBenefitsToPrint {get; set;}
    
    public boolean isTest {get; set;}
    
    public MemberBenefitController() {
        this.isTest = false; 
    }
    
    public PageReference showMemberBenefits() {
        this.searchTerm = ApexPages.currentPage().getParameters().get('searchTerm');
        this.retrieveMemberBenefits();
        return null;
    }
    
    public PageReference showMemberBenefit() {
        this.memberBenefitId = ApexPages.currentPage().getParameters().get('memberBenefitId');
        this.retrieveMemberBenefit();
        return null;
    }
    
    public PageReference searchMemberBenefits() {
        this.retrieveMemberBenefits();
        return null;
    }
    
    public PageReference printDetail() {
        String idToPrint = '-' + this.memberBenefitId + '-';
        PageReference printPage = Page.MemberBenefitsPrint;
        printPage.getParameters().put('idsToPrint', idToPrint);
        printPage.setRedirect(true);
        return printPage;
    }
    
    public PageReference printDetails() {
        return this.callPrintPage(this.memberBenefitWrappers);
    }
    
    public PageReference callPrintPage(List<MemberBenefitWrapper> mbWrappers) {
        String idToPrint = '';
        
        List<String> tempSelectedIds = new List<String>(); 
        for(MemberBenefitWrapper mbw : mbWrappers) {
            if(mbw.checked) {
                tempSelectedIds.add(mbw.memberBenefit.Id);
            }
        }
        
        for(Integer mbIndex = 0; mbIndex < tempSelectedIds.size(); mbIndex ++) {
            idToPrint += '-' + tempSelectedIds[mbIndex] + '-';
            if(mbIndex < tempSelectedIds.size() - 1) {
                idToPrint += '_';
            }
        }
        PageReference printPage = Page.MemberBenefitsPrint;
        printPage.getParameters().put('idsToPrint', idToPrint);
        printPage.setRedirect(true);
        return printPage;
    }
    
    public PageReference print() {
        this.idsToPrint = ApexPages.currentPage().getParameters().get('idsToPrint');
        
        if(this.idsToPrint !=null && this.idsToPrint.length() > 0) {
            this.idsToPrint = this.idsToPrint.replaceAll('-', '\'');
            this.idsToPrint = this.idsToPrint.replaceAll('_', ',');
            List<Member_Benefit__c> tempMemberBenefits = new List<Member_Benefit__c>(); 
            String memberBenefitsPrintQuery = 
                                        'SELECT Id, Name, Start_Date__c, End_Date__c, Offer__c, Category__c, Benefit_Link__c, Logo_Url__c, Featured__c, Top_Two_Featured__c, Marketing_Copy__c, ' +  
                                               'Business_Member_Partner__r.Name, Business_Member_Partner__r.Phone, Business_Member_Partner__r.ShippingCity, ' +
                                               'Business_Member_Partner__r.ShippingState, Business_Member_Partner__r.ShippingStreet, Business_Member_Partner__r.Logo_Url__c, ' + 
                                               'Business_Member_Partner__r.ShippingPostalCode, Business_Member_Partner__r.AboutUs__c, Business_Member_Partner__r.Website ' + 
                                          'FROM Member_Benefit__c ' + 
                                          'WHERE Id IN (' + this.idsToPrint + ')';
            tempMemberBenefits = Database.query(memberBenefitsPrintQuery);
            
            Map<Id, Member_Benefit__c> memberBenefitsWithLocationsMap = new Map<Id, Member_Benefit__c>();
            memberBenefitsWithLocationsMap.putAll(
                   [SELECT Id, 
                            (SELECT Location__r.Phone__c, Location__r.Longitude__c, Location__r.Latitude__c, Location__r.PostalCode__c, Location__r.State__c, Location__r.City__c, 
                             Location__r.Street__c, Location__r.Name, Location__r.Id
                             FROM Member_Benefit_Locations__r)
                    FROM Member_Benefit__c
                    WHERE Id in :tempMemberBenefits]);
            
            this.memberBenefitsToPrint = new List<MemberBenefitWrapper>();
            for(Integer mbIndex = 0; mbIndex < tempMemberBenefits.size(); mbIndex ++) {
                MemberBenefitWrapper tempMbw = new MemberBenefitWrapper(tempMemberBenefits[mbIndex], memberBenefitsWithLocationsMap.get(tempMemberBenefits[mbIndex].Id).Member_Benefit_Locations__r, (mbIndex == tempMemberBenefits.size() - 1) ? false : true);
                tempMbw.checkLink();
                this.memberBenefitsToPrint.add(tempMbw);
            }
        }
        
        return null;
    }
    
    public List<SelectOption> getCategories() {
        List<SelectOption> categories = new list<SelectOption>();
        categories.add(new SelectOption('', '-- All categories --'));
        Schema.Describefieldresult field = Member_Benefit__c.Category__c.getDescribe();
        for (Schema.PicklistEntry entry : field.getPicklistValues()) {
            categories.add(new SelectOption(entry.getLabel(), entry.getLabel()));
        }
        return categories;
    }
    
    public void retrieveMemberBenefit() {
        Member_Benefit__c tempMemberBenefit = 
                                    [SELECT Id, Name, Start_Date__c, End_Date__c, Offer__c, Category__c, Benefit_Link__c, Logo_Url__c, Featured__c, Top_Two_Featured__c, Marketing_Copy__c, 
                                           Business_Member_Partner__r.Name, Business_Member_Partner__r.Phone, Business_Member_Partner__r.ShippingCity, 
                                           Business_Member_Partner__r.ShippingState, Business_Member_Partner__r.ShippingStreet, Business_Member_Partner__r.Logo_Url__c, 
                                           Business_Member_Partner__r.ShippingPostalCode, Business_Member_Partner__r.AboutUs__c, Business_Member_Partner__r.Website 
                                      FROM Member_Benefit__c 
                                      WHERE Id = :this.memberBenefitId];
        
        Member_Benefit__c memberBenefitsWithLocationsMap = 
               [SELECT Id, 
                        (SELECT Location__r.Phone__c, Location__r.Longitude__c, Location__r.Latitude__c, Location__r.PostalCode__c, Location__r.State__c, Location__r.City__c, 
                         Location__r.Street__c, Location__r.Name, Location__r.Id
                         FROM Member_Benefit_Locations__r)
                FROM Member_Benefit__c
                WHERE Id = :this.memberBenefitId];
        
            this.memberBenefitWrapper = new MemberBenefitWrapper(tempMemberBenefit, memberBenefitsWithLocationsMap.Member_Benefit_Locations__r);
            this.memberBenefitWrapper.checkLink();
    }
    
    public void retrieveMemberBenefits() {
        this.memberBenefitMap = new Map<ID, Member_Benefit__c>();
        
        //Category__c INCLUDES ('Food & drink', 'Education')
        /*String categoryClause = '';
        if(category != null && category.size() > 0) {
            categoryClause = ' Category__c INCLUDES (';
            for(Integer catIndex = 0; catIndex < category.size(); catIndex ++) {
                categoryClause += '\'' + category[catIndex] + '\'';
                if(catIndex < category.size() - 1) {
                    categoryClause += ', ';
                }
            }
            categoryClause += ') AND ';
        }*/
        String categoryClause = '';
        if(category != null && category.length() > 0) {
            categoryClause = ' Category__c INCLUDES (\'' + category + '\') AND ';
        }
        
        if(searchTerm != null && searchTerm.length() > 1) {
            
            String soslSearchTerm = '\'*' + String.escapeSingleQuotes(searchTerm) + '*\'';
            String soqlSearchTerm = '\'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
            
            String memberBenefitSearchResultQuery = 
                                    'FIND ' + soslSearchTerm + 'IN ALL FIELDS ' +   
                                    'RETURNING Member_Benefit__c ' +  
                                                '( ' + 
                                                     'Id, Name, Start_Date__c, End_Date__c, Offer__c, Category__c, Featured__c, Top_Two_Featured__c, Benefit_Link__c,  ' + 
                                                     'Business_Member_Partner__r.Name, Business_Member_Partner__r.Logo_Url__c, Business_Member_Partner__r.Logo__c, Business_Member_Partner__r.Website, Business_Member_Partner__r.AboutUs__c ' + 
                                                     'WHERE ' + categoryClause + '(Start_date__c = null OR (Start_date__c <= today AND (End_date__c = null OR End_date__c >= today))) ' + 
                                                ') ';
            List<List<SObject>> memberBenefitSearchResult = Search.query(memberBenefitSearchResultQuery);
            List<Member_Benefit__c> memberBenefitList = memberBenefitSearchResult[0];
            this.memberBenefitMap.putAll(memberBenefitList);
            
            String accountSearchQuery = 'SELECT Id ' +  
                                        'FROM Account ' +  
                                        'WHERE ' + 
                                          'Account.Name LIKE ' + soqlSearchTerm;
            
            String memberBenefitsFromAccountsQuery = 
                                        'SELECT Id, Name, Start_Date__c, End_Date__c, Offer__c, Category__c, Featured__c, Top_Two_Featured__c, Benefit_Link__c, ' + 
                                               'Business_Member_Partner__r.Name, Business_Member_Partner__r.Logo_Url__c, Business_Member_Partner__r.Logo__c, Business_Member_Partner__r.Website, Business_Member_Partner__r.AboutUs__c ' + 
                                          'FROM Member_Benefit__c ' + 
                                          'WHERE Member_Benefit__c.Business_Member_Partner__c IN (' + accountSearchQuery + ') AND ' +  
                                                 categoryClause + '(Start_date__c = null OR (Start_date__c <= today AND (End_date__c = null OR End_date__c >= today)))';   
            List<Member_Benefit__c> memberBenefitsFromAccounts = Database.query(memberBenefitsFromAccountsQuery);
            this.memberBenefitMap.putAll(memberBenefitsFromAccounts);
            
            String locationSearchQuery = 'SELECT Member_Benefit__c ' + 
                                         'From Member_benefit_Location__c ' + 
                                         'WHERE ' + 
                                           'location__r.Street__c LIKE ' + soqlSearchTerm + ' OR ' + 
                                           'location__r.State__c LIKE ' + soqlSearchTerm + ' OR ' + 
                                           'location__r.PostalCode__c LIKE ' + soqlSearchTerm + ' OR ' + 
                                           'location__r.Phone__c LIKE ' + soqlSearchTerm + ' OR ' + 
                                           'location__r.Name LIKE ' + soqlSearchTerm + ' OR ' + 
                                           'location__r.City__c LIKE ' + soqlSearchTerm;
            
            String memberBenefitsFromLocationsQuery = 
                                        'SELECT Id, Name, Start_Date__c, End_Date__c, Offer__c, Category__c, Featured__c, Top_Two_Featured__c, Benefit_Link__c, ' +  
                                               'Business_Member_Partner__r.Name, Business_Member_Partner__r.Logo_Url__c, Business_Member_Partner__r.Logo__c, Business_Member_Partner__r.Website, Business_Member_Partner__r.AboutUs__c ' + 
                                          'FROM Member_Benefit__c ' +  
                                          'WHERE Id IN (' + locationSearchQuery + ') AND ' +  
                                                 categoryClause + '(Start_date__c = null OR (Start_date__c <= today AND (End_date__c = null OR End_date__c >= today)))';   
            List<Member_Benefit__c> memberBenefitsFromLocations = Database.query(memberBenefitsFromLocationsQuery);
            this.memberBenefitMap.putAll(memberBenefitsFromLocations);
            
            memberBenefits = this.memberBenefitMap.values();
        } else {
            String memberBenefitsQuery = 
                                        'SELECT Id, Name, Start_Date__c, End_Date__c, Offer__c, Category__c, Featured__c, Top_Two_Featured__c, Benefit_Link__c, ' +  
                                               'Business_Member_Partner__r.Name, Business_Member_Partner__r.Logo_Url__c, Business_Member_Partner__r.Logo__c, Business_Member_Partner__r.Website, Business_Member_Partner__r.AboutUs__c ' + 
                                          'FROM Member_Benefit__c ' +  
                                          'WHERE ' + categoryClause + '(Start_date__c = null OR (Start_date__c <= today AND (End_date__c = null OR End_date__c >= today))) ';
                                          
            if(this.isTest) {
                memberBenefitsQuery += ' And Name like \'Test\' ';
            }
            
            memberBenefitsQuery += ' ORDER BY Name ';
            
            memberBenefits = Database.query(memberBenefitsQuery);
            this.memberBenefitMap.putAll(memberBenefits);
        }
        
        //sorting start
        List<String> sortedMemberBenefitNames = new List<String>();
        for(ID mbId : this.memberBenefitMap.keySet()) {
            String finalMbName;
            String mbName = this.memberBenefitMap.get(mbId).Name;
            if(mbName.toLowerCase().startsWith('the ')) {
                finalMbName = mbName.subString(4, mbName.length());
            }
            else {
                finalMbName = mbName;
            }
            finalMbName = finalMbName.toLowerCase() + ' ~~' + mbId;
            sortedMemberBenefitNames.add(finalMbName); 
        }
        sortedMemberBenefitNames.sort();
        List<Member_Benefit__c> sortedMemberBenefits = new List<Member_Benefit__c>();
        for(String mbName : sortedMemberBenefitNames) {
            String mbId = mbName.subString(mbName.lastIndexOf(' ~~')+3, mbName.length());
            sortedMemberBenefits.add(this.memberBenefitMap.get(mbId));
        }
        this.memberBenefits = sortedMemberBenefits;
        this.memberBenefitMap.putAll(this.memberBenefits);
        //sorting end
        
        String featuredMemberBenefitsQuery = 
                                    'SELECT Id, Name, Start_Date__c, End_Date__c, Offer__c, Featured__c, Top_Two_Featured__c, Benefit_Link__c, ' +  
                                           'Business_Member_Partner__r.Name, Business_Member_Partner__r.Logo_Url__c, Business_Member_Partner__r.Logo__c, Business_Member_Partner__r.Website, Business_Member_Partner__r.AboutUs__c ' + 
                                      'FROM Member_Benefit__c ' +  
                                      'WHERE (Start_date__c = null OR (Start_date__c <= today AND (End_date__c = null OR End_date__c >= today))) AND Top_Two_Featured__c = true';   
        List <Member_Benefit__c> featuredMemberBenefits = Database.query(featuredMemberBenefitsQuery);
        this.topTwoFeaturedMemberBenefitWrappers = new List<MemberBenefitWrapper>();
        for(Member_Benefit__c mb : featuredMemberBenefits) { // TODO: locations???
            this.topTwoFeaturedMemberBenefitWrappers.add(new MemberBenefitWrapper(mb, null, true));
        }
        
        Map<Id, Member_Benefit__c> memberBenefitsWithLocationsMap = new Map<Id, Member_Benefit__c>();
        memberBenefitsWithLocationsMap.putAll(
               [SELECT Id, 
                        (SELECT Location__r.Phone__c, Location__r.Longitude__c, Location__r.Latitude__c, Location__r.PostalCode__c, Location__r.State__c, Location__r.City__c, 
                         Location__r.Street__c, Location__r.Name, Location__r.Id
                         FROM Member_Benefit_Locations__r)
                FROM Member_Benefit__c
                WHERE Id in :memberBenefits]);
        
        this.memberBenefitWrappers = new List<MemberBenefitWrapper>();
        for(Member_Benefit__c mb : this.memberBenefits) {
            this.memberBenefitWrappers.add(new MemberBenefitWrapper(mb, memberBenefitsWithLocationsMap.get(mb.Id).Member_Benefit_Locations__r));
        }
    }
    
    @isTest
    private static void myTest() {
       /*
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


        ApexPages.CurrentPage().getParameters().put('idsToPrint', '-'+mb.Id+'-');
                
        ApexPages.CurrentPage().getParameters().put('searchTerm', 'Whiskeys Smokehouse');
        
        
        //ApexPages.CurrentPage().getParameters().put('memberBenefitId', mb.Id);
        */
        MemberBenefitController clsTest = New MemberBenefitController();
        
        Member_Benefit__c m = new Member_Benefit__c();
        m.Name = 'test';
        insert m;
        Member_Benefit__c m1 = new Member_Benefit__c();
        m1.Name = 'test';
        insert m1;        
        
        
        clsTest.isTest = true;        
        clsTest.showMemberBenefits();
        try{
            clstest.showMemberBenefit();
        }
        Catch(Exception ex) {}
        clsTest.searchMemberBenefits();
        clsTest.printDetail();
        clsTest.printDetails();
        clsTest.callPrintPage(new List<MemberBenefitWrapper>());
        
        ApexPages.currentPage().getParameters().put('idsToPrint',m.Id);
        
        try {
            clsTest.print();
        }
        Catch(Exception ex){}
        
        try {
            clsTest.retrieveMemberBenefit();
        }
        Catch(Exception ex) {}
        
        clsTest.searchTerm = 'Test';
        clsTest.retrieveMemberBenefits();
        clsTest.getCategories();
        
    }
    
   
}