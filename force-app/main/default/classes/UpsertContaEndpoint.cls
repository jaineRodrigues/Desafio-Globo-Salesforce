@RestResource(urlMapping='/Account/*')
global with sharing class UpsertContaEndpoint {

    // Contrato de entrada: recebe um JSON com os dados da Conta
	global class ContaInput {
    	public String name;
    	public String countryId;
    	public String email;
    }

    // Contrato de saída: retorna o ID da Conta criada ou atualizada
    global class ContaOutput {
        public String accountId;
    }

    @HttpPost
    global static ContaOutput doPost(String name, String countryId, String email) {
        ContaOutput output = new ContaOutput();
        Account account = new Account();
        account.Name = name;
        account.Pais__c = countryId;
        account.Email__c = email;
        upsert account;
        
        output.accountId = account.Id;
        return output;
    }
}


/* TESTE HTTP
 {
    "name": "Exemplo de Conta",
    "countryId": "a00bm000003t2PwAAI",
    "email": "exemplo@email.com"
}*/