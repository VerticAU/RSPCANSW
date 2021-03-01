public without sharing class WorkflowService {

    public static Date calcActivityDate(Integer activityDays) {

        Date activityDate = date.today();
        while (activityDays > 0) {
            activityDate = activityDate.addDays(1);
            if (vertic_Utils.dates.IsWorkingDay(activityDate) == true) {
                activityDays--;
            }
        } 

        return activityDate;
    }
}