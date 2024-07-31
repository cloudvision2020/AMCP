global class CaptureEngagementScoreHistoryBatch implements Database.Batchable<sObject>, Database.Stateful {
    global String contactId;
    global Database.QueryLocator start(Database.BatchableContext BC) {        
        List<String> fieldsApiNames = getFieldNames();
        String query = 'SELECT Id, ' + String.join(fieldsApiNames, ',') + ' FROM Contact';
        if(contactId !=null){
            query = 'SELECT Id, ' + String.join(fieldsApiNames, ',') + ' FROM Contact WHERE Id =:contactId';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contact> contacts) {
        List<Engagement_Score_Snapshot__c> essList = new List<Engagement_Score_Snapshot__c>();

        for(Contact contact: contacts){
            Engagement_Score_Snapshot__c ess = getEngagementScoreSnapshot(contact);
            essList.add(ess);
        }
        insert essList;
    }   
    global void finish(Database.BatchableContext BC) {
    }

    public static Engagement_Score_Snapshot__c getEngagementScoreSnapshot(Contact contact){
        Engagement_Score_Snapshot__c ess = new Engagement_Score_Snapshot__c();
        ess.Contact__c = contact.Id;
        ess.Engagement_Category__c = contact.Engagement_Category__c;
        ess.Overall_Engagement_Score__c = contact.Overall_Engagement_Score__c;
        ess.Membership_Engagement_Score__c = contact.Membership_Score__c;
        ess.Board_Committee_Score__c = contact.Board_Committee_Score__c;
        ess.Meetings_Large_Score__c = contact.Meetings_Large_Score__c;
        ess.Meetings_Small_Score__c = contact.Meetings_Small__c;
        ess.Meeting_Affiliate_Score__c = contact.Affiliate_Meetings__c;
        ess.AMCP_Webinar_Score__c = contact.AMCP_Webinar__c;
        ess.CE_Webinar_Score__c = contact.CE_Webinar__c;
        ess.PIE_Webinar_Score__c = contact.PIE_Webinar__c;
        ess.SIT_Webinar_Score__c = contact.SIT_Webinar__c;
        ess.Meeting_Virtual__c = contact.Virtual_Meetings__c;
        ess.AMCP_Learn_Products__c = contact.Learn_Product_Score__c;
        ess.AMCP_Learn_Certificate__c = contact.Ethos_Certification_Score__c;
        ess.Webinar_Score__c = contact.Webinar_Score__c;
        ess.Volunteer_Long_Term_Score__c = contact.Volunteer_Long_Term_Score__c;
        ess.Volunteer_Short_Term_Score__c = contact.Volunteer_Short_Term_Score__c;
        ess.Donation_Score__c = contact.Donation_Score__c;
        ess.Champion_Score__c = contact.Champion__c;

        return ess;
    }
    public static List<String>  getFieldNames(){
        List<String> fieldsApiNames = new List<String>();
        fieldsApiNames.add('Engagement_Category__c');
        fieldsApiNames.add('Overall_Engagement_Score__c');
        fieldsApiNames.add('OrderApi__Lifetime_Engagement_Score__c');
        fieldsApiNames.add('Board_Score__c');
        fieldsApiNames.add('Meetings_Small__c');
        fieldsApiNames.add('Meetings_Large_Score__c');
        fieldsApiNames.add('Affiliate_Meetings__c');
        fieldsApiNames.add('AMCP_Webinar__c');
        fieldsApiNames.add('CE_Webinar__c');
        fieldsApiNames.add('PIE_Webinar__c');
        fieldsApiNames.add('SIT_Webinar__c');
        fieldsApiNames.add('Virtual_Meetings__c');
        fieldsApiNames.add('Learn_Product_Score__c');
        fieldsApiNames.add('Learn_Product_Participation_Score__c');
        fieldsApiNames.add('Webinar_Score__c');
        fieldsApiNames.add('Volunteer_Long_Term_Score__c');
        fieldsApiNames.add('Volunteer_Short_Term_Score__c');
        fieldsApiNames.add('Donation_Score__c');
        fieldsApiNames.add('Champion__c');
        fieldsApiNames.add('Membership_Score__c');
        fieldsApiNames.add('Board_Committee_Score__c');
        fieldsApiNames.add('Ethos_Certification_Score__c');
        
        return fieldsApiNames;
    }
}