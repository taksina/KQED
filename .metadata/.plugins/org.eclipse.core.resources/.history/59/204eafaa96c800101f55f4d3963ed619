public class LookupParentCampaign {
    //-------------------Variable Section ----------------------------//
    
    private List<String> noMatch;
    private List<Campaign> results;
    private List<Campaign> smallresults;
    private String name;
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
    
    public List<Campaign> getSmallResults(){
        return this.smallresults;
    }
  
    public List<String> getNoMatch() {
        return this.noMatch;
    }
  
    public Boolean getShowResults() {
        if(smallResults.size() > 0)
            return true;
        else
            return false;
    }
  
  //-------------------Constructor Section ----------------------------//
  
    public LookupParentCampaign(){
        smallresults = new List<Campaign>();
        
        noMatch = new List<String>();
        noMatch.add('No Matches Found.');
        
        typeOf = System.currentPageReference().getParameters().get('parentid');
        DistributorID = System.currentPageReference().getParameters().get('distributorid');
        MfgAccID = System.currentPageReference().getParameters().get('mfgaccid');
        EndCustomer = System.currentPageReference().getParameters().get('EndCustomer');
        pricebook = System.currentPageReference().getParameters().get('parentid');
        value = System.currentPageReference().getParameters().get('value');
        index = System.currentPageReference().getParameters().get('index');
        
        if(value != ''  && value != null) name = value;
        
        searchParentCampaign() ;
    }
  
  //--------------------Function Section---------------------------------//
    public PageReference searchParentCampaign() {
       /* if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<Campaign>)[ select id,  Name
                        from Campaign where (Name like :sName) order by Name limit 100];
            smallresults = results;
            system.debug('##results' + smallresults); 
        }else{
            results = (List<Campaign>)[ select id,  Name
                        from Campaign where id =: pricebook and IsActive = true order by Name limit 100];            
            smallresults = results;
            system.debug('##results' + smallresults); 
        }*/
        
         system.debug('##name ' + name );
         system.debug('##typeOf ' + typeOf ); 
    if ((typeOf!='' && typeOf!=null) && ((name!='' && name!=null))) {      
        
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<Campaign>)[ select id,  Name
                        from Campaign
                        where Name like :sName AND (id =: typeOf) order by name limit 100 ];
        }
        else {
            results = (List<Campaign>)[select id, Name
                        from Campaign order by name limit 100];
        }
        
    }
    else {
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<Campaign>)[ select id,  Name
                        from Campaign
                        where (Name like :sName) order by name limit 100];
        }
        else {
            results = (List<Campaign>)[select id,  Name
                        from Campaign order by name limit 100];
        }
    }
   
    smallresults = results;
    
    system.debug('##smallresults'+ smallresults );
    return null;                  
        return null;
    }

    static testMethod void myTest() {
        
        //ApexPages.currentPage().getParameters().put('id', '006300000047LxM');
        
        LookupParentCampaign clsTest = new LookupParentCampaign();
        clsTest.searchParentCampaign();
        clsTest.name='Test';
        clsTest.searchParentCampaign();
        clsTest.setName('test');
        clsTest.getName();
        clsTest.getValue();
        
       // clsTest.getSmallResults();
       // clsTest.getShowResults();

    }    
    
}