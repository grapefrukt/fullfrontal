package com.grapefrukt.apps.fullfrontal.views;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.models.Game;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameView extends Sprite {
	
	var index:Int;
	var offsetX(default, null):Int;
	var offsetY(default, null):Int;
	
	var lastGameIndex:Int = -1;
	
	var text:TextField;
	var collection:Collection;
	var game:Game;
	
	var bitmap:Bitmap;

	public function new(collection:Collection, index:Int, offsetX:Int, offsetY:Int) {
		super();
		this.collection = collection;
		this.index = index;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
		bitmap = new Bitmap(null);
		addChild(bitmap);
		
		//text = new TextField();
		//text.text = Std.string(index);
		//text.selectable = false;
		//addChild(text);
		
		graphics.beginFill(Std.int(Math.random() * 0xffffff));
		graphics.drawRect(0, 0, Settings.VIEW_GAME_SNAP_W, Settings.VIEW_GAME_SNAP_H);
	}
	
	public function update(selectionX:Int, selectionY:Int) {
		var row = selectionY - offsetY + 2;
		var page = Math.floor(row / 4);
		var scrollRow = row - page * 4;
		var gameIndex = page * 12 + index;
		if (lastGameIndex != gameIndex) refresh(gameIndex);
		
		//text.text = '$index\n$page\n$gameIndex';
		x = offsetX * Settings.VIEW_GAME_W;
		y = ( -scrollRow + 2) * Settings.VIEW_GAME_H;
	}
	
	function refresh(gameIndex:Int) {
		lastGameIndex = gameIndex;
		if (game != null) game.disposeSnap();
		game = collection.getGameByIndex(gameIndex);
		visible = game != null;
		if (!visible) return;
		
		game.generateSnap();
		bitmap.bitmapData = game.snap;
	}
	
}