@isTest
public class CreateAdditionalTaskTest {

    @isTest 
    static void testAdditionalTask() {
      Campaign camp = new Campaign();
      camp.Name='Test Camp';
      camp.No_of_followup_email__c=2;
      camp.No_of_Days_Gap__c=2;
      camp.X1st_Email_Template__c='abc';
      camp.X2nd_Email_Template__c='xyz';
      camp.Stage__c='Ongoing';
      insert camp;
        
      List<Lead> leadList  =new List<Lead>();
      Lead leadObject = new lead();
      leadObject.FirstName='priyanka';
      leadObject.LastName='Aiwale';
      leadObject.Email='priyanka.aiwale@thinqloud.com';
      leadObject.Authority_Country__c='USA';
      leadObject.Company='Thinqloud';
      leadObject.Campaign__c=camp.id;
      leadObject.First_Email_FollowUp_Start_Date__c=System.today();
      leadList.add(leadObject);
      insert leadList;
        
      camp.No_of_followup_email__c=3;
      update camp;
        
        
    }
}