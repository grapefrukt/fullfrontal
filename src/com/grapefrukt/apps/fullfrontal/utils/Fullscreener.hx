package com.grapefrukt.apps.fullfrontal.utils;
import com.grapefrukt.apps.fullfrontal.utils.Launcher.LaunchEvent;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.TimerEvent;
import openfl.Lib;
import openfl.system.Capabilities;
import openfl.utils.Timer;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Fullscreener {

	static var timer:Timer;
	static var launcher:Launcher;
	static var stage:Stage;
	
	public static function init(launcher:Launcher) {
		Fullscreener.launcher = launcher;
		
		timer = new Timer(2000);
		timer.addEventListener(TimerEvent.TIMER, handleTimerTick);
		
		stage = Lib.current.stage;
		
		launcher.addEventListener(LaunchEvent.LAUNCH, handleLaunch);
		launcher.addEventListener(LaunchEvent.CLOSE, handleClose);
		
		check();
	}
	
	static function handleTimerTick(e:TimerEvent) {
		check();
	}
	
	static function handleLaunch(e:LaunchEvent) {
		check();
	}
	
	static function handleClose(e:LaunchEvent) {
		check();
	}
	
	static public function enterFullscreen() {
		timer.reset();
		timer.start();
		stage.setFullscreen(true);
		if (stage.stageWidth != Settings.STAGE_W) {
			stage.setResolution(Settings.STAGE_W, Settings.STAGE_H);
		}
	}
	
	static public function exitFullscreen() {
		timer.reset();
		timer.start();
		stage.setFullscreen(false);
		stage.resize(1, 1);
	}
	
	static public function check() {
		//trace('checkFullscreen', hasGameRunning, stage.displayState);
		if (!Settings.FULLSCREEN) return;
		if (launcher.hasGameRunning) exitFullscreen();
		else enterFullscreen();
	}
	
}