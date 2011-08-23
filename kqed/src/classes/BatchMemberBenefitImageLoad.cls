public class BatchMemberBenefitImageLoad {
 
    public Boolean isTest = false;
    
    public BatchMemberBenefitImageLoad(){
        
    }

    public void execute(){
        String queryStr = 'select id, BenefitImage__c, Logo_Url__c from Member_Benefit__c where logo_url__c = null';
        if(this.isTest) {
            queryStr += ' and name like \'%Blue Ribbon BBQ%\' Limit 1';
        }
        List<Member_Benefit__c> mbs = Database.query(queryStr);
        
        List<Document> images = new List<Document>();
        Folder folder = [Select Id FROM Folder WHERE developerName = 'Member_Benefit_Images'];
        
        for(Member_Benefit__c mb : mbs){
            if(mb.BenefitImage__c != null) {
                String iname = mb.BenefitImage__c.substring(mb.BenefitImage__c.lastIndexOf('s/')+2, mb.BenefitImage__c.lastIndexOf('.')+4).replace('&#39;', '\'').replace('&amp;', '&');
                System.debug(Logginglevel.WARN, iname);
                PageReference pageRef = new PageReference('/resource/mdo_images/'+iname);
                System.debug(Logginglevel.WARN, pageRef.getUrl());
                Blob img = pageRef.getContent();
                
                if(img != null) {
                    Document newImage = new Document();
                    newImage.Body = img;
                    newImage.Name = ((String)mb.Id).substring(0, 15) + '-Logo_Url__c';
                    newImage.IsPublic = true;
                    newImage.FolderId = folder.Id;
                    
                    images.add(newImage);
                }
            }
        }
        insert images;
        
        Map<String, Id> imageMap = new Map<String, Id>();
        images = [SELECT id, Name from Document];
        for(Document d : images) {
            imageMap.put(d.Name, d.id);
        }
        
        for(Member_Benefit__c mb : mbs){
            if(mb.BenefitImage__c != null) {
                String url = '/servlet/servlet.ImageServer?id='+imageMap.get(((String) mb.Id).substring(0, 15) + '-Logo_Url__c') + '&oid=' + UserInfo.getOrganizationId();
                mb.Logo_Url__c = url;
            }
        }
        update mbs;
    }

    @isTest
    public static void testImageUpload() {
        Account bmp = new Account(
           Name = 'Blue Ribbon BBQ', 
           Member_Discount_Offer__c = true, 
           Logo__c = 's/BlueRibbonBBQ.jpg'
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
           Name = 'Blue Ribbon BBQ', 
           Offer__c = 'Get 15 cent wings, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Business_Member_Partner__c =  bmp.id
        );
        insert mb;
        
        Test.StartTest();
        BatchMemberBenefitImageLoad bmbil = new BatchMemberBenefitImageLoad();
        bmbil.isTest = true;
        bmbil.execute();
        Test.StopTest();
        
        Member_Benefit__c mbUpdated = [select id, Logo_Url__c from Member_Benefit__c where name like '%Blue Ribbon BBQ%' Limit 1];
        System.debug('mbUpdated: '+mbUpdated.Logo_Url__c);
    }
}