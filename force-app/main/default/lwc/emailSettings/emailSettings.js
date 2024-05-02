import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

// campo a sere recuperado do registro de conta
const FIELDS = ['Account.Enviar_email__c'];

export default class EmailSettings extends LightningElement {
  @api recordId;
  sendEmail = false;

  // Wire para buscar o registro de conta com base no ID fornecido
  @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
  wiredRecord({ error, data }) {
    if (error) {
      this.showToast('Erro', 'Erro ao carregar o registro', 'error');
    }
    if (data) {
      this.sendEmail = data.fields.Enviar_email__c.value || false;
    }
  }

  // Manipulador de evento para lidar com o envio do formulário
  handleSubmit(event) {
    event.preventDefault();
    const fields = event.detail.fields;
    fields.Enviar_email__c = this.sendEmail;
    this.template.querySelector('lightning-record-edit-form').submit(fields);
    this.showToast('Sucesso!', 'Dados atualizados com sucesso!', 'success');
  }

  // Manipulador de evento para lidar com a mudança no estado do toggle
  handleChange(event) {
    this.sendEmail = event.target.checked;
  }

  // Método para exibir um toast
  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
      })
    );
  }
}