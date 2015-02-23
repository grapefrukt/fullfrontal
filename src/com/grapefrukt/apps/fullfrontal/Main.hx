package com.grapefrukt.apps.fullfrontal;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.utils.Parser;
import com.grapefrukt.apps.fullfrontal.utils.Fullscreener;
import com.grapefrukt.apps.fullfrontal.utils.Launcher;
import com.grapefrukt.apps.fullfrontal.utils.Resizer;
import com.grapefrukt.utils.CrashReporter;
import cpp.vm.Thread;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.display.StageScaleMode;
import openfl.events.Event;
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
	var parser:Parser;
	var launcher:Launcher;
	var collection:Collection;
	var snapshots:Snapshots;
	
	public static var home(default, null):String = '';
	
	public function new() {
		super();		
		CrashReporter.init('C:\\files\\dev\\fullfrontal\\src\\');
		
		launcher = new Launcher('c:\\files\\games\\emu\\mame', 'mame64.exe');
		
		Fullscreener.init(launcher);
		Resizer.init(this);
		
		home = Sys.getCwd();
		
		collection = new Collection();
		
		parser = new Parser(collection, 12);
		//parser.addEventListener(ParserEvent.COMPLETE, handleParseComplete);
		parser.addEventListener(ParserEvent.READY, handleParseReady);
		//parser.addEventListener(ParserEvent.PROGRESS, handleParseProgress);
		
		snapshots = new Snapshots();
		
		addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
	}
	
	function handleParseReady(e:Event) {
		trace('handleParseReady');
		
		graphics.clear();
		
		var t = Lib.getTimer();
		var i = 0;
		for (x in 0 ... 3) {
			for (y in 0 ... 4) {
				snapshots.request(collection.games[i]);
				var b = new Bitmap(collection.games[i].snap);
				b.x = 18 + (collection.games[i].snap.width  + 8) * x;
				b.y = (collection.games[i].snap.height + 8) * y;
				addChild(b);
				i++;
			}
		}
		trace('loaded $i snaps in ' + (Lib.getTimer() - t));
	}
	
	function handleEnterFrame(e:Event) {
		graphics.clear();
		if (parser.progress >= 1) return;
		graphics.beginFill(0x000000);
		graphics.drawRect(5, 5, 2, 234 * parser.progress);
	}
	
	function handleKeyDown(e:KeyboardEvent) {
		if (e.keyCode == Keyboard.ESCAPE) {
			openfl.system.System.exit(0);
			return;
		}
		if (e.keyCode != Keyboard.ENTER) return;
		
		launcher.requestLaunch(collection.games[0]);
	}
	
}
