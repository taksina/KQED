Public Class CampaignSourceCode {
    Public string Char1_2_3(Campaign c) {
        String strReturn = '---';
        
        if (c.Station__c == 'WGBH') strReturn = 'GBH';
        if (c.Station__c == 'WGBY') strReturn = 'GBY';
        if (c.Station__c == 'WCAI') strReturn = 'CAI';
        if (c.Station__c == 'KCRW') strReturn = 'CRW';
        if (c.Station__c == 'ACADEMY OF MUSIC') strReturn = 'AOM';
        if (c.Station__c == 'CLASSICAL RADIO') strReturn = 'GBH';
        
        return strReturn;
    }
    
    Public string Char4(Campaign c) {
        String strReturn = '-';
        if(c.Product_Program__c == 'MEMBERSHIP') {
            if(c.Campaign_Name__c == 'ANNUAL') strReturn = 'A';
            if(c.Campaign_Name__c == 'EVENTS') strReturn = 'E';
            if(c.Campaign_Name__c == 'MATCHING GIFT') strReturn = 'G';
            if(c.Campaign_Name__c == 'IN KIND') strReturn = 'K';
            if(c.Campaign_Name__c == 'SALES') strReturn = 'S';
            if(c.Campaign_Name__c == 'VOLUNTEER') strReturn = 'V';
        }
        else {
            if(c.Product_Program__c == 'MAJOR GIFT') strReturn = 'M';
            if(c.Product_Program__c == 'AUCTION') strReturn = 'D';
            if(c.Product_Program__c == 'CULTIVATION') strReturn = 'C';
            if(c.Product_Program__c == 'STEWARDSHIP') strReturn = 'C';
            if(c.Product_Program__c == 'ONLINE') strReturn = 'O';
            if(c.Product_Program__c == 'UNDERWRITING') strReturn = 'U';
            if(c.Product_Program__c == 'SURVEY') strReturn = 'P';
        }
        
        return strReturn;
    }

    Public string Char5(Campaign c) {
        String strReturn = '-';
        
        if(c.Product_Program__c == 'MAJOR GIFT') {
            if(c.Campaign_Name__c == 'BUILDING') strReturn = 'B';
            if(c.Campaign_Name__c == 'CAPITAL') strReturn = 'C';
            if(c.Campaign_Name__c == 'EVENTS') strReturn = 'E';
            if(c.Campaign_Name__c == 'FOUNDATION DEVELOPMENT') strReturn = 'F';
            if(c.Campaign_Name__c == 'PLANNED GIVING') strReturn = 'P';
            if(c.Campaign_Name__c == 'RESTRICTED GIVING') strReturn = 'R';
            
        }
        else if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c=='ANNUAL' && !(c.Channel_Technique__c =='WEB' && c.Channel_Technique__c =='TELESALES')) {
            if(c.Giving_Segment__c == 'RALPH LOWELL SOCIETY') strReturn = 'D';
            if(c.Giving_Segment__c == 'MURROW SOCIETY') strReturn = 'D';
            if(c.Giving_Segment__c == 'LEADERSHIP') strReturn = 'Q';
            if(c.Giving_Segment__c == 'MID LEVEL') strReturn = 'I';
            if(c.Giving_Segment__c == 'MEMBERSHIP') strReturn = 'M';
            if(c.Giving_Segment__c == 'ON-AIR PLEDGE') strReturn = 'O';
            if(c.Giving_Segment__c == 'SUSTAINER') strReturn = 'S';
            if(c.Giving_Segment__c == 'VEHICLE DONATION') strReturn = 'V';
        }
        
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c == 'IN KIND') strReturn = 'B';
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c == 'MATCHING') strReturn = 'G';
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c == 'EVENTS') strReturn = 'E';
        if(c.Product_Program__c == 'AUCTION' && c.Campaign_Name__c == 'SALES') strReturn = 'S';
        
        
        if(c.Product_Program__c == 'AUCTION' && c.Campaign_Name__c == 'INKIND') strReturn = 'D';
        if(c.Product_Program__c == 'AUCTION' && c.Campaign_Name__c == 'AUCTION') strReturn = 'B';
        if(c.Product_Program__c == 'AUCTION' && c.Campaign_Name__c == 'VOLUNTEER') strReturn = 'V';
        
        
        
        
        if(c.Product_Program__c == 'UNDERWRITING' && c.Campaign_Name__c == 'SALES') strReturn = 'S';
        
        
        
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c == 'ANNUAL' && c.Channel_Technique__c == 'WEB') strReturn = 'W';
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c == 'ANNUAL' && c.Channel_Technique__c == 'TELESALES' && c.Sub_Channel__c == 'INBOUND') strReturn = 'C';        
        
        if(strReturn=='-') strReturn = 'U';
        return strReturn;
    }
    
    Public string Char6(Campaign c) {
        String strReturn = '-';
        
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c=='ANNUAL' && c.Giving_Segment__c <> 'ON-AIR PLEDGE') {
            if(c.Solicitation_Type__c == 'ACQUISITION') strReturn = 'Q';
            if(c.Solicitation_Type__c == 'ADD GIFT') strReturn = 'A';
            if(c.Solicitation_Type__c == 'LAPSED') strReturn = 'L';
            if(c.Solicitation_Type__c == 'REJOIN') strReturn = 'L';
            if(c.Solicitation_Type__c == 'RENEWAL') strReturn = 'R';
            if(c.Solicitation_Type__c == 'UPGRADE') strReturn = 'U';
        }
        
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c=='ANNUAL' && c.Giving_Segment__c == 'ON-AIR PLEDGE') {
            if(c.Channel_Technique__c == 'TV') {
                if(c.Sub_Channel__c == '2') strReturn = '2';
                if(c.Sub_Channel__c == '44') strReturn = '4';
                if(c.Sub_Channel__c == 'KIDS') strReturn = 'K';
                if(c.Sub_Channel__c == 'WORLD') strReturn = 'W';
                if(c.Sub_Channel__c == 'CREATE') strReturn = 'D';
                if(c.Sub_Channel__c == '57') strReturn = 'P';
            
            }
            if(c.Channel_Technique__c == 'RADIO') {
                if(c.Sub_Channel__c == 'WCAI') strReturn = '9';
                if(c.Sub_Channel__c == '89.7') strReturn = 'F';
                if(c.Sub_Channel__c == '99.5') strReturn = 'C';            
            }            
        }
        if(c.Product_Program__c == 'AUCTION') strReturn = 'A';

        if(c.Product_Program__c == 'UNDERWRITING' && c.Giving_Segment__c == 'LOCAL') strReturn = 'L';
        if(c.Product_Program__c == 'UNDERWRITING' && c.Giving_Segment__c == 'NATIONAL') strReturn = 'N';


        if(strReturn == '-') strReturn = 'G';
        
        return strReturn;
    }
    
    Public string Char7_8_9_10(Campaign c) {
        String strReturn = '----';
        if(c.Start_Time_Date__c!=null) {
            string strYY = string.valueOf(c.Start_Time_Date__c.Year());
            strYY = strYY.substring(strYY.length()-2,strYY.length());
    
            string strMM = string.valueOf(c.Start_Time_Date__c.Month());
            
            if(strMM.length()==1) strMM = '0' + strMM;
            
            strReturn = strYY + strMM;           
            
        }
        return strReturn;
    }
    Public string Char11_12(Campaign c) {
        String strReturn = '--';
        
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c=='ANNUAL' && c.Giving_Segment__c <> 'ON-AIR PLEDGE' && c.Effort_for_Project__c!=null) {
            if (c.Effort_for_Project__c.length()==1 && c.Effort_for_Project__c!='0') {
                strReturn = '0' + c.Effort_for_Project__c;
            }
            else {
                strReturn = c.Effort_for_Project__c;
            }
        }
        if(c.Product_Program__c == 'MEMBERSHIP' && c.Campaign_Name__c=='ANNUAL' && c.Giving_Segment__c == 'ON-AIR PLEDGE') {
            strReturn = string.ValueOf(c.Start_Time_Date__c.Day());
            if(strReturn.length()==1) strReturn = '0' + strReturn;
        }
        
        if(strReturn=='--' || strReturn=='') strReturn = '01';
        
        return strReturn;
    }
    Public string Char13_14_15(Campaign c) {
        String strReturn = '---';
 
        if(c.ParentID==null) {
            strReturn = '000';
        }
        else {
            strReturn = c.Program_Count__c;
        }
        if(strReturn == null || strReturn == '' || strReturn == '---'){
            strReturn = '000';
        }
        return strReturn;    
    }

    static testMethod void myTest() {
        CampaignSourceCode clsTest = new CampaignSourceCode();
        Campaign c = new Campaign(name='test');
        c.Station__c = 'WGBH';
        c.Product_Program__c = 'MEMBERSHIP';
        c.Campaign_Name__c = 'ANNUAL';
        c.Solicitation_Type__c = 'ACQUISITION';
        c.Start_Time_Date__c = system.Now();
        c.Effort_for_Project__c = '1';
        clsTest.Char1_2_3(c);
        clsTest.Char4(c);
        clsTest.Char5(c);
        clsTest.Char6(c);
        clsTest.Char13_14_15(c);
        clsTest.Char11_12(c);
        clsTest.Char7_8_9_10(c);
        
    }    
    
}