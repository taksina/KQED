public class BatchAccountImageLoad {
 
    public Boolean isTest = false;
    
    public BatchAccountImageLoad(){
        
    }

    public void execute(){
    	String queryStr = 'select id, Logo__c, Logo_Url__c from Account where Member_Discount_Offer__c = true';
        if(this.isTest) {
            queryStr += ' and name like \'%Blue Ribbon BBQ%\' Limit 1';
        }
    	List<Account> mdoAccounts = Database.query(queryStr);
    	
    	List<Document> images = new List<Document>();
    	
        for(Account a : mdoAccounts){
            if(a.logo__c != null) {
		        String iname = a.logo__c.substring(a.logo__c.lastIndexOf('s/')+2, a.logo__c.lastIndexOf('.')+4).replace('&#39;', '\'').replace('&amp;', '&');
		        System.debug(Logginglevel.WARN, iname);
		        PageReference pageRef = new PageReference('/resource/mdo_images/'+iname);
		        System.debug(Logginglevel.WARN, pageRef.getUrl());
		        Blob img = pageRef.getContent();
		        
		        if(img != null) {
		        	Folder folder = [Select Id FROM Folder WHERE developerName = 'Member_Benefit_Images'];
		            Document newImage = new Document();
		            newImage.Body = img;
		            newImage.Name = ((String)a.Id).substring(0, 15) + '-Logo_Url__c';
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
        
        for(Account a : mdoAccounts){
        	if(a.logo__c != null) {
        	    String url = '/servlet/servlet.ImageServer?id='+imageMap.get(((String) a.Id).substring(0, 15) + '-Logo_Url__c') + '&oid=' + UserInfo.getOrganizationId();
        	    a.Logo_Url__c = url;
        	}
        }
        update mdoAccounts;
    }

    @isTest
    public static void testImageUpload() {
    	Account bmp = new Account(
           Name = 'Blue Ribbon BBQ', 
           Member_Discount_Offer__c = true, 
           Logo__c = 's/BlueRibbonBBQ.jpg'
        );
        insert bmp;
        
        Test.StartTest();
    	BatchAccountImageLoad bail = new BatchAccountImageLoad();
    	bail.isTest = true;
    	bail.execute();
        Test.StopTest();
        
        Account ubmp = [select id, Logo__c, Logo_Url__c from Account where Member_Discount_Offer__c = true and name like '%Blue Ribbon BBQ%' Limit 1];
        System.debug('ubmp: '+ubmp.Logo_Url__c);
    }
}