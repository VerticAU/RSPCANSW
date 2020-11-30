public class ScheduleManager{

    public static final List<Type> SCHEDULERS = new List<Type>{
        vertic_AsyncProcessBatch.class,             // Every Minute + Daily Re-runner at 11.55 PM
        EzidebitGetPaymentsScheduleProc.class,      // Every Day at 8 PM
        EzidebitGetDDPaymentsScheduledProc.class    // Every Day at 8 PM
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