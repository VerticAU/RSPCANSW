public class DateCalculator {

    private Integer fyStartMonth = 1;
    private Date todayVar;
    private Date thisYearStartDate;
    private Date thisYearEndDate;

    private Date thisFinancialYearStartDate;
    private Date thisFinancialYearEndDate;

    private Date lastFinancialYearStartDate;
    private Date lastFinancialYearEndDate;

    public DateCalculator() {
        this(Date.today());
    }

    public DateCalculator(Date dateVar) {
        this(dateVar, 1);
    }

    public DateCalculator(Date dateVar, Integer fyStartMonth) {
        this.todayVar = dateVar;
        this.fyStartMonth = fyStartMonth;
        initDates();
    }

    public DateCalculator(Integer year, Integer fyStartMonth) {
        this.fyStartMonth = fyStartMonth;
    }

    public DateCalculator(Integer year) {
        this(Date.newInstance(year, 1, 1), 1);
    }

    public Integer getFYStartMonth(){
        return this.fyStartMonth;
    }

    private void initDates() {

        Integer thisYear = todayVar.year();

        this.thisYearStartDate = Date.newInstance(thisYear, 1, 1);
        this.thisYearEndDate = Date.newInstance(thisYear, 12, 31);

        // This FY.
        Integer thisFinancialYear = todayVar < Date.newInstance(thisYear, this.getFYStartMonth(), 1).addDays(-1) ?
            thisYear - 1 :
            thisYear;

        this.thisFinancialYearStartDate = Date.newInstance(thisFinancialYear, this.getFYStartMonth(), 1);
        this.thisFinancialYearEndDate = Date.newInstance(thisFinancialYear + 1, this.getFYStartMonth(), 1).addDays(-1);

        // Last FY.
        this.lastFinancialYearStartDate = thisFinancialYearStartDate.addYears(-1);
        this.lastFinancialYearEndDate = thisFinancialYearEndDate.addYears(-1);

        System.debug('thisYearStartDate: ' + thisYearStartDate.format());
        System.debug('thisYearEndDate: ' + thisYearEndDate.format());

        System.debug('thisFinancialYearStartDate: ' + thisFinancialYearStartDate.format());
        System.debug('thisFinancialYearEndDate: ' + thisFinancialYearEndDate.format());

        System.debug('lastFinancialYearStartDate: ' + lastFinancialYearStartDate.format());
        System.debug('lastFinancialYearEndDate: ' + lastFinancialYearEndDate.format());

    }

    public Boolean isThisYear(Date dateVar) {
        return dateVar >= this.thisYearStartDate && dateVar <= this.thisYearEndDate;
    }

    public Boolean isThisFinancialYear(Date dateVar) {
        return dateVar >= this.thisFinancialYearStartDate && dateVar <= this.thisFinancialYearEndDate;
    }

    public Boolean isLastFinancialYear(Date dateVar) {
        return dateVar >= this.lastFinancialYearStartDate && dateVar <= this.lastFinancialYearEndDate;
    }

    public Date thisFinancialYearStartDate(){
        return this.thisFinancialYearStartDate;
    }

    public Date thisFinancialYearEndDate(){
        return this.thisFinancialYearEndDate;
    }

}