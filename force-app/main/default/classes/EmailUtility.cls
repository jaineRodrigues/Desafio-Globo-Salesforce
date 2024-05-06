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
                String body = 'Olá ' + acc.Name + ',\n\n';
                body += 'Seja bem-vindo à nossa plataforma!\n\n';
                body += 'Estamos muito felizes por ter você como parte da nossa comunidade.\n';
                body += 'Aqui estão algumas informações sobre sua conta:\n\n';
                body += 'Nome da Conta: ' + acc.Name + '\n';
                body += 'ID da Conta: ' + acc.Id + '\n';
                body += 'Veja mais detalhes: ' + accountLink + '\n\n';
                body += 'Se precisar de alguma ajuda ou tiver alguma dúvida, não hesite em entrar em contato conosco.\n\n';
                body += 'Atenciosamente,\nSua Equipe';

                
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