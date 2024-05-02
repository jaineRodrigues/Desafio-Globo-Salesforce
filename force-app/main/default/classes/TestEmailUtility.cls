@isTest
public class TestEmailUtility {

    @isTest
    static void testSendEmail() {
        // Criando um país de teste 
        Country__c testCountry = new Country__c(Name = 'Brasil', Acronym__c = 'BR');
        insert testCountry;

        // Criando uma conta para associar às Orders
        Account testAccount = new Account(Name = 'Conta Teste', Pais__c = testCountry.Id, Email__c = 'jainer469@gmail.com', Enviar_email__c = true);
        insert testAccount;

        // Chamando o método sendEmail da classe EmailUtility
        Test.startTest();
        List<Account> accountsToSend = new List<Account>{testAccount};
        EmailUtility.sendEmail(accountsToSend);
        Test.stopTest();

        // Verificar se o email foi enviado corretamente
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject, TextBody FROM EmailMessage];
        System.assertNotEquals(0, sentEmails.size(), 'Nenhum email foi enviado.');

        // Verificar o conteúdo do email enviado
        EmailMessage sentEmail = sentEmails[0];
        System.assertEquals('jainer469@gmail.com', sentEmail.ToAddress, 'O endereço de email no email enviado não corresponde ao esperado.');
        System.assertEquals('Atualização de conta', sentEmail.Subject, 'O assunto do email enviado não corresponde ao esperado.');
        System.assert(sentEmail.TextBody.contains('Nome da Conta: Conta Teste'), 'O nome da conta não está presente no corpo do emai.');
        System.assert(sentEmail.TextBody.contains('ID da Conta:'), 'O ID da conta não está presente no corpo .');
        
        // Verificar o link para a conta
        String accountLink = '/' + testAccount.Id;
        System.assert(sentEmail.TextBody.contains(accountLink), 'O link para a conta não corresponde ao esperado .');
    }
}