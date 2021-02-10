({
    handleInit: function(cmp, event, helper){
        console.log('dto', JSON.stringify(cmp.get('v.meta.dto')));

        cmp.set('v.payColumns', [
            {
                changeAction: 'add', label: '', type: 'button-icon', initialWidth: 50, firstPosition: true,
                typeAttributes: {
                    name: 'Add', iconName: 'utility:add',
                    doAction: function (row) {
                        helper.handlePaymentAction(cmp, helper, row);
                    }
                }
            }
        ]);

        helper.updatePaymentTableCondition(cmp);
        cmp.find('pay-data-table').refresh();

    },

    handleNewPayment: function(cmp, event, helper){
        cmp.set('v.meta.dto.payment', {
            npe01__Opportunity__c: cmp.get('v.meta.dto.opportunity.Id'),
            Batch__c: cmp.get('v.meta.dto.batch.Id'),
            npe01__Payment_Date__c: new Date().toISOString(),
            npsp__Payment_Acknowledgment_Status__c: 'Do Not Acknowledge'
        });
    },

    handlePaymentMethodChange: function(cmp, event, helper){
        if(cmp.get('v.meta.dto.payment.npe01__Payment_Method__c') === 'Credit Card'){
            cmp.find('modalService').show(
                'c:BulkContributionManagementCCModal',
                {
                    contribution: cmp.get('v.meta.dto.opportunity')
                },
                {
                    header: 'Credit Card Payment'
                }
            ).then($A.getCallback(function (response) {
                if(!$A.util.isUndefinedOrNull(response)){
                    cmp.set('v.meta.dto.payment.Stripe_Customer_Id__c', response.stripeCustomerId);
                    cmp.set('v.meta.dto.payment.Stripe_Payment_Id__c', response.stripePaymentMethodId);
                }
            }));
        } else {
            cmp.set('v.meta.dto.payment.Stripe_Customer_Id__c', null);
            cmp.set('v.meta.dto.payment.Stripe_Payment_Id__c', null);
        }

        if(cmp.get('v.meta.dto.payment.npe01__Payment_Method__c') !== 'Cheque'){
            cmp.set('v.meta.dto.payment.Cheque_Number__c', null);
            cmp.set('v.meta.dto.payment.BSB__c', null);
            cmp.set('v.meta.dto.payment.Bank_Account_Number__c', null);
            cmp.set('v.meta.dto.payment.Name_on_Cheque__c', null);
        }
    },
});