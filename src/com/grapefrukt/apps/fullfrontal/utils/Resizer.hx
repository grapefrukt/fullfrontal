package com.grapefrukt.apps.fullfrontal.utils;
import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Resizer {
	
	static var root:Sprite;

	public static function init(root:Sprite) {
		Resizer.root = root;
		Lib.current.stage.addEventListener(Event.RESIZE, handleResize);
		Timer.delay(function() {
			handleResize(null);
		}, 200);
	}
	
	static function handleResize(e:Event) {
		var stageWidth = Std.int(Lib.current.stage.stageWidth);
		var stageHeight = Std.int(Lib.current.stage.stageHeight);
		
		var ratio = stageWidth / stageHeight;
		// landscape
		if (ratio > Settings.STAGE_W / Settings.STAGE_H) {
			root.scaleY = root.scaleX = stageHeight / Settings.STAGE_H;
		// portrait
		} else {
			root.scaleX = root.scaleY = stageWidth / Settings.STAGE_W;
		}
		
		root.x = stageWidth / 2 - Settings.STAGE_W * root.scaleX / 2;
		root.y = stageHeight / 2 - Settings.STAGE_H * root.scaleY / 2;
	}
	
}