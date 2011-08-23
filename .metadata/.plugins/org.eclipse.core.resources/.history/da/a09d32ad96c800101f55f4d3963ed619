global class OnlineEventDetailWs 
{
    
        
    global class OnlineEventDetailWs_Result 
    {
    
        webservice String status {get; set;} //'Success','Error','Exception' 
        webservice String description {get; set;} //'Success', message, execption message
        webservice String xml {get; set;} //result
    }
    
    //returns a single event using the event id primary key
    //need validation for string length
    //need validation for result set size
    webservice static OnlineEventDetailWs_Result getEventById(String eventId)
    {
        OnlineEventDetailWs_Result result = new OnlineEventDetailWs_Result();
        result.status='Success';
        result.Description='Success';
        
        try
        {
            Campaign selectedCampaign = [SELECT id,description, Event_logo__c, Subject_title__c, Event_Url__c, Start_time_date__c, End_time_date__c,
                                        Ticket_Url__c, Ticket_information__c, Venue_name__c, street_address__c, city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c, 
                                        State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c, Member_Benefit_Discount_Logo__c 
                                        FROM Campaign where active__c=True AND id = :eventId];
          
   
            String xmlResult = '<events>';

/* Ketan Benegal - 12/14/2010 - Code Start
   createXmlResult will create the XmlResult.
*/
            xmlResult = createXmlResult(selectedCampaign, xmlResult);
            
/*          xmlResult += '<event>';
            xmlResult += createElement('id', selectedCampaign.id);
            xmlResult += createElement('title', selectedCampaign.Subject_title__c);
            xmlResult += createElement('Event_url', selectedCampaign.Event_Url__c);
            xmlResult += createElement('description', selectedCampaign.description);
            xmlResult += createElement('Capacity', selectedCampaign.Maximum_Capacity__c);
            xmlResult += createElement('logo_url', selectedCampaign.Event_logo__c);
    
            xmlResult += createElement('starttime', String.valueof(selectedCampaign.Start_time_date__c));
            xmlResult += createElement('endtime', String.valueof(selectedCampaign.End_time_date__c));
            xmlResult += createElement('ticket_info', selectedCampaign.Ticket_information__c);
            xmlResult += createElement('ticket_url', selectedCampaign.Ticket_Url__c);
    
            xmlResult += createElement('Venue_Name', selectedCampaign.Venue_Name__c);
            xmlResult += createElement('street', selectedCampaign.street_address__c);
            xmlResult += createElement('city', selectedCampaign.city__c);
            xmlResult += createElement('state', selectedCampaign.State_province__c);
            xmlResult += createElement('postalCode', selectedCampaign.Zip_postalcode__c);
            xmlResult += createElement('Latitude', selectedCampaign.Location_Latitude__c);
            xmlResult += createElement('Longitude', selectedCampaign.Location_Longitude__c);
    
            xmlResult += createElement('contact', selectedCampaign.name__c);
            xmlResult += createElement('phone', selectedCampaign.Phone__c);
            xmlResult += createElement('email', selectedCampaign.Email__c);
*/             

            xmlResult += '</events>';
/* Ketan Benegal - 12/14/2010 - Code End
   Appended xmlResult += '</events>'; line was missing and would be incomplete xml.
*/
            
            result.xml = xmlResult; 
               
            return result;
    
        }
        catch(Exception ex)//what exceptions are we catching?
        {
            result.status='Exception';
            result.Description=ex.getMessage();
            result.xml=null;
            return result;                  
        }   
    
    }
   /** Created by Brian Wainwright.
   
    //returns events by using the following criteria:
    //Subject = Subject_Title__c
    //Topic = Type
    //City = City__c
    //Category = ?
    //Genre = Category__c
    //Start date & time = Start_Time_Date__c
    //end date & time = End_Time_Date__c
    //Featured? = Feature__c
   */ 
    webservice static OnlineEventDetailWs_Result getEventsByCriteria(String subject,
                                                                     String topic,
                                                                     String city,
                                                                     String genre,
                                                                     String startDateAndTime,
                                                                     String endDateAndTime,
                                                                     boolean feature) 
    {
        OnlineEventDetailWs_Result result = new OnlineEventDetailWs_Result();
        result.status='Success';
        result.Description='Success';
        //Original Query. Commented out since currently no Active Campaign available for testing.
       String queryString = 'SELECT id, description, Event_logo__c, Subject_title__c, Event_Url__c,'
                                   + 'Start_time_date__c, End_time_date__c, Ticket_Url__c,'
                                   + 'Ticket_information__c, Venue_name__c, street_address__c,'
                                   + 'city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c,'
                                   + 'State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c,'
                                   + 'Member_Benefit_Discount_Logo__c FROM Campaign WHERE active__c=True';
 
         /* String queryString = 'SELECT id, description, Event_logo__c, Subject_title__c, Event_Url__c,'
                                   + 'Start_time_date__c, End_time_date__c, Ticket_Url__c,'
                                   + 'Ticket_information__c, Venue_name__c, street_address__c,'
                                   + 'city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c,'
                                   + 'State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c,'
                                   + 'Member_Benefit_Discount_Logo__c FROM Campaign  ';*/
                                   
       if ( subject != null && subject.length() > 0 )
       {
            queryString += ' AND Subject_Title__c = \'' + subject + '\'';
       }
       
       if ( topic != null && topic.length() > 0 )
       {
            queryString += ' AND Type = \'' + topic + '\'';
       }
       
       if ( city != null && city.length() > 0 )
       {
            queryString += ' AND City__c = \'' + city + '\'';
       }
       
       if ( genre != null && genre.length() > 0 )
       {
            queryString += ' AND Category__c = \'' + genre + '\'';
       }
       
       if ( startDateAndTime != null && startDateAndTime.length() > 0 )
       {
       		//lastRun.lastRun__c.format('yyyy-MM-dd\'T\'HH:mm:ss')
            //Datetime stDateTime = getConvertDateTime(startDateAndTime);
            queryString += ' AND Start_Time_Date__c = ' + startDateAndTime + '';
       }
        
       if ( endDateAndTime != null && endDateAndTime.length() > 0 )
       {
            //DateTime endDateTime = getConvertDateTime(endDateAndTime);
            queryString += ' AND End_Time_Date__c = ' + endDateAndTime + '';
       }
        
        try 
        {
            List<Campaign> resultSet = Database.query(queryString);
            
            
            String xmlResult = '<events>';
            
            for(Campaign ca:resultSet)
            {
                xmlResult = createXmlResult(ca, xmlResult);
/* Ketan Benegal - 12/14/2010 - Code End.*/
            }        
       
            xmlResult += '</events>';
               
            result.xml = xmlResult; 
               
            return result;
    
        }
        catch(Exception ex)
        {
            result.status='Exception';
            result.Description=ex.getMessage();
            result.xml=null;
            return result;                  
        }       
    }
    
    //get all active events
    webservice static OnlineEventDetailWs_Result getEvents() 
    {
        OnlineEventDetailWs_Result result = new OnlineEventDetailWs_Result();
        result.status='Success';
        result.Description='Success';
        
        try 
        {
            
            List<Campaign> newca = [SELECT id,description, Event_logo__c, Subject_title__c, Event_Url__c, Start_time_date__c, End_time_date__c,
                                    Ticket_Url__c, Ticket_information__c, Venue_name__c, street_address__c, city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c, 
                                    State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c, Member_Benefit_Discount_Logo__c from Campaign where active__c=True And
                                    (Start_time_date__c = null OR (Start_time_date__c <= today AND (End_time_date__c = null OR End_time_date__c >= today)))];
                   
            String xmlResult = '<events>';
            
            for(Campaign ca:newca)
            {
/* Ketan Benegal - 12/14/2010 - Code Start
   createXmlResult will create the XmlResult.
   Commented out the code for xmlResult.
*/
/*              xmlResult += '<event>';
                xmlResult += createElement('id', ca.id);
                xmlResult += createElement('title', ca.Subject_title__c);
                xmlResult += createElement('Event_url', ca.Event_Url__c);
                xmlResult += createElement('description', ca.description);
                xmlResult += createElement('Capacity', ca.Maximum_Capacity__c);
                xmlResult += createElement('logo_url', ca.Event_logo__c);
        
                xmlResult += createElement('starttime', String.valueof(ca.Start_time_date__c));
                xmlResult += createElement('endtime', String.valueof(ca.End_time_date__c));
                xmlResult += createElement('ticket_info', ca.Ticket_information__c);
                xmlResult += createElement('ticket_url', ca.Ticket_Url__c);
        
                xmlResult += createElement('Venue_Name', ca.Venue_Name__c);
                xmlResult += createElement('street', ca.street_address__c);
                xmlResult += createElement('city', ca.city__c);
                xmlResult += createElement('state', ca.State_province__c);
                xmlResult += createElement('postalCode', ca.Zip_postalcode__c);
                xmlResult += createElement('Latitude', ca.Location_Latitude__c);
                xmlResult += createElement('Longitude', ca.Location_Longitude__c);
        
                xmlResult += createElement('contact', ca.name__c);
                xmlResult += createElement('phone', ca.Phone__c);
                xmlResult += createElement('email', ca.Email__c);
        
                xmlResult += '</event>';
*/
                xmlResult = createXmlResult(ca, xmlResult);
/* Ketan Benegal 12/14/2010 Code End.*/             
            }        
       
            xmlResult += '</events>';
               
            result.xml = xmlResult; 
               
            return result;
    
        }
        catch(Exception ex)
        {
            result.status='Exception';
            result.Description=ex.getMessage();
            result.xml=null;
            return result;                  
        }       
    } 
    
    static String createElement(String tag, String value) 
    {
        return (value != null && value.length() > 0) ? ('<' + tag + '>' + value + '</' + tag + '>') : '';
    }
    /*
    static DateTime getConvertDateTime(String dateString)
    {
                
        Map<String,integer> MapMonthList = new Map<String,integer>();
        MapMonthList.put('January',1);
        MapMonthList.put('February',2);
        MapMonthList.put('March',3);
        MapMonthList.put('April',4);
        MapMonthList.put('May',5);
        MapMonthList.put('June',6);
        MapMonthList.put('July',7);
        MapMonthList.put('August',8);
        MapMonthList.put('September',9);
        MapMonthList.put('October',10);
        MapMonthList.put('November',11);
        MapMonthList.put('December',12);

        String[] dateStringDivided = dateString.split(' ');
        
        String month = String.ValueOf(MapMonthList.get(dateStringDivided.get(0)));
        String day = dateStringDivided.get(1).replace(',', '');
        String year = dateStringDivided.get(2);
        
        String hour = dateStringDivided.get(3).split(':').get(0);
        String minute = dateStringDivided.get(3).split(':').get(1);
        String second = '00';
        
        if (dateStringDivided.get(4) == 'PM')
        {
            hour = String.ValueOf(Integer.ValueOf(hour) + 12);
        }
        
        String stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        
        return datetime.valueOf(stringDate);
                
    }*/
    
    static String createXmlResult(Campaign ca, String xmlResult)
    {
                xmlResult += '<event>';
                xmlResult += createElement('id', ca.id);
                xmlResult += createElement('title', ca.Subject_title__c);
                xmlResult += createElement('Event_url', ca.Event_Url__c);
                xmlResult += createElement('description', ca.description);
                xmlResult += createElement('Capacity', ca.Maximum_Capacity__c);
                xmlResult += createElement('logo_url', ca.Event_logo__c);
        
                xmlResult += createElement('starttime', String.valueof(ca.Start_time_date__c));
                xmlResult += createElement('endtime', String.valueof(ca.End_time_date__c));
                xmlResult += createElement('ticket_info', ca.Ticket_information__c);
                xmlResult += createElement('ticket_url', ca.Ticket_Url__c);
        
                xmlResult += createElement('Venue_Name', ca.Venue_Name__c);
                xmlResult += createElement('street', ca.street_address__c);
                xmlResult += createElement('city', ca.city__c);
                xmlResult += createElement('state', ca.State_province__c);
                xmlResult += createElement('postalCode', ca.Zip_postalcode__c);
                xmlResult += createElement('Latitude', ca.Location_Latitude__c);
                xmlResult += createElement('Longitude', ca.Location_Longitude__c);
        
                xmlResult += createElement('contact', ca.name__c);
                xmlResult += createElement('phone', ca.Phone__c);
                xmlResult += createElement('email', ca.Email__c);
        
                xmlResult += '</event>';
                return xmlResult;
    }
    
    static testMethod void getEventByIdTest() 
    {
       String eventName = 'BRW: Test Campaign';
       Campaign testCampaign = new Campaign(
                           Name = 'BRW: Campaign 1', 
                           StartDate = date.parse('01/22/2005'), 
                           EndDate = date.parse('01/21/2006'), 
                           Subject_title__c = 'BRW: Test Campaign',
                           active__c = true
                           );
        
        insert testCampaign;
        
        String eventId = testCampaign.id;

        Campaign selectedCampaign = [SELECT id,description, Event_logo__c, Subject_title__c, Event_Url__c, Start_time_date__c, End_time_date__c,
                                        Ticket_Url__c, Ticket_information__c, Venue_name__c, street_address__c, city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c, 
                                        State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c, Member_Benefit_Discount_Logo__c 
                                        FROM Campaign where active__c=True AND id = :eventId];
        
        System.assertNotEquals(selectedCampaign, null);
        System.assertEquals(selectedCampaign.id, eventId);                              
    }
    
    static testMethod void getEventByCriteriaTest()
    {
        String subject = 'BRW: Test Campaign 2';
        String city    = 'Boston';
        String genre   = 'Test Genre';
        String topic   = 'Test Topic';
        String startDateAndTime = '2010-01-20 18:00:00';//1/20/2011 6:00 PM';
        String endDateAndTime   = '2010-01-22 09:00:00'; //'1/22/2011 9:00 AM';
        //The String should use the standard date format “yyyy-MM-dd HH:mm:ss” in the local time zone. 
        Campaign testCampaign = new Campaign(
                           Name = 'BRW: Campaign 2',
                           Start_time_date__c =  Datetime.valueOf(startDateAndTime),
                           End_time_date__c = Datetime.valueOf(endDateAndTime),
                           Subject_title__c = subject,
                           Type = topic,
                           city__c = city,
                           Category__c = genre
                           );
        
        insert testCampaign;
        
        String eventId = testCampaign.id;
        
        String queryString = 'SELECT id, description, type, Category__c, Event_logo__c, Subject_title__c, Event_Url__c,'
                                   + 'Start_time_date__c, End_time_date__c, Ticket_Url__c,'
                                   + 'Ticket_information__c, Venue_name__c, street_address__c,'
                                   + 'city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c,'
                                   + 'State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c,'
                                   + 'Member_Benefit_Discount_Logo__c FROM Campaign  ';
                                   
       if ( subject != null && subject.length() > 0 )
       {
            queryString += ' AND Subject_Title__c = \'' + subject + '\'';
       }
       
       if ( topic != null && topic.length() > 0 )
       {
            queryString += ' AND Type = \'' + topic + '\'';
       }
       
       if ( city != null && city.length() > 0 )
       {
            queryString += ' AND City__c = \'' + city + '\'';
       }
       
       if ( genre != null && genre.length() > 0 )
       {
            queryString += ' AND Category__c = \'' + genre + '\'';
       }
        
       if ( startDateAndTime != null && startDateAndTime.length() > 0 )
       {
       		//lastRun.lastRun__c.format('yyyy-MM-dd\'T\'HH:mm:ss')
            //Datetime stDateTime = getConvertDateTime(startDateAndTime);
            queryString += ' AND Start_Time_Date__c = ' + startDateAndTime + '';
       }
        
       if ( endDateAndTime != null && endDateAndTime.length() > 0 )
       {
            //DateTime endDateTime = getConvertDateTime(endDateAndTime);
            queryString += ' AND End_Time_Date__c = ' + endDateAndTime + '';
       }
        
        try 
        {
            List<Campaign> resultSet = Database.query(queryString);
            for(Campaign ca:resultSet)
            {
                System.assertEquals( ca.Subject_title__c, subject );
                System.assertEquals( ca.id, eventId );
                System.assertEquals( ca.type, topic );
                System.assertEquals( ca.Category__c, genre );
            }
        }
        catch (Exception ex)
        {
            System.debug(queryString);
        }
        
    }
    
    
    
}