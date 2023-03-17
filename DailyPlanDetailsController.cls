public class DailyPlanDetailsController {
     @AuraEnabled(cacheable=true)
    public static List<Daily_Plan_Detail__c> getDailyPlanDetailList() {
        return [SELECT  Account_Name__c, Account_Type__c, Account_Address__c,
        Account_Class__c
            FROM Daily_Plan_Detail__c];
    }

}