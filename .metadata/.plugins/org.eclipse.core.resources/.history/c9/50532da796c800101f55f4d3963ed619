public class ImageUploadController {
    
    public String recordId {get; set;}
    public String objectName {get; set;}
    public String field {get; set;}
    public String folderName {get; set;}
    public Boolean showRemoveImageButton {get; set;}
    public Boolean showDefaultImage {get; set;}
    public String defaultImageUrl {get; set;}
    
    public Blob imageData{get;set;}
    
    public String url {
        get {
            String imageName = this.recordId.substring(0, 15) + '-' + this.field;
            Document[] images = [SELECT Id FROM Document WHERE Name = :imageName LIMIT 1];
            if(images != null && images.size() > 0) {
                url = '/servlet/servlet.ImageServer?id='+images[0].Id+'&oid='+UserInfo.getOrganizationId();
            }
            else {
                if(showDefaultImage == true) {
                    if(defaultImageUrl == null || defaultImageUrl.length() <= 0) 
                        url = '/resource/default_account_logo_trans';
                    else 
                        url = defaultImageUrl;
                }
                else {
                    url = null;
                }
            }
            return url;
        }
        private set;
    }
    
    public ImageUploadController() {
        
    }
    
    public PageReference deleteImage() {
        String imageName = this.recordId.substring(0, 15) + '-' + this.field;
        Document[] images = [SELECT Id FROM Document WHERE Name = :imageName LIMIT 1];
        if(images != null && images.size() > 0) {
            delete images[0];
        }
        return null;
    }
    
    public PageReference uploadImage() {
        String imageName = this.recordId.substring(0, 15) + '-' + this.field;
        Document[] images = [SELECT Id FROM Document WHERE Name = :imageName];
        
        if(images != null && images.size() > 0) {
            Document image = images[0];
            image.Body = this.imageData;
            image.IsPublic = true;
            image.Name = imageName;
            update image;
        }
        else {
            Folder folder = [Select Id FROM Folder WHERE developerName = :this.folderName];
            Document newImage = new Document();
            newImage.Body = this.imageData;
            newImage.Name = imageName;
            newImage.IsPublic = true;
            newImage.FolderId = folder.Id;
            insert newImage;
        }
        
        String urlQuery = 'SELECT ' + this.field + ' FROM ' + this.objectName + ' WHERE id=\'' + this.recordId + '\'';
        sObject[] sos = Database.query(urlQuery);
        
        if(sos.size() > 0) {
            sos[0].put(this.field, this.url);
            try {
                update sos[0];
            }
            catch(Exception ex) {
            }
        }
        
        return null;
   }
   
   @isTest
   public static void testImageUpload() {
       Account testAccount = new Account(name = 'WGBH-test');
       insert testAccount;
       
       ImageUploadController iu = new ImageUploadController();
       
       iu.recordId = testaccount.Id;
       iu.objectName = 'Account';
       iu.folderName = 'Member_Benefit_Images';
       
       iu.field = 'invalid-field';
       String defaultImageUrl = iu.url;
       iu.field = 'Logo_Url__c';
       
       Blob sampleImage = Blob.valueOf('This is the image. Whaaaat?');
       //new image
       iu.imageData = sampleImage;
       iu.uploadImage();
       
       //update image
       iu.uploadImage();
       
       //assert
       String imageName = ((String)testaccount.Id).substring(0, 15) + '-Logo_Url__c';
       Document[] images = [SELECT Id, Name FROM Document WHERE Name = :imageName];
       
       System.assert(images[0].name.contains(imageName));
   }
}