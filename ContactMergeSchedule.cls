public class ContactMergeSchedule implements Schedulable{
	public void execute(SchedulableContext sc){
        Database.executeBatch(new ContactMergeBatch());
    }
}