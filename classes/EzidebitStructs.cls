public class EzidebitStructs {
    public class Payment {
        public String BankFailedReason;
        public String BankReceiptID;
        public String BankReturnCode;
        public String CustomerName;
        public DateTime DebitDate;
        public String EzidebitCustomerID;
        public String InvoiceID;
        public Double PaymentAmount;
        public String PaymentID;
        public String PaymentMethod;
        public String PaymentReference;
        public String PaymentSource;
        public String PaymentStatus;
        public Double ScheduledAmount;
        public DateTime SettlementDate;
        public Double TransactionFeeClient;
        public Double TransactionFeeCustomer;
        public DateTime TransactionTime;
        public String YourGeneralReference;
        public String YourSystemReference;
    }

    public class BPayCRN {
        public String BPayBillerCode;
        public String BPayCRN;
    }
}