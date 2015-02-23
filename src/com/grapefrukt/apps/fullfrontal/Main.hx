package com.grapefrukt.apps.fullfrontal;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.utils.Parser;
import com.grapefrukt.apps.fullfrontal.utils.Fullscreener;
import com.grapefrukt.apps.fullfrontal.utils.Launcher;
import com.grapefrukt.apps.fullfrontal.utils.Resizer;
import com.grapefrukt.apps.fullfrontal.views.GameListView;
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
	var gameListView:GameListView;
	
	public static var home(default, null):String = '';
	
	public function new() {
		super();		
		CrashReporter.init('C:\\files\\dev\\fullfrontal\\src\\');
		
		launcher = new Launcher(Settings.PATH_MAME);
		
		Fullscreener.init(launcher);
		Resizer.init(this);
		
		home = Sys.getCwd();
		
		collection = new Collection();
		
		parser = new Parser(collection, 12);
		//parser.addEventListener(ParserEvent.COMPLETE, handleParseComplete);
		//parser.addEventListener(ParserEvent.PROGRESS, handleParseProgress);
		parser.addEventListener(ParserEvent.READY, handleParseReady);
		
		snapshots = new Snapshots();
		
		addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
	}
	
	function handleParseReady(e:Event) {
		trace('handleParseReady');
		gameListView = new GameListView(collection);
		addChild(gameListView);
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
