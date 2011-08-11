global class MemberBenefitWs {
	
	public static Boolean isTest = false;
	
	global class MemberBenefitWs_Result {
		webservice String status {get; set;} // 'Success','Error','Exception' 
		webservice String description {get; set;} // 'Success', message, execption message
		webservice String xml {get; set;} //result
		
	}
	
	webservice static MemberBenefitWs_Result getMemberBenfits() {
		try {
			MemberBenefitWs_Result result = new MemberBenefitWs_Result();
            result.status='Success';
            result.Description='Success';
            
            MemberBenefitController mbc = new MemberBenefitController();
            if(MemberBenefitWs.isTest) {
            	mbc.isTest = true;
            }
            mbc.retrieveMemberBenefits();
            
            Map<Id, List<MemberBenefitWrapper>> mbwAccountMap = new Map<Id, List<MemberBenefitWrapper>>();
            for(MemberBenefitWrapper mbw : mbc.memberBenefitWrappers) {
                Id partnerId = mbw.memberBenefit.Business_Member_Partner__c;
                List<MemberBenefitWrapper> mbwList = null;
                if(mbwAccountMap.get(partnerId) == null) {
                    mbwList = new List<MemberBenefitWrapper>();                 
                }
                else {
                    mbwList = mbwAccountMap.get(partnerId);
                }
                mbwList.add(mbw);
                mbwAccountMap.put(partnerId, mbwList);
            }
            
            for(Id pId : mbwAccountMap.keySet()) {
                //System.debug(Logginglevel.WARN, 'id: '+pId+', size: '+mbwAccountMap.get(pId).size());
            }
            
            /*Map<Id, Account> accountLocationsMap = new Map<Id, Account>();
            accountLocationsMap.putAll(
                [Select Id, 
                    (Select Id, Street__c, City__c, State__c, PostalCode__c, Phone__c, Latitude__c, Longitude__c From Locations__r)
                 From Account Where Id IN :mbwAccountMap.keySet()]
            );
            System.debug(Logginglevel.WARN, 'AccMbMap len: '+mbwAccountMap.size()+', AccLocMap len: '+accountLocationsMap.size());  */
            
            String xmlResult = '<underwriters>';
            for(Id partnerId : mbwAccountMap.keySet()) {
                List<MemberBenefitWrapper> mbwList = mbwAccountMap.get(partnerId);
                MemberBenefitWrapper mbwTemp = mbwList.get(0);
                xmlResult += '<underwriter>';
                    xmlResult += createElement('id', partnerId);//' +  + '
                    xmlResult += createElement('name', mbwTemp.memberBenefit.Business_Member_Partner__r.Name);
                    xmlResult += createElement('description', mbwTemp.memberBenefit.Business_Member_Partner__r.AboutUs__c);
                    xmlResult += createElement('url', mbwTemp.memberBenefit.Business_Member_Partner__r.Website);
                    if(mbwTemp.memberBenefit.Business_Member_Partner__r.Logo_Url__c != null && mbwTemp.memberBenefit.Business_Member_Partner__r.Logo_Url__c.length() > 0) {
                    	xmlResult += createElement('logo_url', 'http://wgbh.force.com' + mbwTemp.memberBenefit.Business_Member_Partner__r.Logo_Url__c);
                    }
                    
                    Map<Id, Member_benefit_Location__c> mbLocations = new Map<Id, Member_benefit_Location__c>();
                    for(MemberBenefitWrapper mbw : mbwList) {
                    	for(Member_benefit_Location__c mblTemp : mbw.memberBenefitLocations) {
                    		mbLocations.put(mblTemp.Id, mblTemp);
                    	}
                    }
                    xmlResult += '<locations>';
                    for(Id locationId : mbLocations.keySet()) {
                    	Location__c location = mbLocations.get(locationId).Location__r;
                    	xmlResult += '<location>';
                    	    xmlResult += createElement('id', location.Id);
                    	    xmlResult += createElement('street', location.Street__c);
                    	    xmlResult += createElement('city', location.City__c);
                    	    xmlResult += createElement('state', location.State__c);
                    	    xmlResult += createElement('postal_code', location.PostalCode__c);
                    	    xmlResult += createElement('phone', location.Phone__c);
                    	    xmlResult += createElement('latitude', location.Latitude__c.toPlainString());
                    	    xmlResult += createElement('longitude', location.Longitude__c.toPlainString());
                    	xmlResult += '</location>';
                    }
                    xmlResult += '</locations>';
                    
                    xmlResult += '<benefits>';
                    for(MemberBenefitWrapper mbw : mbwList) {
                    	xmlResult += '<benefit>';
                    	    xmlResult += createElement('id', mbw.memberBenefit.Id);
                    	    xmlResult += createElement('name', mbw.memberBenefit.Name);
                    	    //xmlResult += createElement('start_date', mbw.memberBenefit.Start_Date__c.format());
                    	    //xmlResult += createElement('end_date', mbw.memberBenefit.End_Date__c.format());
                    	    xmlResult += createElement('description', mbw.memberBenefit.Offer__c);
                    	    xmlResult += createElement('category', mbw.memberBenefit.Category__c);
                    	    xmlResult += createElement('featured', String.valueOf(mbw.memberBenefit.Featured__c));
                    	    xmlResult += createElement('top_two_featured', String.valueOf(mbw.memberBenefit.Top_Two_Featured__c));
                    	    
                    	    xmlResult += '<benefit_locations>';
                    	    for(Member_benefit_Location__c mbl : mbw.memberBenefitLocations) {
                                xmlResult += createElement('id', mbl.Location__r.Id);
                    	    }
                    	    xmlResult += '</benefit_locations>';
                    	xmlResult += '</benefit>';
                    }
                    xmlResult += '</benefits>';
                   
                xmlResult += '</underwriter>';
            }
            xmlResult += '</underwriters>';
            
            result.xml = xmlResult; 
            
            //System.debug(Logginglevel.WARN, '***********************'+result.xml);	
			return result;
		}
		catch  (Exception ex) {
            MemberBenefitWs_Result result = new MemberBenefitWs_Result();
            result.status='Exception';
            result.Description=ex.getMessage();
            result.xml=null;
            return result;        			
		}		
	} 
	
	static String createElement(String tag, String value) {
		return (value != null && value.length() > 0) ? ('<' + tag + '>' + value + '</' + tag + '>') : ('<' + tag + '/>');
	}
    
    
}