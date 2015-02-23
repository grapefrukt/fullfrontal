package com.grapefrukt.apps.fullfrontal.views;

import openfl.display.Sprite;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameView extends Sprite {
	
	public var posX(default, null):Int;
	public var posY(default, null):Int;

	public function new(posX:Int, posY:Int) {
		super();
		this.posX = posX;
		this.posY = posY;
		
		trace(posX, posY);
		
		graphics.beginFill(Std.int(Math.random() * 0xffffff));
		graphics.drawRect(0, 0, Settings.VIEW_GAME_SNAP_W, Settings.VIEW_GAME_SNAP_H);
	}
	
}