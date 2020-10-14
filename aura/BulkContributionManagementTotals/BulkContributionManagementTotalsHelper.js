({
    recalculate: function (cmp, event, helper) {
        
        var contributions = cmp.get('v.contributions');
        var totals = [];

        var paymentTypes = cmp.get('v.paymentMethods') || [];

        if (paymentTypes) {
            paymentTypes.forEach(function (paymentType) {
                totals.push({
                    title: 'Total ' + paymentType.label,
                    type: 'currency',
                    value: 0
                })
            })
        }

        var value = 0;

        contributions.forEach(function (contribution) {

            var contributionAmount = 0;
            try{
                contributionAmount = parseFloat(contribution.Amount || 0);
            } catch (e) {}

            value += contributionAmount;

            if (paymentTypes) {

                paymentTypes.forEach(function (paymentType, index) {

                    // if (paymentType.value != contribution.Payment_Method__c) {
                    //     return;
                    // } todo Payment Method field

                    totals[index].value += contributionAmount;
                });
            }
        });

        totals.push({
            title: 'Total',
            type: 'currency',
            value: value
        });

        cmp.set('v.totals', totals)
    }
})