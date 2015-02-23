package com.grapefrukt.apps.fullfrontal.views;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.utils.InputRepeater;
import com.grapefrukt.apps.fullfrontal.views.GameView;
import com.grapefrukt.utils.inputter.InputterPlayer;
import openfl.display.Sprite;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameListView extends Sprite {
	
	var collection:Collection;
	var views:Array<GameView>;
	var rows:Int = Settings.VIEW_GAME_NUM_ROWS;
	var cols:Int = Settings.VIEW_GAME_NUM_COLUMNS;
	
	var scrollY:Float = 0;
	
	var selectionX:Int = 0;
	var selectionY:Int = 0;
	
	var inputRepeatY:InputRepeater;
	var inputRepeatX:InputRepeater;
	
	var maxScrollY(get, never):Int;

	public function new(collection:Collection, input:InputterPlayer) {
		super();
		this.collection = collection;
		
		inputRepeatX = new InputRepeater(input, 0);
		inputRepeatY = new InputRepeater(input, 1);
		
		x = Settings.VIEW_MARGIN_LEFT;
		y = Settings.VIEW_MARGIN_TOP + Settings.VIEW_GAME_H / 2;
		
		views = [];
		for (i in 0 ... rows * cols) {
			var view = new GameView(collection, i, i % cols, Math.floor(i / cols));
			views.push(view);
			addChild(view);
		}	
	}
	
	public function update() {
		inputRepeatY.update();
		inputRepeatX.update();
		
		selectionX += inputRepeatX.getMovement();
		if (selectionX < 0) selectionX = cols - 1;
		if (selectionX > cols - 1) selectionX = 0;
		
		selectionY += inputRepeatY.getMovement();
		
		while (selectionY > 1) {
			scrollY++;
			selectionY--;
		}
		
		while (selectionY < 0) {
			scrollY--;
			selectionY++;
		}
		
		if (scrollY < 0) scrollY = 0;
		if (scrollY > maxScrollY) scrollY = maxScrollY;
		
		for (view in views) view.update(selectionX, selectionY, Math.floor(scrollY));
	}
	
	function get_maxScrollY() return Std.int(collection.games.length / cols) - 2;
	
}