package com.grapefrukt.apps.fullfrontal.utils;
import com.grapefrukt.apps.fullfrontal.models.Game;
import cpp.vm.Thread;
import haxe.Timer;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;
import sys.io.Process;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Launcher extends EventDispatcher {
	
	public var hasGameRunning(default, null):Bool = false;
	
	var path:String;
	var executable:String;
	var thread:Thread;
	
	static inline var DELAY_LAUNCH:Int = 200;
	static inline var DELAY_CLOSE:Int = 200;

	public function new(path:String, executable:String) {
		super();
		this.path = path;
		this.executable = executable;
	}
	
	public function requestLaunch(game:Game) {
		if (hasGameRunning) return false;
		
		//trace('thread created');
		hasGameRunning = true;
		dispatchEvent(new LaunchEvent(LaunchEvent.LAUNCH));
		
		Timer.delay(function() {
			thread = Thread.create(launch);
			thread.sendMessage(path);
			thread.sendMessage(executable);
			thread.sendMessage(game.name);
			thread.sendMessage(onComplete);
		}, DELAY_LAUNCH);
		
		return true;
	}
	
	function onComplete() {
		Timer.delay(function() {
			hasGameRunning = false;
			thread = null;
			dispatchEvent(new LaunchEvent(LaunchEvent.CLOSE));
		}, DELAY_CLOSE);
	}
	
	static function launch() {
		var path:String = Thread.readMessage(true);
		var executable:String = Thread.readMessage(true);
		var args:String = Thread.readMessage(true);
		var onComplete:Void->Void = Thread.readMessage(true);
		
		Sys.setCwd(path);
		var p = new Process(executable, ['pang']);
		// this call blocks until the process closes
		var exitCode = p.exitCode();
		
		trace('game closed, exit code: $exitCode');
		
		onComplete();
	}
	
}

class LaunchEvent extends Event {
	
	public static inline var LAUNCH	:String = 'launchevent_launch';
	public static inline var CLOSE	:String = 'launchevent_close';
	
	public function new(type:String) {
		super(type);
	}
}