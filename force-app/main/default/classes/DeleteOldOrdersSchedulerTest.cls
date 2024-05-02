@isTest
public class DeleteOldOrdersSchedulerTest {

    @isTest
    static void testExecute() {
        // Criando um país de teste 
        Country__c testCountry = new Country__c(Name = 'Brasil', Acronym__c = 'BR');
        insert testCountry;

        // Criando uma conta para associar às Orders
        Account testAccount = new Account(Name = 'Conta Teste', Pais__c = testCountry.Id);
        insert testAccount;

        // Cria Orders antigas para teste
        List<Order> oldOrders = new List<Order>();
        for (Integer i = 0; i < 5; i++) {
            Order oldOrder = new Order();
            oldOrder.Status = 'Draft';
            oldOrder.AccountId = testAccount.Id; // Atribuir a conta de teste ao pedido
            oldOrder.Teste_ultima_modificao__c = Date.today().addMonths(-4); // Definir o campo de data de modificação simulada
            oldOrder.EffectiveDate = Date.today().addMonths(-4); 
            oldOrders.add(oldOrder);
        }
        insert oldOrders;

        // Chamar o método execute 
        Test.startTest();
        List<DeleteOldOrdersScheduler.FlowInput> inputs = new List<DeleteOldOrdersScheduler.FlowInput>();
        for (Order oldOrder : oldOrders) {
            DeleteOldOrdersScheduler.FlowInput input = new DeleteOldOrdersScheduler.FlowInput();
            input.orderId = oldOrder.Id;
            inputs.add(input);
        }
        DeleteOldOrdersScheduler.execute(inputs);
        Test.stopTest();

        // Verificar se as Orders antigas foram deletadas
        List<Order> remainingOrders = [SELECT Id FROM Order WHERE Id IN :oldOrders];
        System.assertEquals(0, remainingOrders.size(), 'As Orders antigas não foram deletadas corretamente.');
    }
}