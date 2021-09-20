({
    handleInit: function(cmp, event, helper) {
        var options = cmp.get('v.options') || [];
        var selectOptions = [];
        var requiredOptions = cmp.get('v.requiredOptions') || [];
        var selectRequiredOptions = [];
        options.forEach(function(option) {
            selectOptions.push({
                label: option,
                value: option
            });
        });
        requiredOptions.forEach(function(requiredOptions) {
            selectRequiredOptions.push({
                label: requiredOptions,
                value: requiredOptions
            });
        });

        cmp.set('v.selectOptions', selectOptions);
        cmp.set('v.selectRequiredOptions', selectRequiredOptions);
    }
});