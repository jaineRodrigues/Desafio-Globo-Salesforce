<p align="center">
  <img src="https://img.shields.io/badge/VEM SER DBC-068996?style=for-the-badge" alt="VEM SER DBC"/>
  <img src="https://img.shields.io/badge/SALESFORCE-0689E6?style=for-the-badge" alt="Salesforce"/>
</p>

<br>

<p text-align="center">


<a href="#-credenciais-de-acesso"> 🔑Credenciais de Acesso</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#-fluxo-de-exclusão-automática-de-orders-antigas"> ❌Fluxo de Exclusão Automática de Orders Antigas</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#detalhes-da-implementação">Detalhes da Implementação</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#cobertura-de-testes">Cobertura de Testes</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#-enviar-email-ao-atualizar-ou-criar-uma-conta">📧 Enviar Email ao Atualizar ou Criar uma Conta</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#-componente-para-editar-via-interface">🖥️ Componente para Editar Via Interface</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#-automação-para-incremento-do-valor-da-order">📈 Automação para Incremento do Valor da Order</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#-listagem-de-endpoints">🚀 Listagem de Endpoints</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
</p>




>Este repositório contém o código fonte de classes, trigger e componentes desenvolvido para a resolução dos itens necessários para completar o desafio proposto.
### Nome do Aplicativo: Desafio Globo
Para agrupar os itens necessários para realizar o desafio, optei pela criação de um aplicativo, o qual nomeei de: `Desafio Globo`.

## 🔑 Credenciais de Acesso
Você pode acessar a organização diretamente pelo seguinte link [Salesforce Organization](https://globo89-dev-ed.develop.my.salesforce.com)


> **Nome de Usuário:** `avaliadordesafioglobo@email.com`

> **Senha:** `******************`
<br>

---

### 🚀 Listagem de Endpoints
 Nesta seção, estão listados os dois endpoints que foram solicitados no desafio proposto.

1. **Endpoint:** `/order/`
   - **Descrição:** Este endpoint permite criar uma nova ordem.
   - **Método HTTP:** POST
   - **Parâmetros:** O corpo da solicitação deve incluir os seguintes campos em formato JSON:
     - `accountId`: ID da conta associada à ordem.
     - `ContractId`: ID do contrato associado à ordem.
     - `EffectiveDate`: Data efetiva da ordem.
     - `Status`: Status da ordem (por exemplo, "Draft").
   - **Retorno:** O ID da ordem criada.

2. **Endpoint:** `/Account/`
   - **Descrição:** Este endpoint permite criar ou atualizar uma conta.
   - **Método HTTP:** POST
   - **Parâmetros:** O corpo da solicitação deve incluir os dados da conta a ser criada ou atualizada, como nome, pais e email
   - **Retorno:** O ID da conta criada ou atualizada.

### Testar endpoins

- Para testar os endpoins, voçê pode acessar o workbench com o usuário e senha disponibilizado: `https://workbench.developerforce.com/login.php?startUrl=%2FrestExplorer.php` 

- Testar upsert de conta:

>{
    "name": "Testar ndpoint",
    "countryId": "a00bm000003t2PwAAI",
    "email": "exemplo@email.com"
}


- Testar insert de uma order:
>{
    "accountId": "001bm000007SayzAAC",
    "ContractId": "800bm000003w121AAA",
    "EffectiveDate": "2024-05-01" 
}



<br>

 ---


## ❌ Fluxo de Exclusão Automática de Orders Antigas

Nesta solução, implementei um fluxo agendado para executar uma vez por dia e lidar com a exclusão de Orders com data de modificação maior que 3 meses. Isso é feito para otimizar o desempenho e minimizar a sobrecarga, especialmente em grandes volumes de dados.

### Detalhes da Implementação:

1. **Agendamento do Fluxo:** Utilizei um fluxo agendado para automatizar a execução diária da exclusão de Orders antigas em um horário específico.

2. **Filtro de Condição:** No fluxo, defini condições de filtro para selecionar apenas as Orders que atendem ao critério de terem uma data de modificação maior que 3 meses, a partir da data em que o fluxo foi acionado.

3. **Ação de Deleção:** Dentro do fluxo, adicionei uma ação que chama a classe `DeleteOldOrdersScheduler`. Esta classe é responsável por iterar sobre as Orders e deletá-las.

4. **Campo de Teste:** Criei um campo personalizado de teste para simular o campo `LastModifiedDate`, permitindo especificar uma data para fins de teste.

### Cobertura de Testes:

Também desenvolvi uma classe de teste para a classe `DeleteOldOrdersScheduler`, na qual obtive uma cobertura de 88%.

### Melhoria que gostaria de implementar:

Após uma análise mais aprofundada e dialogo com outras pessoas, identifiquei uma possível melhoria na implementação do processo de auutomação para a exclusão automática de Orders. Considerando que o fluxo tem uma limitação de 50 mil registros para serem excluídos em um processo, uma abordagem mais robusta seria implementar um agendamento por schedulable job. Isso permitiria lidar de forma mais eficiente com grandes volumes de dados e evitar possíveis limitações do fluxo, que consequentemente afeta o desempenho do processo. Esta melhoria ainda não está aplicada ao projeto mas já está em andamento.

<br>

---

## 📧 Enviar Email ao Atualizar ou Criar uma Conta

1. **Classe `EmailUtility`:**

Para solucionar esta parte do desafio, criei uma classe `EmailUtility` para gerenciar o envio de e-mails. Nesta classe, defini um método estático `sendEmail`, que recebe uma lista de contas como parâmetro. Em seguida, verifiquei se o campo `Enviar_email__c` está marcado como verdadeiro para cada conta.

2. **Criação e Envio de Email:**

Para cada conta com o envio de e-mail habilitado, criei um objeto `Messaging.SingleEmailMessage`. Configurei o destinatário, o assunto e o corpo do e-mail com informações relevantes.

3. **Trigger `sendEmailForAccountCreated`:**

- Criei uma trigger chamada `sendEmailForAccountCreated`. Esta trigger é acionada após a inserção ou atualização de uma conta.
- Na trigger, verifiquei se o campo `Enviar_email__c` estava marcado como verdadeiro para a conta inserida ou atualizada.
- Se o envio de e-mail estiver habilitado, adicionei a conta a uma lista e chamei o método `sendEmail` da classe `EmailUtility`.

### Testes de Unidade na Classe `TestEmailUtility`:

Criei uma classe de teste `TestEmailUtility`, na qual obtive 100% de cobertura.

### 🖥️ Componente para Editar Via Interface

1. **Controle de Estado do Toggle:**
   - O estado do toggle é atualizado com base no valor do campo `Enviar_email__c` da conta.

2. **Comunicação com o Salesforce:**
   - O componente utiliza a função `getRecord` do módulo `lightning/uiRecordApi` para recuperar os dados da conta do Salesforce.

3. **Exibição de Mensagens de Toast:**
   Utilizei um toast para dar feedback visual quando a conta é criada.

4. **Manuseio de Eventos:**
   - O componente inclui métodos para lidar com eventos de mudança no estado do toggle e de submissão do formulário. Os métodos são responsáveis por atualizar o estado do componente e enviar os dados atualizados para o Salesforce.


<br>

---


## 📈 Automação para Incremento do Valor da Order

Para isso, utilizei um fluxo atualizado por registro, tendo como objeto acionador o produto do item.
- Determinei uma ação de atualização de registro, onde acesso o pedido e a conta relacionada.
- Atribuí o valor total do pedido (do objeto pedido) ao campo total da conta (conta).
