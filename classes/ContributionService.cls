public class ContributionService {

    public static String formatReceiptFileName(){
        return String.format('Donation Receipts - {0}.pdf', new List<String>{Date.today().format()});
    }

    public static String formatAnnualReceiptFileName(Date startDate, Date endDate){
        return String.format('Annual Donation Receipts - {0}.pdf', new List<String>{GetFinancialYearsMetaProc.formatFinancialYear(startDate, endDate)});
    }

}