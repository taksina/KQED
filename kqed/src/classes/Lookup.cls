public class Lookup {
    //-------------------Variable Section ----------------------------//
    
    private List<String> noMatch;
    private List<PricebookEntry> results;
    private List<PricebookEntry> smallresults;
    private String name;
    private String id;
    public String index{get;set;}
    private String value;
    public string getValue(){
        return this.value;
    }  
    private String typeOf;
    
    private String DistributorID='';
    private String MfgAccID='';
    private String EndCustomer='';
    public String pricebook{get;set;}
    //-------------------Property Section ----------------------------//
  
    public void setName(String name){
        this.name = name;
    }   
    public String getName(){
        return this.name;
    }
    public void setId(String id){
        this.id = id;
    }   
    public String getId(){
        return this.id;
    }
    

  
    public List<String> getNoMatch() {
        return this.noMatch;
    }
  
    public Boolean getShowResults() {
        if(lstResult.size() > 0)
            return true;
        else
            return false;
    }
  
  //-------------------Constructor Section ----------------------------//
    Public String objectName{get;set;}
    Public String fieldName{get;set;}
    public Lookup(){
        smallresults = new List<PricebookEntry>();
        
        noMatch = new List<String>();
        noMatch.add('No Matches Found.');
        
        value = System.currentPageReference().getParameters().get('value');
        id = System.currentPageReference().getParameters().get('id');
        index = System.currentPageReference().getParameters().get('index');
        fieldName = System.currentPageReference().getParameters().get('field');
        objectName = System.currentPageReference().getParameters().get('object');
        system.debug('####Last Index ----> ' + fieldName.lastIndexOf('.'));
        if(fieldName.lastIndexOf('.')>0){
            fieldName = fieldName.substring(fieldName.lastIndexOf('.')+1,fieldName.trim().length());
            system.debug('####object name ----> ' + fieldName);
        }
        if(value != ''  && value != null) name = value;
        
        getPicklist();
    }
    public List<LookupResult> lstResult{get;set;}
    public List<LookupResult> getPicklist(){        
        lstResult = new List<LookupResult>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType ctype = gd.get(objectName);
        Map<String, Schema.SobjectField> fmap = ctype.getDescribe().fields.getMap();
        Schema.DescribeFieldResult fieldResult = fmap.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
        if(ple.size()>0){     
            for( Schema.PicklistEntry f : ple)
            {
                //options.add(new SelectOption(f.getLabel(), f.getValue()));
                LookupResult obj = new LookupResult();
                obj.name = f.getValue();
                lstResult.add(obj);
            }
        }
        else{
            LookupResult obj = new LookupResult();
            lstResult.add(obj);
        }
        
        
        return lstResult;
    }
    /*
    public List<LookupResult> getLookup() {
        List<sObject> lst = new List<sObject>();
        List<LookupResult> lstResult = new List<LookupResult>();
        String query = '';
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            query = 'Select id, name From ' + objectName + '  where (' + fieldName + ' like : ' + sName + ') Order by ' + fieldName + ' Limit 200';
        }else{
            query = 'Select id, name From ' + objectName + ' Order by ' + fieldName + ' Limit 200';
        }            
        lst = database.query(query);
        if(lst.size()>0){
            for(sObject s:lst){
                LookupResult obj = new LookupResult();
                obj.id = String.valueOf(s.get('id'));
                obj.name = String.valueOf(s.get('name'));
                lstResult.add(obj);
            }
        }
        else{
            LookupResult obj = new LookupResult();
            lstResult.add(obj);
        }
        return lstResult;
    }
    */
    public class LookupResult{
        public string id{get;set;}
        public string name{get;set;}
    }  
  //--------------------Function Section---------------------------------//
    
    public PageReference searchProduct() {
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<PricebookEntry>)[ select id,  Name, ProductCode, Product2.Description
                        from PricebookEntry where (Name like :sName or ProductCode like :sName or Product2.Description like :sName) 
                        and Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
            smallresults = results; 
        }else{
            results = (List<PricebookEntry>)[ select id,  Name, ProductCode, Product2.Description
                        from PricebookEntry where Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
            smallresults = results; 
        }                  
        return null;
    }
    
    static testMethod void myTest() {
        
        //ApexPages.currentPage().getParameters().put('id', '006300000047LxM');
        
        System.currentPageReference().getParameters().put('value','123');
        System.currentPageReference().getParameters().put('id','123123');
        System.currentPageReference().getParameters().put('index','1');
        System.currentPageReference().getParameters().put('field','Opportunity.StageName');
        System.currentPageReference().getParameters().put('object','Opportunity');
                
        Lookup clsTest = new Lookup();
        clsTest.searchProduct();
        clsTest.name='Test';
        clsTest.searchProduct();
        clsTest.setName('test');
        clsTest.getName();
        clsTest.getValue();
        clsTest.name='';
        clsTest.searchProduct();
        
        clsTest.setId('12341234');
        clsTest.getId();
        clsTest.getShowResults();
        
        
        clsTest.getNoMatch();
        clsTest.getShowResults();
    }    
    
}