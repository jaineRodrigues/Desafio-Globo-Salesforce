@RestResource(urlMapping='/Order/*')
global with sharing class InsertOrderEndpoint {

    // Contrato de saída: retorna o ID da Ordem criada
    global class OrderOutput {
        public String orderId;
    }

    @HttpPost
    global static OrderOutput doPost(String accountId, String ContractId, String EffectiveDate) {
        OrderOutput output = new OrderOutput();
        
        // Criação de uma nova ordem
        Order newOrder = new Order();
        newOrder.AccountId = accountId;
        newOrder.ContractId = ContractId;  
        newOrder.EffectiveDate = Date.valueOf(EffectiveDate); // Convertendo - para Date
        newOrder.Status = 'Draft'; 
        
        insert newOrder;
        
        // Retorna o ID da ordem criada
        output.orderId = newOrder.Id;
        return output;
    }
}
/*
 * Test HTTP
{
    "accountId": "001bm000007SayzAAC",
    "ContractId": "800bm000003w121AAA",
    "EffectiveDate": "2024-05-01" 
}

*/