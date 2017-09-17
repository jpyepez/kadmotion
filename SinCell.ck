public class SineCell extends Chubgraph {

    // global variables
    dur totalEnvDuration;
    float initFreq;

    // audio chain
    SinOsc sin => ADSR env => Pan2 p => dac;
    SinOsc mod => blackhole;

    // set up initial parameters
    fun void setup(float freq, float pan, float sus, int num_sines) {
        freq => initFreq => sin.freq;
        Math.random2f(0.0125, 0.025) => mod.freq;
        pan => p.pan;
        env.set(Math.random2f(.1, .2), Math.random2f(.1, .2), Math.random2f(0.25, 0.9), Math.random2f(0.1, .2));
        sus::second => dur sustainTime;
        env.attackTime() + env.decayTime() + sustainTime + env.releaseTime() => totalEnvDuration;
    }
                           
    fun void play() {
        spork ~ updateFreq();
        0.01 => p.gain;
        1 => env.keyOn;
        totalEnvDuration => now;
        1 => env.keyOff;
        2::second => now;
        p =< dac;
    }

    fun void updateFreq() {
        while(true) {
            initFreq + mod.last() * 200 => sin.freq;
            5::ms => now;
        }
    }

    fun void updateVol() {
        float zg;

        while(true) {
            ( .7/GlobalVol.sine_count ) => float g;
            smooth(g, zg, 0.1) => p.gain;
            1::ms => now;
            g => zg;
        }
    }

    fun float smooth(float value, float lVal, float amt) {
        value * amt + lVal * (1-amt) => float smoothVal;
        return smoothVal;
    }
}
