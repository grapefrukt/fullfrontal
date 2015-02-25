package com.grapefrukt.apps.fullfrontal.utils;
import com.grapefrukt.utils.easing.Quad;
import com.grapefrukt.utils.inputter.InputterPlayer;
import openfl.geom.Point;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class InputRepeater {
	
	var input:InputterPlayer;
	var axis:Int;
	var lastValue:Float = 0;
	var queuedMoves:Float = 0;
	var timeHeld:Int = 0;
	var lastUpdate:Int = 0;
	
	var timeToRepeat:Int = Settings.INPUT_TIME_TO_REPEAT;
	var timeToMax:Int = Settings.INPUT_TIME_TO_MAX;
	
	var repeatSpeedStart:Float = Settings.INPUT_REPEAT_SPEED_MIN;
	var repeatSpeedEnd:Float = Settings.INPUT_REPEAT_SPEED_MAX;
	
	public function new(input:InputterPlayer, axis:Int) {
		this.axis = axis;
		this.input = input;
	}
	
	public function update() {
		var value = input.getAxis(axis);
		// deadzone
		if (value < Settings.INPUT_DEADZONE && value > -Settings.INPUT_DEADZONE) value = 0;
		// axis has no value, bail
		if (value == 0) {
			timeHeld = 0;
			lastValue = 0;
			queuedMoves = 0;
			return;
		}
		
		// set value to either -1 or 1
		value = value > 0 ? 1 : -1;
		
		// axis HAS value but did not on last update
		if (lastValue == 0) {
			queuedMoves += value;
			lastUpdate = Lib.getTimer();
		}
		
		timeHeld += Lib.getTimer() - lastUpdate;
		lastUpdate = Lib.getTimer();
		lastValue = value;
		
		var repeatRatio = (timeHeld - timeToRepeat) / timeToMax;
		if (repeatRatio < 0) return;
		if (repeatRatio > 1) repeatRatio = 1;
		
		queuedMoves += value * (repeatSpeedStart + (repeatRatio) * (repeatSpeedEnd - repeatSpeedStart));
		
		//trace(timeHeld, Math.round(queuedMoves * 100) / 100);
	}
	
	public function getMovement() {
		var movement = Math.floor(queuedMoves);
		queuedMoves -= movement;
		return movement;
	}
	
}