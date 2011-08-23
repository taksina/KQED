public class OnlineEventDetail
    {
        public  ID campid = ApexPages.currentPage().getParameters().get('id'); 
        public Campaign  ca{set; get;}
        public List<Attachment> at{get; set;}
        public id attid{get; set;}
        public boolean image{get; set;}
        
        public void EventDetail()
            {
                ca= [SELECT id,description, Event_logo__c, Subject_title__c, Event_Url__c, Start_time_date__c, End_time_date__c,
                     Ticket_Url__c, Ticket_information__c, Venue_name__c, street_address__c, city__c,Maximum_Capacity__c,  
                     State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c, Member_Benefit_Discount_Logo__c from Campaign where id=:campid ];
    try{
    at=[Select id, name from attachment where parentid=:campid limit 1];
    attid=at[0].id;
    image=true;
    }
    catch(Exception e)
    {
    image=false;
    }
    System.Debug(ca);
    }        
 
    public pagereference print(){           
    PageReference printPage = Page.PrintEvents;
    printPage.getParameters().put('idsToPrint', campid);
    printPage.setRedirect(true);
    return printPage;
    }     
      
          public static testmethod void te()
            {
                List<Campaign> c = [SELECT id, name from Campaign limit 1];
                PageReference pg = Page.OnlineEventDetailPage; 
                Test.setCurrentPage(pg); ApexPages.currentPage().getParameters().put('id', c[0].id);
                OnlineEventDetail d = new OnlineEventDetail();
                d.EventDetail();
                Pagereference p = d.print();
            }
        }