package com.grapefrukt.apps.fullfrontal.utils;
import com.grapefrukt.apps.fullfrontal.utils.Launcher.LaunchEvent;
import haxe.Timer;
import openfl.display.StageDisplayState;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Fullscreener {

	static var fullscreenCheckTimer:Timer;
	static var launcher:Launcher;
	
	public static function init(launcher:Launcher) {
		Fullscreener.launcher = launcher;
		fullscreenCheckTimer = new Timer(2000);
		fullscreenCheckTimer.run = check;
		
		launcher.addEventListener(LaunchEvent.LAUNCH, handleLaunch);
		launcher.addEventListener(LaunchEvent.CLOSE, handleClose);
		
		check();
	}
	
	static function handleLaunch(e:LaunchEvent) {
		check();
	}
	
	static function handleClose(e:LaunchEvent) {
		check();
	}
	
	static public function check() {
		//trace('checkFullscreen', hasGameRunning, stage.displayState);
		if (Settings.FULLSCREEN) Lib.current.stage.displayState = launcher.hasGameRunning ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
	}
	
}