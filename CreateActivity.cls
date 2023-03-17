public class CreateActivity {
@AuraEnabled
    public static void CreateActivityContact(string ContactId) 
    {
      List<Task> taskList = new List<Task>();
       // system.debug(ContactId);
        List<contact> contactList = [SELECT Id,AccountId,Account.Ownerid FROM contact WHERE id =:ContactId];
       // system.debug(contactList);
        for(contact acc:contactList){
            Task first1Task = new Task();
            first1Task.Subject = 'LinkedIn Profile-Day1';
            first1Task.Type = 'Email';
            first1Task.Status = 'Not Started';
            first1Task.Priority = 'Normal';
            first1Task.OwnerId = acc.Account.OwnerId;
            first1Task.WhatId = acc.AccountId;
            first1Task.WhoId = acc.Id;
          //  first1Task.ActivityDate = system.today().addDays(0);
            taskList.add(first1Task);
            
            Task firstTask = new Task();
            firstTask.Subject = 'Email 1-Day 1';
            firstTask.Type = 'Email';
            firstTask.Status = 'Not Started';
            firstTask.Priority = 'Normal';
            firstTask.OwnerId = acc.Account.OwnerId;
            firstTask.WhatId = acc.AccountId;
            firstTask.WhoId = acc.Id;
           // firstTask.ActivityDate = system.today().addDays(0);
            taskList.add(firstTask);
            
            Task secondTask = new Task();
            secondTask.Subject = 'Email 2 - Day 3';
            secondTask.Type = 'Email';
            secondTask.Status = 'Not Started';
            secondTask.Priority = 'Normal';
            secondTask.OwnerId = acc.Account.OwnerId;
            secondTask.WhatId = acc.AccountId;
            secondTask.WhoId = acc.Id;
         //   secondTask.ActivityDate = system.today().addDays(2);
            taskList.add(secondTask);
            
            Task thirdTask = new Task();
            thirdTask.Subject = 'Linkedin Request -Day 5';
            thirdTask.Type = 'Others';
            thirdTask.Status = 'Not Started';
            thirdTask.Priority = 'Normal';
            thirdTask.OwnerId = acc.Account.OwnerId;
            thirdTask.WhatId = acc.AccountId;
            thirdTask.WhoId = acc.Id;
           // thirdTask.ActivityDate = system.today().addDays(4);
            taskList.add(thirdTask);
            
            Task fourthTask = new Task();
            fourthTask.Subject = 'Email 3 - Day 7';
            fourthTask.Type = 'Email';
            fourthTask.Status = 'Not Started';
            fourthTask.Priority = 'Normal';
            fourthTask.OwnerId = acc.Account.OwnerId;
            fourthTask.WhatId = acc.AccountId;
            fourthTask.WhoId = acc.Id;
//            fourthTask.ActivityDate = system.today().addDays(6);
            taskList.add(fourthTask);
            
            Task fifthTask = new Task();
            fifthTask.Subject = 'Call 1 - Day 9';
            fifthTask.Type = 'Call';
            fifthTask.Status = 'Not Started';
            fifthTask.Priority = 'Normal';
            fifthTask.OwnerId = acc.Account.OwnerId;
            fifthTask.WhatId = acc.AccountId;
            fifthTask.WhoId = acc.Id;
           // fifthTask.ActivityDate = system.today().addDays(8);
            taskList.add(fifthTask);
            
            Task sixthTask = new Task();
            sixthTask.Subject = 'Email 4 -Day 11';
            sixthTask.Type = 'Email';
            sixthTask.Status = 'Not Started';
            sixthTask.Priority = 'Normal';
            sixthTask.OwnerId = acc.Account.OwnerId;
            sixthTask.WhatId = acc.AccountId;
            sixthTask.WhoId = acc.Id;
           // sixthTask.ActivityDate = system.today().addDays(10);
            taskList.add(sixthTask);
            
            Task seventhTask = new Task();
            seventhTask.Subject = 'Email 5 - Day 13';
            seventhTask.Type = 'Email';
            seventhTask.Status = 'Not Started';
            seventhTask.Priority = 'Normal';
            seventhTask.OwnerId = acc.Account.OwnerId;
            seventhTask.WhatId = acc.AccountId;
            seventhTask.WhoId = acc.Id;
           // seventhTask.ActivityDate = system.today().addDays(12);
            taskList.add(seventhTask);
            
            Task eighthTask = new Task();
            eighthTask.Subject = 'Call 2 -Day 15';
            eighthTask.Type = 'Call';
            eighthTask.Status = 'Not Started';
            eighthTask.Priority = 'Normal';
            eighthTask.OwnerId = acc.Account.OwnerId;
            eighthTask.WhatId = acc.AccountId;
            eighthTask.WhoId = acc.Id;
           // eighthTask.ActivityDate = system.today().addDays(14);
            taskList.add(eighthTask);
            
            Task ninethTask = new Task();
            ninethTask.Subject = 'Call 3 -Day 17';
            ninethTask.Type = 'Call';
            ninethTask.Status = 'Not Started';
            ninethTask.Priority = 'Normal';
            ninethTask.OwnerId = acc.Account.OwnerId;
            ninethTask.WhoId = acc.Id;
            ninethTask.WhatId = acc.AccountId;
          //  ninethTask.ActivityDate = system.today().addDays(16);
            taskList.add(ninethTask);
            
            Task tenthTask = new Task();
            tenthTask.Subject = 'Email 6 -Day 19';
            tenthTask.Type = 'Email';
            tenthTask.Status = 'Not Started';
            tenthTask.Priority = 'Normal';
            tenthTask.OwnerId = acc.Account.OwnerId;
            tenthTask.WhatId = acc.AccountId;
            tenthTask.WhoId = acc.Id;
          //  tenthTask.ActivityDate = system.today().addDays(18);
            taskList.add(tenthTask);
            
        }
        if(taskList != null && taskList.size()>0){
            insert taskList;
        }  
}
}