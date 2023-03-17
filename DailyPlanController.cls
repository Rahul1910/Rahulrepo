public class DailyPlanController {
@AuraEnabled (cacheable=true)
    public static List<Daily_Plans__c> fetchDailyPlans (){
        //system.debug('tourplan d==='+getTourPlanId)
        return [Select Id,Date__c,User__c FROM Daily_Plans__c];       
    }


@AuraEnabled(cacheable=true)
    public static List<Tour_Plan_Detail__c> getTourPLanDetailList() {
        return [SELECT  Id,Date__c,Day__c, User__c, Expense_Budget__c,Area__c,Is_Manager_Accompany__c,Activity_Type__c
            FROM Tour_Plan_Detail__c];
    }
    @AuraEnabled
     public static List<Tour_Plan_Detail__c> getTourPLanDetailListimp() {
        return [SELECT  Id,Date__c,Day__c, User__c, Expense_Budget__c,Area__c,Is_Manager_Accompany__c,Activity_Type__c
            FROM Tour_Plan_Detail__c];
    }
}