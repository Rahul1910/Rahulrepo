public with sharing class CSVController {

    @AuraEnabled
    public static string loadCSVData(Id contentDocumentId){

        ContentVersion contentVersionObj = [ SELECT Id, VersionData FROM 
                                             ContentVersion WHERE 
                                             ContentDocumentId =:contentDocumentId ];
        
         list<User> userlist=new list<User>();
         
         String data= contentVersionObj.VersionData.toString();

         string[] csvFileLines=data.split('\n');

         for(Integer i=1;i<csvFileLines.size();i++){            
            string[] csvRecordData = csvFileLines[i].split(',');
            
            User userObj = new User() ;
            userObj.LastName = csvRecordData[0] ;             
            userObj.Alias = csvRecordData[1];
            userObj.Username = csvRecordData[2];
            userObj.Email = csvRecordData[3];
          //  userObj.UserRoleId = csvRecordData[4];
            userObj.CommunityNickname = csvRecordData[4];
            userObj.ProfileId = csvRecordData[5];
            userObj.EmailEncodingKey = csvRecordData[6];
            userObj.TimeZoneSidKey = csvRecordData[7];
            userObj.LocaleSidKey = csvRecordData[8];
            userObj.LanguageLocaleKey = csvRecordData[9]; 
             
            Database.DMLOptions dmlo = new Database.DMLOptions();
			dmlo.EmailHeader.triggerUserEmail = true;
			dmlo.EmailHeader.triggerAutoResponseEmail= true;
			dmlo.EmailHeader.triggerOtherEmail = true;
			userObj.setOptions(dmlo);	            
                                                                                       
            userlist.add(userObj);   
        }
        insert userlist;

        return string.valueOf(userlist.size());
    

    }
}