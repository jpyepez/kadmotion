 
// OSC setup
OscIn oin;
OscMsg msg;
6450 => oin.port;
oin.addAddress("/wek/outputs");

MLOsc oscEvent;
SineSys sines;

sines.setup(oscEvent);

// main program
spork ~ sines.update();
spork ~ getOsc();

while(second => now);

// get OSC messages
fun void getOsc() {
    while(true) {
        oin => now;
        oscEvent.broadcast();

        while(oin.recv(msg) != 0 ) {
            for(int i; i < oscEvent.motion.size(); i ++) {
                msg.getFloat(i) => oscEvent.motion[i];
            }
            oscEvent.printMotion();
        }
    }
}
