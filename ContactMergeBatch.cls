global class ContactMergeBatch implements Database.Batchable<sObject>{
	global static Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id,Email from Contact');
    }
    
    global static void execute(Database.BatchableContext bc,List<Contact> myCon){
        for(Contact c : myCon){
            if(c.Id != null){
                List<Contact> mergeCon = [select Id,Email from Contact where Email =: c.Email And Id != :c.Id LIMIT 2];
                if(mergeCon.size() > 0){
                    try{
                        merge c mergeCon;
                    }catch(Exception e){
                        System.debug('Exception :'+e.getMessage());
                    }
                }
            } 
        }
    }
    
    global static void finish(Database.BatchableContext bc){
        System.debug('Finishing batch');
    }
}