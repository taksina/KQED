public class update_job_level{
@future

    public static void met_new(List<String> pos) //added by LRT
    {
        List<Position__c> lstPos = [Select id, position_title__c, job_level__c,billing_activity_code__c, billing_accounting_unit__c  from Position__c where id in:pos];
        List<ID> lstWGBHid = new List<ID>(); 
        List<ID> lstPositionTitleId = new List<ID>();
        Map<ID,WGBH_AUAC__c> MapW_auac = new Map<ID,WGBH_AUAC__c>();
        Map<ID,wgbh_job_titles__c> Mapwht = new Map<ID,wgbh_job_titles__c>();
        
        if(lstPos <> null && lstPos.size()>0){
            for(Position__c p:lstPos){
                if(p.billing_accounting_unit__c!=null){
                    lstWGBHid.add(p.billing_accounting_unit__c);
                }
                if(p.position_title__c!=null){
                    lstPositionTitleId.add(p.position_title__c);
                }
            }        
            if(lstWGBHid <> null && lstWGBHid.size()>0){
                MapW_auac = new Map<Id,WGBH_AUAC__c>([Select id, activity__c from WGBH_AUAC__c where id in:lstWGBHid]);
            }
            if(lstPositionTitleId <> null && lstPositionTitleId.size()>0){
                Mapwht = new Map<Id, wgbh_job_titles__c>([select id,name,code__c  from wgbh_job_titles__c where id in:lstPositionTitleId]);
            }
            List<Position__c> lstUpdatePos = new List<Position__c>();
            boolean addtolist = false;
            for(Position__c p: lstPos) {
                if(MapW_auac.containsKey(p.billing_accounting_unit__c)) {
                    WGBH_AUAC__c w = MapW_auac.get(p.billing_accounting_unit__c);
                    p.billing_activity_code__c = w.activity__c;
                    //lstUpdatePos.add(p);
                    addtolist = true;
                }
                if(Mapwht.containsKey(p.position_title__c)){
                    wgbh_job_titles__c job = Mapwht.get(p.position_title__c);
                    p.job_level__c = job.code__c;
                    //lstUpdatePos.add(p);
                    addtolist = true;
                }
                if(addtolist==true) lstUpdatePos.add(p);
                addtolist = false;
            }            
            try{
                if(lstUpdatePos.size()>0) Update lstUpdatePos;
            }
            catch(Exception e)
            {
                System.debug(e.getmessage());
            }            
        }
    }

    public static void met(List<String> pos)
    {
        for(String s:pos)
        {
            Position__c p = [Select id, position_title__c, job_level__c,billing_activity_code__c, billing_accounting_unit__c  from Position__c where id=:s];
            
                 if(p.billing_accounting_unit__c!=null)
                 {
                     // get the  WGBH_AUAC__c lookup record and update the billing activity field accordingly
                     WGBH_AUAC__c W_auac = [Select id, activity__c from WGBH_AUAC__c where id=:p.billing_accounting_unit__c];
                     p.billing_activity_code__c = w_auac.activity__c;
                  }
                  if(p.position_title__c!=null)
                  {
                      // get the  wgbh_job_titles__c lookup record and update the job_level field in position accordingly.
                     wgbh_job_titles__c wht = [select id,name,code__c  from wgbh_job_titles__c where id=:p.position_title__c]; 
                     p.job_level__c = wht.code__c;
                  
                  }
                  try{
                     
                     update p;
                  }
                  catch(Exception e)
                  {
                        System.debug(e.getmessage());
                  }
         
        }
    }
    public static testMethod void testUpdateposition_openapproved() {
        WGBH_Job_Titles__c jobTitle = new WGBH_Job_Titles__c(
            name = 'Apex code hacker',
            is_exempt__c = true,
            is_active__c = true,
            EEO_Category__c = 'Professionals',
            Description__c = 'SalesForce VisualForce Apex hacker',
            code__c = 'X123',
            affiliation__c = 'SAG'
        );
        insert jobTitle;        
        WGBH_AUAC__c auac = new WGBH_AUAC__c(
            Name = 'Fred AUAC',
            Activity__c = 'Activity',
            start_date__c=system.today(),
            end_date__c=system.today() + 1,
            description__c = 'new job',
            auac__c = 'clown'
        );
        insert auac;
        Position__c pos = new Position__c(
            created_by_email__c = 'steven.lemmo@roundcorner.com',
            max_pay__c = 30000.0,
            min_pay__c = 25000.0,
            position_title__c = jobTitle.Id,
            activity_code__c = auac.id,
            billing_accounting_unit__c = auac.id
        ); 
        insert pos; 
        
        //Test.StartTest();
        List<String> positions = new List<String>();
        positions.add(pos.id);          
        update_job_level.met(positions);
        //Test.StopTest(); 
            
        Position__c thispos = [Select id, billing_activity_code__c, job_level__c  from position__c where id=:pos.id];       
        System.assertEquals(thispos.billing_activity_code__c,auac.activity__c);
        System.assertEquals(thispos.job_level__c,jobTitle.code__c);                         
    }     

}