package com.grapefrukt.apps.fullfrontal;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.utils.Parser;
import com.grapefrukt.apps.fullfrontal.utils.Fullscreener;
import com.grapefrukt.apps.fullfrontal.utils.Launcher;
import com.grapefrukt.apps.fullfrontal.utils.Resizer;
import com.grapefrukt.apps.fullfrontal.views.GameListView;
import com.grapefrukt.utils.CrashReporter;
import com.grapefrukt.utils.inputter.Inputter;
import com.grapefrukt.utils.inputter.InputterPlayer;
import com.grapefrukt.utils.inputter.plugins.InputterPluginJoystick;
import com.grapefrukt.utils.inputter.plugins.InputterPluginKeyboard;
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
	var gameListView:GameListView;
	var input:InputterPlayer;
	
	public static var home(default, null):String = '';
	
	public function new() {
		super();		
		CrashReporter.init('C:\\files\\dev\\fullfrontal\\src\\');
		
		var inputter = new Inputter(stage);
		input = inputter.createPlayer(4, 10);
		input.addPlugin(new InputterPluginJoystick(0, [0, 1, 2, 3], [0, 1, 2, 3 ]));
		input.addPlugin(new InputterPluginKeyboard([Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, Keyboard.DOWN], [Keyboard.Z, Keyboard.X, Keyboard.C, Keyboard.V]));		
		
		launcher = new Launcher(Settings.PATH_MAME);
		
		Fullscreener.init(launcher);
		Resizer.init(this);
		
		home = Sys.getCwd();
		
		collection = new Collection();
		
		parser = new Parser(collection, 12);
		parser.addEventListener(ParserEvent.COMPLETE, handleParseComplete);
		//parser.addEventListener(ParserEvent.PROGRESS, handleParseProgress);
		parser.addEventListener(ParserEvent.READY, handleParseReady);
		
		addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
	}
	
	function handleParseComplete(e:ParserEvent) {
		for (game in collection.games) game.generateSnap(false);
	}
	
	function handleParseReady(e:Event) {
		trace('handleParseReady');
		gameListView = new GameListView(collection, input);
		addChild(gameListView);
	}
	
	function handleEnterFrame(e:Event) {
		if (gameListView != null) gameListView.update();
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
