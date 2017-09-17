public class MLOsc extends Event {

    float motion[5];
    string motion_values;

    fun void printMotion() {
        "Motion: " => motion_values;
        for(int i; i < motion.size(); i++) {
            if(i != 0) ", " +=> motion_values;
            Std.ftoa(motion[i], 3) +=> motion_values;
        }
        //<<< motion_values >>>;
    }
}
