trigger sendEmailForAccountCreated on Account (after insert, after update) {
    List<Account> accountsToSendEmail = new List<Account>();
    
    for (Account acc : Trigger.new) {
        if (acc.Enviar_email__c && acc.Email__c != null) {
            accountsToSendEmail.add(acc);
        }
    }
    
    if (!accountsToSendEmail.isEmpty()) {
        EmailUtility.sendEmail(accountsToSendEmail);
    }
}