@isTest
public class ScheduleManagerTest {
    @isTest
    static void testVertic_ScheduledProc() {
        System.runAs(new User(Id = UserInfo.getUserId())) {

            Test.startTest();
            ScheduleManager.restart();
            ScheduleManager.stopAll();
            Test.stopTest();
        }
    }
}