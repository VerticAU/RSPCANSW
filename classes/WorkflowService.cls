public class WorkflowService {

    public static Map<String, List<String>> findUsersByGroups() {

        Map<String, List<String>> groupMemberMap = new Map<String, List<String>>();

        List<GroupMember> groupMemberList = new List<GroupMember>([
            SELECT
                GroupId,
                Group.Name,
                Id,
                SystemModstamp,
                UserOrGroupId
            FROM GroupMember
        ]);

        for (GroupMember groupMember : groupMemberList) {
            List<String> userIds = new List<String>();
            if (groupMemberMap.containsKey(groupMember.Group.Name)) {
                userIds = groupMemberMap.get(groupMember.Group.Name);
            }
            userIds.add(groupMember.UserOrGroupId);
            groupMemberMap.put(groupMember.Group.Name, userIds);
        }
        return groupMemberMap;
    }

    public static Date calcActivityDate(Integer activityDays) {

        Date activityDate = date.today();
        while (activityDays > 0) {
            activityDate = activityDate.addDays(1);
            if (vertic_Utils.dates.IsWorkingDay(activityDate) == true) {
                activityDays--;
            }
        } 
        while (activityDays < 0) {
            activityDate = activityDate.addDays(-1);
            if (vertic_Utils.dates.IsWorkingDay(activityDate) == true) {
                activityDays++;
            }
        }
        return activityDate;
    }
}