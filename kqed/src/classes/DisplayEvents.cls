public class DisplayEvents
    {
        public DisplayEvents(){}
        public class CampaignSelect {
        public CampaignSelect(){}
        private Campaign theCampaign;
        private boolean selected = false;
        private id attid;
        private boolean image=false;
        
         public id getAttId() {
            return AttId;
            }
            
        public void setAttid(id s) {
            this.AttId = s;
            }
 
        
        public CampaignSelect(Campaign a) {
            theCampaign= a;
            }
            
        public Campaign getTheCampaign() {
            return theCampaign;
            }
            
        public void setTheCampaign(Campaign a) {
            theCampaign = a;
            }
            
        public boolean getSelected() {
            return selected;
            }
            
        public void setSelected(boolean b) {
            this.selected = b;
            }
         public boolean getimage() {
            return image;
            }
            
        public void setimage(boolean b1) {
            this.image = b1;
            }
        
                
        }
        
        public String title{get; set;}
        List<CampaignSelect> campaigns = new  List<CampaignSelect>();
        public String idsToPrint {get; set;}
        public String idToPrint {get; set;}
        public boolean x{get; set;} 
        String apexText;
        
        public String getapexText(){
        return apexText;
            }
            
        public void setapexText(String a){
            apexText =a;
            }
            
        Date d = date.today();
        public List<Campaign> Camp{get;set;}
        public boolean NumEvents{get;set;}
        String likeStr = '%';
        String searchEvent;
        public List<String> category {get; set;}
        String CategoryName = '%';
        private String viewCategoryName = 'Category';
        private static final List<SelectOption>
        
            VIEW_CATEGORY = new SelectOption[] {
            new SelectOption('0','--All Categories--'),
            new SelectOption('Arts & Drama','Arts & Drama'),
            new SelectOption('Celtic & Folk','Celtic & Folk'),
            new SelectOption('Classical Music','Classical Music'),
            new SelectOption('Food & Wine','Food & Wine'),
            new SelectOption('History','History'),
            new selectOption('Home & Travel ','Home & Travel '),
            new selectOption('Jazz','Jazz'),
            new selectOption('Kids & Family','Kids & Family'),
            new selectOption('Kids','Kids'),
            new selectOption('Lectures & Screenings','Lectures & Screenings'),
            new selectOption('Museums & Tours','Museums & Tours'),
            new selectOption('News','News'),
            new selectOption('Science','Science'),
            new selectOption('Theater & Dance','Theater & Dance')};
            
        public List<SelectOption> getCategoryViewNames() {
            return VIEW_CATEGORY;
            }
            
        public void setViewCategoryName(String viewCategoryName) {
            this.viewCategoryName = viewCategoryName;
            }
            
        public String getViewCategoryName() {
            return viewCategoryName;
            }
            
        public String getSearchEvent() {
            return this.searchEvent;
            }
            
        public void setSearchEvent(String search) {
            this.searchEvent = search;
            }
            
        public void initList() {
            EventMethod();
            }
            
        public void GetDateEvents(){
            String s=getapextext();
            System.debug('stringdate:'+''+s);
            System.debug('string date'+s);
            if(s!=Null && s!=''){
                stringconv sc = new stringconv();
                Date mydate = sc.format(s);
                
                Camp=[SELECT id,Category__c, date1__c,subject_title__c, start_time_date__c,end_time_date__c,event_logo__c,Maximum_Capacity__c, 
                     venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c
                     from Campaign where feature__c=true  AND date1__c=:mydate And Active__c=true];
                     
                     if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                System.debug('indate'+Numevents);
                }
            }
            
        public void AllEvents(){
        
            Camp=[SELECT id,subject_title__c, start_time_date__c, end_time_date__c, event_logo__c, Maximum_Capacity__c, 
                  venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c, Category__c
                  from Campaign where Active__c=true  AND start_time_date__c>:d ORDER BY Start_time_date__c ASC ];
                     
                     if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                title= 'All Events:';
                }
                    
        public void PopulateQuery(){
        
           
            likeStr = '%' + searchEvent + '%';
            
            System.debug('$$$$$$$$$$$$$$$$$$$$$$4'+viewCategoryName+'$$$$$$$$$$$$$$$$$$$$$$$'+likeStr);
            if (viewCategoryName != '0' && likestr!='%%'){
                CategoryName =viewCategoryName;
                System.debug(viewCategoryName);
                System.debug(likestr);
                System.debug(categoryname);
                
                Camp=[SELECT id, subject_title__c, start_time_date__c, end_time_date__c, event_logo__c, Maximum_Capacity__c, 
                     venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c, Category__c
                     from Campaign where feature__c=true  AND subject_title__c like :likestr AND 
                     category__c includes( :CategoryName ) And Active__c=true  AND start_time_date__c>:d ORDER BY Start_time_date__c ASC ];
                     
                     if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                title= 'Featured Events:';
                System.debug('indate'+Numevents);
                }
            if(viewCategoryName != '0' && likestr=='%%'){
                CategoryName =viewCategoryName;
                System.debug(CategoryName);
                
                Camp=[SELECT id, subject_title__c, start_time_date__c, end_time_date__c, event_logo__c, Maximum_Capacity__c, 
                venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c, Category__c
                from Campaign where feature__c=true  AND category__c includes( :CategoryName ) And Active__c=true
                AND start_time_date__c>:d ORDER BY Start_time_date__c ASC ];
                
                if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                title= 'Featured Events:';
                System.debug('indate'+Numevents);
                }
            if(viewCategoryName == '0' && likestr!='%%')
                {
                System.debug(likestr);
                
                Camp=[SELECT id, subject_title__c, start_time_date__c, end_time_date__c, event_logo__c, Maximum_Capacity__c, 
                venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c, Category__c
                from Campaign where feature__c=true  AND subject_title__c like :likestr And Active__c=true AND start_time_date__c>:d
                ORDER BY Start_time_date__c ASC ];
                
                if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                title= 'Featured Events:';
                System.debug('indate'+Numevents);
                }
            if(viewCategoryName == '0' && Likestr=='%%')
                {
                
                Camp=[SELECT id, subject_title__c, start_time_date__c, end_time_date__c, event_logo__c, Maximum_Capacity__c,
                venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c, Category__c
                from Campaign where feature__c=true And Active__c=true AND start_time_date__c>:d ORDER BY Start_time_date__c ASC];
                
                if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                title= 'Featured Events:';
                System.debug('indate'+Numevents);
                }    
            }
            
        public void EventMethod(){
            System.debug(likestr);
            System.debug(categoryname);
            
            Camp=[SELECT id, subject_title__c, start_time_date__c, end_time_date__c, event_logo__c, Maximum_Capacity__c, 
                 venue_name__c, street_address__C, city__C, state_province__c, zip_postalcode__c, name__c, Category__c
                 from Campaign  where feature__c=true And Active__c=true AND start_time_date__c> :d ORDER BY Start_time_date__c ASC];
                 
                if(Camp.size()==0)
                NumEvents=true;
                else
                NumEvents=false;
                System.debug('indate'+Numevents);
                for(integer i=0; i<camp.size();i++){
                System.Debug(Camp[i].subject_title__c + ' ' + camp[i].start_time_date__c);
                }
                title= 'Featured Events:';
                }
        public List<CampaignSelect> getCampaign() {
            campaigns = new List<CampaignSelect>();
            //if (camp.size() > 0){
            for(Campaign a:camp ) {
            CampaignSelect cs = new CampaignSelect(a);
            try{
            List<Attachment> att = [Select id, name from Attachment where parentid=:a.id limit 1];
            System.debug(att[0].id);
            
            cs.attid=att[0].id;
            cs.image=true;
            System.debug(cs.attid);
            }
            Catch(Exception e)
            {
            
            cs.image=false;    
             System.debug(e);
             
            }
            
            campaigns.add(cs);                   
            }
            //}
            return campaigns;
            }
            
        public PageReference PrintDetails() {
            List<String> tempSelectedIds = new List<String>();
            for(CampaignSelect c: campaigns ){
                if(c.getSelected()){
             Campaign con = c.getTheCampaign();
             tempSelectedIds.add(con.Id);
             }
         }  
            for(Integer mbIndex = 0; mbIndex < tempSelectedIds.size(); mbIndex ++) {
            idToPrint =idToPrint+':'+ tempSelectedIds[mbIndex] ;
            }
            PageReference printPage = Page.PrintEvents;
            printPage.getParameters().put('idsToPrint', idToPrint);
            printPage.setRedirect(true);
            return printPage;
         }
         
        public static testmethod void te(){
            DisplayEvents de=new DisplayEvents();
           
            de.initList();
            List<DisplayEvents.CampaignSelect> lc =de.getCampaign();
            for(DisplayEvents.CampaignSelect a :lc)
            {
                a.selected=true;
                
            }
            Pagereference p = de.printdetails();  
            
            de.setapextext('Fri Sep 17 00:00:00 MST 2010 ');
            de.getdateevents();
                       
            List<DisplayEvents.CampaignSelect> lc1 =de.getCampaign();
            
            de.setViewCategoryName('Festival');
            de.populatequery();
            List<DisplayEvents.CampaignSelect> lc2 =de.getCampaign();
                
            de.setViewCategoryName('0');
            de.setSearchEvent('cartoon');
            String t=de.getSearchEvent();
            de.populatequery();
            List<DisplayEvents.CampaignSelect> lc3 =de.getCampaign();
                
            de.setViewCategoryName('Other');
            String q=de.getViewCategoryName();
            de.setSearchEvent('');
            de.populatequery();
            List<DisplayEvents.CampaignSelect> lc4 =de.getCampaign();
            
            de.setViewCategoryName('0');
            de.setSearchEvent('');
            
            System.debug(de.getSearchEvent());
            
            de.populatequery();
            
            
            /*List<DisplayEvents.CampaignSelect> lc5 =de.getCampaign();*/
            
            /*
            Campaign cgn = new Campaign();
             list<recordtype> rt=[Select id, name from recordtype where name='Wgbh event'];
             if(rt!=null)
             {
              System.debug(rt.size());
              System.debug(rt[0].id);
             }
             cgn.recordtypeid=rt[0].id;
             cgn.feature__c = true;
             cgn.name='saandy';
             cgn.Active__c= true;
             insert cgn;
            
            List<Campaign> camp =[Select id, name from Campaign where feature__c=true limit 5];*/
            
            DisplayEvents.CampaignSelect c = new CampaignSelect();  
            
           // c.setTheCampaign(camp[0]);  
            c.setSelected(true);
            Campaign c1 = c.getTheCampaign(); 
            Boolean b = c.getSelected();   
            
            c.setImage(true);
            Boolean b1 = c.getimage();   
            
            de.allevents();
            
        }          
    }