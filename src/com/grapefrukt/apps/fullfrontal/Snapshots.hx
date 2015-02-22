package com.grapefrukt.apps.fullfrontal;
import com.grapefrukt.apps.fullfrontal.data.GameData;
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Snapshots {

	var path:String = 'c:\\files\\games\\emu\\mame\\snap\\';
	var timer:Timer;
	var queue:List<GameData>;
	
	public function new() {
		queue = new List();
	}
	
	function tick() {
		var t = Lib.getTimer();
		for (i in 0 ... 4) pop();
		
		trace(Lib.getTimer() - t);
		
		if (queue.length == 0) {
			timer.stop();
			timer = null;
		}
	}
	
	function pop() {
		var game = queue.pop();
		if (game == null) return;
		
		var image = BitmapData.load(path + game.name + '.png');
		var m = new Matrix();
		m.scale(game.snap.width / image.width, game.snap.height / image.height);
		game.snap.draw(image, m, null, null, null, true);
	}
	
	public function request(game:GameData) {
		game.generateSnap();
		queue.add(game);
		
		if (timer == null) {
			timer = new Timer(16);
			timer.run = tick;
		}
	}
	
}