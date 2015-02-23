package com.grapefrukt.apps.fullfrontal.views;

import openfl.display.Sprite;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameView extends Sprite {
	
	var index:Int;
	var offsetX(default, null):Int;
	var offsetY(default, null):Int;

	public function new(index:Int, offsetX:Int, offsetY:Int) {
		super();
		this.index = index;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
		graphics.beginFill(Std.int(Math.random() * 0xffffff));
		graphics.drawRect(0, 0, Settings.VIEW_GAME_SNAP_W, Settings.VIEW_GAME_SNAP_H);
	}
	
	public function setSelection(selectionX:Int, selectionY:Int) {
		x = offsetX * Settings.VIEW_GAME_W;
		y = ((offsetY - (selectionY + 2)) % 4 + 2) * Settings.VIEW_GAME_H;
	}
	
}