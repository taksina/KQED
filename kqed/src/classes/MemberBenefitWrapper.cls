public class MemberBenefitWrapper {
    public Boolean checked {get; set;}
    public Boolean notLastPage {get; set;}
    public Member_Benefit__c memberBenefit {get; set;}
    public List<Member_benefit_Location__c> memberBenefitLocations {get; set;}
    
    public MemberBenefitWrapper(Member_Benefit__c memberBenefit, List<Member_benefit_Location__c> memberBenefitLocations) {
        this.memberBenefit = memberBenefit;
        this.memberBenefitLocations = memberBenefitLocations;
        this.notLastPage = true;
        this.checked = false;
        
        checkLogo();
    }
    
    public MemberBenefitWrapper(Member_Benefit__c memberBenefit, List<Member_benefit_Location__c> memberBenefitLocations, Boolean notLastPage) {
        this.memberBenefit = memberBenefit;
        this.memberBenefitLocations = memberBenefitLocations;
        this.notLastPage = notLastPage;
        this.checked = false;
        
        checkLogo();
    }
    
    public void checkLogo() {
    	//if(this.memberBenefit.BenefitImage__c == null || this.memberBenefit.BenefitImage__c.length() <= 0) {
    	//	this.memberBenefit.BenefitImage__c = '<img src="/resource/default_benefit_image" alt="Special Offer">';
    	//}
    	
    	if(this.memberBenefit.Business_Member_Partner__r != null && (this.memberBenefit.Business_Member_Partner__r.Logo_Url__c == null || this.memberBenefit.Business_Member_Partner__r.Logo_Url__c.length() <= 0)) {
            this.memberBenefit.Business_Member_Partner__r.Logo_Url__c = '/resource/default_account_logo_trans';
        }
    }
    
    public void checkLink() {
    	if(this.memberBenefit.Benefit_Link__c != null && this.memberBenefit.Benefit_Link__c.length() > 0) {
            if(! this.memberBenefit.Benefit_Link__c.startsWith('http://')) {
                this.memberBenefit.Benefit_Link__c = 'http://' + this.memberBenefit.Benefit_Link__c;
            }
        }
        //System.debug('Partner website for benefit: '+this.memberBenefit.Id+' is: '+this.memberBenefit.Business_Member_Partner__r.Website);
        if(this.memberBenefit.Business_Member_Partner__r.Website != null && this.memberBenefit.Business_Member_Partner__r.Website.length() > 0) {
            if(! this.memberBenefit.Business_Member_Partner__r.Website.startsWith('http://')) {
                this.memberBenefit.Business_Member_Partner__r.Website = 'http://' + this.memberBenefit.Business_Member_Partner__r.Website;
            }
        }
    }
}