public class SalutationController {
    
    private Salutation__c clazz;
    
    private Map<String, String> salutationCodes = null;
    
    private ApexPages.StandardController controller;
    private String sObjectType;
    private String recordId;
    
    public SalutationController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.clazz = (Salutation__c) controller.getRecord();
        
        sObjectType = ApexPages.currentPage().getParameters().get('sObjectType');
        recordId = ApexPages.currentPage().getParameters().get('recordId');
        
        if(sObjectType == 'Contact') {
            clazz.Contact__c = recordId;
        }
        else if(sObjectType == 'Account') {
            clazz.Account__c = recordId;
        }
        else if(sObjectType == 'Account') {
            clazz.Household__c = recordId;
        }
        
        this.salutationCodes = new Map<String, String>();
        List<Salutation_Code__c> scs = [SELECT name, description__c FROM Salutation_Code__c order by description__c];
        // example: name=\D &&&& description=Default 
        for(Salutation_Code__c sc : scs) {
            this.salutationCodes.put(sc.description__c, sc.name);
        }
        
        if(clazz.Name == null || clazz.Name.length() <= 0) {
            List<Salutation__c> sampleSalutationList = new List<Salutation__c>();
            if(sObjectType == 'Contact') {
                sampleSalutationList = [SELECT id, name, salutation_code__c, inside_salutation_1__c, salutation_line_1__c, salutation_line_2__c, salutation_line_3__c
                                    FROM Salutation__c
                                    WHERE Contact__c = :recordId AND Name = 'Default'];
            }
            else if(sObjectType == 'Account') {
                sampleSalutationList = [SELECT id, name, salutation_code__c, inside_salutation_1__c, salutation_line_1__c, salutation_line_2__c, salutation_line_3__c
                                    FROM Salutation__c
                                    WHERE Account__c = :recordId AND Name = 'Default'];
            }
            else if(sObjectType == 'Account') {
                sampleSalutationList = [SELECT id, name, salutation_code__c, inside_salutation_1__c, salutation_line_1__c, salutation_line_2__c, salutation_line_3__c
                                    FROM Salutation__c
                                    WHERE Household__c = :recordId AND Name = 'Default'];
            }
            if(sampleSalutationList.size() > 0) {
                Salutation__c sampleSalutation = sampleSalutationList[0];
                //clazz.Name = sampleSalutation.Name;
                //clazz.salutation_code__c = sampleSalutation.salutation_code__c;
                clazz.inside_salutation_1__c = sampleSalutation.inside_salutation_1__c;
                clazz.salutation_line_1__c = sampleSalutation.salutation_line_1__c;
                clazz.salutation_line_2__c = sampleSalutation.salutation_line_2__c;
                clazz.salutation_line_3__c = sampleSalutation.salutation_line_3__c;
            }
        }
    }
    
    public PageReference presave() {
        clazz.salutation_code__c = this.salutationCodes.get(this.clazz.Name);
        System.debug('Saving sal: '+clazz);
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
    
    public List<selectOption> salutationsPicklist {
        get {
            List<String> salutationsList = new List<String>();
            for (String salutationCode : this.salutationCodes.keyset())
                salutationsList.add(salutationCode);
            //salutationsList.sort();
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('','-- Choose a Salutation --'));
            for (String salutationCode : this.salutationCodes.keyset())
                options.add(new SelectOption(salutationCode, salutationCode));
            return options;
        }
        set;
    }

    public static testMethod void testBatch() {
        Salutation_Code__c sc = new Salutation_Code__c(
            name = 'Default',
            description__c = '/D' 
        );
        insert sc;
        Contact c = new Contact(
            FirstName = 'Joe', 
            LastName = 'Dirt', 
            TaContactId__c = '12345_01_I'
        );
        insert c;
        Salutation__c s1 = new Salutation__c(
            contact__c = c.id, 
            name = 'Default', 
            salutation_code__c = '/D', 
            TA_Salutations_Id__c = '12345_01_I_/D',
            bulk_load__c = true
        );
        insert s1;
        Account h = new Account(
            Name = 'Mr. & Mrs. Joe Dirt', 
            TaAccountId__c = 12345
        );
        insert h;
        Salutation__c s2 = new Salutation__c(
            household__c = h.id, 
            name = 'Default', 
            salutation_code__c = '/D', 
            TA_Salutations_Id__c = '12345_00_I_/D',
            bulk_load__c = true
        );
        insert s2;
        Account a = new Account(
            Name = 'Joe Dirt and Co', 
            TaAccountId__c = 123456
        );
        insert a;
        Salutation__c s3 = new Salutation__c(
            account__c = a.id, 
            name = 'Default', 
            salutation_code__c = '/D', 
            TA_Salutations_Id__c = '12345_00_C_/D',
            bulk_load__c = true
        );
        insert s3;
        
        PageReference sPage1 = Page.SalutationNew;
        sPage1.getParameters().put('sObjectType', 'Contact');
        sPage1.getParameters().put('recordId', c.id);
        Test.setCurrentPageReference(sPage1);
        SalutationController sc1 = new SalutationController(new ApexPages.StandardController(s1));
        List<selectOption> sc1Codes = sc1.salutationsPicklist;
        sc1.controller.getRecord().put('name', sc.description__c);
        sc1.presave();
        System.AssertEquals(sc1.controller.getRecord().get('salutation_code__c'), sc.name);
        
        /*PageReference sPage2 = Page.ClassificationNew;
        sPage2.getParameters().put('sObjectType', 'Account');
        sPage2.getParameters().put('recordId', h.id);
        Test.setCurrentPageReference(sPage2);
        SalutationController sc2 = new SalutationController(new ApexPages.StandardController(s2));
        List<selectOption> sc2Codes = sc2.salutationsPicklist;
        sc2.controller.getRecord().put('name', sc.description__c);
        sc2.presave();
        System.AssertEquals(sc2.controller.getRecord().get('salutation_code__c'), sc.name);
        
        PageReference sPage3 = Page.ClassificationNew;
        sPage3.getParameters().put('sObjectType', 'Account');
        sPage3.getParameters().put('recordId', a.id);
        Test.setCurrentPageReference(sPage3);
        SalutationController sc3 = new SalutationController(new ApexPages.StandardController(s3));
        List<selectOption> sc3Codes = sc3.salutationsPicklist;
        sc3.controller.getRecord().put('name', sc.description__c);
        sc3.presave();
        System.AssertEquals(sc3.controller.getRecord().get('salutation_code__c'), sc.name);*/
    }
}