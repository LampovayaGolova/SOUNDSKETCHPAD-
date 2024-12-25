//SOUNDSKETCHPAD v 3.0 (beta)
//by lampovayagolova


//HOW TO USE:
//1) boot server
//2) select all code (Ctrl+A)
//3) Compile it (Ctrl+Enter)


//KEYBINDS:
//Z - turn the sin osc on
//X - turn the tri osc on
//C - turn the saw osc on
//J - turn the noise on

//WHEN NOISE IS ON ITS IMPOSSIBLE TO TURN IT OFF, PLEASE USE THE REBOOT SERVER FUNCTION IN CODE TO TURN IT OFF

//PEN COLOR CHANGE ISNT WORKING

//!IGNORE THE ERROR IN POSTLN!


//CODE STARTS HERE:

//инициализация глоб
var redChange, greenChange, blueChange;
var point, red, green, blue, win, view, colorTask, synth1, synth2, synth3, synthNoise, sampleSynth;

// изм цветов пена
redChange = 0.01;
greenChange = 0.015;
blueChange = 0.02;

// начальные дефолтные значения RGB
red = 0; green = 0.33; blue = 0.67;

// создаем окно
win = Window("SoundSketchPad", resizable: true, border: false);
win.fullScreen;
win.onClose = {
    if (colorTask.isPlaying, { colorTask.stop }, {});
 // synth1.free; synth2.free; synth3.free; // при закрытии синты отрубаются
 ~synth1_1.set(\freq, 0);
    ~synth2_1.set(\freq, 0);
    ~synth3_1.set(\freq, 0);
	~synthNoise_1.set(\freq,0);
	if (~sampleSynth.isPlaying, { ~sampleSynth.stop }); // остановить сэмпл при закрытии
};

// доп создание для окна
view = UserView(win, Window.screenBounds);
view.clearOnRefresh = false;
view.background = Color.white;

// синты проигрываются при взаимодейтсвии
synth1 = { |freq|
  var pila, pila2, sinone, sinall;
 // sinone = SinOsc.ar(freq, 0, 0.1) * 0.5;
  pila2 = LFSaw.ar(freq, 0, 0.1) * 0.2;
 // pila = LFSaw.ar(freq, 0, 0.1) * 0.5;

 // sinall = pila + pila2 + sinone;
 sinall = pila2;

  [sinall, sinall];
};

synth2 = { |freq|
 var pila3, sinone2, sintwoall;
 // pila3 = LFSaw.ar(freq,0,0.1)*0.5;
 sinone2 = SinOsc.ar(freq,0,0.1)*0.7;
 // sintwoall = pila3 + sinone2;
 sintwoall = sinone2;

 [sintwoall,sintwoall];
};

synth3 = { |freq|
 var tri1, sinone3, pila4, sinthreeall;
 tri1 = LFTri.ar(freq,0,0.1)*0.5;
 // sinone3 = SinOsc.ar(freq,0,0.1)*0.3;
 // pila4 = LFSaw.ar(freq,0,0.1)*0.1:

 // sinthreeall = tri1 + sinone3 + pila4;
 sinthreeall = tri1;

 [sinthreeall,sinthreeall];
};

synthNoise = { |freq|
    var noise = WhiteNoise.ar(0.05);
    var filteredNoise = RLPF.ar(noise, freq, 0.1);
    [filteredNoise, filteredNoise];
};



~synth1_1 = synth1.play;
~synth2_1 = synth2.play;
~synth3_1 = synth3.play;

~curr_synth = ~synth1_1;
// ~curr_noise = ~synthNoise_1;

/*~synthNoise_1 = synthNoise.play;*/


// бинды
win.view.keyDownAction = {
 arg view, char, modifiers, unicode, keycode;

 [char, keycode].postln;


 switch (keycode,
  90, { //z
   ~curr_synth.set(\freq, 0);
   ~curr_synth = ~synth2_1;
   "sin is on".postln;
  },
  88, { //x
   ~curr_synth.set(\freq, 0);
   ~curr_synth = ~synth3_1;
   "tri is on".postln;
  },
  67, { //c
   ~curr_synth.set(\freq, 0);
   ~curr_synth = ~synth1_1;
   "saw is on".postln;
  },
74, { //j
	/*~synthNoise1 = synthNoise.stop;*/
	/*~synthNoise_1.set(\freq,0);*/
	~synthNoise_1 = synthNoise.play;
	"noise is on".postln;
		}
/*	74, { // Кнопка "j"
            if (~sampleSynth.isPlaying, { ~sampleSynth.stop }); // остановить, если уже играет
            ~sampleSynth = { |buf| PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop: 0) }.play(~sampleBuffer);
        },
     75, { // Кнопка "k"
            if (~sampleSynth.isPlaying, { ~sampleSynth.stop });
        }*/
 );
};

// mouse down
view.mouseDownAction = {
    |v, x, y, mod, butNum, clkCnt|
    point = [x, y];
    if (butNum == 1, {
        view.drawFunc_({ nil });
        view.clearDrawing;
        view.refresh;
    }, {});
};

// mouse up
view.mouseUpAction = {
    |v, x, y, mod, butNum, clkCnt|
    /*synth1.set(\freq, 0); // Stop sound for synth1 on mouse release
    synth2.set(\freq, 0); // Stop sound for synth2 on mouse release
    synth3.set(\freq, 0); // Stop sound for synth3 on mouse release*/
 ~curr_synth.set(\freq, 0);
	~synthNoise_1.set(\freq,0);

};

// mouse drag redefines userview drawFunc
view.mouseMoveAction = {
    |v, x, y, mod|
    // переменные для частот по x и y
    var freq = x.linexp(0, view.bounds.width, 200, 2000).clip(200, 2000); // частота для синтов по оси Х
	var noiseFreq = y.linexp(0, view.bounds.height, 20, 20000).clip(20, 20000); // частота для шума по оси Y

	~synthNoise_1.set(\freq, noiseFreq); // устанавливаем частоту шума

	~curr_synth.set(\freq, freq); // устанавливаем частоту текущего синтезатора


    /*sysnth1.set(\freq, freq); // Update frequency for synth1
    synth2.set(\freq, freq); // Update frequency for synth2
    synth3.set(\freq, freq); // Update frequency for synth3*/

    view.drawFunc = {
        Pen.strokeColor = Color.new(red.fold(0, 1), green.fold(0, 1), blue.fold(0, 1));
        Pen.width = 3;
        Pen.line(point.asPoint, x@y);
        point = [x, y];
        Pen.stroke;
    };
    win.refresh;
};


//ДОДЕЛАТЬ ФИЧУ:
// RGB values wrap through range 0≤x<2
colorTask = Task({
    {
        red = (red + redChange) % 2;
        green = (green + greenChange) % 2;
        blue = (blue + blueChange) % 2;
        0.05.wait; // arbitrary wait time
    }.loop;
});

// зачем
colorTask.s