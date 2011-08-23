public class CampaignMemberClass {

    List<SelectOption> tempFieldList;
    List<SelectOption> tempOperators;
        
    List<SelectOption> memberFieldList;
    
    Public String CampaignId{get;set;}
    Public String ActiveTab{get;set;}
    Public Integer TabIndex{get;set;}
    Public boolean blnAddmember{get;set;}
    Public boolean blnExistingMember{get;set;}
    Public String lblExistingMembers{get;set;}
    Public boolean blnAction{get;set;}    
    Public boolean blnAdvanceFilter{get;set;}
    Public String AdvanceFilter{get;set;}
    String emptyTableText = 'There are no members to display. Use the search options to find and add members.';
    String queryLimit = '25';    
    
    Public PageReference tabClick(){
        selectTab();
        return null;
    }
    
    void selectTab(){
        if(ActiveTab == 'ADDMEMBER'){
            resetPaging();
            blnAddmember = true;
            blnExistingMember = false;
            lstContactResult = new List<ContactResult>();
            lstLeadResult = new List<LeadResult>();
            refreshed = emptyTableText;
        }
        if(ActiveTab == 'EXISTINGMEMBER'){
            resetPaging();
            blnAddmember = false;
            blnExistingMember = true;
            LoadExistingMembers();
        }
    }
    
    void setDefaultTab(){
        if(ActiveTab == null){
            //ActiveTab = 'EXISTINGMEMBER';
            system.debug('##################mode : ' + mode);
            if(mode == 'edit')
                ActiveTab = 'EXISTINGMEMBER';
            else
                ActiveTab = 'ADDMEMBER';
        }
        LoadExistingMembers();
        selectTab();
    }
    Public PageReference removeSingle(){
        LoadExistingMembers();
        return null;
    }
    
    public String selectedStatusExisting{get;set;}
    public PageReference updateStatus(){
        List<CampaignMember> lstUpdate = new List<CampaignMember>();
        Set<ID> memberId = new Set<ID>();
        //setPagingToMainList_Existing();
        if(lstExistingMember != null && lstExistingMember.size()>0){
            for(ExistingMember mem:lstExistingMember){
                if(mem.selected == true){
                    memberId.add(mem.memberId);
                }
            }
            if(memberId != null && memberId.size()>0){
                lstUpdate = [Select Id From CampaignMember Where Id in:memberId];
                if(lstUpdate != null && lstUpdate.size()>0){
                    for(CampaignMember mem:lstUpdate){
                        mem.status = selectedStatusExisting;
                    }
                    try{
                        update lstUpdate;
                    }Catch(Exception ex){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
                    }
                    LoadExistingMembers();
                }
            }
        }
        return null;
    }
    Public PageReference removeSelected(){
        List<CampaignMember> lstDel = new List<CampaignMember>();
        Set<ID> selectedMembers = new Set<ID>();
        if(lstExistingMember != null && lstExistingMember.size()>0){
            for(ExistingMember e:lstExistingMember){
                if(e.selected == true){
                    selectedMembers.add(e.memberId);
                }
            }
        }
        if(selectedMembers != null && selectedMembers.size()>0){
            lstDel = [Select Id From CampaignMember Where Id in:selectedMembers];
            if(lstDel != null && lstDel.size()>0){
                Delete lstDel;                
                LoadExistingMembers();
            }
        }
        return null;
    }
    void LoadExistingMembers(){
        lstExistingMember = new List<ExistingMember>();
        List<CampaignMember> lstMember = new List<CampaignMember>();
        lstMember = [Select Id, LeadId, CampaignId, ContactId, Lead.Name, Lead.Company, Status, LastModifiedDate, 
        Contact.Name, Contact.Title, Lead.Title, Lead.Email, Contact.Account.Name, Contact.Email 
        From CampaignMember Where CAMPAIGNID =: CampaignId order by LastModifiedDate desc limit 2000];
        
        lstExistingMember = setListMember(lstMember);
    }
    string mode='';
    public CampaignMemberClass (ApexPages.StandardController controller) {
        lstContactResult = new List<ContactResult>();
        blnAction = false;
        blnAdvanceFilter = true;
        CampaignId = ApexPages.currentPage().getParameters().get('id');
        mode = ApexPages.currentPage().getParameters().get('mode');
        resetPaging();
        setDefaultTab();
        tempFieldList = getFieldList();
        
        memberFieldList = getMemberField();
        PopulateListCriteriaAdd();
        PopulateListCriteriaExisting();
    }
    Public PageReference resetFilterExisting(){
        PopulateListCriteriaExisting();
        return null;
    }
    Public PageReference resetFilterAdd(){
        PopulateListCriteriaAdd();
        return null;
    }
    private void PopulateListCriteriaAdd() {
        tempOperators = getOperators(null);
        ListCriteria = new List<SearchingCriteria>();
        tempCondition = getConditionOperator();
        integer i;        
        for(i=1;i<=5;i++) {
            ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,'',tempCondition,i));
        }
    }
    public boolean IsTest{get;set;}    
    public void UpdateRowNo(){
        Integer iRow = 1;
        if(ListCriteria != null && ListCriteria.size()>0){
            for(SearchingCriteria c:ListCriteria){
                c.RowNo = iRow++;
            }
        }
    }
    public class SearchingCriteria {
        public Integer RowNo{get;set;}
        public List<SelectOption> FieldList{get;set;}
        public string SelectedField{get;set;}
        public Opportunity datePicker{get;set;}
        public List<SelectOption> Operators{get;set;}
        public List<SelectOption> Conditions{get;set;}
        public string SelectedOperator{get;set;}
        public String selectedCondition{get;set;}
        public boolean checkbox{get;set;}
        public string Value{get;set;}
        public SearchingCriteria()
        {
            datePicker = new Opportunity();
        }
        public SearchingCriteria (List<SelectOption> tempFieldList,List<SelectOption> tempOperators,string tempValue,List<SelectOption> tempCondition) {
            FieldList = tempFieldList;
            Operators = tempOperators;
            Conditions = tempCondition;
            datePicker = new Opportunity();
            Value = tempValue;
            checkbox = false;
            RowNo = 0;
            selectedCondition = '--None--';
        }
        public SearchingCriteria (List<SelectOption> tempFieldList,List<SelectOption> tempOperators,string tempValue,List<SelectOption> tempCondition, Integer cRow) {
            FieldList = tempFieldList;
            Operators = tempOperators;
            Conditions = tempCondition;
            datePicker = new Opportunity();
            Value = tempValue;
            checkbox = false;
            RowNo = cRow;
            selectedCondition = '--None--';
        }
    }   
    public List<SelectOption> tempCondition;
    public List<SelectOption> getConditionOperator() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--')); 
        options.add(new SelectOption('AND','And')); 
        options.add(new SelectOption('OR','or'));  
        return options; 
    }
    public PageReference CheckFieldType() {
        if(IsTest==null) IsTest=false;
        IsTest = !IsTest;
        if(ListCriteria != null && ListCriteria.size()>0){
            for(SearchingCriteria s:ListCriteria){
                s.value='';
                if(s.SelectedField != '--None--'){
                    if(s.SelectedOperator == '--None--'){
                        s.SelectedCondition = 'AND';
                        List<String> lstField = new List<String>();
                        lstField = s.SelectedField.split(';');
                        List<SelectOption> operator = new List<SelectOption>();
                        
                        operator = getOperators(lstField[2]);
                        s.Operators = operator;
                        s.SelectedOperator = 'e';
                    }
                }
                else
                    s.SelectedOperator = '--None--';
                    s.SelectedCondition = '--None--';
            }
        }
        return null;
    }
    public PageReference CheckFieldTypeExisting() {
        if(IsTest==null) IsTest=false;
        IsTest = !IsTest;
        if(ListCriteriaExisting != null && ListCriteriaExisting.size()>0){
            for(SearchingCriteria s:ListCriteriaExisting){
                if(s.SelectedField != '--None--'){
                    List<String> lstField = new List<String>();
                    lstField = s.SelectedField.split(';');
                    List<SelectOption> operator = new List<SelectOption>();
                    
                    operator = getOperators(lstField[2]);
                    s.Operators = operator;
                    if(s.SelectedOperator == '--None--'){
                        s.SelectedOperator = 'e';
                    }
                        s.value='';
                }
                else
                    s.SelectedOperator = '--None--';
            }
        }
        return null;
    }
    Public PageReference changeExistingView(){
        Integer currentRows = ListCriteria.size();
        system.debug('############ SelectedView : ' + SelectedView);
        system.debug('############ AdvanceFilter before : ' + AdvanceFilter);
        if(SelectedView != null && SelectedView.length()>0){
            Campaign_Criteria_Template__c objTemplate = [Select id, name, Advance_Filter__c From Campaign_Criteria_Template__c Where id =:SelectedView];
            if(objTemplate != null)
                AdvanceFilter = objTemplate.Advance_Filter__c;
            system.debug('############ AdvanceFilter after : ' + AdvanceFilter);
        }
        List<Campaign_Criteria_Template_Detail__c> lstDetail = new List<Campaign_Criteria_Template_Detail__c>();
        lstDetail = [Select id, Criteria__c, Fields__c, Field_Type__c, Object__c, Operators__c, Values__c, Template__c From Campaign_Criteria_Template_Detail__c Where Template__c =: SelectedView];
        
        Set<String> setFieldName = new Set<String>();
        Set<String> setFieldType = new Set<String>();
        Set<String> setObjectName = new Set<String>();
        if(lstDetail != null && lstDetail.size()>0){
            for(Campaign_Criteria_Template_Detail__c d:lstDetail){
                setFieldName.add(d.Fields__c);
                setFieldType.add(d.Field_Type__c);
                setObjectName.add(d.Object__c);
            }
        
            List<Campaign_Member_Criteria__c> lstCriteria = [Select Id, name, Field_Name__c, Field_Type__c, 
            Parent_Object_API_Name__c, Parent_Object__c 
            From Campaign_Member_Criteria__c 
            Where Field_Name__c in: setFieldName and Field_Type__c in: setFieldType and Parent_Object_API_Name__c in: setObjectName ];
            
            Map<Id, Campaign_Member_Criteria__c> mapCriteria = new Map<Id, Campaign_Member_Criteria__c>();
            
            if(lstCriteria != null && lstCriteria.size()>0){
                for(Campaign_Criteria_Template_Detail__c d:lstDetail){
                    for(Campaign_Member_Criteria__c c:lstCriteria){
                        if(d.Fields__c == c.Field_Name__c && 
                        d.Field_Type__c == c.Field_Type__c &&
                        d.Object__c == c.Parent_Object_API_Name__c){
                            mapCriteria.put(d.Id, c);
                        }
                    }
                }
            }
            List<SelectOption> fields = new List<SelectOption>();
            if(mapCriteria != null && mapCriteria.size()>0){ 
                ListCriteria = new List<SearchingCriteria>();               
                Integer row = 1;
                for(Campaign_Criteria_Template_Detail__c d:lstDetail){
                    //ListCriteria
                    //ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,'')); 
                    SearchingCriteria objCriteria = new SearchingCriteria(tempFieldList,tempOperators,'',tempCondition,row++);
                    List<SelectOption> operator = new List<SelectOption>();
                    if(mapCriteria.containsKey(d.Id)){
                        Campaign_Member_Criteria__c temp = mapCriteria.get(d.Id);
                        String selectedField = temp.Parent_Object_API_Name__c + ';' + temp.Field_Name__c + ';' + temp.Field_Type__c;
                        objCriteria.SelectedField = selectedField;
                        operator = getOperators(temp.Field_Type__c);
                        if(temp.Field_Type__c.trim().toUpperCase()=='CHECKBOX'){
                            if(d.Values__c != null)
                                objCriteria.checkbox = boolean.valueof(d.Values__c);
                            else
                                objCriteria.checkbox = false;
                        }
                        else if(temp.Field_Type__c.trim().toUpperCase()=='DATE'){
                            if(d.Values__c != null){
                                objCriteria.datePicker.closedate = date.valueof(d.Values__c);
                            }
                        }
                        else if(temp.Field_Type__c.trim().toUpperCase()=='DATETIME'){
                            if(d.Values__c != null){
                                objCriteria.datePicker.Gift_Date_Time__c = datetime.valueof(d.Values__c);
                                system.debug('####### objCriteria.datePicker.Gift_Date_Time__c : ' + objCriteria.datePicker.Gift_Date_Time__c);
                            }
                            system.debug('####### temp.Field_Type__c : ' + temp.Field_Type__c);
                            system.debug('####### d.Values__c : ' + d.Values__c);
                       }
                        system.debug('####### temp.Field_Type__c : ' + temp.Field_Type__c.trim().toUpperCase());
                        system.debug('####### d.Values__c : ' + d.Values__c);
                    }
                    objCriteria.Operators = operator;
                    objCriteria.selectedOperator = d.Operators__c;
                    objCriteria.Value = d.Values__c;
                    ///////////
                    ///////////
                    ListCriteria.add(objCriteria);
                    
                }
                while(ListCriteria.size()<5){
                    ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,'',tempCondition,row++));
                }
            }    
            else{
                PopulateListCriteriaAdd();
        }
            //ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,''));    
        }    
        else{
            PopulateListCriteriaAdd();
        }
        return null;//Go();
    }
    private void PopulateListCriteriaExisting() {
        tempOperators = getOperators(null);
        ListCriteriaExisting = new List<SearchingCriteria>();
        integer i;        
        for(i=1;i<=5;i++) {
            ListCriteriaExisting.add(new SearchingCriteria(memberFieldList,tempOperators,'',tempCondition ));
        }
    }
    private List<SelectOption> getOperators(String FieldType) {
        List<SelectOption> options = new List<SelectOption>(); 
        if(FieldType == null || FieldType.trim().length()==0){
            options.add(new SelectOption('--None--','--None--'));
        }
        else{
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('e',operators('e')));//equal to
            options.add(new SelectOption('n',operators('n')));//not equal to
            if(FieldType.trim().toUpperCase() != 'CHECKBOX'){
                if(FieldType.trim().toUpperCase() == 'NUMBER'){
                    options.add(new SelectOption('l',operators('l')));//less than
                    options.add(new SelectOption('g',operators('g')));//greater than
                    options.add(new SelectOption('m',operators('m')));//less or equal
                    options.add(new SelectOption('h',operators('h')));//greater or equal
                }
                if(FieldType.trim().toUpperCase() == 'DATE' || FieldType.trim().toUpperCase() == 'DATETIME'){
                    options.add(new SelectOption('l',operators('l')));//less than
                    options.add(new SelectOption('g',operators('g')));//greater than
                    options.add(new SelectOption('m',operators('m')));//less or equal
                    options.add(new SelectOption('h',operators('h')));//greater or equal
                }
                if(FieldType.trim().toUpperCase() == 'TEXT' || FieldType.trim().toUpperCase() == 'PICKLIST'){
                    options.add(new SelectOption('s',operators('s')));//starts with
                    options.add(new SelectOption('c',operators('c')));//contains
                    options.add(new SelectOption('k',operators('k')));//does not contain
                }
                options.add(new SelectOption('u',operators('u')));//includes
                options.add(new SelectOption('x',operators('x')));//excludes
            }
        }
        return options;
    }
    String operators(String code){
        code = code.trim().toLowerCase();
        String operator = '';
        
        if(code == 'n')
            operator = 'not equal to';
        else if(code == 'e')
            operator = 'equal to';
        else if(code == 's')
            operator = 'starts with';
        else if(code == 'c')
            operator = 'contains'; 
        else if(code == 'k')
            operator = 'does not contain'; 
        else if(code == 'l')
            operator = 'less than'; 
        else if(code == 'g')
            operator = 'greater than'; 
        else if(code == 'm')
            operator = 'less or equal'; 
        else if(code == 'h')
            operator = 'greater or equal'; 
        else if(code == 'u')
            operator = 'includes'; 
        else if(code == 'x')
            operator = 'excludes'; 
        
        return operator;
    } 
    Public String selectedStatus{get;set;}
    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        List<CampaignMemberStatus> lstStatus = new List<CampaignMemberStatus>();
        Boolean blnInsertedFound = false;
        Integer sortOrder = 1;
        lstStatus = [Select Id, Label, IsDefault, SortOrder From CampaignMemberStatus Where CampaignId =: CampaignId];
        if(lstStatus != null && lstStatus.size()>0){
            for(CampaignMemberStatus status:lstStatus){
                options.add(new SelectOption(status.Label,status.Label)); 
                sortOrder++;
                if(status.Label.trim().toUpperCase() == 'INSERTED')
                    blnInsertedFound = true;
                if(status.IsDefault == true)
                    selectedStatus = status.Label;
            }
        }
        If(blnInsertedFound == false){
            CampaignMemberStatus objInserted = new CampaignMemberStatus();
            objInserted.Label = 'Inserted';
            objInserted.IsDefault = true;
            objInserted.CampaignId = CampaignId;
            objInserted.SortOrder = SortOrder;
            //insert objInserted;
            //options.add(new SelectOption('Inserted','Inserted')); 
        }
        return options; 
    }
    public List<SelectOption> getSearchType() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('LEAD','Prospects/Leads')); 
        options.add(new SelectOption('CONTACT','Contacts')); 
        return options; 
    }
    Public PageReference SelectSearchType(){
        tempFieldList = getFieldList();
        
        memberFieldList = getMemberField();
        
        PopulateListCriteriaAdd();
        
        resetPaging();
        lstContactResult = new List<ContactResult>();
        lstPagingAddContact = new List<ContactResult>();
        
        lstLeadResult = new List<LeadResult>();
        lstPagingAddLead = new List<LeadResult>();
        return null;
    }

    String SelectedSearch = 'CONTACT';
               
    public String getSelectedSearch() {
        return SelectedSearch;
    }
                    
    public void setSelectedSearch(String SelectedSearch) { this.SelectedSearch= SelectedSearch; }
    
    public List<SelectOption> ExistingViews;
    public string SelectedView{get;set;}
    
    public List<SearchingCriteria> ListCriteria{get;set;}
    public List<SearchingCriteria> ListCriteriaExisting{get;set;}
    
    private List<SelectOption> getMemberField() {        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--'));
        //System.Label.RecurringDonationStageName
        options.add(new SelectOption('CampaignMember;ContactId;text',getLabel('CampaignMember') + ' Contact ID' ));
        options.add(new SelectOption('CampaignMember;LeadId;text',getLabel('CampaignMember') + ' Lead ID' ));
        options.add(new SelectOption('CampaignMember;Type;text','Type' ));//custom
        options.add(new SelectOption('CampaignMember;Id;text',getLabel('CampaignMember') + ' ID' ));   
        options.add(new SelectOption('CampaignMember;Status;picklist','Status' ));  
        options.add(new SelectOption('CampaignMember;Name;text','Name')); 
        options.add(new SelectOption('CampaignMember;FirstName;text','First Name'));
        options.add(new SelectOption('CampaignMember;LastName;text','Last Name'));
        options.add(new SelectOption('CampaignMember;Campaign.Name;text',getLabel('Campaign') + ' Name'));
        options.add(new SelectOption('CampaignMember;Title;text','Title'));
        options.add(new SelectOption('CampaignMember;Company;text','Company'));
        options.add(new SelectOption('CampaignMember;Phone;text','Phone'));
        options.add(new SelectOption('CampaignMember;Mobile;text','Mobile'));
        options.add(new SelectOption('CampaignMember;Fax;text','Fax'));
        options.add(new SelectOption('CampaignMember;Email;text','Email'));
        options.add(new SelectOption('CampaignMember;Email_opt_out;text','Email Opt-out'));
        options.add(new SelectOption('CampaignMember;Donotcall;text','Do not Call'));
        options.add(new SelectOption('CampaignMember;OwnerAlias;text',getLabel('Lead') + '/' + getLabel('Contact') + ' Owner Alias' ));
        options.add(new SelectOption('CampaignMember;OwnerFirstName;text',getLabel('Lead') + '/' + getLabel('Contact') + ' Owner First Name' ));
        options.add(new SelectOption('CampaignMember;OwnerLastName;text',getLabel('Lead') + '/' + getLabel('Contact') + ' Owner Last Name' ));
        options.add(new SelectOption('CampaignMember;OwnerFullName;text',getLabel('Lead') + '/' + getLabel('Contact') + ' Owner Full Name' ));
        options.add(new SelectOption('CampaignMember;AccOwnerAlias;text',getLabel('Account') + ' Owner Alias' ));
        options.add(new SelectOption('CampaignMember;AccOwnerFirstName;text',getLabel('Account') + ' Owner First Name' ));
        options.add(new SelectOption('CampaignMember;AccOwnerLastName;text',getLabel('Account') + ' Owner Last Name' ));
        options.add(new SelectOption('CampaignMember;AccOwnerFullName;text',getLabel('Account') + ' Owner Full Name' ));
        
        options.add(new SelectOption('CampaignMember;Street;text','Street'));
        options.add(new SelectOption('CampaignMember;City;text','City'));
        options.add(new SelectOption('CampaignMember;State;text','State'));
        options.add(new SelectOption('CampaignMember;Zip;text','Zip'));
        options.add(new SelectOption('CampaignMember;Country;text','Country'));
        options.add(new SelectOption('CampaignMember;LastModifiedDate;text','Last Modified Date'));
        
        return options;          
    }
    String getSelectFields(){
        String fields = 'Id, LeadId, CampaignId, ContactId, Lead.Name, Lead.Company, Status, LastModifiedDate,'; 
        fields += 'Contact.Name, Contact.Title, Lead.Title, Lead.Email, Contact.Account.Name, Contact.Email';
        
        return fields;
    }
    Public PageReference GoForExistingMember(){
        String Query = '';
        String Condition = '';
        try{
            lstExistingMember = new List<ExistingMember>();
            String conditionalOperator = 'And';
            Integer i=0;
            Integer NextRow = 0;
            if(ListCriteriaExisting != null && ListCriteriaExisting.size()>0){
                for(SearchingCriteria criteria:ListCriteriaExisting){
                    if((criteria.SelectedField != null && criteria.SelectedField != '--None--') &&
                    (criteria.SelectedOperator != null && criteria.SelectedOperator != '--None--')){
                        List<String> lstFields = new List<String>();
                        System.debug ('###Selected field lists : --> ' + criteria.SelectedField);
                        lstFields = criteria.SelectedField.split(';');
                        NextRow = i + 1;
                        if(NextRow < ListCriteriaExisting.size()){
                            if(ListCriteriaExisting[NextRow].SelectedField == '--None--'){
                                criteria.selectedCondition = '--None--';
                            }
                        }
                        if(lstFields != null && lstFields.size()>0){
                            String objectName = lstFields[0];
                            String fieldName = lstFields[1];
                            String fieldType = lstFields[2];
                            /*if(Condition.trim().length() > 0){
                                Condition += ' And ' + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                            }
                            else{
                                Condition = getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                            }*/
                            /////////////////
                            if(Condition.trim().length() > 0){
                                if(criteria.selectedCondition.toUpperCase() == 'AND' && conditionalOperator.toUpperCase() == 'OR'){
                                    Condition +=  ' ' + conditionalOperator + ' '  + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType) + ') ' ;
                                }
                                else if(criteria.selectedCondition.toUpperCase() == 'AND' && conditionalOperator.toUpperCase() == 'AND'){
                                    Condition +=  ' ' + conditionalOperator + ' '  + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                                }
                                else if(criteria.selectedCondition.toUpperCase() == 'OR' && conditionalOperator.toUpperCase() == 'AND'){
                                    Condition +=  ' ' + conditionalOperator + ' ('  + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                                }
                                else if(criteria.selectedCondition.toUpperCase() == 'OR' && conditionalOperator.toUpperCase() == 'OR'){
                                    Condition +=  ' ' + conditionalOperator + ' '  + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                                }
                                else if(criteria.selectedCondition.toUpperCase() == '--None--' && conditionalOperator.toUpperCase() == 'OR'){
                                    Condition +=  ' ' + conditionalOperator + ' '  + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType) + ')';
                                }
                                else if(criteria.selectedCondition.toUpperCase() == '--None--' && conditionalOperator.toUpperCase() == 'And'){
                                    Condition +=  ' ' + conditionalOperator + ' '  + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                                }
                                //Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                            }
                            else{
                                if(criteria.selectedCondition.toUpperCase()=='OR')
                                    Condition = '(' + getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                                else
                                    Condition = getCondition(fieldName, criteria.SelectedOperator, criteria.value, fieldType);
                            }
                            conditionalOperator = criteria.selectedCondition;
                            /////////////////
                        }
                    }
                    i++;
                }
            }
            if(Condition != null && Condition.trim().length()>0){
                Condition = ' And ' + Condition;
            }
            Query = 'Select ' + getSelectFields() + ' From CampaignMember Where CampaignId = \'' + CampaignId + '\' ' + Condition ;
            System.debug('###Existing Member Query : --> ' + Query);
            List<sObject> lstobj = Database.Query(Query);
            List<CampaignMember> tempMember = new List<CampaignMember>();
            if(lstobj != null && lstobj.size()>0){
                for(sObject s:lstobj){
                    CampaignMember member = new CampaignMember();
                    member = (CampaignMember) s;
                    tempMember.add(member);
                }
                if(tempMember != null && tempMember.size()>0)
                    lstExistingMember = setListMember(tempMember);
            }
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        
        return null;
    }
    String getCondition(String fieldName, String operator, String value, String fieldType){
        String Condition = '';
        if(fieldName != null && fieldName.trim().length()>0){
            if(fieldName == 'ContactId'){
                Condition = 'Contact.Id ' +  getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'LeadId'){
                Condition = 'Lead.Id ' +  getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'Type'){
                if(value.trim().length()>0){
                    if(value.trim().toUpperCase() == 'CONTACT' || value.trim().toUpperCase() == getLabel('Contact').toUpperCase()){
                        if(operator == 'n')// not equal to
                            Condition = ' (Contact.Id = null Lead.Id <> null) ';
                        if(operator == 'e')// equal to
                            Condition = ' (Lead.Id = null And Contact.Id <> null) ';
                    }
                    if(value.trim().toUpperCase() == 'LEAD' || value.trim().toUpperCase() == 'LEADS' || value.trim().toUpperCase() == getLabel('Lead').toUpperCase()){
                        if(operator == 'n')// not equal to
                            Condition = ' (Lead.Id = null Contact.Id <> null) ';
                        if(operator == 'e')// equal to
                            Condition = ' (Contact.Id = null And Lead.Id <> null) ';
                    }
                }
            }
            if(fieldName == 'Id'){
                Condition = ' Id ' +  getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'Status'){
                Condition = ' Status ' + getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'LastModifiedDate'){
                Condition = ' LastModifiedDate ' + getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'Name'){
                Condition = ' (Contact.Name ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Name ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'FirstName'){
                Condition = ' (Contact.FirstName ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.FirstName ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'LastName'){
                Condition = ' (Contact.LastName ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.LastName ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Campaign.Name'){
                Condition = ' Campaign.Name ' + getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'Title'){
                Condition = ' (Contact.Title ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Title ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Company'){
                Condition = ' (Contact.Account.Name ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Company ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Phone'){
                Condition = ' (Contact.Phone ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Phone ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Mobile'){
                Condition = ' (Contact.MobilePhone ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.MobilePhone ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Fax'){
                Condition = ' (Contact.Fax ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Fax ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Email'){
                Condition = ' (Contact.Email ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Email ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Email_opt_out'){
                Condition = ' (Contact.HasOptedOutOfEmail ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.HasOptedOutOfEmail ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Donotcall'){
                Condition = ' (Contact.DoNotCall ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.DoNotCall ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'OwnerAlias'){
                Condition = ' (Contact.Owner.Alias ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Owner.Alias ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'OwnerFirstName'){
                Condition = ' (Contact.Owner.FirstName ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Owner.FirstName ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'OwnerLastName'){
                Condition = ' (Contact.Owner.LastName ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Owner.LastName ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'OwnerFullName'){
                Condition = ' (Contact.Owner.Name ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Owner.Name ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            
            
            if(fieldName == 'AccOwnerAlias'){
                Condition = ' Contact.Account.Owner.Alias ' + getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'AccOwnerFirstName'){
                Condition = ' Contact.Account.Owner.FirstName ' + getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'AccOwnerLastName'){
                Condition = ' Contact.Account.Owner.LastName ' + getOperatorSymbol(operator, value, fieldType);
            }
            if(fieldName == 'AccOwnerFullName'){
                Condition = ' Contact.Account.Owner.Name ' + getOperatorSymbol(operator, value, fieldType);
            }
            
            if(fieldName == 'State'){
                Condition = ' (Contact.MailingState ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.State ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Street'){
                Condition = ' (Contact.MailingStreet ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Street ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'City'){
                Condition = ' (Contact.MailingCity ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.City ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Zip'){
                Condition = ' (Contact.MailingPostalCode ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.PostalCode ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
            if(fieldName == 'Country'){
                Condition = ' (Contact.MailingCountry ' + getOperatorSymbol(operator, value, fieldType);
                Condition += ' OR Lead.Country ' + getOperatorSymbol(operator, value, fieldType) + ') ';
            }
        }
        Return Condition;
    }
    
    Public List<ExistingMember> lstExistingMember{get;set;}
    Public Class ExistingMember{
        Public boolean selected{get;set;}
        Public ID memberId{get;set;}
        Public ID contactId{get;set;}
        Public ID leadId{get;set;}
        Public String Name{get;set;}
        Public String MemberType{get;set;}
        Public String Title{get;set;}
        Public String Company{get;set;}
        Public String Email{get;set;}
        Public String Status{get;set;}
        Public DateTime LastModifiedDate{get;set;}
    }
    string getLabel(String objectName){
        String strResult = '';

        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        System.debug('The label for this Object is '+r.getLabel() ) ;
        strResult = r.getLabel();
        return strResult;
    }
    string getLabel(String objectName, String FieldName){
        String strResult = '';

    Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
    Schema.SObjectType s = m.get(objectName) ;
    Schema.DescribeSObjectResult r = s.getDescribe() ;
    // we can get various attributes and propeties on the SObject
    System.debug('The label for this Object is '+r.getLabel() ) ;
    strResult = r.getLabel();
    //if(r.isCustom())
    //    System.debug(' Custom object' ) ;
    // etc..
    // Get all the fields 
    //Map<String, Schema.SObjectField> fields = r.fields.getMap() ;
    // Can now retrieve a particular field and get additional properties
    //Schema.SObjectField f = fields.get('BillingCity' ) ;
    //Schema.DescribeFieldResult r2 = f.getDescribe() ;
    //System.debug( 'The label for this field is '+r2.getLabel() ) ;
        
        return strResult;
    }
    private List<SelectOption> getFieldList() {
        List<Campaign_Member_Criteria__c> lstCampaignCriteria = [Select ID,Name,Lead__c,Contact__c,Field_Name__c,Parent_Object__c,Parent_Object_API_Name__c,Field_Type__c from Campaign_Member_Criteria__c order by Parent_Object__c,Name];
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--'));
        
        for(Campaign_Member_Criteria__c c: lstCampaignCriteria) {
            if(SelectedSearch == 'LEAD'){
                if(c.Lead__c == true)
                    options.add(new SelectOption(c.Parent_Object_API_Name__c + ';' + c.Field_Name__c + ';' + c.Field_Type__c, c.Parent_Object__c + '.' + c.Name));
            }
            if(SelectedSearch == 'CONTACT'){
                if(c.Contact__c == true)
                    options.add(new SelectOption(c.Parent_Object_API_Name__c + ';' + c.Field_Name__c + ';' + c.Field_Type__c, c.Parent_Object__c + '.' + c.Name));
            }
        }
        return options;
    }   
    public PageReference AddNewSearchRow() {
        ListCriteria.add(new SearchingCriteria(tempFieldList,tempOperators,'',tempCondition,ListCriteria.size()+1 ));
        return null;
    }
    public PageReference AddNewSearchRowExisting() {
        ListCriteriaExisting.add(new SearchingCriteria(memberFieldList,tempOperators,'',tempCondition ));
        return null;
    }
        
    public List<CampaignMember> getNewCampaignMembers() {
        List<CampaignMember> lstMem = new List<CampaignMember>();
        return lstMem;
    }
    
    


    Public String templateName{get;set;}
    public List<SelectOption> getExistingViews() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--'));
        List<Campaign_Criteria_Template__c> lstTemplate = new List<Campaign_Criteria_Template__c>();
        lstTemplate = [select id, name, Lead__c, Contact__c from Campaign_Criteria_Template__c];        
        
        if(lstTemplate.size()>0){
            for(Campaign_Criteria_Template__c t:lstTemplate){
                if(SelectedSearch == 'LEAD')
                    if(t.Lead__c == true)
                        options.add(new SelectOption(t.id,t.name));
                if(SelectedSearch == 'CONTACT')
                    if(t.Contact__c == true)
                        options.add(new SelectOption(t.id,t.name));
            }
        }
        
        return options;
    } 
    Public PageReference addMember(){
        List<CampaignMember> lstMemberInsert = new List<CampaignMember>();
        List<CampaignMember> lstMemberUpdate = new List<CampaignMember>();
        if(SelectedSearch=='CONTACT'){
            if(lstContactResult != null && lstContactResult.size()>0){
                for(ContactResult result:lstContactResult){
                    if(result.selected == true){
                        if(result.memberId == null){
                            CampaignMember mem = new CampaignMember();
                            mem.CampaignId = CampaignId;
                            mem.ContactId = result.objContact.Id;
                            mem.status = selectedStatus;
                            
                            lstMemberInsert.add(mem);
                        }
                        if(result.memberId != null){
                            result.objMember.status = selectedStatus;
                            lstMemberUpdate.add(result.objMember);
                        }
                    }
                }
            }        
        }
        else if(SelectedSearch == 'LEAD'){
            if(lstLeadResult != null && lstLeadResult.size()>0){
                for(LeadResult result:lstLeadResult){
                    if(result.selected == true){
                        if(result.memberId == null){
                            CampaignMember mem = new CampaignMember();
                            mem.CampaignId = CampaignId;
                            mem.LeadId = result.objLead.Id;
                            mem.status = selectedStatus;
                            
                            lstMemberInsert.add(mem);
                        }
                        if(result.memberId != null){
                            result.objMember.status = selectedStatus;
                            lstMemberUpdate.add(result.objMember);
                        }
                    }
                }
            }        
        }
        
        if(lstMemberInsert != null && lstMemberInsert.size()>0){
            try{
                insert lstMemberInsert;
                ActiveTab = 'EXISTINGMEMBER';
                selectTab();
                String msg;
                msg = 'You have successfully added ' + String.valueOf(lstMemberInsert.size()) + ' member(s).';
                msg += '\nYou can add more members to this campaign using the \'Add Members\' tab.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,msg)); 
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
            }
        }
        if(lstMemberUpdate != null && lstMemberUpdate.size()>0){
            try{
                update lstMemberUpdate;
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
            }
        }
        LoadExistingMembers();
        return null;
    }
    Public List<ContactResult> lstContactResult{get;set;}
    Public Class ContactResult{
        Public boolean selected{get;set;}
        Public Contact objContact{get;set;}
        Public String MemberStatus{get;set;}
        Public ID memberId{get;set;}
        Public CampaignMember objMember{get;set;}
    }
    Public List<LeadResult> lstLeadResult{get;set;}
    Public Class LeadResult{
        Public boolean selected{get;set;}
        Public Lead objLead{get;set;}
        Public String MemberStatus{get;set;}
        Public ID memberId{get;set;}
        Public CampaignMember objMember{get;set;}
    }
    Public String refreshed{get;set;}
    Public PageReference Go(){
        try{
            resetPaging();
            String Query = generateQuery();
            List<sObject> lstResult = new List<sObject>();
            lstContactResult = new List<ContactResult>();
            lstLeadResult = new List<LeadResult>();
            List<CampaignMember> lstMember;
            
            if(Query != null && Query.trim().Length()>0){
                try{
                    lstResult = Database.Query(Query);
                }catch(System.DmlException e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage())); 
                }
                if(lstResult != null && lstResult.size()>0){                
                    if(SelectedSearch == 'CONTACT'){
                        lstMember = [Select Id, ContactId, Status
                        From CampaignMember Where ContactId != null and CampaignId =: CampaignId];
                    }
                    else if(SelectedSearch == 'LEAD'){
                        lstMember = [Select Id, LeadId, Status
                        From CampaignMember Where LeadId != null and CampaignId =: CampaignId];
                    }
                    for(sObject s:lstResult){
                        if(SelectedSearch == 'CONTACT'){
                            Contact c = new Contact();
                            CampaignMember objMember = new CampaignMember();
                            c = (Contact) s;
                            ContactResult result = new ContactResult();
                            result.selected = false;
                            result.objContact = c;
                            result.memberId = null;
                            result.MemberStatus = '';
                            result.objMember = null;
                            for(CampaignMember mem:lstMember){
                                if(c.Id == mem.ContactId){
                                    result.memberId = mem.Id;
                                    result.MemberStatus = mem.Status;
                                    result.objMember = mem;
                                }
                            }
                            lstContactResult.add(result);
                        }
                        else if(SelectedSearch == 'LEAD'){
                            Lead L = new Lead();
                            CampaignMember objMember = new CampaignMember();
                            L = (Lead) s;
                            LeadResult result = new LeadResult();
                            result.selected = false;
                            result.objLead = L;
                            result.memberId = null;
                            result.MemberStatus = '';
                            result.objMember = null;
                            for(CampaignMember mem:lstMember){
                                if(L.Id == mem.LeadId){
                                    result.memberId = mem.Id;
                                    result.MemberStatus = mem.Status;
                                    result.objMember = mem;
                                }
                            }
                            lstLeadResult.add(result);
                        }
                    }
                }
            }
            refreshed = '';
            if((SelectedSearch == 'LEAD' && lstLeadResult.size()<=0) || (SelectedSearch == 'CONTACT' && lstContactResult.size()<=0)){
                refreshed = emptyTableText;
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        /*}catch(System.DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage())); 
        }*/
        return null;
    }
    String Queryfields(){
        String fields = '';
        if(SelectedSearch == 'LEAD'){
            fields = ' id, FirstName, LastName, Title, Company, Email ';
        }
        else if(SelectedSearch == 'CONTACT'){
            fields = ' id, FirstName, LastName, Title, Account.Name, Email, AccountId ';
        }
        return fields;
    }
    String getContactFieldName(String ObjectName){
        if(ObjectName.trim().length()>0){
            if(ObjectName.trim().toUpperCase() == 'OPPORTUNITY' || ObjectName.trim().toUpperCase() == 'GIVING')
                return 'Oppty_Related_Contact__c';
            if(ObjectName.trim().toUpperCase() == 'BIO' || ObjectName.trim().toUpperCase() == 'BIOS' || ObjectName.trim().toUpperCase() == 'BIOS__C')
                return 'Related_To__c';
            if(ObjectName.trim().toUpperCase() == 'ADDRESS' || ObjectName.trim().toUpperCase() == 'ADDRESS__C')
                return 'Contact__c';
            if(ObjectName.trim().toUpperCase() == 'CASE' || ObjectName.trim().toUpperCase() == 'CASES')
                return 'ContactId';
            if(ObjectName.trim().toUpperCase() == 'CLASSIFICATION' || ObjectName.trim().toUpperCase() == 'CLASSIFICATIONS' || ObjectName.trim().toUpperCase() == 'CLASSIFICATION__C')
                return 'Contact__c';
            if(ObjectName.trim().toUpperCase() == 'GIVING SUMMARY' || ObjectName.trim().toUpperCase() == 'GIVING_SUMMARY__C' || ObjectName.trim().toUpperCase() == 'GIVINGSUMMARY')
                return 'Account__r.One2OneContact__c';
            if(ObjectName.trim().toUpperCase() == 'OPPORTUNITY PRODUCT' || ObjectName.trim().toUpperCase() == 'OPPORTUNITYPRODUCT' || ObjectName.trim().toUpperCase() == 'OPPORTUNITYLINEITEM')
                return 'Opportunity.Oppty_Related_Contact__c';
            if(ObjectName.trim().toUpperCase() == 'RELATIONSHIP' || ObjectName.trim().toUpperCase() == 'RELATIONSHIPS__C')
                return 'People__c';
            if(ObjectName.trim().toUpperCase() == 'EVENT')
                return 'WhoId';
            if(ObjectName.trim().toUpperCase() == 'TASK')
                return 'WhoId';
            if(ObjectName.trim().toUpperCase() == 'CAMPAIGNMEMBER' || ObjectName.trim().toUpperCase() == 'CAMPAIGN MEMBER' || ObjectName.trim().toUpperCase() == 'CAMPAIGN/PROGRAM MEMBER')
                return 'ContactId';            
            else
                return '';
        }
        else
            return '';
    }
    String getObjectName(String ObjectName){
        if(ObjectName.trim().length()>0){
            if(ObjectName.trim().toUpperCase() == 'OPPORTUNITY' || ObjectName.trim().toUpperCase() == 'GIVING')
                return 'Opportunity';
            if(ObjectName.trim().toUpperCase() == 'BIO' || ObjectName.trim().toUpperCase() == 'BIOS' || ObjectName.trim().toUpperCase() == 'BIOS__C')
                return 'Bios__c';
            if(ObjectName.trim().toUpperCase() == 'ADDRESS' || ObjectName.trim().toUpperCase() == 'ADDRESS__C')
                return 'Address__c';
            if(ObjectName.trim().toUpperCase() == 'CASE' || ObjectName.trim().toUpperCase() == 'CASES')
                return 'Case';
            if(ObjectName.trim().toUpperCase() == 'CLASSIFICATION' || ObjectName.trim().toUpperCase() == 'CLASSIFICATIONS' || ObjectName.trim().toUpperCase() == 'CLASSIFICATION__C')
                return 'Classification__c';
            if(ObjectName.trim().toUpperCase() == 'GIVING SUMMARY' || ObjectName.trim().toUpperCase() == 'GIVING_SUMMARY__C' || ObjectName.trim().toUpperCase() == 'GIVINGSUMMARY')
                return 'Giving_Summary__c';
            if(ObjectName.trim().toUpperCase() == 'OPPORTUNITY PRODUCT' || ObjectName.trim().toUpperCase() == 'OPPORTUNITYPRODUCT' || ObjectName.trim().toUpperCase() == 'OPPORTUNITYLINEITEM')
                return 'OpportunityLineItem';
            if(ObjectName.trim().toUpperCase() == 'RELATIONSHIP' || ObjectName.trim().toUpperCase() == 'RELATIONSHIPS__C')
                return 'Relationships__c';
            if(ObjectName.trim().toUpperCase() == 'EVENT')
                return 'Event';
            if(ObjectName.trim().toUpperCase() == 'TASK')
                return 'Task';
            if(ObjectName.trim().toUpperCase() == 'CAMPAIGNMEMBER' || ObjectName.trim().toUpperCase() == 'CAMPAIGN MEMBER' || ObjectName.trim().toUpperCase() == 'CAMPAIGN/PROGRAM MEMBER')
                return 'CampaignMember'; 
            else
                return '';
        }
        else
            return '';
    }
    String generateQuery(){
        String query = '';
        List<String> lstCondition = new List<String>();
        //String arrSelectedfield = 
        //List<Contact> lst = [Select id, FirstName, LastName, Account.Name, Email from Contact];
        String objectName = '';
        String Field = '';
        String Condition = '';
        String innerCondition = '';
        String conditionalOperator = 'And';
        query = 'Select ' + Queryfields() + ' from ' + SelectedSearch;
        Integer i = 0;
        Integer NextRow = 0;
        if(ListCriteria != null && ListCriteria.size()>0){
            for (SearchingCriteria c:ListCriteria){
                List<String> arrList = c.SelectedField.split(';');
                system.debug('######### Array : ' + arrList);
                NextRow = i + 1;
                if(NextRow < ListCriteria.size()){
                    if(ListCriteria[NextRow].SelectedField == '--None--'){
                        c.selectedCondition = '--None--';
                    }
                }
                if(arrList != null && arrList.size()>0 && arrList[0] != '--None--'){
                    if(SelectedSearch == 'LEAD' || 
                    (SelectedSearch == 'CONTACT' && 
                        (arrList[0].trim().toUpperCase() == 'CONTACT' || 
                        arrList[0].trim().toUpperCase() == 'ACCOUNT'))){
                        Field = arrList[1];
                        if(arrList[2] == 'Checkbox')
                            c.value = String.valueOf(c.checkbox);
                        if(arrList[2] == 'Date')
                            c.value = String.valueOf(c.datePicker.closedate);
                        if(arrList[2] == 'DateTime')
                            c.value = String.valueOf(c.datePicker.Gift_Date_Time__c);
                        if(Condition.trim().length() > 0){
                            if(c.selectedCondition.toUpperCase() == 'AND' && conditionalOperator.toUpperCase() == 'OR'){
                                Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]) + ') ' ;
                            }
                            else if(c.selectedCondition.toUpperCase() == 'AND' && conditionalOperator.toUpperCase() == 'AND'){
                                Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                            }
                            else if(c.selectedCondition.toUpperCase() == 'OR' && conditionalOperator.toUpperCase() == 'AND'){
                                Condition +=  ' ' + conditionalOperator + ' ('  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                            }
                            else if(c.selectedCondition.toUpperCase() == 'OR' && conditionalOperator.toUpperCase() == 'OR'){
                                Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                            }
                            else if(c.selectedCondition.toUpperCase() == '--None--' && conditionalOperator.toUpperCase() == 'OR'){
                                Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]) + ')';
                            }
                            else if(c.selectedCondition.toUpperCase() == '--None--' && conditionalOperator.toUpperCase() == 'And'){
                                Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                            }
                            //Condition +=  ' ' + conditionalOperator + ' '  + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                        }
                        else{
                            if(c.selectedCondition.toUpperCase()=='OR')
                                Condition = '(' + Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                            else
                                Condition = Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                        }
                        system.debug('####### Condition : ' + Condition);
                        conditionalOperator = c.selectedCondition;
                        lstCondition.add(Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]));
                    }
                    else if(SelectedSearch == 'CONTACT'){
                        //List<sObject> lstGiving = new List<sObject>();
                        List<AggregateResult> lstGiving = new List<AggregateResult>();
                        String strObjName = getObjectName(arrList[0].trim());
                        String contactFieldName = getContactFieldName(strObjName);
                        String oppQuery = '';
                        if(strObjName.trim().toUpperCase() == 'CAMPAIGNMEMBER' || strObjName.trim().toUpperCase() == 'CAMPAIGN MEMBER' || strObjName.trim().toUpperCase() == 'CAMPAIGN/PROGRAM MEMBER')
                            oppQuery = 'Select ' + contactFieldName + ' From ' + strObjName + ' Where ' + contactFieldName + ' <> null And CampaignId = \'' + CampaignId + '\'';
                        else
                            oppQuery = 'Select ' + contactFieldName + ' From ' + strObjName + ' Where ' + contactFieldName + ' <> null ';
                        String oppCondition = '';                      
                        Field = arrList[1];
                        if(arrList[2] == 'Checkbox')
                            c.value = String.valueOf(c.checkbox);
                        if(arrList[2] == 'Date')
                            c.value = String.valueOf(c.datePicker.closedate);
                        if(arrList[2] == 'DateTime')
                            c.value = String.valueOf(c.datePicker.Gift_Date_Time__c);
                        oppCondition = Field + getOperatorSymbol(c.SelectedOperator, c.value, arrList[2]);
                        
                        if(oppCondition.trim().length()>0)
                            //oppQuery += ' ' + conditionalOperator + ' ' + oppCondition;
                            oppQuery += ' And ' + oppCondition;
                        String contactId = ''; 
                        system.debug('##########SUB QUERY:  ' + oppQuery + ' Group By ' + contactFieldName);
                        oppQuery += ' Group By ' + contactFieldName + ' Limit 100';
                        conditionalOperator = c.selectedCondition;
                        lstGiving = Database.Query(oppQuery);
                        if(lstGiving != null && lstGiving.size()>0){
                            for(sObject s:lstGiving){
                                if(strObjName.toUpperCase() == 'EVENT' || strObjName.toUpperCase() == 'TASK'){
                                    if(getObjectNameById(String.valueOf(s.get(contactFieldName))) == 'CONTACT'){
                                        //if(innerCondition.contains(String.valueOf(s.get(contactFieldName)==false))){
                                            //if(contactId.contains(String.valueOf(s.get(contactFieldName)==false))){
                                                if(contactId == '')
                                                    contactId = '\'' + String.valueOf(s.get(contactFieldName)) + '\'';
                                                else
                                                    contactId += ',\'' + String.valueOf(s.get(contactFieldName)) + '\'';
                                            //}
                                        //}
                                    }
                                }
                                else{
                                    //if(innerCondition.contains(String.valueOf(s.get(contactFieldName)==false))){
                                        //if(contactId.contains(String.valueOf(s.get(contactFieldName)==false))){
                                            if(contactId == '')
                                                contactId = '\'' + String.valueOf(s.get(contactFieldName)) + '\'';
                                            else
                                                contactId += ',\'' + String.valueOf(s.get(contactFieldName)) + '\'';
                                        //}
                                    //}
                                }
                            }
                            if(contactId != ''){
                                if(innerCondition.trim().length()>0){
                                    innerCondition += ',' + contactId;
                                }else{
                                    innerCondition = contactId;
                                }
                                system.debug('########### Contact Ids : ' + innerCondition);
                            }
                            lstCondition.add(' ID In (' + contactId + ') ');
                            system.debug('######################lstCondition.size() ' + lstCondition.size());
                        }
                        else{
                            //return null;
                        }
                    }
                }
                i++;
            }
            system.debug('###### AdvanceFilter ---> ' + AdvanceFilter);
            system.debug('###### innerCondition ---> ' + innerCondition);
            system.debug('###### Condition ---> ' + Condition);
            if(blnAdvanceFilter == true && (AdvanceFilter != null && AdvanceFilter.trim().length()>0)){
                String strAdvanceConditon = '';
                system.debug('###### AdvanceFilter ---> ' + AdvanceFilter);
                Integer totalCondition = lstCondition.size();
                List<String> lstOp = AdvanceFilter.trim().split(' ');
                Integer j;
                for(j=1; j <= lstCondition.size(); j++){
                    system.debug('##########################(' + string.valueof(j) + ') : ' + lstCondition[j-1]);
                    system.debug('##########################AdvanceFilter.indexOf(' + string.valueof(j) + ') : ' + AdvanceFilter.indexOf(String.valueOf(j)));
                    if(AdvanceFilter.indexOf(String.valueOf(j)) >= 0){
                        AdvanceFilter = AdvanceFilter.replace(' ' + String.valueOf(j) + ' ', ' ' + lstCondition[j-1] + ' ');
                        AdvanceFilter = AdvanceFilter.replace(String.valueOf(j) + ' ', ' ' + lstCondition[j-1] + ' ');
                        AdvanceFilter = AdvanceFilter.replace(' ' + String.valueOf(j), ' ' + lstCondition[j-1] + ' ');
                    }else{
                        break;
                    }
                }
                j--;
                if(j<lstCondition.size()){
                    while(j<lstCondition.size()){
                        AdvanceFilter += ' And ' + lstCondition[j];
                        j++;
                    }
                }
                system.debug('###### AdvanceFilter ---> ' + AdvanceFilter);
                Condition = ' ' + AdvanceFilter;
            }
            else{
                if(innerCondition.trim().length()>0){
                    if(Condition.trim().length() > 0){
                        Condition += ' And Id IN (' + innerCondition + ')';
                    }
                    else{
                        Condition += ' Id IN (' + innerCondition + ')';
                    }
                }
            }
            if(Condition.trim().length()>0){
                query += ' Where ' + Condition;
                if(SelectedSearch == 'LEAD'){
                    query += ' And Status = \'New\'';
                }
            }
            else{
                if(SelectedSearch == 'LEAD'){
                    query += ' Where Status = \'New\'';
                }
            }            
        }
        query += ' Limit 2000';
        System.debug('######### QUERY ############     ' + query);
        return query;
        //return '';
    }
    String NVL(string val){
        if(val == null)
            return '';
        else return val.trim();
    }
    String getObjectNameById(String objId){
        String objName = '';
        String prefix = '';
        try{
            objId = NVL(objId);
            if(objId.length()>3){
                prefix = NVL(objId).trim().substring(0,3);
                if(prefix == '003')
                    objName = 'CONTACT';
            }
            Return objName;
        }catch(Exception ex){
            Return '';
        }
    }
    String setValueBasedonType(String Value, String dataType){
        String retValue = '';
        if (dataType.trim().toUpperCase()=='TEXT'){
            retValue =  '\'' + Value + '\'';
        }
        else if (dataType.trim().toUpperCase()=='NUMBER'){
            retValue =  Value;
        }
        else if (dataType.trim().toUpperCase()=='PICKLIST'){
            retValue =  '\'' + Value + '\'';
        }
        else if(dataType.trim().toUpperCase() == 'CHECKBOX'){
            retValue = Value;
        }
        else if (dataType.trim().toUpperCase()=='DATETIME'){
            //retValue =  '\'' + Value + '\'';
            //retValue = DateTime.valueof(value).format('YYYY-MM-DDThh:mm:ssZ');  
            retValue = DateTime.valueof(value).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');      
        }
        else if (dataType.trim().toUpperCase()=='DATE'){
            retValue = value;
            system.debug('####### value of Date:  ' + value);
        }
        return retValue;
    }
    String PicklistCondition(String Code, String Originalvalue){
        code = code.trim().toLowerCase();
        String operator = '';
        String Condition = '';
        //
        List<String> lstValues = OriginalValue.split(',');
        if(lstValues != null && lstValues.size()>0){
            for(string strVal:lstValues){
                String value =  setValueBasedonType(strVal, 'PickList');
                String temp = '';
                temp = value;
                /*if(code == 'n')//not equal to
                    operator = ' != ' + value;
                else if(code == 'e')//equal to
                    operator = ' = ' + value;
                else if(code == 's')//starts with
                    operator = ' \'%' + Originalvalue + '\'';
                else if(code == 'c')//contains
                    operator = ' Like \'%' + Originalvalue + '%\''; 
                else if(code == 'k')//does not contain
                    operator = ' Not Like \'%' + Originalvalue + '%\''; 
                else if(code == 'l')//less than
                    operator = ' <' + value; 
                else if(code == 'g')//greter than
                    operator = ' >' + value; 
                else if(code == 'm')//less or equal
                    operator = ' <=' + value; 
                else if(code == 'h')//greater or equal
                    operator = ' >=' + value; 
                else if(code == 'u')//includes
                    operator = ' Like \'%' + Originalvalue + '%\''; 
                else if(code == 'x')//excludes
                    operator = ' Like \'%' + Originalvalue + '%\''; */
                    
                if(Condition.trim().length()==0){
                    Condition = temp;
                }else{
                    Condition += ',' + temp;
                }
            }
            if(Condition.trim().length()>0){
                Condition = ' IN (' + Condition + ')';
            }
        }
        
        
        return Condition;
    }
    String getOperatorSymbol(String code, String Originalvalue, String dataType){
        code = code.trim().toLowerCase();
        String operator = '';
        if(datatype.trim().toUpperCase() == 'PICKLIST' && Originalvalue.trim().indexOf(',')>0){
            return PicklistCondition(code, OriginalValue);
        }
        String value =  setValueBasedonType(OriginalValue, dataType);
        if(code == 'n')//not equal to
            operator = ' != ' + value;
        else if(code == 'e')//equal to
            operator = ' = ' + value;
        else if(code == 's')//starts with
            operator = ' \'%' + Originalvalue + '\'';
        else if(code == 'c')//contains
            operator = ' Like \'%' + Originalvalue + '%\''; 
        else if(code == 'k')//does not contain
            operator = ' Not Like \'%' + Originalvalue + '%\''; 
        else if(code == 'l')//less than
            operator = ' <' + value; 
        else if(code == 'g')//greter than
            operator = ' >' + value; 
        else if(code == 'm')//less or equal
            operator = ' <=' + value; 
        else if(code == 'h')//greater or equal
            operator = ' >=' + value; 
        else if(code == 'u')//includes
            operator = ' Like \'%' + Originalvalue + '%\''; 
        else if(code == 'x')//excludes
            operator = ' Like \'%' + Originalvalue + '%\''; 
        
        return operator;
    }  
    Campaign_Criteria_Template__c getTemplate(){
        Campaign_Criteria_Template__c objTemplate = new Campaign_Criteria_Template__c();        
        Boolean blnLead = false;
        Boolean blnContact = false;
        if(SelectedSearch == 'LEAD'){
            blnLead = true;
        }
        if(SelectedSearch == 'CONTACT'){
            blnContact = true;
        }
        List<Campaign_Criteria_Template__c> lstTemplate = new List<Campaign_Criteria_Template__c>();
        lstTemplate = [Select Id From Campaign_Criteria_Template__c
        Where name =: templateName.trim() and Lead__c =:blnLead and Contact__c =: blnContact];
        if(lstTemplate != null && lstTemplate.size()>0){
            objTemplate = lstTemplate[0];
        }
        return objTemplate;
    }
    public void removeChild(String parentId){
        List<Campaign_Criteria_Template_Detail__c> lstChild = new List<Campaign_Criteria_Template_Detail__c>();
        lstChild = [select id from Campaign_Criteria_Template_Detail__c where Template__c =: parentId];
        if(lstChild != null && lstChild.size()>0){    
            delete lstChild;
        }
    }
    Public PageReference SaveTemplate(){
        Campaign_Criteria_Template__c objParent = new Campaign_Criteria_Template__c();
        List<Campaign_Criteria_Template_Detail__c> lstChild = new List<Campaign_Criteria_Template_Detail__c>();
        String Objects = '';
        String Fields = '';
        String Values = '';
        String Criteria = '';
        String Operators = '';
        
        try{
            objParent = getTemplate();
            objParent.name = templateName;
            objParent.Advance_Filter__c = AdvanceFilter;
            if(SelectedSearch == 'LEAD')
                objParent.Lead__c = true;
            if(SelectedSearch == 'CONTACT')
                objParent.Contact__c = true;
            if(objParent.Id == null)
                insert objParent;
            else{
                removeChild(objParent.Id);
                update objParent;
            }
            if(objParent.Id != null){
                for (SearchingCriteria c:ListCriteria){
                    Campaign_Criteria_Template_Detail__c objChild = new Campaign_Criteria_Template_Detail__c();
                    List<String> arrList = c.SelectedField.split(';');
                    system.debug('##################### ' + arrList);
                    if(arrList != null && arrList.size()>0 && arrList[0] != '--None--'){
                        objChild.Object__c = arrList[0];
                        objChild.Fields__c = arrList[1];                        
                        objChild.Field_Type__c = arrList[2];
                        
                        if(arrList[2].trim().toUpperCase()=='CHECKBOX')
                            objChild.Values__c = string.valueof(c.CheckBox);
                        else if(arrList[2].trim().toUpperCase()=='DATE')
                            objChild.Values__c = string.valueof(c.datePicker.closedate);
                        else if(arrList[2].trim().toUpperCase()=='DATETIME')
                            objChild.Values__c = string.valueof(c.datePicker.Gift_Date_Time__c);
                        else 
                            objChild.Values__c = c.Value;
                            
                        if(c.SelectedOperator != '--None--')
                            objChild.Operators__c = c.SelectedOperator;  
                        objChild.Template__c = objParent.Id;  
                        lstChild.add(objChild);
                    }                                                               
                }
                if(lstChild != null && lstChild.size()>0){
                    insert lstChild;
                }
            }
        }Catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        } 
        return null;
    }
     

   
    List<ExistingMember> setListMember(List<CampaignMember> lstMember){
        List<ExistingMember> lstTemp = new List<ExistingMember>();
        if(lstMember != null && lstMember.size()>0){
            lblExistingMembers = 'Existing Members (' + String.valueOf(lstMember.size()) + ')' ;
        }
        else{
            lblExistingMembers = 'Existing Members';
        }
        if(lstMember != null && lstMember.size()>0){
            //lblExistingMembers = 'Existing Members (' + String.valueOf(lstMember.size()) + ')' ;
            for(CampaignMember mem:lstMember){
                ExistingMember existing = new ExistingMember();
                existing.memberId = mem.Id;
                existing.status = mem.status;
                existing.LastModifiedDate = mem.LastModifiedDate;
                if(mem.ContactId != null && String.ValueOf(mem.ContactId).Trim().Length()>0){//Contact
                    existing.Name = mem.Contact.Name;
                    existing.Title = mem.Contact.Title;
                    existing.Company = mem.Contact.Account.Name;
                    existing.Email = mem.Contact.Email;
                    existing.MemberType = 'CONTACT';
                    existing.contactId = mem.ContactId;
                }
                else{
                    existing.Name = mem.Lead.Name;
                    existing.Title = mem.Lead.Title;
                    existing.Company = mem.Lead.Company;
                    existing.Email = mem.Lead.Email;
                    existing.MemberType = 'LEAD';
                    existing.LeadId = mem.LeadId;
                }
                lstTemp.add(existing);
            }
        }
        return lstTemp;
    }
    public boolean blnAllMemberSelected{get;set;}
    Public PageReference selectAllMember(){
        if(blnAllMemberSelected == null)blnAllMemberSelected=true;
        if(lstExistingMember != null && lstExistingMember.size()>0){
            for(ExistingMember mem:lstExistingMember){
                mem.selected = blnAllMemberSelected;
            }
        }
        return null;
    }
    public boolean blnAllRowSelected{get;set;}
    Public PageReference selectAll(){
        if(blnAllRowSelected == null)blnAllRowSelected=true;
        if(SelectedSearch == 'LEAD')
            for(LeadResult led:lstLeadResult){
                led.selected = blnAllRowSelected;
            }
        if(SelectedSearch == 'CONTACT')
            for(ContactResult con:lstContactResult){
                con.selected = blnAllRowSelected;
            }
        return null;
    }    
////////////////////////Paging//////////////////////////
    public integer recordCount{get;set;}
    public string AssetName{get;set;}    
      
    public integer TotalCall {get;set;}
    public integer pageNumber {get;set;}
    private integer pageSize;
    public boolean nextPg {get;set;}
    public boolean previousPg {get;set;}
    public boolean isPaging {get;set;}
    public integer totalPage {get;set;}
    public integer totalRecords {get;set;}
    public integer FromRecords {get;set;}
    public integer ToRecords {get;set;}   
    
    void resetPaging(){
        system.debug('#######resetPaging called');
        blnAllMemberSelected = false;
        blnAllRowSelected = false;
        pageNumber=0;
        pageSize = 10;
        totalPage=0;
        totalRecords=0;
        FromRecords=0;
        ToRecords=0;

        nextPg = false;
        previousPg = false;
        isPaging = false;    
    }
    
public string event{get;set;}
    public PageReference NextPage()
    {
        system.debug('#######Next page called');
        //event = 'NextPage';
        if (pageNumber < totalPage ) 
            pageNumber++;
            
        if (pageNumber < totalPage) 
        {
            nextPg = false;
            if (pageNumber > 1) 
            {
                previousPg = false;
            } 
        }
        else 
        {
            nextPg = true;
            previousPg = false;
        }
        event = 'PageNumber ' + pageNumber;
        return null;
    }
    public void PreviousPage()
    {
        system.debug('#######Previous page called');
        event = 'PreviousPage';
        if (pageNumber > 0) 
        {
            pageNumber--;
        }
        if (pageNumber > 1) 
        {
            previousPg = false;
            if (pageNumber < totalPage) 
            {
                nextPg = false;
            }
        }
        else 
        {
            previousPg = true;
            nextPg = false;
        }
        //return null;
    }
    Public List<ExistingMember> lstPagingExisting{get;set;}
    Public List<ExistingMember> getExistingMember(){
        totalRecords = lstExistingMember.size();
        
        
        if (pageNumber == null || pageNumber == 0) 
        {
            pageNumber = 2;
            PreviousPage();
        }

        FromRecords = ((pageNumber - 1) * pageSize) + 1;
        ToRecords = FromRecords + pageSize -1 ;
        
        if (ToRecords>totalRecords) ToRecords = totalRecords;

        if (lstExistingMember.size() <= pageSize)
        {
            totalPage = 1;
            nextPg = true;
            previousPg = true;       
        }
        else
        {
            totalPage = Integer.valueof(lstExistingMember.size()/pageSize);
            if (Math.mod(lstExistingMember.size(), pageSize) > 0)
            {
                totalPage++;
            }
        }
        
        integer totalCountForPage = pageNumber * pageSize;
        if (lstExistingMember.size() < pageSize)
        {
            totalCountForPage = lstExistingMember.size();
        }
        lstPagingExisting = new List<ExistingMember>();
        for (integer i=((pageNumber - 1) * pageSize);i<totalCountForPage;i++)
        {
            if (i < lstExistingMember.size()) {
                ExistingMember existing = new ExistingMember();
                existing = lstExistingMember[i];
                lstPagingExisting.add(existing);
            }
        }
        
        if (totalRecords==0) FromRecords=0; 
        
        
        
        return lstPagingExisting;
    }
    
    
    Public List<ContactResult> lstPagingAddContact{get;set;}
    integer counter = 0;
    Public List<ContactResult> getContactResult(){
        if(SelectedSearch != 'CONTACT') return null;
        totalRecords = lstContactResult.size();
        if (pageNumber == null || pageNumber == 0) 
        {
            pageNumber = 2;
            PreviousPage();
        }

        FromRecords = ((pageNumber - 1) * pageSize) + 1;
        ToRecords = FromRecords + pageSize -1 ;
        
        if (ToRecords>totalRecords) ToRecords = totalRecords;

        if (lstContactResult.size() <= pageSize)
        {
            totalPage = 1;
            nextPg = true;
            previousPg = true;       
        }
        else
        {
            totalPage = Integer.valueof(lstContactResult.size()/pageSize);
            if (Math.mod(lstContactResult.size(), pageSize) > 0)
            {
                totalPage++;
            }
        }
        
        integer totalCountForPage = pageNumber * pageSize;
        if (lstContactResult.size() < pageSize)
        {
            totalCountForPage = lstContactResult.size();
        }
        //event='counter ' + string.valueof(counter++);
        lstPagingAddContact = new List<ContactResult>();
        for (integer i=((pageNumber - 1) * pageSize);i<totalCountForPage;i++)
        {
            if (i < lstContactResult.size()) {                
                
                ContactResult result = new ContactResult();
                result = lstContactResult[i];
                lstPagingAddContact.add(result);
            }
        }
        //if(lstPagingAddContact.size()>0)
        //event='--> ' + lstPagingAddContact[0].objContact.FirstName + '  ' + string.valueof(counter++);
        if (totalRecords==0) FromRecords=0; 
        return lstPagingAddContact;
    }
    
    Public List<LeadResult> lstPagingAddLead{get;set;}
    Public List<LeadResult> getLeadResult(){
        if(SelectedSearch != 'LEAD') return null;
        totalRecords = lstLeadResult.size();
        
        
        if (pageNumber == null || pageNumber == 0) 
        {
            pageNumber = 2;
            PreviousPage();
        }

        FromRecords = ((pageNumber - 1) * pageSize) + 1;
        ToRecords = FromRecords + pageSize -1 ;
        
        if (ToRecords>totalRecords) ToRecords = totalRecords;

        if (lstLeadResult.size() <= pageSize)
        {
            totalPage = 1;
            nextPg = true;
            previousPg = true;       
        }
        else
        {
            totalPage = Integer.valueof(lstLeadResult.size()/pageSize);
            if (Math.mod(lstLeadResult.size(), pageSize) > 0)
            {
                totalPage++;
            }
        }
        
        integer totalCountForPage = pageNumber * pageSize;
        if (lstLeadResult.size() < pageSize)
        {
            totalCountForPage = lstLeadResult.size();
        }
        lstPagingAddLead = new List<LeadResult>();
        for (integer i=((pageNumber - 1) * pageSize);i<totalCountForPage;i++)
        {
            if (i < lstLeadResult.size()) {
                /*AssetsWrapper tempAsset = new AssetsWrapper();
                tempAsset.objAsset = results[i];
                objAssetsWrapper.add(tempAsset);*/
                LeadResult result = new LeadResult();
                result = lstLeadResult[i];
                lstPagingAddLead.add(result);
            }
        }
        
        if (totalRecords==0) FromRecords=0; 
        
        
        
        return lstPagingAddLead;
    }
//////////////////////////////////////////////////////// 

  
    
    static testMethod void CampaignMemberClass() {
        Campaign objCampaign = new Campaign();
        objCampaign.name = 'Test Campaign';
        objCampaign.Campaign_Name__c = 'Annual';
        objCampaign.Station__c = 'WGBH';
        
        insert objCampaign;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'test first name';
        objContact.LastName = 'test last name';
        
        insert objContact;
        
        
        Contact objContact1 = new Contact();
        objContact1.FirstName = 'test first name1';
        objContact1.LastName = 'test last name1';
        
        insert objContact1;
        
        Lead objLead = new Lead();
        objLead.FirstName = 'test Lead first';
        objLead.LastName = 'test Lead last';
        objLead.Company = 'test lead company';
        
        insert objLead;
            
        Campaign member = new Campaign();
        ApexPages.currentPage().getParameters().put('id',objCampaign.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(member);
        CampaignMemberClass clsTest = new CampaignMemberClass(controller);
        
        clsTest.resetFilterExisting();
        clsTest.resetFilterAdd();
        clsTest.UpdateRowNo();
        //clsTest.SearchingCriteria();
        clsTest.getCondition('ContactId','n','LEAD','test');
        clsTest.getExistingViews();
        clsTest.getContactFieldName('OPPORTUNITY');
        clsTest.getObjectName('OPPORTUNITY');
        clsTest.NVL('test');
        clsTest.getObjectNameById('test');
        clsTest.setValueBasedonType('test','TEXT');
        clsTest.PicklistCondition('test','test');
        clsTest.getOperatorSymbol('n','test','TEXT');
        clsTest.removeChild('test');
        clsTest.SaveTemplate();
        clsTest.selectAllMember();
        clsTest.selectAll();
        
        clsTest.SelectedSearch ='CONTACT';
        clsTest.getFieldList();
        
        clsTest.AddNewSearchRow();
        clsTest.AddNewSearchRowExisting();
        clsTest.getNewCampaignMembers();
        clsTest.getStatus();
        clsTest.getSearchType();
        clsTest.SelectSearchType();
        clsTest.getSelectedSearch();
        
        CampaignMember objMem = new CampaignMember();
        objMem.status = 'sent';
        objMem.CampaignId = objCampaign.Id;
        objMem.ContactId = objContact.Id;
        insert objMem;
        clsTest.Go();
        clsTest.selectedStatus = 'sent';
        //clsTest.ConditionOperator();
        clsTest.NextPage();
        clsTest.PreviousPage();
        ContactResult obj = new ContactResult();
        obj.selected = true;
        obj.objContact = objContact1;
        clsTest.lstContactResult.add(obj);
        
        clsTest.addMember();
        
        clsTest.SelectedSearch ='LEAD';
        
        LeadResult obj1 = new LeadResult();
        obj1.selected = true;
        obj1.objLead = objLead;
        clsTest.lstLeadResult.add(obj1);
        
        clsTest.addMember();
        
        clsTest.SelectedSearch ='CONTACT';
        clsTest.Go();
        clsTest.lstContactResult[0].selected = true;
        clsTest.addMember();
        clsTest.SelectedSearch ='LEAD';
        clsTest.Go();
        clsTest.lstLeadResult[0].selected = true;
        clsTest.addMember();
        
        
       
        clsTest.ActiveTab = 'EXISTINGMEMBER';
        clsTest.tabClick();
        clsTest.GoForExistingMember();
        clsTest.selectedStatusExisting = 'sent';
        clsTest.updateStatus();
        clsTest.removeSelected();
        clsTest.removeSingle();
        clsTest.getSelectFields();
        
        try{
            clsTest.CheckFieldType();
        }
        Catch(Exception ex){}
        
        try{
            clsTest.CheckFieldTypeExisting();
        }
        Catch(Exception ex){}
        
        try{
            clsTest.changeExistingView();
        }
        Catch(Exception ex){}
    
        try{
            clsTest.setSelectedSearch('Test');        
        }
        Catch(Exception ex){}

        try{
            clsTest.getLeadResult();        
        }
        Catch(Exception ex){}
        
        try{
            clsTest.getContactResult();
        }
        Catch(Exception ex){}        
        
        try{
            clsTest.getExistingMember();
        }
        Catch(Exception ex){}
    }

}