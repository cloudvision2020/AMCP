global class UpdateMembershipAndContactFields_Sch implements Schedulable {
    global void execute(SchedulableContext sc){
        UpdateMembershipAndContactFieldsBatch updateBatch = new UpdateMembershipAndContactFieldsBatch();
        Database.executebatch(updateBatch);
    }
}