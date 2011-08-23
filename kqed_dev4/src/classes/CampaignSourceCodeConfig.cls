Public Class CampaignSourceCodeConfig {
    Public String SetCampaignSocuceCode(List<Campaign> lstCampaign) {
        String SCchar123;
        String SCchar4;
        String SCchar5;
        String SCchar6;
        String SCchar78910;
        String SCchar1112;
        String FromField;
        String SCchar131415;
        String SourceCode;
        

        Set<String> sStation = New Set<String>();
        Set<String> sProductProgram = New Set<String>();
        Set<String> sCampaignName = New Set<String>();
        Set<String> sGivingSegment = New Set<String>();
        Set<String> sChannelTechnique = New Set<String>();
        Set<String> sSubChannel = New Set<String>();
        Set<String> sSolicitationType = New Set<String>();
        
        for(Campaign cp:lstCampaign){
            if(sStation.Contains(cp.Station__c)== false) sStation.Add(cp.Station__c);
            
            if(sProductProgram.Contains(cp.Product_Program__c)== false) sProductProgram.Add(cp.Product_Program__c);
            if(sCampaignName.Contains(cp.Campaign_Name__c)== false) sCampaignName.Add(cp.Campaign_Name__c);
            
             if(sGivingSegment.Contains(cp.Giving_Segment__c)== false) sGivingSegment.Add(cp.Giving_Segment__c);
             if(sChannelTechnique.Contains(cp.Channel_Technique__c)== false) sChannelTechnique.Add(cp.Channel_Technique__c);
             if(sSubChannel.Contains(cp.Sub_Channel__c)== false) sSubChannel.Add(cp.Sub_Channel__c);
             if(sSolicitationType.Contains(cp.Solicitation_Type__c)== false) sSolicitationType.Add(cp.Solicitation_Type__c);
        }
        
        List<SourceCodeConfig__c> objSCD123 = New List<SourceCodeConfig__c>([Select Char1__c,Char2__c,Char3__c,
                            Station__c,Product_Program__c,Campaign_Name__c , Giving_Segment__c,Channel_Technique__c,
                            Sub_Channel__c,Solicitation_Type__c,isDefault__c From SourceCodeConfig__c Where RecordType.DeveloperName= 'Char_1_2_3']);
                            //Where RecordType.DeveloperName= 'Char_1_2_3' AND Station__c In:sStation]);

        List<SourceCodeConfig__c> objSCD4 = New List<SourceCodeConfig__c>([Select Char4__c,
                              Station__c,Product_Program__c,Campaign_Name__c , Giving_Segment__c,Channel_Technique__c,
                              Sub_Channel__c,Solicitation_Type__c,isDefault__c From SourceCodeConfig__c Where RecordType.DeveloperName= 'Char_4']);
                              /*Where RecordType.DeveloperName= 'Char_4' And Product_Program__c In:sProductProgram 
                              And Campaign_Name__c In:sCampaignName]);*/
        List<SourceCodeConfig__c> objSCD5 = New List<SourceCodeConfig__c>([Select Char5__c ,
                              Station__c,Product_Program__c,Campaign_Name__c , Giving_Segment__c,Channel_Technique__c,
                              Sub_Channel__c,Solicitation_Type__c,isDefault__c From SourceCodeConfig__c Where RecordType.DeveloperName= 'Char_5']);
                              /*Where RecordType.DeveloperName= 'Char_5' And Product_Program__c In:sProductProgram 
                              And Campaign_Name__c In:sCampaignName And Giving_Segment__c In: sGivingSegment 
                              And Channel_Technique__c In:sChannelTechnique And Sub_Channel__c In: sSubChannel]);*/

        List<SourceCodeConfig__c> objSCD6 = New List<SourceCodeConfig__c>([Select Char6__c ,
                              Station__c,Product_Program__c,Campaign_Name__c , Giving_Segment__c,Channel_Technique__c,
                              Sub_Channel__c,Solicitation_Type__c,isDefault__c From SourceCodeConfig__c Where RecordType.DeveloperName= 'Char_6']);
                              /*Where RecordType.DeveloperName= 'Char_6' And Product_Program__c In:sProductProgram 
                              And Campaign_Name__c In:sCampaignName And Giving_Segment__c In: sGivingSegment 
                              And Channel_Technique__c In:sChannelTechnique And Sub_Channel__c In: sSubChannel 
                              And Solicitation_Type__c In: sSolicitationType]);*/
        
        List<SourceCodeConfig__c> objSCD11_12 = New List<SourceCodeConfig__c>([Select Char11__c,Char12__c,From_Field__c ,
                              Station__c,Product_Program__c,Campaign_Name__c , Giving_Segment__c,Channel_Technique__c,
                              Sub_Channel__c,Solicitation_Type__c,isDefault__c From SourceCodeConfig__c Where RecordType.DeveloperName= 'Char_11_12']);
                              /*Where RecordType.DeveloperName= 'Char_11_12' And Product_Program__c In:sProductProgram 
                              And Campaign_Name__c In:sCampaignName And Giving_Segment__c In: sGivingSegment]);*/

        
        String strDefaultvalue;
        
        for(Campaign cp:lstCampaign){
            SCchar123= '---';
            strDefaultvalue = '';
            for(SourceCodeConfig__c scd1: objSCD123) {
                if(CompairTheValue(cp.Station__c,scd1.Station__c)) {
                    SCchar123= isNullBlank(scd1.Char1__c) + isNullBlank(scd1.Char2__c) + isNullBlank(scd1.Char3__c);
                    break;
                }
                if(scd1.isDefault__c == true && strDefaultvalue =='') {
                    strDefaultvalue = isNullBlank(scd1.Char1__c) + isNullBlank(scd1.Char2__c) + isNullBlank(scd1.Char3__c);}
            }
            if(SCchar123== '---' && strDefaultvalue !='') SCchar123 = strDefaultvalue;
            
            
            SCchar4 = '-';
            strDefaultvalue = '';
            for(SourceCodeConfig__c scd4: objSCD4) {
                if(CompairTheValue(cp.Product_Program__c,scd4.Product_Program__c) && CompairTheValue(cp.Campaign_Name__c,scd4.Campaign_Name__c)) {
                   SCchar4 = isNullBlank(scd4.Char4__c);
                    break;
                }
                if(scd4.isDefault__c == true && strDefaultvalue =='') {
                    strDefaultvalue = isNullBlank(scd4.Char4__c);}
            }
            if(SCchar4 == '-' && strDefaultvalue !='') SCchar4 = strDefaultvalue;
            
            SCchar5 = '-';
            strDefaultvalue = '';
            for(SourceCodeConfig__c scd5: objSCD5) {
                if(CompairTheValue(cp.Product_Program__c,scd5.Product_Program__c) && CompairTheValue(cp.Campaign_Name__c,scd5.Campaign_Name__c) 
                    && CompairTheValue(cp.Giving_Segment__c,scd5.Giving_Segment__c) && CompairTheValue(cp.Channel_Technique__c,scd5.Channel_Technique__c)
                    && CompairTheValue(cp.Sub_Channel__c,scd5.Sub_Channel__c)) {
                       SCchar5 = isNullBlank(scd5.Char5__c);
                       break;
                }
                if(scd5.isDefault__c == true && strDefaultvalue =='') {
                    strDefaultvalue = isNullBlank(scd5.Char5__c);}
            }
            if(SCchar5 == '-' && strDefaultvalue !='') SCchar5 = strDefaultvalue;
            
            SCchar6 = '-';
            strDefaultvalue = '';
            for(SourceCodeConfig__c scd6: objSCD6) {
                if(CompairTheValue(cp.Product_Program__c,scd6.Product_Program__c) && CompairTheValue(cp.Campaign_Name__c,scd6.Campaign_Name__c )
                    && CompairTheValue(cp.Giving_Segment__c,scd6.Giving_Segment__c) && CompairTheValue(cp.Channel_Technique__c,scd6.Channel_Technique__c)
                    && CompairTheValue(cp.Sub_Channel__c,scd6.Sub_Channel__c)&& CompairTheValue(cp.Solicitation_Type__c,scd6.Solicitation_Type__c)) {
                       SCchar6 = isNullBlank(scd6.Char6__c);
                       break;
                }
                if(scd6.isDefault__c == true && strDefaultvalue =='') {
                   strDefaultvalue = isNullBlank(scd6.Char6__c);}
            }
            if(SCchar6 == '-' && strDefaultvalue !='') SCchar6 = strDefaultvalue;

            SCchar78910 = '----';
            SCchar78910 = Char7_8_9_10(cp);
            
            SCchar1112 = '--';
            FromField = '';
            strDefaultvalue = '';
            for(SourceCodeConfig__c scd11_12: objSCD11_12) {
                if(CompairTheValue(cp.Product_Program__c,scd11_12.Product_Program__c) && CompairTheValue(cp.Campaign_Name__c,scd11_12.Campaign_Name__c)
                    && CompairTheValue(cp.Giving_Segment__c,scd11_12.Giving_Segment__c)) {
                       SCchar1112 = isNullBlank(scd11_12.Char11__c) + isNullBlank(scd11_12.Char12__c);
                       FromField = scd11_12.From_Field__c;
                       break;
                }
                if(scd11_12.isDefault__c == true && strDefaultvalue =='') {
                   strDefaultvalue =isNullBlank(scd11_12.Char11__c) + isNullBlank(scd11_12.Char12__c);}
            }
           
            IF(FromField == 'Effort' || FromField== 'Start DateTime') {
              SCchar1112 = Char11_12(cp,FromField);
            }
            if((SCchar1112 == '--' || SCchar1112 == '') && strDefaultvalue !='') SCchar1112 = strDefaultvalue;

            
            SCchar131415 = '---';
            SCchar131415 = Char13_14_15(cp);
            
            
            SourceCode = SCchar123 + SCchar4 + SCchar5 + SCchar6 + SCchar78910 + SCchar1112 + SCchar131415;
            
            cp.Source_Code__c = SourceCode;
        }
        
        //return null;
        return SourceCode;
    }
    Private Boolean CompairTheValue(String strValue,String strMultipleValue)
    {
        if(strValue == null) strValue = '';
        if(strMultipleValue == null) strMultipleValue = '';
        if(strValue == strMultipleValue || strMultipleValue.toUpperCase() == 'All' || strMultipleValue.startsWith('All;') || 
            strMultipleValue.EndsWith(';All') || strMultipleValue.Contains(';All;')) return true;
        else if(strValue == '' || strMultipleValue== '' ) return false;
        else if(strMultipleValue.startsWith(strValue + ';') || 
            strMultipleValue.EndsWith(';'+strValue) || strMultipleValue.Contains(';'+ strValue + ';')) return true;

        return false;
    }

    Private String isNullBlank(String value){
        if(value == null || value=='') {
            return '-';
        }
        
        return value;
        
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

    Public string Char11_12(Campaign c,String FieldName) {
        String strReturn = '--';
        If(FieldName == 'Effort') {
            if (c.Effort_for_Project__c != null) {
                if(c.Effort_for_Project__c.length()==1 && c.Effort_for_Project__c!='0') {
                    strReturn = '0' + c.Effort_for_Project__c;
                }
                else {
                    strReturn = c.Effort_for_Project__c;
                }
            }
        }
        else if(FieldName == 'Start DateTime' && c.Start_Time_Date__c !=null) {
            strReturn = string.ValueOf(c.Start_Time_Date__c.Day());
            if(strReturn.length()==1) strReturn = '0' + strReturn;
        }

        //if(strReturn=='--' || strReturn=='') strReturn = '01';

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
    
    Public String Mytest(String Id) {
        String strid = Id; //'701T0000000BwxD'; //'701T0000000Bwwo';  //'701T0000000BtRD';
        List <Campaign> lstcp = [Select id, Source_Code__c,Station__c,Product_Program__c,Campaign_Name__c , Giving_Segment__c,Channel_Technique__c,Sub_Channel__c,Solicitation_Type__c,Start_Time_Date__c,ParentId,effort_for_project__c,Program_Count__c From Campaign where id =: strid];
        System.debug('###-Old#:' + lstcp[0].Source_Code__c);
        
        String strNewSC;
        strNewSC=SetCampaignSocuceCode(lstcp);
        System.debug('###-New#:' + strNewSC);
        return strNewSC;
    }

    Static testMethod void MySourceCodeTest()
    {
        //String strid =   //'701T0000000BwxD'; //'701T0000000Bwwo';  //'701T0000000BtRD';
        List <Campaign> lstcp = [Select id, Source_Code__c,Station__c,Product_Program__c,Campaign_Name__c , 
            Giving_Segment__c,Channel_Technique__c,Sub_Channel__c,Solicitation_Type__c,Start_Time_Date__c,
            ParentId,effort_for_project__c,Program_Count__c From Campaign  Limit 10];
        CampaignSourceCodeConfig objSc = New CampaignSourceCodeConfig();
        
        if(lstcp.size()>0)
        {
            objSc.SetCampaignSocuceCode(lstcp);
            objSc.CompairTheValue(null,null);
            objSc.CompairTheValue('test',null);
            objSc.CompairTheValue('one','one;two;three');
            objSc.Char11_12(lstcp[0],'Effort');
            objSc.Char11_12(lstcp[0],'Start DateTime');
            
        }
    }
}