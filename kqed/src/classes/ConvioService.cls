public with sharing class ConvioService {
    
    public static final string DONATION_REC_TYPE_ID = '012T00000004lF8';
    public static final string DONATION_INSTALLMENT_REC_TYPE_ID = '012T00000004lF9';
    
    public Contact dummyCont {
        get {
            if ( dummyCont == null ) {dummyCont = new Contact();}
            return dummyCont;
        }
        private set;
    }
    public void testRunConvio() {
        if ( dummyCont != null && dummyCont.Birthdate != null ) {
            processConvioDonationsByDateRange(dummyCont.Birthdate, dummyCont.Birthdate.addDays(1));
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Processing completed.'));
        }
        else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Enter a date.'));
        }
    }
    
    public void testRunProductOrder() {
        if ( dummyCont != null && dummyCont.Birthdate != null ) {
            processConvioPurchaseOrdersByDateRange(dummyCont.Birthdate, dummyCont.Birthdate.addDays(1));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Processing completed.'));
        }
        else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Enter a date.'));
        }
    }

    public void processTodaysConvioProductOrders() {
        processConvioPurchaseOrdersByDateRange(System.today().addDays(-1), System.today());
    }

    @future(callout=true)
    public static void processTodaysConvioProductOrdersAsynch() {
        ConvioService convioServ = new ConvioService();
        convioServ.processConvioPurchaseOrdersByDateRange(System.today().addDays(-1), System.today());
    }

    public void processTodaysConvioDonations() {
        processConvioDonationsByDateRange(System.today().addDays(-1), System.today());
    }

    @future(callout=true)
    public static void processTodaysConvioDonationsAsynch() {
        ConvioService convioServ = new ConvioService();
        convioServ.processConvioDonationsByDateRange(System.today().addDays(-1), System.today());
    }

    public void processConvioDonationsByDateRange(Date startDate, Date endDate) {

        DateTime startDateTime = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day());
        DateTime endDateTime = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day());

        Map<String, List<ConvioObject.Donation>> constituentIdToDonations = new Map<String, List<ConvioObject.Donation>>();
        Map<Integer, String> donationIdToReccurringPaymentId = new Map<Integer, String>();
        Map<Integer, Account> consIdToAccount = new Map<Integer, Account>();
        //Set<Integer> recurringPaymentIds = new Set<Integer>();

        ConvioDAO dao = new ConvioDAO();
        //List<ConvioObject.Donation> donations = dao.getDonationsByModifiedDateRange(startDate, endDate);
        for ( ConvioObject.Donation donation : dao.getDonationsByModifiedDateRange(startDate, endDate) ) {

            // Populate Set of Constituent IDs (using constituentIdToDonations Map)
            List<ConvioObject.Donation> donz = constituentIdToDonations.get(String.valueOf(donation.Donor.consId));
            if ( donz == null ) {
                donz = new List<ConvioObject.Donation>();
                constituentIdToDonations.put(String.valueOf(donation.Donor.consId), donz);
            }
            donz.add(donation);

            // Populate Map of Transaction ID to Original Transaction ID (Recurring_Donation__r.Convio_Transaction_Id__c)
            if ( donation.RecurringPayment != null && donation.RecurringPayment.OriginalTransactionId != null ) {
                donationIdToReccurringPaymentId.put(
                    donation.TransactionId, String.valueOf(donation.RecurringPayment.OriginalTransactionId));
            }
        }

        // Populate Map of ConstituentID to Account
        for ( Account acct : 
                [select Name, alt_account_id__c, (select Id from Contacts) 
                from Account 
                where alt_account_id__c in :constituentIdToDonations.keySet()] ) {
            consIdToAccount.put(Integer.valueOf(acct.alt_account_id__c), acct);
        }

        // Populate Map of OriginalTransactionID (Recurring_Donation__r.Convio_Transaction_Id__c) to Recurring_Donation__c record
        Map<Integer, Opportunity> convioRecurringPayment = new Map<Integer, Opportunity>();
        for ( Opportunity rd : 
                [select alt_transaction_id__c, 
                    (select Id from Giving_Installments__r where StageName = 'Pledged' order by CloseDate limit 1) 
                from Opportunity 
                where alt_transaction_id__c in :donationIdToReccurringPaymentId.values()] ) {
            convioRecurringPayment.put(Integer.valueOf(rd.alt_transaction_id__c), rd);
        }

        Map<Integer, SfdcConstituent> sfdcConstituents = new Map<Integer, SfdcConstituent>();
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();

        Set<Integer> processedRecurringDonationIds = new Set<Integer>();
        List<Opportunity> recurringDonations = new List<Opportunity>();
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Opportunity> updatableOpportunities = new List<Opportunity>();
        List<Opportunity> pledgedOpportunities = new List<Opportunity>();
        Map<Integer, List<Opportunity>> newRecurringPaymentIdToOpportunities = new Map<Integer, List<Opportunity>>();

        //List<TaPayment__c> payments = new List<TaPayment__c>();
        //List<SfdcConstituent> newConstituents = new List<SfdcConstituent>();

        // Iterate over constituentIdToDonations map to create new SFDC Accounts and Contacts
        for ( String consId : constituentIdToDonations.keySet() ) {

            List<ConvioObject.Donation> donations = constituentIdToDonations.get(String.valueOf(consId));

            // If Constituent doesn't already exist, create a new one (Account + Contact)
            Account acct = consIdToAccount.get(Integer.valueOf(consId));
            SfdcConstituent constituent;
            if ( acct == null ) {
                constituent = new SfdcConstituent(donations[0].Donor);
                accounts.add(constituent.acct);
                contacts.add(constituent.cont);
                //newConstituents.add(constituent);
            }
            else {
                constituent = new SfdcConstituent(acct, acct.Contacts.size() > 0 ? acct.Contacts[0] : null);
            }
            sfdcConstituents.put(Integer.valueOf(consId), constituent);
        }

        System.debug('accounts: ' + accounts);
        //LRT//upsert accounts alt_account_id__c; 
        System.debug('accounts: ' + accounts);

        System.debug('contacts: ' + contacts);
        upsert contacts;
        System.debug('contacts: ' + contacts);

        // Iterate over constituentIdToDonations map to transfer Donations to SFDC
        for ( String consId : constituentIdToDonations.keySet() ) {

            SfdcConstituent constituent = sfdcConstituents.get(Integer.valueOf(consId));
            List<ConvioObject.Donation> donations = constituentIdToDonations.get(consId);
            // Iterate over all Donations for this Constituent
            for ( ConvioObject.Donation donation : donations ) {

                //System.debug('donation: ' + donation);
                // If Recurring Payment
                if (donation.RecurringPayment != null) {

                    ConvioObject.RecurringPayment rp = donation.RecurringPayment;
                    // If NEW Recurring Donation AND NOT already processed in this run
                    if ( //rp.Frequency != null && rp.Frequencey > 1 &&
                        !processedRecurringDonationIds.contains(rp.OriginalTransactionId) && 
                        !convioRecurringPayment.keySet().contains(rp.OriginalTransactionId)) {

                        String interactionSource = donation.InteractionSource != null ? donation.InteractionSource.CodeText : 'INTERNET';

                        // Create Recurring_Donation__c record
                        Opportunity rd = 
                            new Opportunity(
                                alt_transaction_id__c = String.valueOf(rp.OriginalTransactionId),
                                //gift_date__c = ????????,
                                source__c = interactionSource,
                                payment_frequency__c = String.valueOf(rp.Frequency),
                                pledge_number__c = String.valueOf(rp.OriginalTransactionId + 80000000),
                                Amount = donation.Payment.Amount,
                                RecordTypeId = DONATION_REC_TYPE_ID,
                                CloseDate = donation.Payment.PaymentDate.date(),
                                StageName = 'Partial Close');

                        if(donation.Recognition != null) {
                            if ( donation.Recognition.IsAnonymous == 'true' || donation.Recognition.IsAnonymous == '1' ) {
                                rd.Anonymous__c = true;
                            }
                            
                            
                            rd.Recipient_First_Name__c = donation.Recognition.TributeFirstName;
                            rd.Recipient_Last_Name__c = donation.Recognition.TributeLastName;
                            
                            if(donation.Recognition.SenderAddress != null) { 
                                //rd.Recipient_Apartment_Number__c = donation.Recognition.SenderAddress.;
                                rd.Recipient_City__c = donation.Recognition.SenderAddress.City;
                                rd.Recipient_Country__c = donation.Recognition.SenderAddress.Country;
                                rd.Recipient_Extra_Line__c = donation.Recognition.SenderAddress.Street2;
                                rd.Recipient_State__c = donation.Recognition.SenderAddress.State;
                                rd.Recipient_Street_Name__c = donation.Recognition.SenderAddress.Street1;
                                rd.Recipient_Street_Number__c = donation.Recognition.SenderAddress.Street3;
                                rd.Recipient_Zip_Code__c = donation.Recognition.SenderAddress.Zip;
                            }
                        }
                        
                        if ( constituent.acct.Id != null ) {
                            rd.AccountId = constituent.acct.Id;
                            rd.Name = constituent.acct.Name + ' Donations ' + donation.Payment.PaymentDate.date().format();
                        }
                        if ( constituent.cont != null && constituent.cont.Id != null ) {
                            rd.Oppty_Related_Contact__c = constituent.cont.Id;
                        }

                        //Integer numberOfInstallments = 1;
                        rd.Installments__c = 1;
                        // If SUSTAINING, then create 12 monthly installments
                        if ( rp.Type_x == 'SUSTAINING' ) {
                            rd.gift_kind__c = 'Sustaining Gift';
                            rd.Installment_Period__c = 'Monthly';
                            rd.Installments__c = 12;
                        }
                        // ELSE, calculate number of installments
                        else {
                            rd.gift_kind__c = 'Installment';
                            rd.Installment_Period__c = 'Installment Schedule';
                            if ( rp.duration != null && rp.duration != 0 ) {
                                rd.Installments__c = rp.duration / rp.Frequency;
                            }
                        }

                        recurringDonations.add(rd);
                        processedRecurringDonationIds.add(rp.OriginalTransactionId);

                        List<Opportunity> recurringDonationOpptys = new List<Opportunity>();
                        // Create an Opportunity for each Installment
                        for (Integer i = 0; i < rd.Installments__c; i++ ) {
                            Opportunity oppty = 
                                new Opportunity(
                                    Amount = donation.Payment.Amount,
                                    RecordTypeId = DONATION_INSTALLMENT_REC_TYPE_ID,
                                    Recurring_Donation_Opportunity__r = 
                                        new Opportunity(
                                            alt_transaction_id__c = String.valueOf(rp.OriginalTransactionId)));

                            if ( i == 0 ) {
                                oppty.alt_transaction_id__c = String.valueOf(donation.TransactionId) + '-1';
                                oppty.StageName = 'Partial Close';
                                oppty.CloseDate = donation.Payment.PaymentDate.date();
                                opportunities.add(oppty);
                                //recurringDonationOpptys.add(oppty);
                            }
                            else {
                                oppty.StageName = 'Pledged';
                                oppty.CloseDate = donation.Payment.PaymentDate.addMonths(i).date();
                                recurringDonationOpptys.add(oppty);
                            }
                            oppty.Name = 
                                constituent.acct.Name + ' Donation (' + (i + 1) + ' of ' + 
                                rd.Installments__c + ') ' + oppty.CloseDate.format();

                            setOpptyAccountContact(constituent, oppty);
                        }
                        newRecurringPaymentIdToOpportunities.put(rp.OriginalTransactionId, recurringDonationOpptys);
                        pledgedOpportunities.addAll(recurringDonationOpptys);
                        System.debug('recurringDonationOpptys: ' + recurringDonationOpptys);
                    }
                    // ELSE IF: NEW Recurring Donation AND already processed in this run
                    else if (processedRecurringDonationIds.contains(rp.OriginalTransactionId) && 
                        !convioRecurringPayment.keySet().contains(rp.OriginalTransactionId)) {

                        // Fetch child Opportunities created for this Recurring_Donation__c
                        List<Opportunity> recurringDonationOpptys = 
                            newRecurringPaymentIdToOpportunities.get(rp.OriginalTransactionId);
                        //System.debug('recurringDonationOpptys: ' + recurringDonationOpptys);
                        // Iterate over child Opportunities to find the next open Opportunity
                        for ( Opportunity oppty : recurringDonationOpptys ) {
                            // If this is an open Opportunity, track payment to it
                            if ( oppty.StageName == 'Pledged' ) {
                                oppty.alt_transaction_id__c = String.valueOf(donation.TransactionId);
                                oppty.Amount = donation.Payment.Amount;
                                oppty.StageName = 'Partial Close';
                                oppty.CloseDate = donation.Payment.PaymentDate.date();
                                oppty.RecordTypeId = DONATION_REC_TYPE_ID;
                                break;
                            }
                        }
                    }
                    // ELSE IF: Payment on existing Recurring_Donation__c
                    else if ( convioRecurringPayment.keySet().contains(rp.OriginalTransactionId) ) {

                        Opportunity rd = convioRecurringPayment.get(rp.OriginalTransactionId);
                        List<Opportunity> opptys = rd.Giving_Installments__r;
                        System.debug('opptys: ' + opptys);

                        // If there is an open Opportunity under this Recurring_Donation__c, then
                        // track this payment to that Opportunity
                        if ( opptys.size() == 1 ) {
                            opptys[0].alt_transaction_id__c = String.valueOf(donation.TransactionId);
                            opptys[0].Amount = donation.Payment.Amount;
                            opptys[0].CloseDate = donation.Payment.PaymentDate.date();
                            opptys[0].StageName = 'Partial Close';
                            opptys[0].RecordTypeId = DONATION_REC_TYPE_ID;
                            updatableOpportunities.add(opptys[0]);
                            
                            //System.debug('opptys[0]: ' + opptys[0]);
                        }
                        // ELSE: NO open Opportunity found under this Recurring_Donation__c, then
                        // track this payment to a NEW Opportunity
                        else {
                            Opportunity oppty = 
                                new Opportunity(
                                    alt_transaction_id__c = String.valueOf(donation.TransactionId) + '-1',
                                    Name = constituent.acct.Name + ' Donation ' + donation.Payment.PaymentDate.date().format(),
                                    Amount = donation.Payment.Amount,
                                    CloseDate = donation.Payment.PaymentDate.date(),
                                    StageName = 'Partial Close',
                                    RecordTypeId = DONATION_REC_TYPE_ID,
                                    Recurring_Donation_Opportunity__c = rd.Id);
                            opportunities.add(oppty);
                            System.debug('oppty: ' + oppty);
                        }
                    } // EOF: Payment on existing Recurring_Donation__c
                } // EOF: Donation.RecurringPayment
                // ELSE: One-time Payment/Donation
                else {
                    Opportunity oppty = 
                        new Opportunity(
                            alt_transaction_id__c = String.valueOf(donation.TransactionId),
                            Name = constituent.acct.Name + ' Donation ' + donation.Payment.PaymentDate.date().format(),
                            Amount = donation.Payment.Amount,
                            CloseDate = donation.Payment.PaymentDate.date(),
                            StageName = 'Closed Won',
                            RecordTypeId = DONATION_REC_TYPE_ID);
                            
                    if(donation.Recognition != null) {
                        if ( donation.Recognition.IsAnonymous == 'true' || donation.Recognition.IsAnonymous == '1' ) {
                            oppty.Anonymous__c = true;
                        }
                        
                        
                        oppty.Recipient_First_Name__c = donation.Recognition.TributeFirstName;
                        oppty.Recipient_Last_Name__c = donation.Recognition.TributeLastName;
                        
                        if(donation.Recognition.SenderAddress != null) { 
                            //rd.Recipient_Apartment_Number__c = donation.Recognition.SenderAddress.;
                            oppty.Recipient_City__c = donation.Recognition.SenderAddress.City;
                            oppty.Recipient_Country__c = donation.Recognition.SenderAddress.Country;
                            oppty.Recipient_Extra_Line__c = donation.Recognition.SenderAddress.Street2;
                            oppty.Recipient_State__c = donation.Recognition.SenderAddress.State;
                            oppty.Recipient_Street_Name__c = donation.Recognition.SenderAddress.Street1;
                            oppty.Recipient_Street_Number__c = donation.Recognition.SenderAddress.Street3;
                            oppty.Recipient_Zip_Code__c = donation.Recognition.SenderAddress.Zip;
                        }
                    }   

                    setOpptyAccountContact(constituent, oppty);
                    
                    opportunities.add(oppty);
                    System.debug('oppty: ' + oppty);
                }
            } // EOF: Constituent Donations
        } // EOF: Constituents

        System.debug('recurringDonations: ' + recurringDonations);
        upsert recurringDonations alt_transaction_id__c;
        //System.debug('recurringDonations: ' + recurringDonations);

        System.debug('opportunities: ' + opportunities);
        upsert opportunities alt_transaction_id__c;
        System.debug('opportunities: ' + opportunities);

        System.debug('pledgedOpportunities: ' + pledgedOpportunities);
        insert pledgedOpportunities;
        System.debug('pledgedOpportunities: ' + pledgedOpportunities);

        System.debug('updatableOpportunities: ' + updatableOpportunities);
        update updatableOpportunities;
        System.debug('updatableOpportunities: ' + updatableOpportunities);
        
        List<Opportunity> pldgedOpp = [select Id, Name, CloseDate from Opportunity where Recurring_Donation_Opportunity__c != null and CloseDate = :startDate and StageName = 'Pledged'];
        System.debug('------ pldgedOpp:' + pldgedOpp);
        
        List<Convio_Error__c> errors = new List<Convio_Error__c>();
        for(Opportunity opp : pldgedOpp) {
            errors.add(new Convio_Error__c(Name = 'Error on: ' + String.valueOf(opp.CloseDate), Opportunity__c = opp.Id));
        }
        System.debug('------ errors:' + errors);
        insert errors;
        System.debug('------ errors:' + errors);
    }

    public void processConvioPurchaseOrdersByDateRange(Date startDate, Date endDate) {

        DateTime startDateTime = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day());
        DateTime endDateTime = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day());

        //Map<String, List<ConvioObject.ProductOrder>> constituentIdToProductOrders = new Map<String, List<ConvioObject.ProductOrder>>();
        Map<Integer, Account> consIdToAccount = new Map<Integer, Account>();
        Set<String> consIds = new Set<String>();
        ConvioDAO dao = new ConvioDAO();
        List<Integer> productIds = new List<Integer>();
        
        List<ConvioObject.ProductOrder> orders = dao.getProductOrdersByModifiedDateRange(startDate, endDate);
        for ( ConvioObject.ProductOrder prodOrder : orders ) {
            for(ConvioObject.ShipTo shipTo : prodOrder.ShipTo) {
                for (ConvioObject.Item item : shipTo.Item) {
                    productIds.add(item.ProductId); 
                }
            }
            
            consIds.add(String.valueOf(prodOrder.Purchaser.ConsId));
        }
        
        Map<Integer, String> productsMap = new Map<Integer, String>();
        List<ConvioObject.Product> products = dao.getProductsByProductIds(productIds);
        for(ConvioObject.Product product : products) {
            productsMap.put(product.productId, product.Title);
        }

        // Populate Map of ConstituentID to Account
        for ( Account acct : 
                [select Name, alt_account_id__c, (select Id from Contacts) 
                from Account 
                where alt_account_id__c in :consIds] ) {
            consIdToAccount.put(Integer.valueOf(acct.alt_account_id__c), acct);
        }

        Map<Integer, SfdcConstituent> sfdcConstituents = new Map<Integer, SfdcConstituent>();
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();

        // Iterate over orders to create new SFDC Accounts and Contacts
        for ( ConvioObject.ProductOrder prodOrder : orders ) {
            Integer consId = prodOrder.Purchaser.ConsId;
            Account acct = consIdToAccount.get(consId);
            SfdcConstituent constituent;
            if ( acct == null ) {
                constituent = new SfdcConstituent(prodOrder.Purchaser); 
                accounts.add(constituent.acct);
                contacts.add(constituent.cont);
            } else {
                constituent = new SfdcConstituent(acct, acct.Contacts.size() > 0 ? acct.Contacts[0] : null);
            }
            sfdcConstituents.put(consId, constituent);
        }

        System.debug('accounts: ' + accounts);
        //LRT//upsert accounts alt_account_id__c;
        System.debug('accounts: ' + accounts);

        System.debug('contacts: ' + contacts);
        upsert contacts;
        System.debug('contacts: ' + contacts);
        
        List<Convio_Product_Order__c> sfOrders = new List<Convio_Product_Order__c>();
        List<Convio_Product_Order_Item__c> sfOrderItems = new List<Convio_Product_Order_Item__c>();
        
        for ( ConvioObject.ProductOrder prodOrder : orders ) {
            Convio_Product_Order__c sfOrder = new Convio_Product_Order__c();
            SfdcConstituent constituent = sfdcConstituents.get(prodOrder.Purchaser.ConsId);
            
            if(constituent != null && constituent.acct != null ) {
                sfOrder.Account__c = constituent.acct.Id;
            }
            
            sfOrder.Convio_Transaction_ID__c = String.valueOf(prodOrder.TransactionId);
            sfOrder.Purchase_Amount__c = prodOrder.PurchaseAmount;
            sfOrder.Name = 'Order ID: ' + prodOrder.OrderId;
            
            sfOrders.add(sfOrder);
            //prodOrder.TransactionId
            
            if(prodOrder.ShipTo != null) {
                for(ConvioObject.ShipTo shipTo : prodOrder.ShipTo) {
                    if(shipTo.Item != null) {
                        Integer count = 1;
                        for (ConvioObject.Item item : shipTo.Item) {
                            Convio_Product_Order_Item__c sfOrderItem = new Convio_Product_Order_Item__c();
                            sfOrderItem.Convio_Product_Order__r = new Convio_Product_Order__c(Convio_Transaction_ID__c = String.valueOf(prodOrder.TransactionId));
                            sfOrderItem.Ship_To_City__c = shipTo.City;
                            sfOrderItem.Ship_To_Country__c = shipTo.Country;
                            sfOrderItem.Ship_To_First_Name__c = shipTo.FirstName;
                            sfOrderItem.Ship_To_Last_Name__c = shipTo.LastName;
                            sfOrderItem.Ship_To_State__c = shipTo.Stateprov;
                            sfOrderItem.Ship_To_Street_Number__c = shipTo.Street1;
                            sfOrderItem.Ship_To_Street_Name__c = shipTo.Street2;
                            
                            if(item.Config != null && item.Config.size() > 0) {
                                sfOrderItem.Product_Option_Value__c = item.Config[0].Value;
                                sfOrderItem.Product_Option__c = item.Config[0].ConfigId;
                            }
                            
                            String title = productsMap.get(item.ProductId);
                            if(title != null) {
                                sfOrderItem.Product_Internal_Name__c = title;
                            }
                            
                            sfOrderItem.Convio_Transaction_ID__c = String.valueOf(prodOrder.TransactionId) + '-' + String.valueOf(count);
                            sfOrderItems.add(sfOrderItem);  
                            count ++;
                        }
                    }
                }
            }
        }
        
        System.debug('------ sfOrders: ' + sfOrders);
        upsert sfOrders Convio_Transaction_ID__c;
        
        System.debug('------ sfOrderItems: ' + sfOrderItems);
        upsert sfOrderItems Convio_Transaction_ID__c;
    }

    private void setOpptyAccountContact(SfdcConstituent constituent, Opportunity oppty) {

        if ( constituent.acct.Id != null ) {
            oppty.AccountId = constituent.acct.Id;
        }
        if ( constituent.cont != null && constituent.cont.Id != null ) {
            oppty.Oppty_Related_Contact__c = constituent.cont.Id;
        }

        /*
        if ( constituent.acct.Id != null ) {
            oppty.AccountId = constituent.acct.Id;
        }
        else {
            oppty.Account = new Account(aTaAccountId__c = constituent.acct.aTaAccountId__c);
        }

        if ( constituent.cont != null && constituent.cont.Id != null ) {
            oppty.Oppty_Related_Contact__c = constituent.cont.Id;
        }
        */
        /*
        else {
            rd.Contact__r = new Account(aTaAccountId__c = constituent.acct.aTaAccountId__c);
        }
        */
    }

    public class SfdcConstituent {

        public Account acct {get; private set;}
        public Contact cont {get; private set;}
        public SfdcConstituent(Account a, Contact c) {
            this.acct = a;
            this.cont = c;
        }

        public SfdcConstituent(ConvioObject.Constituent cons) {

            ConvioObject.Name consName = cons.ConsName;
            String fullName = '';
            if ( consName != null && consName.Title != null && consName.Title != '' ) {
                fullName += consName.Title + ' ';
            }
            if ( consName != null && consName.FirstName != null && consName.FirstName != '' ) {
                fullName += consName.FirstName + ' ';
            }
            if ( consName != null && consName.LastName != null && consName.LastName != '' ) {
                fullName += consName.LastName + ' ';
            }
            fullName = fullName.trim();

            this.acct = new Account(Name = fullName, alt_account_id__c = String.valueOf(cons.ConsId));
            this.cont = 
                new Contact(
                    Account = new Account(alt_account_id__c = String.valueOf(cons.ConsId)), Title = consName.Title, 
                    FirstName = consName.FirstName, LastName = consName.LastName,
                    Email = cons.PrimaryEmail /* OTHER FIELDS */); 
        }
    }
}