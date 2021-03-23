public without sharing class UpdateTaskOwnerBatch implements Database.Batchable<sObject> {

    private Map<String, String> TQFullNameMap = new Map<String, String>{
        'amyb' => 'Amy Brown',
        'Taylor' => 'Taylor Mahoney',
        'LisaJ' => 'Lisa Jenkins',
        'Mel' => 'Melanie Parent',
        'Rochelle' => 'Rochelle Van De Merwe (Temp)',
        'Alia' => 'Alia Alhafny',
        'Domenica' => 'Domenica Nascimento',
        'RebeccaC' => 'Rebecca Crompton',
        'Lisa' => 'Lisa Gledhill',
        'Larry' => 'Larry Jones',
        'Julie' => 'Julie Valenta',
        'Charmaine' => 'Charmaine Labindao',
        'Kristy' => 'Kristy Blake',
        'Melaniev' => 'Melanie Verges',
        'Felicity' => 'Felicity Chisolm',
        'Rachel' => 'Rachel English/Partridge',
        'Venus' => 'Venus Carrasco',
        'LisaM' => 'Lisa Mitchell',
        'Natasha' => 'Natasha Wilton',
        'Esther' => 'Esther Krizmancic',
        'HelenT' => 'Helen Trussler',
        'Carla' => 'Carla Mirabilio',
        'Danielle' => 'Danielle Cameron',
        'NatashaG' => 'Natasha Gebron',
        'Michael' => 'Michael Buckingham',
        'Maria' => 'Maria Natera',
        'Jacqui' => 'Jacqui Ross',
        'Ninda' => 'Ninda Nusantara',
        'Malcolm' => 'Malcolm Wilbow',
        'Michele' => 'Michelle Robson',
        'GabbyM' => 'Gabrielle Mills',
        'KristyP' => 'Kristy Partridge',
        'AnneK' => 'Anne Keyvar',
        'Veronica' => 'Veronica Francken',
        'ShazT' => 'Sharon Tinant (volunteer)',
        'RachelM' => 'Rachel Morton (volunteer)',
        'Sharon' => 'Sharon Salt (volunteer)',
        'David' => 'David Dubin',
        'VeronikaS' => 'Veronika Sanobova (volunteer)',
        'Linda' => 'Linda Foley (volunteer)',
        'Laura' => 'Laura Zeljeznjak',
        'LisaH' => 'Lisa Hardwidge',
        'Nicky' => 'Nicky Kim-McCormack',
        'Desleigh' => 'Desleigh White',
        'Zac' => 'Zac Gough',
        'Sarah' => 'Sarah Nagle',
        'KatieW' => 'Katie Wong (volunteer)',
        'Olivia' => 'Olivia Behan',
        'Steve' => 'Steve Coleman',
        'Paige' => 'Paige Gibbs',
        'Vladimira' => 'Vladimira Vosoba (volunteer)'
    };

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Owner__c FROM Task WHERE Owner__c IN (\''+
            String.join(new List<String>(this.TQFullNameMap.keySet()), '\',\'') + '\')');
    }

    public void execute(Database.BatchableContext BC, List<Task> scope) {
        for(Task taskVar : scope){
            taskVar.Owner__c = this.TQFullNameMap.get(taskVar.Owner__c);
        }
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('UpdateTaskOwnerBatch finished!');
    }
}