package com.grapefrukt.apps.fullfrontal;

import cpp.vm.Thread;
import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.Lib;
import openfl.ui.Keyboard;
import sys.io.Process;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class Main extends Sprite {

	var hasGameRunning = false;
	var fullscreenCheckTimer:Timer;
	public static var home(default, null):String = '';
	
	public function new() {
		super();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		fullscreenCheckTimer = new Timer(2000);
		fullscreenCheckTimer.run = checkFullscreen;
		
		home = Sys.getCwd();
		
		var p = new Parser();
		
		checkFullscreen();
	}
	
	function checkFullscreen() {
		//trace('checkFullscreen', hasGameRunning, stage.displayState);
		//stage.displayState = hasGameRunning ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
	}
	
	function handleKeyDown(e:KeyboardEvent) {
		if (e.keyCode == Keyboard.ESCAPE) {
			openfl.system.System.exit(0);
			return;
		}
		if (hasGameRunning) return;
		
		if (e.keyCode != Keyboard.ENTER) return;
		
		trace('thread created');
		hasGameRunning = true;
		checkFullscreen();
		
		var t = Thread.create(launch);
		t.sendMessage(onComplete);
	}
	
	function onComplete() {
		trace('thread completed');
		hasGameRunning = false;
		checkFullscreen();
	}
	
	static function launch() {
		var onComplete:Void->Void = Thread.readMessage(true);
		
		trace('game launched', Lib.getTimer());
		
		Sys.setCwd('c:\\files\\games\\emu\\mame');
		var p = new Process('mame64.exe', ['pang']);
		// this call blocks until the process closes
		var exitCode = p.exitCode();
		
		trace('game closed?', Lib.getTimer());
		
		onComplete();
	}
}
