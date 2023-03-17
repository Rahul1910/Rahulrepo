@isTest


public class CreateTaskTest {

 @isTest
  static void testCreateTaskInvocableMethod() {
      
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
      //insert leadObject;
      
      
      Lead leadObject3 = new lead();
      leadObject3.FirstName='priyanka';
      leadObject3.LastName='Aiwale';
      leadObject3.Email='priyanka.aiwale123@thinqloud.com';
      leadObject3.Authority_Country__c='USA';
      leadObject3.Company='Thinqloud';
      leadList.add(leadObject3);
     // insert leadObject3;
      
      /*
      Lead leadObject4 = new lead();
      leadObject4.id=leadObject3.id;
      leadObject4.Campaign__c =camp.id;
      update leadObject4;
      */
      
      
      Lead leadObject2 = new lead();
      leadObject2.FirstName='priyankaa';
      leadObject2.LastName='Aiwalea';
      leadObject2.Email='priyanka.aiwale1@thinqloud.com';
      leadObject2.Authority_Country__c='USA';
      leadObject2.Company='Thinqloud';
      leadObject2.Campaign__c=camp.id;
      leadObject2.First_Email_FollowUp_Start_Date__c=Date.today().addDays(-5);
      leadList.add(leadObject2);
      insert leadList;
      
      List<Task> t =[select id from task where whoId =: leadObject2.id];
      System.debug(t);
      
      
      Campaign camp1 = new Campaign();
      camp1.Name='Test Camp';
      camp1.No_of_followup_email__c=2;
      camp1.No_of_Days_Gap__c=2;
      camp1.X1st_Email_Template__c='abc';
      camp1.X2nd_Email_Template__c='xyz';
      camp1.Stage__c='Ongoing';
      insert camp1;
      
      Campaign camp2 = new Campaign();
      camp2.Name='Test Camp';
      camp2.No_of_followup_email__c=2;
      camp2.No_of_Days_Gap__c=2;
      camp2.X1st_Email_Template__c='abc';
      camp2.X2nd_Email_Template__c='xyz';
      camp2.Stage__c='Ongoing';
      insert camp2;
     
    
      Lead leadObject5 = new lead();
      leadObject5.FirstName='priyanka';
      leadObject5.LastName='Aiwale';
      leadObject5.Email='priyanka.aiwale2021@thinqloud.com';
      leadObject5.Authority_Country__c='USA';
      leadObject5.Company='Thinqloud';
      insert  leadObject5;
      
      CampaignMember cmp = new CampaignMember();
      cmp.LeadId=leadObject5.id;
      cmp.CampaignId=camp1.id;
      insert cmp;
      
       CampaignMember cmp11 = new CampaignMember();
      cmp11.LeadId=leadObject5.id;
      cmp11.CampaignId=camp2.id;
      insert cmp11;
      
      
      
      
     
      
      
      
      
      


  }
}