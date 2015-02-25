package com.grapefrukt.apps.fullfrontal.views;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.models.Game;
import openfl.display.Bitmap;
import openfl.display.JointStyle;
import openfl.display.Shape;
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
	var selection:Shape;

	public function new(collection:Collection, index:Int, offsetX:Int, offsetY:Int) {
		super();
		this.collection = collection;
		this.index = index;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
		bitmap = new Bitmap(null);
		addChild(bitmap);
		
		selection = new Shape();
		selection.graphics.lineStyle(3, Settings.COLOR_BASE, 1, false, null, null, JointStyle.MITER);
		selection.graphics.drawRect(0, 0, Settings.VIEW_GAME_SNAP_W, Settings.VIEW_GAME_SNAP_H);
		addChild(selection);
	}
	
	public function update(selectionX:Int, selectionY:Int, scrollY:Int, selectedIndex:Int, forceRefresh:Bool = false) {
		var row = scrollY - offsetY + 2;
		var page = Math.floor(row / 4);
		var scrollRow = row - page * 4;
		var gameIndex = page * 12 + index;
		
		selection.visible = selectedIndex == gameIndex;
		
		if (lastGameIndex != gameIndex || forceRefresh) refresh(gameIndex);
		
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