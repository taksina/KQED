public class UploadRecordMatching{


    public static List<sObject> getMatchingRows(WGBH_PB5_UPLOAD__c objPB5, String objectName, String MatchingCriteria){
        List<sObject> lstReturn;
        String matchCondition = '';
        String compare = '';        
        system.debug('##### called for object : ' + objectName);
        sObject sPB5 = (sObject)objPB5;
        system.debug('##############MatchingCriteria : ' + MatchingCriteria);
        if(MatchingCriteria != null && MatchingCriteria.length()>0){        
            List<String> lstMatchingCriteria = new List<String>();
            lstMatchingCriteria = MatchingCriteria.split(';');
            if(lstMatchingCriteria.size()>0){
                for(String s:lstMatchingCriteria){
                    system.debug('######### conditions with ; ---> ' + s);
                    system.debug('######### compare ------> ' + compare);
                    List<String> lstFields = new List<String>();
                    lstFields = s.split(',');
                    if(lstFields != null && lstFields.size()>0){
                        String temp = '';
                        for(String f:lstFields){
                            system.debug('####### conditin with , ---> ' + f);
                            List<String> field = new List<String>();
                            field = f.split('=');
                            system.debug('######## field ' + field);
                            if(field != null && field.size()>0){
                                string compareValue = String.valueOf(sPB5.get(field[1]));
                                if (compareValue == null){
                                    compareValue = '';
                                }
                                System.debug('###########Compare value : ' + comparevalue);
                                if(compareValue.trim().length()>0){
                                    compareValue = '\'' + compareValue + '\'';
                                    if(Temp.trim().length()==0)
                                        Temp = field[0] + ' = ' + compareValue;
                                    else
                                        Temp += ' AND ' + field[0] + ' = ' + compareValue;
                                }
                            }
                        }
                        if(temp.trim().length()>0){
                            if(compare.trim().length()>0){
                                compare += ' OR (' + temp + ')';
                                //compare += ' AND ';
                            }
                            else{
                                compare = '(' + temp + ')';
                            }
                            system.debug('######### compare...... ' + compare);
                        }
                    }
                }
            }
            if(compare.trim().length()>0){
                matchCondition = ' Where ' + compare;
            }
            system.debug('#### QUERY ### ' + 'Select Id, Name From ' + objectName + ' ' + matchCondition);
            if(matchCondition.trim().length()>0)
                lstReturn = Database.query('Select Id, Name From ' + objectName + ' ' + matchCondition);            
            else{
                lstReturn = new List<sObject>();
            }
                                
        }
        return lstReturn;
    }

    public static List<sObject> getMatchingRows_old(WGBH_PB5_UPLOAD__c objPB5, String objectName, String MatchingCriteria){
        List<sObject> lstReturn;
        String matchCondition = '';
        String compare = '';        
        system.debug('##### called for object : ' + objectName);
        sObject sPB5 = (sObject)objPB5;
        system.debug('##############MatchingCriteria : ' + MatchingCriteria);
        if(MatchingCriteria != null && MatchingCriteria.length()>0){        
            List<String> lstMatchingCriteria = new List<String>();
            lstMatchingCriteria = MatchingCriteria.split(';');
            if(lstMatchingCriteria.size()>0){
                for(String s:lstMatchingCriteria){
                    List<String> lstFields = new List<String>();
                    lstFields = s.split(',');
                    if(compare.trim().length()>0){
                        compare += ' OR ';
                        //compare += ' AND ';
                    }
                    if(lstFields != null && lstFields.size()>0){
                        String temp = '';
                        for(String f:lstFields){
                            List<String> field = new List<String>();
                            field = f.split('=');
                            if(field != null && field.size()>0){
                                string compareValue = String.valueOf(sPB5.get(field[1]));
                                if (compareValue == null)
                                    compareValue = '';
                                if(compareValue.trim().length()>0){
                                    compareValue = '\'' + compareValue + '\'';
                                    if(Temp.trim().length()==0)
                                        Temp = field[0] + ' = ' + compareValue;
                                    else
                                        Temp += ' AND ' + field[0] + ' = ' + compareValue;
                                }
                            }
                        }
                        if(temp.trim().length()>0)
                            compare += '(' + temp + ')';
                    }
                }
            }
            if(compare.trim().length()>0){
                matchCondition = ' Where ' + compare;
            }
            system.debug('#### QUERY ### ' + 'Select Id, Name From ' + objectName + ' ' + matchCondition);
            if(matchCondition.trim().length()>0)
                lstReturn = Database.query('Select Id, Name From ' + objectName + ' ' + matchCondition);            
            else{
                lstReturn = new List<sObject>();
            }
                                
        }
        return lstReturn;
    }

    static testMethod void myTest() {
        WGBH_PB5_UPLOAD__c objPB5 = New WGBH_PB5_UPLOAD__c();
        insert objPB5;
        

        UploadRecordMatching.getMatchingRows_old(objPB5, 'WGBH_PB5_UPLOAD__c','Flag_for_Review__c=IS_DUPLICATE__c');
        UploadRecordMatching.getMatchingRows(objPB5, 'WGBH_PB5_UPLOAD__c','Flag_for_Review__c=IS_DUPLICATE__c');
              
    }
}