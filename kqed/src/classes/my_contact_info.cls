public with sharing class my_contact_info{ 
    public Contact contact= new Contact();
    public Contact getContact(){ return contact; }
    public Contact  cont{get;set;}
    public Address__c addr{get;set;}
    public List<Address__c> listAddress{get;set;}
    Public Address__c address= new Address__c();
    public Address__c  getaddress(){ return address; }
    PageReference page;
    public String addressid;
    public String contactid;
    public List<Contact> chkContact;
    public Boolean AddressFlag{get;set;}
    public String AddressVal{get;set;}
    
    public void editAddress(){
        if(System.currentPagereference().getParameters().get('addressid')!=null){
            AddressFlag=true;
            addr=[select Address_Type__c,City__c,State__c,Country__c,Postal_Code__c,Street_1__c,Street_2__c from Address__c  where id=:System.currentPagereference().getParameters().get('addressid')];
            address.Address_Type__c=addr.Address_Type__c;
            address.City__c=addr.City__c;
            address.State__c=addr.State__c;
            address.Country__c=addr.Country__c;
            address.Postal_Code__c=addr.Postal_Code__c;
            address.Street_1__c=addr.Street_1__c;
            address.Street_2__c=addr.Street_2__c;
            AddressVal=addr.id;
        }
    }
    
    public my_contact_info(){
       if(System.currentPagereference().getParameters().get('addressid')!=null){
            AddressFlag=true;
       }else{
            AddressFlag=false;
       }
       if(System.currentPagereference().getParameters().get('id')!=null){
            listAddress=[select Address_Type__c,Street_1__c,Street_2__c,City__c,State__c,Country__c,Postal_Code__c from Address__c where  Contact__r.id=:System.currentPagereference().getParameters().get('id')];
            cont=[select Phone,Preferred_Address__r.Address_Type__c,Preferred_Address__r.City__c,Preferred_Address__r.State__c,Preferred_Address__r.Country__c,Preferred_Address__r.Postal_Code__c,Preferred_Address__r.Street_1__c,Preferred_Address__r.Street_2__c,Salutation,middle_name__c,HomePhone,MobilePhone,Email,Firstname,lastname,WorkEmail__c,HasOptedOutOfEmail,Preferred_Email__c,AlternateEmail__c,PreferredPhone__c,WorkPhone__c,OtherPhone,Fax,DoNotCall,HasOptedOutOfFax,HomeEmail__c from Contact where id=:System.currentPagereference().getParameters().get('id')];
            contact.Salutation=cont.Salutation;
            contact.Firstname=cont.Firstname;
            contact.lastname =cont.lastname;
            contact.HomePhone=cont.HomePhone;
            contact.MobilePhone=cont.MobilePhone;
            contact.Email=cont.Email;
            contact.WorkEmail__c=cont.WorkEmail__c;
            contact.HasOptedOutOfEmail=cont.HasOptedOutOfEmail;
            contact.Preferred_Email__c=cont.Preferred_Email__c;
            contact.HomeEmail__c=cont.HomeEmail__c;
            contact.AlternateEmail__c=cont.AlternateEmail__c;
            contact.PreferredPhone__c=cont.PreferredPhone__c;
            contact.WorkPhone__c=cont.WorkPhone__c;
            contact.OtherPhone=cont.OtherPhone;
            contact.Fax=cont.Fax;
            contact.DoNotCall=cont.DoNotCall;
            contact.HasOptedOutOfFax=cont.HasOptedOutOfFax;
            contact.Phone=cont.Phone;
            
         }
   }
    
  public PageReference searchContact(){
        
        if(contact.email == '' || contact.email == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Email.');
            ApexPages.addMessage(msg);
        }else if(!isEmailAddr(contact.email)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Valid Email.');
            ApexPages.addMessage(msg);
        }
        if(address.Postal_Code__c == '' || address.Postal_Code__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Zip Code.');
            ApexPages.addMessage(msg);
        }
        if(ApexPages.hasMessages()){
            return null;
        }  
        
        List<Address__c> chkAddress= [Select Contact__r.id,Contact__r.email,Contact__r.name,Postal_Code__c From Address__c where Postal_Code__c=:address.Postal_Code__c and Contact__r.email=:contact.email order by CreatedDate desc ]; 
        if(chkAddress.size()>0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.saveAsActivity = false;
            mail.setTargetObjectId(chkAddress[0].Contact__r.id);
            mail.setTemplateId('00XT0000000nP82MAE');  // this is the id of the email template
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            page= System.Page.my_contact_success;
        }else{
            page= System.Page.my_contact_error;
        }
        page.setRedirect(true);
        return page;        
  }
  
    public PageReference Save(){
        if(contact.lastname == '' || contact.lastname== null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Last Name.');
            ApexPages.addMessage(msg);
        }
        if(contact.email == '' || contact.email == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Email.');
            ApexPages.addMessage(msg);
        }else if(!isEmailAddr(contact.email)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Valid Email.');
            ApexPages.addMessage(msg);
        }
        if(contact.HomeEmail__c!=''){
            if(!isEmailAddr(contact.HomeEmail__c)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Valid Personal Email.');
                ApexPages.addMessage(msg);
            }
        }
        if(contact.WorkEmail__c!=''){
            if(!isEmailAddr(contact.WorkEmail__c)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Valid Work Email.');
                ApexPages.addMessage(msg);
            }
        }
        if(contact.AlternateEmail__c!=''){
            if(!isEmailAddr(contact.AlternateEmail__c)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Valid Alternate Email.');
                ApexPages.addMessage(msg);
            }
        }
       
        if(ApexPages.hasMessages()){
            return null;
        }
         contactid=System.currentPagereference().getParameters().get('id');
        if(contactid!=null){ 
            chkContact= [Select Preferred_Address__r.id,id,Name From Contact where  id=:contactid];  
            if(chkContact.size()>0){
                Contact  contupdate= new Contact();
                try{
                   contupdate=[select Phone,Salutation,Email,Firstname,lastname,middle_name__c,HomePhone,MobilePhone,WorkEmail__c,HasOptedOutOfEmail,Preferred_Email__c,AlternateEmail__c,PreferredPhone__c,WorkPhone__c,OtherPhone,Fax,DoNotCall,HasOptedOutOfFax,HomeEmail__c from Contact   where id=:contactid];
                    contupdate.Salutation=contact.Salutation;
                    contupdate.Firstname=contact.Firstname;
                    contupdate.lastname =contact.lastname;
                    contupdate.HomePhone=contact.HomePhone;
                    contupdate.MobilePhone=contact.MobilePhone;
                    contupdate.Email=contact.Email;
                    contupdate.WorkEmail__c=contact.WorkEmail__c;
                    contupdate.HasOptedOutOfEmail=contact.HasOptedOutOfEmail;
                    contupdate.Preferred_Email__c=contact.Preferred_Email__c;
                    contupdate.HomeEmail__c=contact.HomeEmail__c;
                    contupdate.AlternateEmail__c=contact.AlternateEmail__c;
                    contupdate.PreferredPhone__c=contact.PreferredPhone__c;
                    contupdate.WorkPhone__c=contact.WorkPhone__c;
                    contupdate.OtherPhone=contact.OtherPhone;
                    contupdate.Fax=contact.Fax;
                    contupdate.DoNotCall=contact.DoNotCall;
                    contupdate.HasOptedOutOfFax=contact.HasOptedOutOfFax;
                    contupdate.Phone=contact.Phone;
                    
                    update contupdate; 
                }catch(DMLException e){
                    ApexPages.addMessages(e);
                    return null;
                }   
                page= System.Page.my_contact_info3;
            }else{
                page= System.Page.my_contact_error;
            }
        }else{
            page= System.Page.my_contact_error;
        }
        page.setRedirect(true);
        return page;   
    }
    public PageReference  SaveAddress(){
        
        AddressFlag=false;
        contactid=System.currentPagereference().getParameters().get('id');
        if(contactid!=null){ 
            chkContact= [Select Preferred_Address__r.id,id,Name From Contact where  id=:contactid];  
            if(chkContact.size()>0){
                Address__c addrupdate= new Address__c();
                     try{  
                        addrupdate=[select Contact__r.id,Address_Type__c,City__c,State__c,Country__c,Postal_Code__c,Street_1__c,Street_2__c from Address__c where id=:AddressVal];
                        addrupdate.Address_Type__c=address.Address_Type__c;
                        addrupdate.City__c=address.City__c;
                        addrupdate.State__c=address.State__c;
                        addrupdate.Country__c=address.Country__c;
                        addrupdate.Postal_Code__c=address.Postal_Code__c;
                        addrupdate.Street_1__c=address.Street_1__c;
                        addrupdate.Street_2__c=address.Street_2__c;
                        update addrupdate; 
                    }catch(DMLException e){ 
                        ApexPages.addMessages(e);
                    }  
                  listAddress=[select Address_Type__c,Street_1__c,Street_2__c,City__c,State__c,Country__c,Postal_Code__c from Address__c where  Contact__r.id=:contactid];
     
              }
              
        } 
           
        return null; 
    }
  
    Public Boolean isEmailAddr(String email){
        Boolean result = false;
        String theStr = email;
        Integer index = theStr.indexOf('@');
        if (index > 0){
            Integer pindex = theStr.indexOf('.',index);
            if ((pindex > index+1) && (theStr.length() > pindex+1))
            result = true;
        }
        return result;
    }
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            options.add(new SelectOption('Mr.','Mr.'));
            options.add(new SelectOption('Ms.','Ms.'));
            options.add(new SelectOption('Mrs.','Mrs.'));
            options.add(new SelectOption('Dr.','Dr.'));
            options.add(new SelectOption('Prof.','Prof.'));
            return options;
    }
        

}