trigger NewEmployee on Job_Application__c (after update) {
//MODIFIED BY BRW 1/18/2010
    Job_Application__c[] newja = Trigger.new;
    Job_Application__c[] oldja = Trigger.old;
   
    if(newja[0].Picklist__c != oldja[0].Picklist__c && newja[0].Picklist__c == 'Hired')
    {
     
        position__c pos = [SELECT id,
                                    name,
                                    Billing_Account_Category__c,
                                    Departments__r.Process_Level__c,
                                    Departments__r.Department_Code__c,
                                    Department_Process_Level__c,
                                    Supervisor_Name__r.Code__c,
                                    WGBH_Accounting_Unit__c,
                                    Position_Title__r.code__c,
                                    Person_who_issues_paychecks_to_thishire__r.code__c,
                                    Building_Location_Code__c,
                                    Billing_Activity_Code__c
                                    FROM Position__C
                                    WHERE id =: newja[0].Position__c];
                                   
        Candidate__c can = [SELECT id,
                                    name,
                                    First_Name__c,
                                    last_Name__c,
                                    Veteran_information__c,
                                    Handicapped__c,
                                    gender__c,
                                    EEO_Diversity__c,
                                    phone__c,
                                    Current_employee_of_WGBH__c,
                                    Previously_employed_at_WGBH__c,
                                    Previous_WGBH_employee_ID__c,
                                    Street_Address1__c,
                                    Street_Address2__c,
                                    City__c,
                                    State_lkp__r.code__c,
                                    Zip_Postal_Code__c,
                                    Country_lkp__r.code__c,
                                    Salary_Hired__c
                                    FROM Candidate__c
                                    WHERE id=: newja[0].Candidate__c];   
        //set the EEOClass                     
            String eeoClass = null;
            if (can.EEO_Diversity__c == 'Hispanic or Latino')
        {
            eeoClass = 'HI';
        }
        else if (can.EEO_Diversity__c == 'American Indian or Alaskan Native (Not Hispanic or Latino)')
        {
            eeoClass = 'AN';
        }
        else if (can.EEO_Diversity__c == 'Black or African American (Not Hispanic or Latino)')
        {
            eeoClass = 'B';
        }
        else if (can.EEO_Diversity__c == 'Asian (Not Hispanic or Latino)')
        {
            eeoClass = 'AS';
        }
        else if (can.EEO_Diversity__c == 'Native Hawaiian or Other Pacific Islander (Not Hispanic or Latino)')
        {
            eeoClass = 'NH';
        }
        else if (can.EEO_Diversity__c == 'White (Not Hispanic or Latino)')
        {
            eeoClass = 'WH';
        }
        else
        {
            eeoClass = null;
        }
           
        Lawson_Employee__c emp  =  new Lawson_Employee__c();
        emp.EmpFc__c       = (can.Current_employee_of_WGBH__c || can.Previously_employed_at_WGBH__c == 'Yes') ? 'C' : 'A';
        emp.EmpCompany__c  = '0100';
        emp.EmpEmployee__c = (can.Current_employee_of_WGBH__c || can.Previously_employed_at_WGBH__c == 'Yes') ? can.Previous_WGBH_employee_ID__c : null;
        emp.last_name__c   = can.last_name__c;
        emp.first_name__c  = can.first_name__c;
        emp.Street_Address1__c = can.Street_Address1__c;
        emp.Street_Address2__c = can.Street_Address2__c;
        emp.Street_Address_3__c = null;
        emp.Street_Address_4__c = null;
        emp.City__c = can.City__c;
        emp.State_Province__c = can.State_lkp__r.code__c;
        emp.Zip_Postal_Code__c = can.Zip_Postal_Code__c;
        emp.EmpCountryCode__c  = can.Country_lkp__r.code__c;
        emp.EmpStatus__c = 'A';
        //DATA ENTERED
        //emp.EmpFicaNbr__c = '';
        emp.EmpProcessLevel__c = pos.Departments__r.Process_Level__c;
        emp.EmpDepartment__c = pos.Departments__r.Department_Code__c;
        emp.EmpHmDistCo__c = (pos.Department_Process_Level__c == 'WGBY') ? '0157' : '0100';
        emp.Accounting_Unit__c = pos.WGBH_Accounting_Unit__c;
        emp.EmpHmAccount__c = '701010';
        emp.EmpHmSubAcct__c = '0000';
        emp.EmpSupervisor__c = pos.Supervisor_Name__r.Code__c;
        emp.Billing_Activity_Code__c = pos.Billing_Activity_Code__c;
        emp.EmpUnionCode__c = pos.Position_Title__r.code__c.substring(0,1);
        emp.EmpUserLevel__c = pos.Person_who_issues_paychecks_to_thishire__r.code__c;
        emp.EmpDateHired__c =  System.now().format('yyyymmdd');
        emp.EmpAdjHireDate__c = (can.Current_employee_of_WGBH__c || can.Previously_employed_at_WGBH__c == 'Yes') ? null : System.now().format('yyyymmdd');
        emp.EmpJobCode__c = pos.Position_Title__r.code__c;
        emp.EmpNbrFte__c = null;//TODO SET
        emp.EmpSalaryClass__c = 'H';
        emp.EmpPayRate__c = (newja[0].Final_Salary__c/26)/80;
        emp.EmpPayFrequency__c = '2';
        emp.EmpOtPlanCode__c = 'BW';
        emp.PemHmPhoneNbr__c = can.Phone__c;
        emp.EEO_Diversity__c = eeoClass;
        emp.Gender__c = (can.gender__c == 'Male') ? 'M' : 'F';
        emp.Handicapped__c = (can.Handicapped__c == 'Yes') ? 'Y' : 'N';
        emp.Veteran_information__c = (can.Veteran_information__c != null && (can.Veteran_information__c != 'Decline to identify' || can.Veteran_information__c != 'Not a Veteran')) ? 'Y' :'N';
        //DATA ENTERED
        //emp.Birth_Date__c = '';
        emp.Location__c = pos.Building_Location_Code__c;
        emp.Billing_Account_Category__c = pos.Billing_Account_Category__c;
        emp.PemBenDateA__c = (can.Current_employee_of_WGBH__c || can.Previously_employed_at_WGBH__c == 'Yes') ? null : System.now().format('yyyymmdd');
        emp.PepPosLevel__c = '1';
        emp.PepEffectDate__c = System.now().format('yyyymmdd');
        emp.EmpWorkSched__c = newja[0].Work_Schedule__c;//TODO SET WORK SCHEDULE
        emp.EmpAnnualHours__c = '2080';
       
        try
        {
            insert emp;
        }
        catch(exception e)
        {
            throw e;
        }
       
   
    }
 
 
}