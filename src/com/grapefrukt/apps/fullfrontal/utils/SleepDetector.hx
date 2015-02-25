package com.grapefrukt.apps.fullfrontal.utils;
import haxe.Timer;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class SleepDetector {

	static var t:Timer;
	static var times:Array<Float>;
	static inline var NUM_TIMES:Int = 5;
	static inline var TIME:Int = 1000;
	
	static public function init() {
		times = [];
		
		t = new Timer(TIME);
		t.run = tick;
	}
	
	static function tick() {
		var time:Float = Date.now().getTime();
		times.push(time);
		if (times.length > NUM_TIMES) times.shift();
		
		if (times.length < NUM_TIMES) return;
		
		var average = .0;
		for (i in 1 ... times.length) {
			average += (times[i] - times[i - 1]);
		}
		
		average /= NUM_TIMES - 1;
		
		if (average > TIME * 2) {
			trace('was in sleep mode, exiting fullscreen to rejigger display');
			Fullscreener.exitFullscreen();
		}
	}
}