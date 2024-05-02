global class DeleteOldOrdersScheduler {
    
    //classe para armazenar os IDs das Orders
    public class FlowInput {
        @InvocableVariable(label='ID da Order')
        public Id orderId;
    }

    @InvocableMethod(label='Executar Exclusão de Orders Antigas')
    public static void execute(List<FlowInput> inputs) {
        
        // Lista para armazenar os IDs das Orders
        List<Id> orderIds = new List<Id>();

        // Itera sobre os inputs do Flow para extrair os IDs das Orders
        for (FlowInput input : inputs) {
            orderIds.add(input.orderId);
        }

        // Consulta SOQL para buscar as Orders antigas com base nos IDs fornecidos
        List<Order> oldOrders = [SELECT Id FROM Order WHERE Id IN :orderIds AND Teste_ultima_modificao__c < :Date.today().addMonths(-3)];
        
        // Verifica quantas Orders antigas foram encontradas
        System.debug('Orders antigas encontradas para exclusão: ' + oldOrders.size());
        
        // Deleta as Orders encontradas
        if (!oldOrders.isEmpty()) {
            try {
                delete oldOrders;
                System.debug('Orders antigas deletadas com sucesso.');
            } catch (DmlException e) {
                System.debug('Erro ao deletar as Orders antigas: ' + e.getMessage());
            }
        } else {
            System.debug('Nenhuma Order antiga encontrada para exclusão.');
        }
    }
}