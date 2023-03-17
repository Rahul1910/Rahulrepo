public class ContactSelector {
    
    public Static List<Contact> getContactByEmailId(String email){
    List<Contact> contactList = [SELECT Id, Name, Email,hasOptedOutOfEmail
                                 FROM Contact
                                 WHERE Email = :email
                                 LIMIT 1];
     System.debug('contactList');
     return contactList;
    }

}