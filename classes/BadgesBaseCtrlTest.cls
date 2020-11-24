/**
 * Created by golub on 24.11.2020.
 */

@IsTest
private class BadgesBaseCtrlTest {
    @IsTest
    static void testEmptyConstructor() {
        BadgesBaseCtrl.Badge badge = new BadgesBaseCtrl.Badge();
        System.assertEquals(null, badge.recordId );
    }
    @IsTest
    static void testConstructorWithTwoParameters(){
        String sldsIconName = 'add';
        String title = 'addTitle';
        
        BadgesBaseCtrl.Badge badge = new BadgesBaseCtrl.Badge(sldsIconName, title);
        
        System.assertEquals(sldsIconName, badge.sldsIconName);
        System.assertEquals(title, badge.title);
    }
    @IsTest
    static void testConstructorWhithForParameters(){
        String sldsIconName = 'add';
        String title = 'addTitle';
        BadgesBaseCtrl.Badge badge = new BadgesBaseCtrl.Badge(sldsIconName, title);
        System.assertEquals(sldsIconName, badge.sldsIconName);
        System.assertEquals(title, badge.title);
    }
}