package com.grapefrukt.apps.fullfrontal.views;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.models.Game;
import motion.Actuate;
import motion.easing.Back;
import openfl.display.Bitmap;
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
	
	var isSelected:Bool = false;
	
	static inline var HIDE_SCALE:Float = .4;

	public function new(collection:Collection, index:Int, offsetX:Int, offsetY:Int) {
		super();
		this.collection = collection;
		this.index = index;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		
		graphics.beginFill(0xff00ff);
		graphics.drawCircle(0, 0, 5);
		
		selection = new Shape();
		var w = Settings.VIEW_GAME_SNAP_W + Settings.VIEW_GAME_SELECT_OUTLINE * 2;
		var h = Settings.VIEW_GAME_SNAP_H + Settings.VIEW_GAME_SELECT_OUTLINE * 2;
		selection.graphics.beginFill(Settings.COLOR_BASE);
		selection.graphics.drawRect( -w / 2, -h / 2, w, h);
		selection.scaleX = selection.scaleY = HIDE_SCALE;
		addChild(selection);
		
		bitmap = new Bitmap(null);
		bitmap.x -= Settings.VIEW_GAME_SNAP_W / 2;
		bitmap.y -= Settings.VIEW_GAME_SNAP_H / 2;
		addChild(bitmap);
	}
	
	public function update(selectionX:Int, selectionY:Int, scrollY:Int, selectedIndex:Int, forceRefresh:Bool = false) {
		var row = scrollY - offsetY + 2;
		var page = Math.floor(row / 4);
		var scrollRow = row - page * 4;
		var gameIndex = page * 12 + index;
		
		setSelected(selectedIndex == gameIndex);
		
		if (lastGameIndex != gameIndex || forceRefresh) refresh(gameIndex);
		
		x = offsetX * Settings.VIEW_GAME_W + Settings.VIEW_GAME_SNAP_W / 2;
		y = ( -scrollRow + 2) * Settings.VIEW_GAME_H + Settings.VIEW_GAME_SNAP_H / 2;
	}
	
	function setSelected(value:Bool) {
		if (isSelected == value) return;
		isSelected = value;
		if (isSelected) {
			Actuate.tween(selection, .2, { scaleX : 1 } ).ease(Back.easeOut);
			Actuate.tween(selection, .2, { scaleY : 1 } ).ease(Back.easeOut).delay(.1);
		} else {
			Actuate.tween(selection, .2, { scaleX : HIDE_SCALE, scaleY : HIDE_SCALE } );
		}
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