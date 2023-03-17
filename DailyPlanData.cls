public with sharing class DailyPlanData {
    @AuraEnabled (cacheable=true)
    public static List<Daily_Plans__c> getDailyPlansOfLoginUser (Id LoginUser){
    //system.debug('tourplan d==='+getTourPlanId); 1
    return [Select Id,Name,Date__c,Expense_Budget__c,Activity_Types__c,User__c,User_Name__c ,Area__c from Daily_Plans__c where User__c = : LoginUser]; // where User__c = : loginUserId1
    }
    @AuraEnabled (cacheable=true)
    public static List<Daily_Plans__c> getDailyPlansOfLoginUserwire (Id LoginUser){
    //system.debug('tourplan d==='+getTourPlanId); 1
    return [Select Id,Name,Date__c,Expense_Budget__c,Activity_Types__c,User__c,User_Name__c ,Area__c from Daily_Plans__c where User__c = : LoginUser]; // where User__c = : loginUserId1
    }
    @AuraEnabled 
    public static List<Daily_Plan_Detail__c> getDailyPlansDetailsOfLoginUser (Id DailyPlansId){
    system.debug('tourplan id==='+DailyPlansId);
    return [Select Id,Account_Name__c,Account_Type__c,Account_Address__c,Visit_Time__c,Account_Class__c,HQ_Visit__c, Leave_Taken__c from Daily_Plan_Detail__c where (Daily_Plan__c = : DailyPlansId) And ( Activity_Type__c != 'HQ Visit' ) And ( Activity_Type__c != 'Leave' )]; // where Daily_Plan__c = : DailyPlansId 12 1
    }
   
    @AuraEnabled 
    public static List<Daily_Plan_Detail__c> getDailyPlansDetailsOfLoginUserHQVisit (Id DailyPlansIdss){
    system.debug('tourplan id 1 ==='+DailyPlansIdss);
    List<Daily_Plan_Detail__c> lstt2 = [Select Id,Visit_Time__c,HQ_Visit__c,Plan_Remarks__c from Daily_Plan_Detail__c where ( Daily_Plan__c = : DailyPlansIdss ) And ( Activity_Type__c = 'HQ Visit' ) ]; 
    system.debug( 'lstt2 HQVisit = '+lstt2);
    return [Select Id,Visit_Time__c,HQ_Visit__c,Plan_Remarks__c from Daily_Plan_Detail__c where ( Daily_Plan__c = : DailyPlansIdss ) And ( Activity_Type__c = 'HQ Visit' ) ]; // where Daily_Plan__c = : DailyPlansId 12 1
    }
   
    @AuraEnabled 
    public static List<Daily_Plan_Detail__c> getDailyPlansDetailsOfLoginUserLeave (Id DailyPlansIdsss){
    system.debug('tourplan id 2 ==='+DailyPlansIdsss);
    List<Daily_Plan_Detail__c> lsttt = [Select Id, Leave_Taken__c,Plan_Remarks__c from Daily_Plan_Detail__c where ( Daily_Plan__c = : DailyPlansIdsss ) And ( Activity_Type__c = 'Leave' ) ];
    system.debug('lsttt Leave = '+lsttt);
    return [Select Id, Leave_Taken__c,Plan_Remarks__c from Daily_Plan_Detail__c where ( Daily_Plan__c = : DailyPlansIdsss ) And ( Activity_Type__c = 'Leave' ) ]; // where Daily_Plan__c = : DailyPlansId 12 1
    }
   
    @AuraEnabled (cacheable=true)
    public static List<Daily_Plans__c> getDailyPlansOfAllUser (){
    //system.debug('tourplan d==='+getTourPlanId); 1
    return [Select Id,Name,Date__c,Expense_Budget__c,Activity_Types__c,User__c,User_Name__c, Area__c from Daily_Plans__c ]; // where User__c = : loginUserId1
    }
   
    @AuraEnabled (cacheable=true)
    public static List<Daily_Plans__c> getDailyPlansOfMyTeam (Id LoginUserIds){
    //system.debug('tourplan d==='+getTourPlanId); 1
    List<Id> ChildsTerritoryUsersIdsAll = CommanMethodToGetChildsNodes(LoginUserIds);
    return [Select Id,Name,Date__c,Expense_Budget__c,Activity_Types__c,User__c,User_Name__c, Area__c from Daily_Plans__c where (User__c In : ChildsTerritoryUsersIdsAll) And (User__c != : LoginUserIds)]; // where User__c = : loginUserId1
    }
   
    // Comman Method For Getting Assigned User Ids of Territory comes Under Login User (By Territory Hierarchy) aa hqVisitChange
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
    
    List<Territory2> wholeTerrIdsList = [Select Id, ParentTerritory2Id from Territory2];
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
    List<UserTerritory2Association> terrIdsList = [Select Id, UserId, Territory2Id from UserTerritory2Association where UserId = :loginUserId]; 
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
   
   
    
    while ( i < 20)
    { 
    for(Id ObjPar : ListOfTerriIds) //childObjsss
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
    
    List<UserTerritory2Association> UserIdsList = [ Select Id, UserId, Territory2Id from UserTerritory2Association where Territory2Id In : ListOfChildsTerriIds ]; //.UserId; // - check Users of these child territories.
    for(UserTerritory2Association obj3: UserIdsList)
    {
    ListOfAssociatedUserIdsTerriIds.add(obj3.UserId);
    }
   
    List<Id> ListOfChildsTerriUserIdsNew = new List<Id>();
    ListOfChildsTerriUserIdsNew.addAll(ListOfAssociatedUserIdsTerriIds);
   
    system.debug('ListOfChildsTerriUserIdsNew = '+ListOfChildsTerriUserIdsNew);
    
    return ListOfChildsTerriUserIdsNew ;
   }
   
   
   public static Time convertVisitTime(String visitTimeMap){
    String[] strTimeSplit = visitTimeMap.split(':');
    System.debug(strTimeSplit);
    Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
    ,Integer.valueOf(strTimeSplit[1]) //min
    ,0 //sec
    ,0);
    return timeChange;
    }
    
   
   
   // Code written by Jayshri ends here 111
   
   @AuraEnabled (cacheable=true)
    public static List<Daily_Plans__c> retrieveDailyPlans(){
    system.debug('inside retrive');
    return [SELECT Id, Date__c, Area__c, Expense_Budget__c, Activity_Types__c,User_Name__c, User__c
    FROM Daily_Plans__c];
    
    
    }
   
   }