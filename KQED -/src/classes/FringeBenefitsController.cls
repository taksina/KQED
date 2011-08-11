public with sharing class FringeBenefitsController {

    public String benefits {get; private set;}
    public FringeBenefitsController() {
        String timeInMillis = ApexPages.currentPage().getParameters().get('timestamp');
        
        Date validDate;
        boolean flag;
        if(timeInMillis != null && timeInMillis != ''){
            try {
                validDate = DateTime.newInstance(Long.valueOf(timeInMillis)).date();
               // validDate = DateTime.newInstance(Integer.valueOf(year),Integer.valueOf(month),Integer.valueOf(day)).date();
                system.debug('validDate is '+validDate );
                flag = true;
            } catch(Exception ex) {
                validDate = System.today();
            }
        } else {
            validDate = System.today();
        }
        List<Member_Benefit_Location__c> benefitLocations = new List<Member_Benefit_Location__c>();
        system.debug('validDate is '+validDate);
        if(flag == true){
        benefitLocations =
            [select Location__r.Location_ID__c, Location__r.Name, Location__r.Street__c, Location__r.City__c,Member_Benefit__r.Start_Date__c,    
                Location__r.State__c, Location__r.PostalCode__c, Location__r.Phone__c, 
                Member_Benefit__r.Item_ID__c, Member_Benefit__r.Name, Member_Benefit__r.Offer__c,  
                Member_Benefit__r.Marketing_Copy__c, Member_Benefit__r.Category__c, Member_Benefit__r.Benefit_Link__c,
                Member_Benefit__r.Business_Member_Partner__r.Name, 
                Member_Benefit__r.Business_Member_Partner__r.Industry,
                Member_Benefit__r.Business_Member_Partner__r.Industry_Category__c
                from Member_benefit_Location__c where Member_Benefit__r.LastModifiedDate >= :validDate ];
                
               // Member_Benefit__r.Start_Date__c <= :validDate 
               // and (Member_Benefit__r.End_Date__c = null or Member_Benefit__r.End_Date__c >= :validDate)];
        }
        else {
        benefitLocations = 
            [select Location__r.Location_ID__c, Location__r.Name, Location__r.Street__c, Location__r.City__c,Member_Benefit__r.Start_Date__c,    
                Location__r.State__c, Location__r.PostalCode__c, Location__r.Phone__c, 
                Member_Benefit__r.Item_ID__c, Member_Benefit__r.Name, Member_Benefit__r.Offer__c,  
                Member_Benefit__r.Marketing_Copy__c, Member_Benefit__r.Category__c, Member_Benefit__r.Benefit_Link__c,
                Member_Benefit__r.Business_Member_Partner__r.Name, 
                Member_Benefit__r.Business_Member_Partner__r.Industry,
                Member_Benefit__r.Business_Member_Partner__r.Industry_Category__c
                from Member_benefit_Location__c];
        }
        System.debug('benefitLocations: ' + benefitLocations);
        //benefits = '{"benefits": [';
        benefits = '';
        if ( benefitLocations.size() > 0 ) {
            for ( Member_Benefit_Location__c bl : benefitLocations ) {
            system.debug('start date '+bl.Member_Benefit__r.Start_Date__c );
            System.debug('ItemID: ' + bl.Member_Benefit__r.Item_ID__c != null ? bl.Member_Benefit__r.Item_ID__c : bl.Member_Benefit__c);
            System.debug('LocationID: ' + formatJSONString(bl.Location__r.Location_ID__c != null ? bl.Location__r.Location_ID__c: bl.Location__r.Name));
                benefits += 
                    '\n    {"ItemID": "' + (bl.Member_Benefit__r.Item_ID__c != null ? bl.Member_Benefit__r.Item_ID__c : bl.Member_Benefit__c) + '", ' +
                    '"LocationID": "' + formatJSONString(bl.Location__r.Location_ID__c != null ? bl.Location__r.Location_ID__c: bl.Location__c) + '", ' +
                    '"Name_Display": "' + formatJSONString(bl.Member_Benefit__r.Name) + '", ' +
                    '"Name_Sort": "' + formatJSONString(bl.Member_Benefit__r.Business_Member_Partner__r.Name) + '", ' +
                    '"Address": "' + formatJSONString(bl.Location__r.Street__c) + '", ' +
                    '"City": "' + formatJSONString(bl.Location__r.City__c) + '", ' +
                    '"Country": "' + formatJSONString(bl.Location__r.State__c) + '", ' +
                    '"Zip": "' + formatJSONString(bl.Location__r.PostalCode__c) + '", ' +
                    '"Phone": "' + formatJSONString(bl.Location__r.Phone__c) + '", ' +
                    '"Website_URL": "' + formatJSONString(bl.Member_Benefit__r.Benefit_Link__c) + '", ' +
                    '"Description": "' + formatJSONString(bl.Member_Benefit__r.Marketing_Copy__c) + '", ' +
                    '"Discount_Info": "' + formatJSONString(bl.Member_Benefit__r.Offer__c) + '", ';

                if (bl.Member_Benefit__r.Business_Member_Partner__r.Industry != null && 
                    bl.Member_Benefit__r.Business_Member_Partner__r.Industry.startsWith('Food')) {
                    benefits += 
                        '"Cuisine": "' + formatJSONString(bl.Member_Benefit__r.Business_Member_Partner__r.Industry_Category__c) + '", ';
                }

                String categories = '[';
                if ( bl.Member_Benefit__r.Category__c != null ) {
                    String[] cats = bl.Member_Benefit__r.Category__c.split(';');
                    for (String cat : cats) {
                        categories += '"' + cat + '", ';
                    }
                    categories = categories.substring(0, categories.length() - 2);
                }
                categories += ']';
                benefits += '"Categories": ' + formatJSONString(categories) + '}, ';
            }
            benefits = benefits.substring(0, benefits.length() - 2);
        }
        System.debug('benefits: ' + benefits);
        //benefits = ']';
    }
    private String formatJSONString(String value) {
        return value != null ? value.replaceAll('\n', '\\\\n') : '';
    }
}