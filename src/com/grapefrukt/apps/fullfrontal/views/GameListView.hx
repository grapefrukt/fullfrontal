package com.grapefrukt.apps.fullfrontal.views;

import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.views.GameView;
import openfl.display.Sprite;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameListView extends Sprite {
	
	var games:Collection;
	var views:Array<GameView>;
	
	var positionX:Int = 0;
	var positionY:Int = 0;

	public function new(games:Collection) {
		super();
		this.games = games;
		
		x = Settings.VIEW_MARGIN_LEFT;
		y = Settings.VIEW_MARGIN_TOP + Settings.VIEW_GAME_H / 2;
		
		views = [];
		for (i in 0 ... 12) {
			var view = new GameView(i % Settings.VIEW_GAME_SNAPS_PER_LINE, Math.floor(i / Settings.VIEW_GAME_SNAPS_PER_LINE));
			views.push(view);
			addChild(view);
		}
		
		update();
	}
	
	function update() {
		for (view in views) {
			view.x = view.posX * Settings.VIEW_GAME_W;
			view.y = view.posY * Settings.VIEW_GAME_H;
		}
	}
	
}