@IsTest
public class GetFinancialYearsMetaProcTest {
    @IsTest static void test(){
        vertic_Response response = new GetFinancialYearsMetaProc().process(new Map<String, Object>{});
        System.assert(response.isValid);
    }
}