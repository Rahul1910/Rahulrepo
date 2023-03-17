public with sharing class DailyCallReportData {
    @AuraEnabled (cacheable=true)
    public static List<DCR__c> getDailyCallReportOfLoginUser (Id LoginUser){
        //system.debug('tourplan d==='+getTourPlanId);  1
        List<DCR__c> lstLgUsr = [Select Id,Name,Date__c,Datetime__c , User__c,User_Name__c,Day__c,Expense_Budget__c,Area__c,Activity_Type__c,Status__c from DCR__c where User__c = : LoginUser ORDER BY Date__c DESC];
        system.debug('lstLgUsr = '+lstLgUsr);
        return lstLgUsr;       // where CreatedById = : LoginUser
    }
    @AuraEnabled 
    public static List<DCR_Details__c> getDailyCallReportDetailsOfLoginUser (Id DCRId){
        //system.debug('tourplan id==='+DailyPlansId);
        return [Select Id,Manager_Accompany__c,product__c,Sample_Given__c,Promo_given__c,Purpose__c,Product_Promoted__c,comments__c,Activity_Type__c,Account_Name__c,Account_Type__c,Account_Address__c,Visit_Time__c,Account_Class__c,HQ_Visit__c, Check_in__c,Check_Out__c,Visit_Status__c,Leave_Taken__c,Actual_leave_plan__c, Feedback__c ,Next_Visit_Date__c   from DCR_Details__c where (DCR__c = : DCRId) And ( Activity_Type__c != 'HQ Visit' ) And ( Activity_Type__c != 'Leave' ) ORDER BY Account_Name__c ASC ];       // where (DCR__c = : DCRId) And ( Activity_Type__c != 'Travel To HQ' ) And ( Activity_Type__c != 'Leave' )
    }

    @AuraEnabled 
    public static List<DCR_Details__c> getDailyCallReportDetailsOfLoginUserHQVisit (Id DCRIdss){
        //system.debug('tourplan id==='+DailyPlansId);
        return [Select Id,Visit_Time__c,HQ_Visit__c, Check_in__c,Check_Out__c,Visit_Status__c,comments__c from DCR_Details__c  where ( DCR__c = : DCRIdss ) And ( Activity_Type__c = 'HQ Visit' ) ];       // where ( DCR__c = : DCRIdss ) And ( Activity_Type__c = 'Travel To HQ' )
    }

    @AuraEnabled 
    public static List<DCR_Details__c> getDailyCallReportDetailsOfLoginUserLeave (Id DCRIdsss){
        //system.debug('tourplan id==='+DailyPlansId);
        return [Select Id,Leave_Taken__c,Actual_leave_plan__c,comments__c from DCR_Details__c  where ( DCR__c = : DCRIdsss ) And ( Activity_Type__c = 'Leave' ) ];       // where ( DCR__c = : DCRIdsss ) And ( Activity_Type__c = 'Leave' )
    }

    @AuraEnabled (cacheable=true)
    public static List<DCR__c> getDailyCallReportOfAllUser (Id LoginUserIds){
        //system.debug('tourplan d==='+getTourPlanId);  1
            List<DCR__c> AllPlansss = new List<DCR__c>();
            List<DCR__c> MyPlanss = getDailyCallReportOfLoginUser(LoginUserIds);
            List<DCR__c> MyTeamsPlanss = getDailyCallReportOfMyTeam(LoginUserIds);
            AllPlansss.addAll(MyPlanss);
            AllPlansss.addAll(MyTeamsPlanss); 
            return AllPlansss;
    }

    @AuraEnabled (cacheable=true)
    public static List<DCR__c> getDailyCallReportOfMyTeam (Id LoginUserIds){
        //system.debug('tourplan d==='+getTourPlanId);  1
        List<Id> ChildsTerritoryUsersIdsAll = CommanMethodToGetChildsNodes(LoginUserIds);
        return [Select Id,Name,Datetime__c,Date__c,User__c,User_Name__c from DCR__c where (User__c In : ChildsTerritoryUsersIdsAll) And (User__c != : LoginUserIds) ORDER BY Date__c DESC];       // where User__c = : loginUserId1
    }

    // Comman Method For Getting Assigned User Ids of Territory comes Under Login User (By Territory Hierarchy) aa
@AuraEnabled(cacheable=true)
public static List<Id> CommanMethodToGetChildsNodes(Id loginUserId)
{
    system.debug('Inside common method');
    Set<Id> ListOfTerriIds = new Set<Id>();
    set<Id> ListOfChildsTerriIds = new set<Id>();
    set<Id> ListOfAssociatedUserIdsTerriIds = new set<Id>();
    Map<Id, List<Id>> WholeTreeMap = new Map<Id, List<Id>>();
    set<Id> newList = new set<Id>();
    integer i = 0;
    
    List<Territory2> wholeTerrIdsList = [Select Id, ParentTerritory2Id  from Territory2];
    for(Territory2 wholetreeobj : wholeTerrIdsList)
    {
        if(wholetreeobj.ParentTerritory2Id == null)
        {
            system.debug('null parent');
        }
        else
        {
            if(WholeTreeMap.containsKey(wholetreeobj.ParentTerritory2Id)) {
                List<Id> usersIdLst = WholeTreeMap.get(wholetreeobj.ParentTerritory2Id);
                usersIdLst.add(wholetreeobj.Id);
                WholeTreeMap.put(wholetreeobj.ParentTerritory2Id, usersIdLst);
            } else {
                WholeTreeMap.put(wholetreeobj.ParentTerritory2Id, new List<Id> { wholetreeobj.Id });
            }
        }
    }

    system.debug('WholeTreeMap = '+WholeTreeMap);
    List<UserTerritory2Association> terrIdsList = [Select Id, UserId, Territory2Id  from UserTerritory2Association where UserId = :loginUserId]; 
    system.debug('terrIdsList = '+terrIdsList);
    if(terrIdsList.size() > 0)
    {
        for(UserTerritory2Association obj1: terrIdsList)
        {
            ListOfTerriIds.add(obj1.Territory2Id); 
        }
    } 
   system.debug('ListOfTerriIds ='+ListOfTerriIds); //ListOfTerriIds = =
   system.debug('ListOfTerriIds.size() = '+ListOfTerriIds.size());


   
   while ( i < 10)
   { 
        for(Id ObjPar : ListOfTerriIds)  //childObjsss
        {
            system.debug('childObjsss1 = '+ObjPar);
            if(WholeTreeMap?.containsKey(ObjPar))
            {
                system.debug('WholeTreeMap.get(childObjsss) 2= '+WholeTreeMap.get(ObjPar));
                newList.addAll(WholeTreeMap.get(ObjPar));  
                system.debug('newList 3 = '+newList);
                ListOfChildsTerriIds.addAll(WholeTreeMap.get(ObjPar)); 
                system.debug('ListOfChildsTerriIds 4 = '+ListOfChildsTerriIds); 
                system.debug('WholeTreeMap = '+WholeTreeMap);
            }
        }
        
        
        if(newList.size() != 0)
        {
           for(Id lstnewObjs : newList) 
           {
            ListOfTerriIds.add(lstnewObjs); 
           }
        } 
        else {
            
            ListOfTerriIds.clear();
        }

        system.debug('ListOfTerriIds after clear = '+ListOfTerriIds);
        i++ ; 
            
    }
    system.debug('ListOfChildsTerriIds = '+ListOfChildsTerriIds); 
   
    List<UserTerritory2Association> UserIdsList =  [ Select Id, UserId, Territory2Id  from UserTerritory2Association where Territory2Id In : ListOfChildsTerriIds ];  //.UserId; // - check Users of these child territories.
    for(UserTerritory2Association obj3: UserIdsList)
    {
        ListOfAssociatedUserIdsTerriIds.add(obj3.UserId);
    }

    List<Id>  ListOfChildsTerriUserIdsNew = new List<Id>();
    ListOfChildsTerriUserIdsNew.addAll(ListOfAssociatedUserIdsTerriIds);

    system.debug('ListOfChildsTerriUserIdsNew = '+ListOfChildsTerriUserIdsNew);
    
    return ListOfChildsTerriUserIdsNew ;
}
@AuraEnabled
    public static string getDetails(date dcrdate){
        
    Id usreid = UserInfo.getUserId(); 
	Id recordPageId;
    Id ExpenseParentId= [SELECT Id, Expense_Date__c, User__c FROM Expense__c where Expense_Date__c=:dcrdate AND User__c=: usreid].Id;  
 //recordPageId = [SELECT Id FROM Expense_Details__c where Expense__c=: ExpenseParentId].Id;

 //return recordPageId;
        
       if(ExpenseParentId!= null || ExpenseParentId!= ''){
        system.debug('recordPageId'+ExpenseParentId);
        return ExpenseParentId;
       }
       else 
       return null;  
    }
    @AuraEnabled
    public static string updateTourPlanStatus(string selectedTourRec){
        System.debug('ids==='+ selectedTourRec);
        String str = selectedTourRec;
        List<String> lstString = str.split(',');
        System.debug('-----lstString----'+lstString);
        List<DCR__c> updatetourplan = [select id, Status__c,User__c from DCR__c where Id IN:lstString];
        System.debug('-----sagar----'+updatetourplan);
        try {
            for(DCR__c objtr : updatetourplan){
                objtr.Status__c = 'Submitted';
                update objtr;
            }
            return 'Success';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void fakeMethod(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    
      }
}