public class WHProfileDisclosure {
    
        public List<FieldFmFinancialRelationships> field_fm_financial_relationships;
        public Boolean field_fm_disclose;
        public String pid;
        public String vid;
        public ProfileDisclosureType type;
        public String label;
        public String created;
        public String changed;
        public String url;
        public ProfileDisclosureUser user;
        public String feeds_item_guid;
        public String feeds_item_url;
        public String feed_nid;

        public class FieldFmFinancialRelationships {
            public String uri;
            public String id;
            public String resource;
            public String uuid;
        }

        public class ProfileDisclosureType {
            public String uri;
            public String id;
            public String resource;
        }

        public class ProfileDisclosureUser {
            public String uri;
            public String id;
            public String resource;
            public String uuid;
        }
    }