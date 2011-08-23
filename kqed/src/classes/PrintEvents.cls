public class PrintEvents {

public List<Campaign> lc{get; set;}
public String idsToPrint {get; set;}
public List<Attachment> at{get; set;}
    public id attid{get; set;}
    public boolean image{get; set;}
        

public void Print(){
        this.idsToPrint = ApexPages.currentPage().getParameters().get('idsToPrint');
        
        if(this.idsToPrint !=null && this.idsToPrint.length() > 0) {
        List<String> s = idsToPrint.split(':');
        
        for(integer i=0;i<=s.size();i++)
        {
            System.debug(s);
        }
        for(String st : s){
        lc = [SELECT id, Name__c, Subject_Title__c, Venue_Name__c, Street_Address__c, City__c, State_Province__c, Zip_Postalcode__c, Event_Logo__c, 
             Maximum_Capacity__c, Start_time_date__c, End_time_date__c, Phone__c, Email__c from Campaign where id =:st];
try{

    at=[Select id, name from attachment where parentid=:st limit 1];
attid=at[0].id;
image=true;
}catch(Exception e){
image=false;
}


}
        }     
    }
    
public static testmethod void te(){

    List<Campaign> lc = [SELECT id, name from Campaign limit 5];
    List<String> tempSelectedIds = new List<String>();
    
    String idToPrint ;
    for(Campaign c:lc){
    tempSelectedIds.add(c.Id);
    }
    
    for(Integer mbIndex = 0; mbIndex < tempSelectedIds.size(); mbIndex ++) {
    idToPrint =idToPrint+':'+ tempSelectedIds[mbIndex] ;
    }
    
    PageReference pg = Page.PrintEvents;
    Test.setCurrentPage(pg);
    ApexPages.currentPage().getParameters().put('idsToPrint', idToPrint);
    PrintEvents p = new PrintEvents();
    p.print();
    }
}