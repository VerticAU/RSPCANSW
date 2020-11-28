public class GetFinancialYearsMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{};

        super.process(this.request);

        this.init();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {

        Integer year = this.request.has('year') ? this.request.getInteger('year') : Date.today().year();
        Integer yearsBefore = this.request.has('yearsBefore') ? this.request.getInteger('yearsBefore') : 3;
        Integer yearsAfter = this.request.has('yearsAfter') ? this.request.getInteger('yearsAfter') : 1;

        Integer FYStart = 1;

        if (this.request.has('FYStart')) { FYStart = this.request.getInteger('FYStart'); }

        Integer startYear = year - yearsBefore;
        Integer endYear = year + yearsAfter;

        Date todayVar = Date.today();
        Integer currentFY = todayVar.year();

        Map<Integer, Map<String, Object>> yearMap = new Map<Integer, Map<String, Object>>();
        List<vertic_Structs.SelectOption> financialYearOptions = new List<vertic_Structs.SelectOption>();

        for (Integer currentYear = startYear; currentYear <= endYear; currentYear++) {
            DateCalculator dateCalculatorVar = new DateCalculator(Date.newInstance(currentYear, 1, 1), FYStart);

            Date startDate = dateCalculatorVar.thisFinancialYearStartDate();
            Date endDate = dateCalculatorVar.thisFinancialYearEndDate();

            financialYearOptions.add(new vertic_Structs.SelectOption('' + currentYear,
                String.format('{0} - {1}', new List<String>{
                    startDate.format(), endDate.format()
                })
            ));

            yearMap.put(currentYear, new Map<String, Object>{
                'startDate' => startDate,
                'endDate' => endDate
            });

            if (dateCalculatorVar.isThisFinancialYear(todayVar)) {
                currentFY = endDate.year();
            }
        }

        this.response.selectOptions.put('financialYearOptions', financialYearOptions);
        this.response.getMapper().mapAnyValue('currentFinancialYear', '' + currentFY).mapAnyValue('yearMap', yearMap);
    }

    public static String formatFinancialYear(Date startDate, Date endDate) {
        return String.format('{0}/{1}', new List<String>{
            String.valueOf(startDate.year()), String.valueOf(endDate.format()).right(2)
        });
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response


}