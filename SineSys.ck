public class SineSys extends Chubgraph {

    // Machine Learning Params
    // Motion 0: Chance to add a sine
    // Motion 1: Pan depending on L/R motion balance
    // Motion 2: L/R balance, long notes, L/R imbalance, short notes
    // Motion 3: Frequency

    MLOsc @ sysEvent;
    30 => int sine_lim;

    fun void setup(MLOsc mlo) {
        mlo @=> sysEvent;
    }

    fun void update() {
        while(true) {
            sysEvent => now;
            sysEvent.motion[0] => float chance;
            Std.clampf(chance, 0, 1) => chance;
            if(Math.randomf() < chance) {
                spork ~ add();
            }
        }
    }

    fun void add() {
        if(GlobalVol.sine_count <= sine_lim) {
            GlobalVol.sine_count++;
            SineCell cell;

            Std.scalef(sysEvent.motion[3], 0, 1, 50, 500) => float freq;
            Std.scalef(sysEvent.motion[1], 0, 1, -1 , 1) => float pan;
            Std.scalef(sysEvent.motion[2], 0, 1, 0.05, 4) => float sus;
            cell.setup(freq, pan, sus, GlobalVol.sine_count);
            cell.play();

            GlobalVol.sine_count--;
        }
    }

}
