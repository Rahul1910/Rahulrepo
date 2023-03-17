public class ConvertLead {
    public static void convertRepliedLead(Lead leadObject){
        
        String nameOfCompany =leadObject.Company;
        Id accountId = null;
        if(nameOfCompany != null && String.isNotBlank(nameOfCompany) && String.isNotEmpty(nameOfCompany)){
            List<Account> accountList = AccountSelector.getAccountByName(nameOfCompany);
            if(accountList.size()>0){
                accountId=accountList[0].Id;
            }
        }
        
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(leadObject.id);                
        Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
        if(accountId != null){
           Leadconvert.accountid=accountId; 
        }
        MassLeadconvert.add(Leadconvert);
        List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
        
    }
}