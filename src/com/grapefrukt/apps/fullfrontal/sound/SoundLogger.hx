package com.grapefrukt.apps.fullfrontal.sound;
import com.grapefrukt.apps.fullfrontal.sound.SoundLogger.SoundEvent;
import com.grapefrukt.apps.fullfrontal.sound.SoundManager.Sfx;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class SoundLogger {

	static var buffer:Array<SoundEvent>;
	static var MAX_AGE:Float = 3000.0;
	
	static var playbackStart:Float = 0;
	static var playbackIndex:Int = 0;
	
	static var isPlaying(get, never):Bool;
	
	public static function init() {
		buffer = [];
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
	}
	
	public static function log(sfx:Sfx, index:Int, stageX:Float, duration:Float) {
		if (isPlaying) return;
		
		buffer.push(new SoundEvent(sfx, index, stageX, duration, Lib.getTimer()));
		purge();
	}
	
	public static function startPlayback() {
		if (buffer.length < 1) return;
		trace("Started playback");
		
		playbackStart = Lib.getTimer();
		playbackIndex = 0;
	}
	
	public static function stopPlayback() {
		trace("Stopped playback");
		playbackStart = 0;
		playbackIndex = 0;
	}
	
	public static function togglePlayback() {
		isPlaying ? stopPlayback() : startPlayback();
	}
	
	static private function handleEnterFrame(e:Event) {
		if (playbackStart != 0) playBuffer();
	}
	
	static private function playBuffer() {
		var firstSoundAt = buffer[0].time;
		var playbackFor = Lib.getTimer() - playbackStart;
		var age = firstSoundAt + playbackFor;
		
		if (playbackIndex >= buffer.length) {
			stopPlayback();
			return;
		}
		
		var didPlay = true;
		
		while (didPlay && playbackIndex < buffer.length){
			var sound = buffer[playbackIndex];
			if (sound.time < age) {
				trace("playing " + sound.sfx + (sound.index != 0 ? "(" + sound.index + ")" : ""));
				SoundManager.playMulti(sound.sfx, sound.index, sound.stageX, sound.duration);
				playbackIndex++;
				didPlay = true;
			} else {
				didPlay = false;
			}
		}
	}
	
	static function purge() {
		while (buffer.length > 0 && buffer[0].age > MAX_AGE) buffer.shift();
	}
	
	static function get_isPlaying() {
		return playbackStart != 0;
	}
	
}

class SoundEvent {
	
	public var sfx:Sfx;
	public var stageX:Float = -9999;
	public var duration:Float = -1;
	public var time:Float;
	public var index:Int;
	
	public var age(get, never):Float;
	
	public function new(sfx:Sfx, index:Int, stageX:Float, duration:Float, time:Int) {
		this.sfx = sfx;
		this.duration = duration;
		this.index = index;
		this.stageX = stageX;
		this.time = time;
	}
	
	public function get_age() {
		return Lib.getTimer() - time;
	}
}