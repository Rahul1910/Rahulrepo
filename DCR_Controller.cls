public class DCR_Controller {
    
     @AuraEnabled
    public static void insertTerritoryToDCR(Id loginUsrId,Id DCRIds,String AccLst){
       // List<string> accLstFV = new List<string>();
        List<Id> areaLst = new List<Id>();
        system.debug('loginUsrId = '+loginUsrId);
        system.debug('DCRIds = '+DCRIds);
        system.debug('AccLst = '+AccLst);
        List<UserTerritory2Association> TerritoryUserObj = [Select Id, UserId, Territory2Id from UserTerritory2Association where UserId = : loginUsrId];
        List<Id> LstTerrIds = new List<Id>();
        for(UserTerritory2Association objTerrId : TerritoryUserObj)
        {
            LstTerrIds.add(objTerrId.Territory2Id);
        }
        List<Territory2> terrObj = [select Id, DeveloperName, Name from Territory2 where Id In : LstTerrIds ];
        List<DCR__c> dcrObj = [Select Id ,TerritoryName__c ,TerritoryId__c  from DCR__c where Id = : DCRIds Limit 1];
       system.debug('terrObj = '+terrObj);
        system.debug('dcrObj = '+dcrObj);
        if(dcrObj.size() > 0)
        {
            if(TerritoryUserObj.size() == 1)
            {
                dcrObj[0].TerritoryId__c = terrObj[0].Id;
                dcrObj[0].TerritoryName__c = terrObj[0].Name;
                Update dcrObj[0];
            }

            else if(TerritoryUserObj.size() > 1)
            {
                List<String> accLstFV = AccLst.split('::');
                
             /* List<DCR_Details__c> dcrDtlLst = [Select Id, TerritoryId__c ,TerritoryName__c ,DCR__c, Account_Name__c from DCR_Details__c where DCR__c = : DCRIds]; 
              system.debug('dcrDtlLst = '+dcrDtlLst);
             for(DCR_Details__c objFVAcc : dcrDtlLst)
             {
                if(objFVAcc.Account_Name__c != null)
                {
                    accLstFV.add(objFVAcc.Account_Name__c);
                }
            }*/
              system.debug('accLstFV = '+accLstFV);  
             List<Account> accObjLst = [Select Id, Name, Area__c from Account where Name in : accLstFV];
                system.debug('accObjLst = '+accObjLst);
             for(Account accObj : accObjLst)
             {
                areaLst.add(accObj.Area__c);
             }
               system.debug('areaLst = '+areaLst); 
             List<Area__c> areaObjjj = [Select Id, Territory_Id__c, Territory__c  from Area__c where Id in : areaLst];   
                for(Area__c areaObjAcc : areaObjjj)
                {
                    if(areaObjAcc.Territory_Id__c != null)
                    {
                         dcrObj[0].TerritoryId__c = areaObjAcc.Territory_Id__c;
                    }
                    if(areaObjAcc.Territory__c != null)
                    {
                     dcrObj[0].TerritoryName__c = areaObjAcc.Territory__c;
                    } 
               }
                Update dcrObj[0];
                System.debug('areaObjjj = '+dcrObj[0]);
            }
       }
    }
        
   @AuraEnabled
    public static void insertTerritoryToDCRDetails(Id DCRIdss){
        DCR__c dcrObj = [Select Id,TerritoryId__c,TerritoryName__c from DCR__c where Id = : DCRIdss Limit 1];
        List<DCR_Details__c> dcrDetailsToTerritory = [Select Id, Name, DCR__c from DCR_Details__c where DCR__c = : DCRIdss];
        for(DCR_Details__c dcrDtlobj : dcrDetailsToTerritory)
        {
            dcrDtlobj.TerritoryId__c = dcrObj.TerritoryId__c;
            dcrDtlobj.TerritoryName__c = dcrObj.TerritoryName__c;
        }
        Update dcrDetailsToTerritory;
        
    }
    
    @AuraEnabled
    public static void savevisit(string product, String dpid,String Id,String Name,String AccountTargetClass,string TypeAcc,String sampleGivenarr,String promoGivenarr,String visitStatusarr,string productIds,string sampleGvnIds,string Nextvisitdate,string Feedback )
    {        //savevisit({product,dpid,Id,Name,AccountTargetClass,sampleGivenarr,visitStatusarr:this.dataArray[i].visitStatusarr})
        system.debug('Inside save Method DCR Feedback = '+Feedback);
    system.debug('Inside save Method DCR Nextvisitdate = '+Nextvisitdate);
    DCR_Details__c Dpd = new DCR_Details__c();
    // Dpd.Account__c = Id;
    Dpd.Account_Name__c = Name;
    Dpd.Account_Class__c = AccountTargetClass;
        Dpd.Account_Type__c = TypeAcc;
    Dpd.DCR__c = dpid;
    /*if(checkin != null  && String.IsNotBlank(checkin))
    {
    Dpd.Check_in__c = convertVisitTime(checkin);
    }
   
    if(checkout != null  && String.IsNotBlank(checkout))
    {
    Dpd.Check_Out__c = convertVisitTime(checkout);
    }*/
    
    //Dpd.Purpose__c = purpose;
    //Dpd.Product_Promoted__c = productDetailingarr;
    Dpd.Sample_Given__c = sampleGivenarr;
        Dpd.ProductIds__c = productIds;
        Dpd.SampleGvnIds__c = sampleGvnIds;
        Dpd.Feedback__c = Feedback;
       if(Nextvisitdate == '')
        {
            system.debug('No Date');
        }
        else
        {
             Dpd.Next_Visit_Date__c = date.ValueOf(Nextvisitdate);
        }
       
    //Dpd.Promo_given__c = promoGivenarr;
    /*if(VisitTime != null)
    {
        if(VisitTime != '12:00 AM'){
          Dpd.Visit_Time__c = convertVisitTime(VisitTime);  
        }else{
           Dpd.Visit_Time__c = convertVisitTime('00:00:00') ;
        }
    
    }*/
    
    
    //Dpd.comments__c = comment;
    //Dpd.Manager_Accompany__c = managerAccompany;    
    Dpd.Visit_Status__c = visitStatusarr;
    Dpd.Activity_Type__c = 'Field Visit';
    Dpd.product__c = product;
    insert Dpd;
    System.debug('Dpd Inserted -----');
    
    }
    
    @AuraEnabled
    public static List<String> mngrAccompnyPrepopulate(Id tourPlanIdss){
        system.debug('inside saveMngr'+tourPlanIdss);
       Tour_Plan_Detail__c objTourPlanDtl = [select Id, Manager_Visit__c from Tour_Plan_Detail__c where Id = : tourPlanIdss];
        List<String> mngrAccompanyValues = new List<String>();
        List<String> usrlst = objTourPlanDtl.Manager_Visit__c.split(',  ');
        system.debug('usrlst = '+usrlst);
        
        List<User> usrlstMngrAcmp = [Select Id, Role_of_User__c , Name from User where Name In : usrlst];

        system.debug('usrlstMngrAcmp = '+usrlstMngrAcmp);
        
         string csmvalue = '';
       for(User usrObj : usrlstMngrAcmp)
       {
          
           if(usrObj.Role_of_User__c == 'CSM')
           {
               mngrAccompanyValues.add('CSM');
               
           }
           else if(usrObj.Role_of_User__c == 'DSM')
           {
                mngrAccompanyValues.add('DSM');
               
           }
           else if(usrObj.Role_of_User__c == 'RSM')
           {
                mngrAccompanyValues.add('RSM');
           }
           
       }
        system.debug('mngrAccompanyValues = '+mngrAccompanyValues);
        
       
        return mngrAccompanyValues;
    }
    
    @AuraEnabled
    public static void saveMngrAccompny(string dpid,string csm,string rsm,string dsm){
        system.debug('inside saveMngr'+csm);
        DCR__c dcrMngrAcc = [Select Id, ManagerAccompanied__c  from DCR__c where Id = : dpid];
        string newMngr = '';
        if(csm != 'false')
        {
            newMngr = 'CSM';
        }
        if(rsm != 'false')
        {
            newMngr = newMngr + ',RSM';
        }
        if(dsm != 'false')
        {
            newMngr = newMngr + ',DSM';
        }        
        dcrMngrAcc.ManagerAccompanied__c = newMngr;
         system.debug('inside saveMngr'+newMngr);
        update dcrMngrAcc;
    }
    
    
    @AuraEnabled
    public static void insertNewHQVisit(String dpId,string HqVisit,string VisitTime,string CheckIn,string CheckOut,string VisitStatus,string Comment)
    { 
    System.debug('VisitTime'+ VisitTime);
    if( HqVisit != null || VisitStatus != null || (CheckIn != null  && String.IsNotBlank(CheckIn)) || (CheckOut != null  && String.IsNotBlank(CheckOut)) || VisitTime != null || Comment != null)
    {
    DCR_Details__c DpdListNewHQVisit = new DCR_Details__c(); 
    DpdListNewHQVisit.DCR__c = dpId;
    DpdListNewHQVisit.HQ_Visit__c = HqVisit;
    DpdListNewHQVisit.Visit_Status__c = VisitStatus;
    if(CheckIn != null)
    {
    DpdListNewHQVisit.Check_in__c = convertVisitTime(CheckIn) ; //DCR__c
    }
    if(CheckOut != null)
    {
    DpdListNewHQVisit.Check_Out__c = convertVisitTime(CheckOut) ;
    }
   
    if(VisitTime != null)
    {
    DpdListNewHQVisit.Visit_Time__c = convertVisitTime(VisitTime) ;
    }
    DpdListNewHQVisit.comments__c = Comment;
    DpdListNewHQVisit.Activity_Type__c = 'HQ Visit';
    system.debug('DpdListNewHQVisit new = '+DpdListNewHQVisit);
    insert DpdListNewHQVisit; 
    }
    }
    
    @AuraEnabled
    public static void insertNewLeave(String dpId,string LeavePlan,string ActualLeave,string Comment)
    { 
    system.debug('dpId inSs = '+dpId);
    system.debug('LeavePlan insS = '+LeavePlan);
    system.debug('ActualLeave insS = '+ActualLeave);
    system.debug('Comment insS = '+Comment);
    
    if( LeavePlan != null || ActualLeave != null || Comment != null )
    {
    DCR_Details__c DpdListNewLeave = new DCR_Details__c(); 
    DpdListNewLeave.DCR__c = dpId; 
    DpdListNewLeave.Leave_Taken__c = LeavePlan;
    DpdListNewLeave.Actual_leave_plan__c = ActualLeave;
    DpdListNewLeave.comments__c = Comment ; 
    DpdListNewLeave.Activity_Type__c = 'Leave';
    insert DpdListNewLeave; 
    }
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
    }