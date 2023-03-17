public class CreateTask {
    
    public class leadParam{
        @InvocableVariable(required=true)
        public Id LeadId;
        @InvocableVariable(required=true)
        public Id campaignId;
        @InvocableVariable(required=true)
        public Date emailTriggerDate; 
        @InvocableVariable(required=true)
        public Integer noOfEmail;
        @InvocableVariable(required=true)
        public string leadAuthorityContry;
        @InvocableVariable(required=true)
        public integer noOfDaysGap;
    }
    
    
    @InvocableMethod
    public static void CreateTaskForLead(leadParam[] leadParam)
    {
        List<Task> taskList =new List<Task>();
        List<Id> leadIdList =new List<Id>();
        Map<Id,Date> leadIdVsDate = new Map<Id,Date>();
        Map<Id,Id> leadIdVsCampId = new Map<Id,Id>();
        Map<Id,Integer> campIdVsNoOfEmail = new Map<Id,integer>();
        Map<Id,Integer> campIdVsNoOfDaysGapMap = new Map<Id,Integer>();
        Map<Id,string> leadIdVsCountry = new Map<Id,string>();
        Map<String,List<Date>> countryVsHolidayListMap = new Map<String,List<Date>>();
        List<Lead> leadForUpdateList= new List<Lead>();
        List<Campaign> campaignForUpdateList= new List<Campaign>();
        Map<Id,integer> leadIdVsNoOfEmailSentMap = new Map<Id,integer>();
        Map<Id,integer> campIdVsNoOfEmailSentMap = new Map<Id,integer>();
        String usa = System.Label.USA; 
        String india = System.Label.India; 
        
        
        if(leadParam != null && leadParam.size()>0){
            for(integer i = 0 ; i < leadParam.size();i++ ){
                Id leadId = leadParam[i].LeadId;
                Id campaignId = leadParam[i].campaignId;
                Date emailTriggerDate = leadParam[i].emailTriggerDate;
                integer noOfEmail = leadParam[i].noOfEmail;
                string leadCountry = leadParam[i].leadAuthorityContry;
                integer noOfDaysGap = leadParam[i].noOfDaysGap;
                
                leadIdVsDate.put(leadId,emailTriggerDate);
                leadIdVsCampId.put(leadId,campaignId);
                campIdVsNoOfEmail.put(campaignId,noOfEmail);
                leadIdVsCountry.put(leadId,leadCountry);
                campIdVsNoOfDaysGapMap.put(campaignId,noOfDaysGap);
                
                
            }
        }
        
        // Generate Holiday List Country Wise
        if(leadIdVsCountry != null) {
            List<String> authorityCountriesList = leadIdVsCountry.values(); 
            System.debug('Countries : '+ authorityCountriesList);
            if(authorityCountriesList != null && authorityCountriesList.size()>0){
                countryVsHolidayListMap = TaskDomain.getHolidayList();
            } 
        }
        System.debug('countryVsHolidayListMap'+countryVsHolidayListMap);
        
        for(Id leadId : leadIdVsDate.keySet()){
            
            id campId = leadIdVsCampId.get(leadId);
            integer noOfMail =campIdVsNoOfEmail.get(campId); 
            Date emailDate =leadIdVsDate.get(leadId);
            integer noOfDaysGap = campIdVsNoOfDaysGapMap.get(campId);
            string authorityCountry = leadIdVsCountry.get(leadId);
            Date nextDate = emailDate;
            List<Date> holidayList =new List<Date>();
            
            if(authorityCountry.equalsIgnoreCase(usa)){
                if(countryVsHolidayListMap.containsKey(authorityCountry)){
                   holidayList.addAll(countryVsHolidayListMap.get(authorityCountry));    
                }
            }
            if(authorityCountry.equalsIgnoreCase(india)){
                if(countryVsHolidayListMap.containsKey(authorityCountry)){
                   holidayList.addAll(countryVsHolidayListMap.get(authorityCountry));    
                }
            }
            
            for(integer i = 0 ; i< noOfMail ; i++){
                //Date  dateForEmail;
                Date dateForEmail = TaskDomain.generateValidDate(nextDate,holidayList); 
                
                /*
                if(holidayList.size()>0){
                   dateForEmail = TaskDomain.generateValidDate(nextDate,holidayList); 
                }else{
                    dateForEmail = nextDate;
                }*/
               
                DateTime emailFollowUpDate = TaskDomain.generateDateWithTime(dateForEmail,authorityCountry);
                 
                
                System.debug('emailFollowUpDate'+emailFollowUpDate);
                integer count = i+1;
                Task taskObject = new Task();
                taskObject.WhoId=leadId;
                taskObject.Email_Send_Date_Time__c =emailFollowUpDate;
                taskObject.Subject='Follow Up Email '+count;
                taskObject.Campaign__c=campId;
                taskObject.Task_Type__c='Followup Email';
               // taskObject.Task_Type__c='Followup Email';
                if(emailFollowUpDate < System.today()){
                    taskObject.Email_Sent__c=true; 
                    taskObject.Status='Completed';
                    
                    // Calculate no of sent email on Lead 
                    if(leadIdVsNoOfEmailSentMap.containsKey(leadId)){
                        integer noOfSentEmail = leadIdVsNoOfEmailSentMap.get(leadId);
                        noOfSentEmail= noOfSentEmail + 1; 
                        leadIdVsNoOfEmailSentMap.put(leadId,noOfSentEmail);
                    }else{
                        leadIdVsNoOfEmailSentMap.put(leadId,1); 
                    }
                    
                    if(campIdVsNoOfEmailSentMap.containsKey(campId)){
                        integer noOfSentEmail = campIdVsNoOfEmailSentMap.get(campId);
                        noOfSentEmail= noOfSentEmail + 1; 
                        campIdVsNoOfEmailSentMap.put(campId,noOfSentEmail);
                    }else{
                        campIdVsNoOfEmailSentMap.put(campId,1); 
                    }
                     
                }
                
                taskList.add(taskObject);
                System.debug('nextDate'+nextDate);
                System.debug('noOfDaysGap'+noOfDaysGap);
                
                integer emailGap = noOfDaysGap+1;
                
                // created next Date
                //nextDate = dateForEmail.addDays(emailGap);
                nextDate=LeadDomain.AddBusinessDays(dateForEmail, emailGap,holidayList);
                
                System.debug('nextDate'+nextDate);
                
            }
            System.debug('taskList'+taskList);
            leadIdList.add(leadId);
        }
        if(taskList.size()>0){
            insert taskList;
        }
        
        for(Id id : leadIdList){
            Lead leadObject = new Lead();
            leadObject.Id=id;
            leadObject.FollowUp_Email_Task_Created__c=true;
            if(leadIdVsNoOfEmailSentMap.containsKey(id)){
                leadObject.Total_Mail_Sent__c= leadIdVsNoOfEmailSentMap.get(id);
            }
            leadForUpdateList.add(leadObject);
        }
        
        // Update Lead
        if(leadForUpdateList != null && leadForUpdateList.size()>0){
            update leadForUpdateList;
        }
        
        List<Campaign> campList = CampaignSelector.getCampaign(campIdVsNoOfEmailSentMap.keySet());
        for(Campaign camp : campList){
            Campaign campObject = new Campaign();
            campObject.Id=camp.id;
            if(campIdVsNoOfEmailSentMap.containsKey(camp.Id)){
                integer noOfEmail = campIdVsNoOfEmailSentMap.get(camp.Id);
                if(camp.Total_Mail_Sent__c == null ){
                   camp.Total_Mail_Sent__c = 0; 
                }
                noOfEmail = noOfEmail + Integer.valueOf(camp.Total_Mail_Sent__c);
                campObject.Total_Mail_Sent__c = noOfEmail;
            }
            campaignForUpdateList.add(campObject);
        }
      
        if(campaignForUpdateList.size()>0){
           update campaignForUpdateList; 
        }
        System.debug('taskList'+taskList);
    }
    
    
    
    
    
    
    
}