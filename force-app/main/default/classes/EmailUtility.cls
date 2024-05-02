public class EmailUtility {
    public static void sendEmail(List<Account> accounts) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Account acc : accounts) {
            // Verificndo se o envio de email está habilitado
            if (acc.Enviar_email__c) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{acc.Email__c});
                email.setSubject('Atualização de conta');
                
                // Construindo um link para detalhes da conta
                String baseUrl = URL.getOrgDomainUrl().toExternalForm();
                String accountLink = baseUrl + '/' + acc.Id;
                
                // Adiciona os dados da conta no corpo do email
                String body = 'Uma nova conta foi criada ou editada:';
                body += '\nNome da Conta: ' + acc.Name;
                body += '\nID da Conta: ' + acc.Id;
                body += '\nVeja mais detalhes: ' + accountLink;
                
                email.setPlainTextBody(body);
                
                emails.add(email);
            }
        }
        
        // Envia os emails apenas se houver algum email na lista
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}