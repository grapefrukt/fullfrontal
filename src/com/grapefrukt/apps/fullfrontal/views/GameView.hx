package com.grapefrukt.apps.fullfrontal.views;

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
	
	var text:TextField;

	public function new(index:Int, offsetX:Int, offsetY:Int) {
		super();
		this.index = index;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
		text = new TextField();
		text.text = Std.string(index);
		text.selectable = false;
		
		alpha = .5;
		
		addChild(text);
		
		graphics.beginFill(Std.int(Math.random() * 0xffffff));
		graphics.drawRect(0, 0, Settings.VIEW_GAME_SNAP_W, Settings.VIEW_GAME_SNAP_H);
	}
	
	public function update(selectionX:Int, selectionY:Int) {
		var row = selectionY - offsetY + 2;
		var page = Math.floor(row / 4);
		var scrollRow = row - page * 4;
		var gameIndex = page * 12 + index;
		
		text.text = '$index\n$page\n$gameIndex';
		x = offsetX * Settings.VIEW_GAME_W;
		y = ( -scrollRow + 2) * Settings.VIEW_GAME_H;
		
		// ((offsetY - (selectionY + 2)) % 4 + 2)
	}
	
}