global class Fon_ContactTriggers extends Framework.Domain { 
     public static boolean runContactTrigger = true;
  
    public Fon_ContactTriggers(List<Contact>sObjectList) { 
        super(sObjectList); 
        
    } 
    public override void beforeInsert() {
        if (runContactTrigger) {
            Fon_ContactTriggerHandler.handlebeforeInsert(records);
        }
    }
     public override void beforeUpdate(Map<Id, SObject> oldMap) {
        if (runContactTrigger) {
            Fon_ContactTriggerHandler.handlebeforeUpdate(
                (List<Contact>)records,
                (Map<Id, Contact>)oldMap
            );
  
        }
    }

    global class Constructor implements Framework.Domain.DomainConstructor { 
        public Framework.Domain construct(List<SObject> sObjectList) { 
            return new Fon_ContactTriggers(sObjectList); 
        } 
    } 
}