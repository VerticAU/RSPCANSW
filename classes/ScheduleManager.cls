public class ScheduleManager{

    public static final List<Type> SCHEDULERS = new List<Type>{
        EzidebitGetPaymentsScheduleProc.class
    };

    public static void restart() {
        stopAll();
        startAll();
    }

    public static void startAll() {
        for (Type typeVar : SCHEDULERS) {
            ((vertic_Structs.ISchedulable)typeVar.newInstance()).start();
        }
    }

    public static void stopAll() {
        for (Type typeVar : SCHEDULERS) {
            ((vertic_Structs.ISchedulable)typeVar.newInstance()).stop();
        }
    }

}