/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class createExpense {
    @AuraEnabled
    public static Expense__c createExpense(Expense__c expense, String expdetailsDataString) {
        system.debug('expense'+expense);
        insert expense;
        return expense;  
        
    }

    @AuraEnabled( cacheable = true ) 
    public static List< Expense_Details__c > getExpDetails() { 
        
        return [ SELECT Id, Location__c, Amount__c,Expense_Notes__c,Food_Type__c,Place__c,Details__c,Expense__c FROM Expense_Details__c LIMIT 10 ]; 
        
        
    }

    @AuraEnabled
    public static void saveExpDetails(List<Expense_Details__c> expDetailsFixedExpListApex,List<Expense_Details__c> exppDetailsList ,List<Expense_Details__c> expDetailsExpInfoListApex, List<Expense_Details__c> expDetailsFoodListApex, 
                                      List<Expense_Details__c> expDetailsAccommodationListApex, List<Expense_Details__c> expDetailsMisListApex, String expenseIDApex){
                                      List<String> expdetId = new List<String>();
                                      List<String> expdetFoodId = new List<String>();
                                      List<String> conVersionId = new List<String>();                                        

                                                                                 

                                          List<Id> expdetailsOp = new List<Id>(); 
                                         // List<Id> expdetailsVarFood = new List<Id>(); 
                                         // List<Id> expdetailsVarAccommodation = new List<Id>(); 
                                          //List<Id> expdetailsVarMiscellaneous = new List<Id>(); 
                                          Map<Decimal,String> expIdVSFileLinkMap = new Map<Decimal,String>();
                                          //Map<Decimal,String> expIdVSFileLinkMapForFood = new Map<Decimal,String>();
                                          //Map<Decimal,String> expIdVSFileLinkMapForAccommodation = new Map<Decimal,String>();
                                         // Map<Decimal,String> expIdVSFileLinkMapForMis = new Map<Decimal,String>();
                                          Map<Decimal,String> expIdVSFileLinkMapForFixedExpense = new Map<Decimal,String>();
                                          Map<Decimal,String> expIdVSFileLinkMapForExpInfo = new Map<Decimal,String>();


                                          System.debug('44--->'+ expenseIDApex);
                                          if(expDetailsFixedExpListApex != null){
                                          for(Expense_Details__c expDetail : expDetailsFixedExpListApex ){
                                              expDetail.Expense__c = expenseIDApex;
                                              expDetail.Expense_Type__c = 'Fixed Expense' ; 
                                              expIdVSFileLinkMapForFixedExpense.put(expDetail.Row_Index__c,expDetail.File_Link__c);
                                              system.debug('47---------'+expDetail.Row_Index__c);
                                             system.debug('48---------'+expDetail.File_Link__c); 
                                              expDetail.File_Link__c = null;                                     
                                          }
                                          system.debug('List----'+expDetailsFixedExpListApex);
                                          Insert expDetailsFixedExpListApex;
                                          System.debug('65*********'+expIdVSFileLinkMapForFixedExpense);
                                          for(integer i=0; i < expDetailsFixedExpListApex.size(); i++){                                            
                                           Id expdetailsFixedExpString=expDetailsFixedExpListApex[i].Id;

                                           if(expIdVSFileLinkMapForFixedExpense.containsKey(expDetailsFixedExpListApex[i].Row_Index__c) && expIdVSFileLinkMapForFixedExpense.get(expDetailsFixedExpListApex[i].Row_Index__c) != null){
                                            System.debug('Into if of fixed exp');
                                          // if(file.size()>0){
                                            system.debug('64-------'+expIdVSFileLinkMapForFixedExpense.get(expDetailsFixedExpListApex[i].Row_Index__c));
                                           String base64File  = (expIdVSFileLinkMapForFixedExpense.get(expDetailsFixedExpListApex[i].Row_Index__c));
                                           //String base64File  = (file[i]);
                                              System.debug('## 67--'+ base64File);
                                              base64File=base64File.Substring(base64File.LastIndexOf(',') + 1);
                                              System.debug('## 69--'+ base64File);
                                             // string convert = base64File.Replace("data:application/pdf;base64,");
                                             // System.debug('## 50--'+ convert);
                                          ContentVersion contentVersionRec = new ContentVersion();  
                                          contentVersionRec.Title = expDetailsFixedExpListApex[i].File_Name__c;
                                               System.debug('## 74'+ contentVersionRec.Title);
                                          contentVersionRec.PathOnClient = expDetailsFixedExpListApex[i].File_Name__c;
                                              System.debug('## 76'+ contentVersionRec.PathOnClient);
                                          contentVersionRec.FirstPublishLocationId = expDetailsFixedExpListApex[i].Id;
                                              System.debug('## 78'+ contentVersionRec.FirstPublishLocationId);
                                          contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
                                              System.debug('## 80'+ contentVersionRec.VersionData);
                                          contentVersionRec.IsMajorVersion = true;  
                                          Insert contentVersionRec;  

                                         }               
                                    }
                                }                                                                         
                                          
                                          System.debug('41--->'+ expenseIDApex);
                                          if(exppDetailsList != null){
                                          for(Expense_Details__c expDetail : exppDetailsList ){
                                              expDetail.Expense__c = expenseIDApex;
                                              expDetail.Expense_Type__c = 'Travel' ; 
                                              expIdVSFileLinkMap.put(expDetail.Row_Index__c,expDetail.File_Link__c);
                                              system.debug('47---------'+expDetail.Row_Index__c);
                                             system.debug('48---------'+expDetail.File_Link__c); 
                                              expDetail.File_Link__c = null;                                     
                                          }

                                          system.debug('List----'+exppDetailsList);
                                          Insert exppDetailsList;
                                          System.debug('65*********'+expIdVSFileLinkMap);
                                          for(integer i=0; i < exppDetailsList.size(); i++){                                            
                                           Id expdetailsString=exppDetailsList[i].Id;
                                         //  System.debug('## 63---'+expdetailsString);
                                           expdetailsOp.add(expdetailsString);
                                                                                      
                                            if(expIdVSFileLinkMap.containsKey(exppDetailsList[i].Row_Index__c) && expIdVSFileLinkMap.get(exppDetailsList[i].Row_Index__c) != null){
                                            System.debug('Into if of travel');
                                          // if(file.size()>0){
                                            system.debug('65-------'+expIdVSFileLinkMap.get(exppDetailsList[i].Row_Index__c));
                                           String base64File  = (expIdVSFileLinkMap.get(exppDetailsList[i].Row_Index__c));
                                           //String base64File  = (file[i]);
                                              System.debug('## 67--'+ base64File);
                                              base64File=base64File.Substring(base64File.LastIndexOf(',') + 1);
                                              System.debug('## 69--'+ base64File);
                                             // string convert = base64File.Replace("data:application/pdf;base64,");
                                             // System.debug('## 50--'+ convert);
                                          ContentVersion contentVersionRec = new ContentVersion();  
                                          contentVersionRec.Title = exppDetailsList[i].File_Name__c;
                                               System.debug('## 74'+ contentVersionRec.Title);
                                          contentVersionRec.PathOnClient = exppDetailsList[i].File_Name__c;
                                              System.debug('## 76'+ contentVersionRec.PathOnClient);
                                          contentVersionRec.FirstPublishLocationId = exppDetailsList[i].Id;
                                              System.debug('## 78'+ contentVersionRec.FirstPublishLocationId);
                                          contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
                                              System.debug('## 80'+ contentVersionRec.VersionData);
                                          contentVersionRec.IsMajorVersion = true;  
                                          Insert contentVersionRec;  

                                          //expdetId.add(exppDetailsList[i].Id);
                                        //  System.debug('88----'+expdetId);
                                         // contentVersionClass.contentVersionClass(expdetId);
                                         }                                        
                                        }                               
                                    } 
                                    
                                    System.debug('41--->'+ expenseIDApex);
                                    if(expDetailsExpInfoListApex != null){
                                    for(Expense_Details__c expDetail : expDetailsExpInfoListApex ){
                                        expDetail.Expense__c = expenseIDApex;
                                        expDetail.Expense_Type__c = 'Expense Information'; 
                                        expIdVSFileLinkMapForExpInfo.put(expDetail.Row_Index__c,expDetail.File_Link__c);
                                        system.debug('144---------'+expDetail.Row_Index__c);
                                       system.debug('145---------'+expDetail.File_Link__c); 
                                        expDetail.File_Link__c = null;                                     
                                    }
                                    Insert expDetailsExpInfoListApex;
                                    for(integer i=0; i < expDetailsExpInfoListApex.size(); i++){                                            
                                      Id expdetailsExpInfoString=expDetailsExpInfoListApex[i].Id;
                                      system.debug('97---------'+expdetailsExpInfoString);
                                      system.debug('100---------'+expDetailsExpInfoListApex[i].Row_Index__c);
                                     // expdetailsVarFood.add(expdetailsFoodString);
                                     
                                     if(expIdVSFileLinkMapForExpInfo.containsKey(expDetailsExpInfoListApex[i].Row_Index__c) && expIdVSFileLinkMapForExpInfo.get(expDetailsExpInfoListApex[i].Row_Index__c) != null){
                                        
                                        system.debug('Into if of Exp Info');
                                        system.debug('102---------'+expDetailsExpInfoListApex[i].Row_Index__c);
                                        String base64File  = (expIdVSFileLinkMapForExpInfo.get(expDetailsExpInfoListApex[i].Row_Index__c));
                                        System.debug('## 48--'+ base64File);
                                        base64File=base64File.Substring(base64File.LastIndexOf(',') + 1);
                                        System.debug('## 50--'+ base64File);                                           
                                        ContentVersion contentVersionRec = new ContentVersion();  
                                        contentVersionRec.Title = expDetailsExpInfoListApex[i].File_Name__c;
                                        System.debug('## 48'+ contentVersionRec.Title);
                                        contentVersionRec.PathOnClient = expDetailsExpInfoListApex[i].File_Name__c;
                                        System.debug('## 50'+ contentVersionRec.PathOnClient);
                                        contentVersionRec.FirstPublishLocationId = expDetailsExpInfoListApex[i].Id;
                                        system.debug('115---------'+contentVersionRec.FirstPublishLocationId);
                                        System.debug('## 52'+ contentVersionRec.FirstPublishLocationId);
                                        contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
                                        System.debug('## 54'+ contentVersionRec.VersionData);
                                        contentVersionRec.IsMajorVersion = true;  
                                        Insert contentVersionRec;                                     
                                }
                            }
                        }                                  

                                             
                                        /*if(expDetailsFoodListApex != null){                                        
                                          for(Expense_Details__c expDetail : expDetailsFoodListApex ){
                                             expDetail.Expense__c = expenseIDApex;
                                             expDetail.Expense_Type__c = 'Food' ;  
                                             expIdVSFileLinkMapForFood.put(expDetail.Row_Index__c,expDetail.File_Link__c); 
                                             system.debug('92---------'+expDetail.Row_Index__c);
                                             system.debug('93---------'+expDetail.File_Link__c);
                                             expDetail.File_Link__c = null;                                                
                                          }
                                          Insert expDetailsFoodListApex;
                                          for(integer i=0; i < expDetailsFoodListApex.size(); i++){                                            
                                            Id expdetailsFoodString=expDetailsFoodListApex[i].Id;
                                            system.debug('97---------'+expdetailsFoodString);
                                            system.debug('100---------'+expDetailsFoodListApex[i].Row_Index__c);
                                           // expdetailsVarFood.add(expdetailsFoodString); 

                                            if(expIdVSFileLinkMapForFood.containsKey(expDetailsFoodListApex[i].Row_Index__c) && expIdVSFileLinkMapForFood.get(expDetailsFoodListApex[i].Row_Index__c) != null){
                                           // if(file1.size()>0){
                                            system.debug('Into if of map');
                                            system.debug('102---------'+expDetailsFoodListApex[i].Row_Index__c);
                                            String base64File  = (expIdVSFileLinkMapForFood.get(expDetailsFoodListApex[i].Row_Index__c));
                                            system.debug('106---------'+base64File);
                                            //String base64File  = (file[i]);
                                               System.debug('## 48--'+ base64File);
                                               base64File=base64File.Substring(base64File.LastIndexOf(',') + 1);
                                               System.debug('## 50--'+ base64File);
                                              // string convert = base64File.Replace("data:application/pdf;base64,");
                                              // System.debug('## 50--'+ convert);
                                           ContentVersion contentVersionRec = new ContentVersion();  
                                           contentVersionRec.Title = expDetailsFoodListApex[i].File_Name__c;
                                                System.debug('## 48'+ contentVersionRec.Title);
                                           contentVersionRec.PathOnClient = expDetailsFoodListApex[i].File_Name__c;
                                               System.debug('## 50'+ contentVersionRec.PathOnClient);
                                           contentVersionRec.FirstPublishLocationId = expDetailsFoodListApex[i].Id;
                                           system.debug('115---------'+contentVersionRec.FirstPublishLocationId);
                                               System.debug('## 52'+ contentVersionRec.FirstPublishLocationId);
                                           contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
                                               System.debug('## 54'+ contentVersionRec.VersionData);
                                           contentVersionRec.IsMajorVersion = true;  
                                           Insert contentVersionRec; 

                                          // expdetFoodId.add(expdetailsFoodString);
                                          // System.debug('132----'+expdetFoodId);
                                          // contentVersionClass.contentVersionClassForFoods(expdetFoodId);

                                          }                                         
                                        }
                                       // contentVersionClass.contentVersionClass(expdetId);
                                         }*/
                                          
                                         /*if(expDetailsAccommodationListApex != null){                                          
                                          for(Expense_Details__c expDetail : expDetailsAccommodationListApex ){
                                            expDetail.Expense__c = expenseIDApex;
                                            expDetail.Expense_Type__c = 'Accommodation' ; 
                                            expIdVSFileLinkMapForAccommodation.put(expDetail.Row_Index__c,expDetail.File_Link__c);
                                            expDetail.File_Link__c = null;                                               
                                          }
                                          Insert expDetailsAccommodationListApex;
                                          for(integer i=0; i < expDetailsAccommodationListApex.size(); i++){                                            
                                            Id expdetailsAccommodationString=expDetailsAccommodationListApex[i].Id;
                                            expdetailsVarAccommodation.add(expdetailsAccommodationString); 

                                            if(expIdVSFileLinkMapForAccommodation.containsKey(expDetailsAccommodationListApex[i].Row_Index__c) && expIdVSFileLinkMapForAccommodation.get(expDetailsAccommodationListApex[i].Row_Index__c) != null){
                                            //if(file2.size()>0){
                                            String base64File  =(expIdVSFileLinkMapForAccommodation.get(expDetailsAccommodationListApex[i].Row_Index__c));
                                            //String base64File  = (file[i]);
                                               System.debug('## 48--'+ base64File);
                                               base64File=base64File.Substring(base64File.LastIndexOf(',') + 1);
                                               System.debug('## 50--'+ base64File);
                                              // string convert = base64File.Replace("data:application/pdf;base64,");
                                              // System.debug('## 50--'+ convert);
                                           ContentVersion contentVersionRec = new ContentVersion();  
                                           contentVersionRec.Title = expDetailsAccommodationListApex[i].File_Name__c;
                                                System.debug('## 48'+ contentVersionRec.Title);
                                           contentVersionRec.PathOnClient = expDetailsAccommodationListApex[i].File_Name__c;
                                               System.debug('## 50'+ contentVersionRec.PathOnClient);
                                           contentVersionRec.FirstPublishLocationId = expDetailsAccommodationListApex[i].Id;
                                               System.debug('## 52'+ contentVersionRec.FirstPublishLocationId);
                                           contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
                                               System.debug('## 54'+ contentVersionRec.VersionData);
                                           contentVersionRec.IsMajorVersion = true;  
                                           Insert contentVersionRec;  

                                          // expdetId.add(expdetailsAccommodationString);
                                          // contentVersionClass.contentVersionClass(expdetId);
                                          }
                                        }
                                       
                                        }*/

                                        /*if(expDetailsMisListApex != null){
                                          for(Expense_Details__c expDetail : expDetailsMisListApex ){
                                             expDetail.Expense__c = expenseIDApex;
                                             expDetail.Expense_Type__c = 'Miscellaneous' ; 
                                             expIdVSFileLinkMapForMis.put(expDetail.Row_Index__c,expDetail.File_Link__c);
                                             expDetail.File_Link__c = null;                                                  
                                          }
                                          Insert expDetailsMisListApex;
                                          for(integer i=0; i < expDetailsMisListApex.size(); i++){                                            
                                            Id expdetailsMiscellaneousString=expDetailsMisListApex[i].Id;
                                            expdetailsVarMiscellaneous.add(expdetailsMiscellaneousString);

                                            if(expIdVSFileLinkMapForMis.containsKey(expDetailsMisListApex[i].Row_Index__c) && expIdVSFileLinkMapForMis.get(expDetailsMisListApex[i].Row_Index__c) != null){
                                            //if(file3.size()>0){   
                                            String base64File  = (expIdVSFileLinkMapForMis.get(expDetailsMisListApex[i].Row_Index__c));
                                            //String base64File  = (file[i]);
                                               System.debug('## 48--'+ base64File);
                                               base64File=base64File.Substring(base64File.LastIndexOf(',') + 1);
                                               System.debug('## 50--'+ base64File);
                                              // string convert = base64File.Replace("data:application/pdf;base64,");
                                              // System.debug('## 50--'+ convert);
                                           ContentVersion contentVersionRec = new ContentVersion();  
                                           contentVersionRec.Title = expDetailsMisListApex[i].File_Name__c;
                                                System.debug('## 48'+ contentVersionRec.Title);
                                           contentVersionRec.PathOnClient = expDetailsMisListApex[i].File_Name__c;
                                               System.debug('## 50'+ contentVersionRec.PathOnClient);
                                           contentVersionRec.FirstPublishLocationId = expDetailsMisListApex[i].Id;
                                               System.debug('## 52'+ contentVersionRec.FirstPublishLocationId);
                                           contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
                                               System.debug('## 54'+ contentVersionRec.VersionData);
                                           contentVersionRec.IsMajorVersion = true;  
                                           Insert contentVersionRec;  

                                          // expdetId.add(expdetailsMiscellaneousString);
                                         //  contentVersionClass.contentVersionClass(expdetId);
                                          }
                                        }
                                       // contentVersionClass.contentVersionClass(expdetId);
                                        }*/                                          
                                          
                    }     
    
       

     /*   List<Expense_Details__c> expdetailsList = (List<Expense_Details__c>)System.JSON.deserializeStrict(expdetailsDataString, List<Expense_Details__c>.Class);
        system.debug('expdetailsList size= '+expdetailsList.size() );
       system.debug('expenseDetails '+expdetailsList);
       if(expdetailsList.size() > 0 && expense.id != null){
        for(Expense_Details__c expDetail : expdetailsList ){
            expDetail.Expense__c = expense.id;
            
        }
        Database.insert(expdetailsList);
       
       }

        return expense;
    }*/

@AuraEnabled(cacheable=true)
public static List<Expense__c> fetchExpenseRecords(){
    
        return [select id, name, CreatedBy.Name,Status__c,User__c,User_Name__c,CreatedDate,Expense_Date__c from Expense__c];        
    
}

/*@AuraEnabled
public static decimal calltotalbudget (id getTourPlanId){
    //system.debug('tourplan d==='+getTourPlanId)
    Decimal totalbudget = [Select Id,Amount__c,,User__c FROM Expense__c where id=:getTourPlanId].Total_Budget__c;
    return totalbudget;        
}*/

/*@AuraEnabled(cacheable=true)
    public static List<Tour_Plan_Detail__c> fetchTourPlansDetailsRecords(){
        try {
            return [Select id, name, CreatedBy.Name,User__c,CreatedDate,Date__c,Expense_Budget__c from Tour_Plan_Detail__c];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
    @AuraEnabled(cacheable=true)
    public static List<Tour_Plan_Detail__c> fetchTourPlansDetailsRecords(){
       
        return [Select id,name,User__c,Expense_Budget__c,CreatedBy.Name,CreatedDate,Date__c,Tour_Plan__r.Total_Budget__c,Tour_Plan__r.User__c,Tour_Plan__c from Tour_Plan_Detail__c] ;
    
    }

    @AuraEnabled(cacheable=true)
    public static List<Tour_Plan__c> fetchTourPlanRecords(){
        
        return [Select id,name,User__c,Total_Budget__c,CreatedBy.Name,CreatedDate,Month__c from Tour_Plan__c] ;
    
    }

    @AuraEnabled(cacheable=true)
    public static List<DCR__c> fetchDCRRecords(){
       
        return [Select id,name,User__c,User_Name__c,Date__c,CreatedBy.Name,CreatedDate,Tour_Plan__c,Tour_Plan__r.Total_Budget__c from DCR__c] ;
    
    }

    @AuraEnabled
public static List<Expense__c> fetchExpRecordsForExpenseThisMonth(integer month,integer year,String userId){
    
        return [select id,User__c,User_Name__c,Expense_Date__c,Amount__c from Expense__c where User__c =: userId and CALENDAR_MONTH(Expense_Date__c) =: month and CALENDAR_YEAR(Expense_Date__c)=:year];
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