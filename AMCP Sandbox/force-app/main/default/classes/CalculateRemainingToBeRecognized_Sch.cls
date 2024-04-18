global class CalculateRemainingToBeRecognized_Sch implements Schedulable {
    global void execute(SchedulableContext sc){
        CalculateRemainingToBeRecognizedBatch calculateRemainingBatch = new CalculateRemainingToBeRecognizedBatch();
        Database.executebatch(calculateRemainingBatch);
    }
}