package com.grapefrukt.apps.fullfrontal;
import com.grapefrukt.apps.fullfrontal.models.Game;
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
	var queue:List<Game>;
	var matrix:openfl.geom.Matrix;
	
	public function new() {
		queue = new List();
		matrix = new Matrix();
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
		matrix.identity();
		matrix.scale(game.snap.width / image.width, game.snap.height / image.height);
		game.snap.draw(image, matrix, null, null, null, true);
	}
	
	public function request(game:Game) {
		game.generateSnap();
		queue.add(game);
		
		if (timer == null) {
			timer = new Timer(16);
			timer.run = tick;
		}
	}
	
}