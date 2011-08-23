public class ClassificationController {
    
    private Classification__c clazz;
    
    private Map<String, String> tabnames = new Map<String, String> {
        'Benefit' => 'Benefits', 
        'Appeal' => 'Appeals', 
        'Email' => 'Emails', 
        'Clubs' => 'Clubs', 
        'Auto-Renew' => 'Auto Renewal', 
        'Membership Type' => 'Member Type', 
        'Discount' => 'Discount', 
        'Committee' => 'Committee', 
        'Board' => 'WGBH Boards', 
        'MG Prospects' => 'MG Prospect', 
        'National Programming' => 'National Programming', 
        'Data Tagging' => 'Data Tagging', 
        'BBA Scores' => 'BBA Scores', 
        'Misc' => 'Misc'
    };
    
    private ApexPages.StandardController controller;
    private String sObjectType;
    private String recordId;
    
    public ClassificationController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.clazz = (Classification__c) controller.getRecord();
        
        sObjectType = ApexPages.currentPage().getParameters().get('sObjectType');
        recordId = ApexPages.currentPage().getParameters().get('recordId');
        
        if(sObjectType == 'Contact') {
            clazz.Contact__c = recordId;
        }
        else if(sObjectType == 'Account') {
            clazz.Account__c = recordId;
        }
    }
    
    public PageReference presave() {
        /*Classification_Code__c cc = [
            Select c.tab_name__c
            From Classification_Code__c c 
            Where c.classification_code__c = :clazz.classification_code__c AND c.classification_value__c = :clazz.classification_value__c
        ][0];
        clazz.classification_tabname__c = cc.tab_name__c;
        clazz.Classification_Code_Value__c = cc.id;*/
        return this.save();
    }
    
    public PageReference save() {
        controller.save();
        return new PageReference('/'+this.recordId);
    }
    
    public PageReference cancel() {
        controller.cancel();
        return new PageReference('/'+this.recordId);
    }
    
    public List<selectOption> tabnamesPicklist {
        get {
            List<selectOption> options = new List<selectOption>();
                options.add(new SelectOption('','-- Choose a Tab Name --'));
                for (String tabName : this.tabnames.keyset())
                    options.add(new SelectOption(tabName, this.tabNames.get(tabName)));
            return options;
        }
        set;
    }

    public List<selectOption> classificationCodesPicklist {
        get {
            List<selectOption> options = new List<selectOption>();
            if (clazz.classification_tabname__c != NULL) {
                options.add(new SelectOption('','-- Choose a Preference --'));
                /*for (AggregateResult codeValue : [
                        Select c.code_description__c, c.classification_code__c
                        From Classification_Code__c c
                        Where c.tab_name__c = :clazz.classification_tabname__c
                        group by c.classification_code__c, c.code_description__c
                        order by c.code_description__c
                      ])
                    options.add(new SelectOption((String) codeValue.get('classification_code__c'), (String) codeValue.get('code_description__c')));
                */
            }
            return options;           
        }
        set;
    }
    
    public List<selectOption> classificationValuesPicklist {
        get {
            List<selectOption> options = new List<selectOption>();
            /*if (clazz.classification_code__c != NULL) {
                options.add(new SelectOption('','-- Choose a Value --'));
                for (Classification_Code__c codeValue : [
                        Select c.value_description__c, c.code_description__c, c.classification_value__c, c.classification_code__c
                        From Classification_Code__c c 
                        Where c.classification_code__c = :clazz.classification_code__c
                        Order By c.value_description__c
                      ])
                    options.add(new SelectOption(codeValue.classification_value__c, codeValue.value_description__c));
            }*/
            return options;           
        }
        set;
    }
    
    public static testMethod void testBatch() {
        /*Classification_Code__c cc = new Classification_Code__c(
            classification_code__c = 'CODE', 
            code_description__c = 'CODE', 
            classification_value__c = 'VALUE', 
            value_description__c = 'VALUE'
        );
        insert cc;*/
        Contact c = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I'
        );
        insert c;
        Classification__c c1 = new Classification__c(
           ta_classification_id__c = '12345_01_I_CODE_VALUE',
           bulk_load__c = true
        );
        insert c1;
        Account h = new Account(
           Name = 'Mr. & Mrs. Joe Dirt', 
           TaAccountId__c = 12345
        );
        insert h;
        Classification__c c2 = new Classification__c(
           ta_classification_id__c = '12345_00_I_CODE_VALUE',
           bulk_load__c = true
        );
        insert c2;
        Account a = new Account(
           Name = 'Joe Dirt and Co', 
           TaAccountId__c = 123456
        );
        insert a;
        Classification__c c3 = new Classification__c(
           ta_classification_id__c = '12345_00_C_CODE_VALUE',
           bulk_load__c = true
        );
        insert c3;
        
        PageReference ccPage1 = Page.ClassificationNew;
        ApexPages.CurrentPage().getParameters().put('sObjectType', 'Contact');
        ApexPages.CurrentPage().getParameters().put('recordId', c.id);
        
        ClassificationController cc1 = new ClassificationController(new ApexPages.StandardController(c1));
        List<selectOption> cc1codes = cc1.classificationCodesPicklist;
        
        cc1.presave();
        cc1.save();
        cc1.cancel();
        List<selectOption> test = cc1.tabnamesPicklist;
        
        
        /*cc1.controller.getRecord().put('classification_code__c', cc.classification_code__c);
        List<selectOption> cc1values = cc1.classificationValuesPicklist;
        cc1.controller.getRecord().put('classification_value__c', cc.classification_value__c);
        cc1.presave();
        System.AssertEquals(cc1.controller.getRecord().get('Classification_Code_Value__c'), cc.id);
        
        PageReference ccPage2 = Page.ClassificationNew;
        ccPage2.getParameters().put('sObjectType', 'Account');
        ccPage2.getParameters().put('recordId', h.id);
        Test.setCurrentPageReference(ccPage2);
        ClassificationController cc2 = new ClassificationController(new ApexPages.StandardController(c2));
        List<selectOption> cc2codes = cc2.classificationCodesPicklist;
        cc2.controller.getRecord().put('classification_code__c', cc.classification_code__c);
        List<selectOption> cc2values = cc2.classificationValuesPicklist;
        cc2.controller.getRecord().put('classification_value__c', cc.classification_value__c);
        cc2.presave();
        System.AssertEquals(cc2.controller.getRecord().get('Classification_Code_Value__c'), cc.id);
        
        PageReference ccPage3 = Page.ClassificationNew;
        ccPage3.getParameters().put('sObjectType', 'Account');
        ccPage3.getParameters().put('recordId', a.id);
        Test.setCurrentPageReference(ccPage3);
        ClassificationController cc3 = new ClassificationController(new ApexPages.StandardController(c3));
        List<selectOption> cc3codes = cc3.classificationCodesPicklist;
        cc3.controller.getRecord().put('classification_code__c', cc.classification_code__c);
        List<selectOption> cc3values = cc3.classificationValuesPicklist;
        cc3.controller.getRecord().put('classification_value__c', cc.classification_value__c);
        cc3.presave();
        System.AssertEquals(cc3.controller.getRecord().get('Classification_Code_Value__c'), cc.id);
        */
    }
}