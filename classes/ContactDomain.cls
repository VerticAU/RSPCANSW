public without sharing class ContactDomain extends fflib_SObjectDomain implements fflib_ISObjectDomain {

    public ContactDomain(List<Contact> sObjectList) {
        super(sObjectList);
        this.Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ContactDomain(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        this.formatContacts(this.Records);
    }
    public override void onAfterInsert() {}
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        this.formatContacts(this.Records);
    }
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {}


    public void formatContacts(List<Contact> contacts){
        for(Contact contact : contacts){
            this.formatContact(contact);
        }
        this.formatPhones(contacts);
    }

    public void formatContact(Contact contact){
        contact.MiddleName = contact.MiddleName != null ? contact.MiddleName.replace('.', '') : null;
        contact.Email = contact.Email != null ? contact.Email.toLowerCase() : null;

        contact.MailingCity = this.capitalizeAllWords(contact.MailingCity);
        if(!String.isBlank(contact.MailingState) && !contact.MailingState.isAllUpperCase()){
            contact.MailingState = this.formatState(contact.MailingState);
        }

        if(!String.isBlank(contact.MailingStreet)){ this.splitStreet(contact); }
    }

    private void splitStreet(Contact contact){
        List<String> lines = new List<String>();

        if(contact.MailingStreet.contains('\r\n')){
            lines = contact.MailingStreet.split('\r\n');
        } else if (contact.MailingStreet.contains('\n')){
            lines = contact.MailingStreet.split('\n');
        }

        if(lines.size() > 1){
            contact.Mailing_Street_Line_1__c = lines[0];
            contact.Mailing_Street_Line_2__c = lines[1];
        } else {
            contact.Mailing_Street_Line_1__c = contact.MailingStreet;
        }
    }

    public void formatPhones(List<Contact> contacts){
        vertic_Utils.IPhoneNumberFormatter mobileFormatter = new vertic_Utils.MobilePhoneNumberFormatter();
        vertic_Utils.IPhoneNumberFormatter homeFormatter = new vertic_Utils.HomePhoneNumberFormatter();
        Map<Schema.sObjectField, vertic_Utils.IPhoneNumberFormatter> formatMapping = new Map<Schema.sObjectField, vertic_Utils.IPhoneNumberFormatter>{
            Contact.MobilePhone.getDescribe().getSobjectField() => mobileFormatter,
            Contact.HomePhone.getDescribe().getSobjectField() => homeFormatter,
            Contact.npe01__WorkPhone__c.getDescribe().getSobjectField() => homeFormatter,
            Contact.OtherPhone.getDescribe().getSobjectField() => homeFormatter
        };
        vertic_Utils.formats.formatPhoneNumbers(contacts, formatMapping, true);
    }

    public String capitalizeAllWords(String text){
        if(text == null){ return null; }

        List<String> words = text.split(' ');
        for (Integer i = 0; i < words.size(); i++){
            words[i] = words[i].capitalize();
        }
        return String.join(words, ' ');
    }

    public String formatState(String suburb){
        if(suburb == null || String.isEmpty(suburb)){ return null; }

        Map<String, String> stateAbbr = new Map<String, String>{
            'newsouthwales' => 'NSW',
            'queensland' => 'QLD',
            'northernterritory' => 'NT',
            'southaustralia' => 'SA',
            'westernaustralia' => 'WA',
            'victoria' => 'VIC',
            'tasmania' => 'TAS',
            'australiancapitalterritory' => 'ACT',
            'nsw' => 'NSW',
            'qld' => 'QLD',
            'nt' => 'NT',
            'sa' => 'SA',
            'wa' => 'WA',
            'vic' => 'VIC',
            'tas' => 'TAS',
            'act' => 'ACT'
        };

        String formattedState = stateAbbr.get(suburb.toLowerCase().trim().deleteWhitespace());
        return formattedState == null ? suburb : formattedState;
    }
}