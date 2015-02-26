package com.grapefrukt.apps.fullfrontal.utils;
import com.grapefrukt.apps.fullfrontal.models.Game;
import com.grapefrukt.apps.fullfrontal.sound.SoundManager;
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Snapshots {
	
	var timer:Timer;
	var queue:List<Game>;
	var matrix:Matrix;
	
	var numLoaded:Int = 0;
	var alertOnComplete:Bool = false;
	
	public function new() {
		queue = new List();
		matrix = new Matrix();
	}
	
	function tick() {
		var t = Lib.getTimer();
		for (i in 0 ... 4) pop();
		
		if (queue.length == 0) {
			timer.stop();
			timer = null;
			
			if (alertOnComplete) SoundManager.play(Sfx.complete);
			alertOnComplete = false;
		}
		
		//trace('$numLoaded snaps loaded');
	}
	
	function pop() {
		var game = queue.pop();
		if (game == null) return;
		if (game.snap == null) return;
		
		var image = BitmapData.load(Settings.PATH_SNAPS + '/' + game.name + '.png');
		if (image != null) {
			numLoaded++;
			matrix.identity();
			matrix.scale(game.snap.width / image.width, game.snap.height / image.height);
			game.snap.draw(image, matrix, null, null, null, true);
			image.dispose();
		} else {
			trace('missing snap for ${game.name}');
			game.snap.fillRect(game.snap.rect, 0x000000);
		}
	}
	
	public function request(game:Game, highPriority:Bool) {
		game.generateSnap();
		highPriority ? queue.push(game) : queue.add(game);
		
		if (timer == null) {
			timer = new Timer(16);
			timer.run = tick;
		}
	}
	
	public function requestAll(games:Array<Game>) {
		alertOnComplete = true;
		for (game in games) game.generateSnap(false);
	}
	
	public function cancelRequest(game:Game) {
		//queue.remove(game);
	}
	
}