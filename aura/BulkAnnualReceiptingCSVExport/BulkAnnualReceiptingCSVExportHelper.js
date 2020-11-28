({

    executeAll: function (cmp, processor, requests) {
        var promises = [];

        var d = 0;
        var event = cmp.getEvent('onProgress');
        event.setParams({
            payload: {
                progress: (d * 100) / promises.length
            }
        });
        event.fire();

        requests.forEach(function (request) {
            var promise = cmp.utils.execute(
                cmp,
                processor,
                request
            );
            promise.finally(function () {
                d++;
                var event = cmp.getEvent('onProgress');
                event.setParams({
                    payload: {
                        progress: (d * 100) / promises.length
                    }
                });
                event.fire();
            });
            promises.push(promise);
        });

        return Promise.all(promises);
    },

    produceFile: function (cmp, event, helper, startDate, endDate) {

        return new Promise($A.getCallback(function (resolve, reject) {

            var financeExtract = cmp.get('v.meta.dto.financeExtract');
            var requests = helper.chunkPeriod(
                startDate,
                endDate,
                5
            );

            var filter = cmp.get('v.filter') || {};

            requests = requests.map(function (req) {
                req.filter = filter;
                return req;
            });

            console.table(requests);

            helper.executeAll(cmp, 'BulkAnnualReceiptingCSVExportMetaProc', requests).then(function (results) {

                var allContributions = [];

                results.forEach(function (result) {
                    allContributions = allContributions.concat(result.dto.donations || []);
                });

                // console.table(allContributions);

                var generateResponse = helper.generateFile(financeExtract, allContributions);
                var csv = cmp.find('csvUtils').fromArrays(generateResponse.rows);

                resolve(csv);

            });

        }));
    },

    generateFile: function (financeExtract, allContributions) {

        var helper = this;

        var groupedContributionsMap = helper.groupBy(allContributions, function (contribution) {
            return contribution.Contact__c;
        });

        console.log(groupedContributionsMap);

        var rows = [
            this.getFileHeaderRow()
        ];

        var index = 0;
        var totalAmount = 0;
        var totalCount = 0;

        groupedContributionsMap.forEach(function (contributions, groupKey) {

            var amount = contributions.reduce(function (total, contribution) {
                total += contribution.Amount__c || 0;
                return total;
            }, 0);

            var donationsByMonthsMap = helper.groupBy(contributions, function (donation) {
                var dateVar = new Date(donation.Date__c);
                donation.monthFormatted = $A.localizationService.formatDate(dateVar, 'MMM');
                return dateVar.getMonth() + 1;
            });

            var contributionVar = contributions[0];

            var row = [];
            row.push(contributionVar.Contact__r.Id);
            row.push(contributionVar.Contact__r.Constituent_ID__c);
            row.push(contributionVar.Contact__r.FirstName || '');
            row.push(contributionVar.Contact__r.LastName || '');
            row.push('');
            row.push(contributionVar.Contact__r.MailingStreet || '');
            row.push(contributionVar.Contact__r.MailingState || '');
            row.push(contributionVar.Contact__r.MailingCity || '');
            row.push(contributionVar.Contact__r.MailingPostalCode || '');

            for (var i = 1; i <= 12; i++) {
                var monthTotal = (donationsByMonthsMap.get(i) || []).reduce(function (sum, contribution) {
                    sum += contribution.Amount__c || 0;
                    return sum;
                }, 0);
                row.push(parseFloat(monthTotal).toFixed(2));
            }

            row.push(parseFloat(amount).toFixed(2));
            row.push(contributionVar.Legacy_Receipt_Number__c);
            row.push(totalCount + 1);

            rows.push(row);
            index++;

            totalAmount += amount;
            totalCount++;
        });


        console.table(rows);

        return {
            rows: rows,
            totalAmount: totalAmount,
            totalCount: totalCount
        };
    },

    chunkPeriod: function (startDate, endDate, days) {

        var daysToAdd = days == 0 ? 0 : days - 1;

        var helper = this;
        var periods = [];

        var periodStartDate = startDate;
        var periodEndDate;

        while (periodStartDate <= endDate) {
            periodEndDate = helper.addDays(periodStartDate, daysToAdd);
            if (periodEndDate > endDate) {
                periodEndDate = endDate;
            }
            periods.push({
                startDate: new Date(periodStartDate),
                endDate: new Date(periodEndDate),
                startFormatted: $A.localizationService.formatDate(periodStartDate),
                endFormatted: $A.localizationService.formatDate(periodEndDate),
            });
            periodStartDate = helper.addDays(periodEndDate, 1);
        }

        return periods;
    },

    addDays: function (dateVar, days) {
        var temp = new Date(dateVar.valueOf());
        temp.setDate(temp.getDate() + days);
        return temp;
    },

    groupBy: function groupBy(list, keyGetter) {
        const map = new Map();
        list.forEach((item) => {
            const key = keyGetter(item);
        const collection = map.get(key);
        if (!collection) {
            map.set(key, [item]);
        } else {
            collection.push(item);
        }
    });
        return map;
    },


    getFileHeaderRow: function() {
        return [
            'Contact ID',
            'Constituent ID',
            'First Name',
            'Last Name',
            'ReceiptName',
            'Address',
            'District',
            'Area',
            'Post Code',
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
            'Total Amount',
            'ReceiptNumber',
            'Running Num'
        ];
    },

    getFileRow: function (indexVar, contact, amount) {

        var fileRow = [
            indexVar,
            contact,
            amount
        ];

        return fileRow;

    },

})