global class EthosProfileUpdateBatch_Sch implements Schedulable {
    global void execute(SchedulableContext sc){
        EthosProfileUpdateBatch ethosBatch = new EthosProfileUpdateBatch();
        Database.executebatch(ethosBatch,1);
    }
}