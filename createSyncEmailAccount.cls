public with sharing class createSyncEmailAccount {
    
    //This method is to register user with system
    @future(callout=true)
    public static void addSyncEmailAccount(Set<Id> syncEmailAccount) {

        //Get the token for authentication
        String token = getAccessToken.getAccessTokenFromTokenMgmt();
        //System.debug('Token : ' +token);

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:TIES_Sync_Email_Account');
        request.setMethod('POST');

        TIES_Header_Data__c TIES_headerData = TIES_Header_Data__c.getValues('TIES Header Data');
        
        request.setHeader('Content-Type',TIES_headerData.TIES_Content_Type__c);
        request.setHeader('buId',TIES_headerData.TIES_buId__c);
        request.setHeader('subbuid',TIES_headerData.TIES_subbuid__c);
        request.setHeader('environment',TIES_headerData.TIES_environment__c);
        request.setHeader('Applicationid',TIES_headerData.TIES_Applicationid__c); 
        request.setHeader('userlogin',TIES_headerData.TIES_userlogin__c);
        request.setHeader('issuer',TIES_headerData.TIES_issuer__c);
        request.setHeader('userId',TIES_headerData.TIES_userId__c);
        request.setHeader('Accept', TIES_headerData.TIES_Accept__c);
        request.setHeader('Token',token);
        
        List<Sync_Email_Account__c> emailAccount = [Select Id,emailId__c,syncPeriod__c,password__c,POP3_IMAP_Setting__c,POP3_IMAP_URL__c,syncPeriodType__c,Registration_Status__c,Registration_DateTime__c,LastModifiedDate,userId__c from Sync_Email_Account__c where Id In: syncEmailAccount WITH SECURITY_ENFORCED];
        List<Sync_Email_Error_Log__c> syncErrorLog = new List<Sync_Email_Error_Log__c>();
        //System.debug('Record size : ' + emailAccount.size());

        //Fetch the values from the sObject SyncEmailAccount
        for(Sync_Email_Account__c account : emailAccount) {  
            Integer portNumber;
            Integer syncPeriod = (Integer)account.syncPeriod__c;
            
            if(account.POP3_IMAP_Setting__c == 'pop3s'){
                portNumber = 995;
            }
            else {
                portNumber = 993;
            }

            if(account.syncPeriodType__c == 'Hours'){
                syncPeriod = syncPeriod * 60;
            }

            if(account.syncPeriodType__c == 'Days'){
                syncPeriod = syncPeriod * 1440;
            }

            String body = '{"requestInfo": {'+
            '"applicationId": "'+TIES_headerData.TIES_Applicationid__c+'",'+
            '"buId": "'+TIES_headerData.TIES_buId__c+'",'+
            '"subBuId": "'+TIES_headerData.TIES_subbuid__c+'",'+
            '"action": "'+TIES_headerData.TIES_action__c+'",'+
            '"environment": "'+TIES_headerData.TIES_environment__c+'",'+
            '"issuer": "'+TIES_headerData.TIES_issuer__c+'",'+
            '"userlogin": "'+TIES_headerData.TIES_userlogin__c+'",'+
            '"userId": "'+TIES_headerData.TIES_userId__c+'",'+
            '"token": "'+token+'",'+
            '"jtitoken": ""'+
            '},'+                
            '"details": {'+
            '"hostName": "'+account.POP3_IMAP_URL__c+'",'+
            '"portNumber": '+portNumber+','+
            '"emailAccountName": "'+account.emailId__c+'",'+
            '"password": "'+account.password__c+'",'+
            '"provider": "'+account.POP3_IMAP_Setting__c+'",'+ 
            '"frequencyInMin": "'+syncPeriod+'"'+
            '}}';
            //System.debug(body);

            request.setBody(body);
            HttpResponse response = http.send(request);

            //System.debug('Response : ' + response.getBody());
            Object status = '';
            Object reasonCode = '';
            Object reasonText = '';
			Integer partyId;
            
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){
                String jsonStr = response.getBody();
                Map<String,Object> responseObjectMap = (Map<String,Object>) JSON.deserializeUntyped(jsonStr);
				Map<String, Object> responseObject = (Map<String, Object>) responseObjectMap.get('responseObject');
                
                partyId = (Integer)responseObject.get('partyId');
                status = responseObjectMap.get('status');
                reasonCode = responseObjectMap.get('reasonCode');
                reasonText = responseObjectMap.get('reasonText');
                //System.debug('Response code : ' +response.getStatusCode());
                //System.debug('Status : ' + status);
                //System.debug('Reason code : ' + reasonCode);
                //System.debug('Reason text : ' + reasonText);
            }
            
            if(response.getStatusCode() == 200 && status == 'success' && reasonCode == '201' && reasonText == 'Successfully created.') {
                System.debug('Response code is 200ok');
                //System.debug('Email Account registered.');

                account.Registration_Status__c = 'Activated';
                account.PartyId__c = partyId;
                account.Registration_DateTime__c = account.LastModifiedDate;
            }

            else if(response.getStatusCode() == 400 && status == 'fail' && reasonText == 'Exception is:[AUTHENTICATIONFAILED] Invalid credentials (Failure)'){
                System.debug('Response code is 400');
                //System.debug('Invalid credentials.');
                account.Registration_Status__c = 'Invalid credentials';
                Sync_Email_Error_Log__c syncError = new Sync_Email_Error_Log__c();
                syncError.userId__c = account.userId__c;
                syncError.emailId__c = account.emailId__c;
                syncError.onEvent__c = 'Create Account';
                syncError.errorCode__c = String.valueOf(response.getStatusCode());
                syncError.errorMessage__c = 'Invalid credentials';
                syncError.Sync_Email_Account__c = account.Id;
                syncErrorLog.add(syncError);
            }  

            else if(response.getStatusCode() == 200 && status == 'fail' && reasonText == 'Email Data Already Exist'){
                //System.debug('Email already exist.');
                account.Registration_Status__c = 'Email already exist';
                Sync_Email_Error_Log__c syncError = new Sync_Email_Error_Log__c();
                syncError.userId__c = account.userId__c;
                syncError.emailId__c = account.emailId__c;
                syncError.onEvent__c = 'Create Account';
                syncError.errorCode__c = String.valueOf(response.getStatusCode());
                syncError.errorMessage__c = 'Email already exist';
                syncError.Sync_Email_Account__c = account.Id;
                syncErrorLog.add(syncError);
            }
            
            else {
                //System.debug('');
            }
        } 
        Database.update(emailAccount);

        if(syncErrorLog.size() > 0){
            Database.insert(syncErrorLog);
        }
        
    }
}