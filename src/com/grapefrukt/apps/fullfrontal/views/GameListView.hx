package com.grapefrukt.apps.fullfrontal.views;

import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.models.Game;
import com.grapefrukt.apps.fullfrontal.sound.SoundManager;
import com.grapefrukt.apps.fullfrontal.utils.InputRepeater;
import com.grapefrukt.apps.fullfrontal.views.GameView;
import com.grapefrukt.utils.inputter.events.InputterEvent;
import com.grapefrukt.utils.inputter.InputterPlayer;
import motion.Actuate;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextField;

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
	var lastSelectedIndex = -1;
	
	var textTitle:BitmapTextField;
	var textList:BitmapTextField;
	var fadeTop:Shape;
	var fadeBottom:Shape;
	var currentLetter:CurrentLetterView;
	
	var lockUpdates:Bool = false;
	var selectedGame:com.grapefrukt.apps.fullfrontal.models.Game;
	
	public var selectedIndex(get, never):Int;

	public function new(collection:Collection, input:InputterPlayer) {
		super();
		this.collection = collection;
		
		collection.addEventListener(CollectionEvent.CHANGE_LIST, handleChangeList);
		
		inputRepeatX = new InputRepeater(input, 0);
		inputRepeatY = new InputRepeater(input, 1);
		
		x = Settings.VIEW_MARGIN_X;
		y = Settings.VIEW_MARGIN_Y + Settings.VIEW_GAME_H / 2;
		
		views = [];
		for (i in 0 ... rows * cols) {
			var view = new GameView(collection, i, i % cols, Math.floor(i / cols));
			views.push(view);
			addChild(view);
		}
		
		fadeTop = new Shape();
		fadeTop.graphics.beginFill(0, .8);
		fadeTop.graphics.drawRect(0, -y, Settings.STAGE_W, 40);
		addChild(fadeTop);
		
		fadeBottom = new Shape();
		fadeBottom.graphics.beginFill(0, .8);
		fadeBottom.graphics.drawRect(0, Settings.STAGE_H - 50 - y, Settings.STAGE_W, 50);
		addChild(fadeBottom);
		
		currentLetter = new CurrentLetterView();
		addChild(currentLetter);
		
		textTitle = FontSettings.getDefaultTextField(Settings.STAGE_W - Settings.VIEW_MARGIN_X * 2);
		textTitle.y = Settings.STAGE_H - 42 - y;
		addChild(textTitle);
		
		textList = FontSettings.getDefaultTextField(Settings.STAGE_W - Settings.VIEW_MARGIN_X * 2);
		textList.y = -20;
		textList.alignment = BitmapTextAlign.RIGHT;
		addChild(textList);
		
		alpha = 0;
		handleChangeList(null);
	}
	
	function handleChangeList(e:CollectionEvent) {
		lockUpdates = true;
		Actuate.tween(this, .2, { alpha : 0 } ).onComplete(function() {
			textList.text = collection.currentList.name;
		
			// tries to stay on the same game when list switches
			var index = collection.games.indexOf(selectedGame);
			if (index == -1) index = 0;
			lastSelectedIndex = index;
			selectionX = index % cols;
			selectionY = 0;
			scrollY = Math.floor(index / cols);
			
			lockUpdates = false;
			update(true);
			
			SoundManager.play(Sfx.list);
			
			Actuate.tween(this, .2, { alpha : 1 } );
		});
	}
	
	public function update(force:Bool = false) {
		if (lockUpdates && !force) return;
		
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
		
		for (view in views) view.update(selectionX, selectionY, Math.floor(scrollY), selectedIndex, force);
		
		if (lastSelectedIndex == selectedIndex) return;
		lastSelectedIndex = selectedIndex;
		
		SoundManager.play(Sfx.move);
		
		selectedGame = collection.getGameByIndex(selectedIndex);
		if (selectedGame == null) return;
		textTitle.text = selectedGame.description;
		currentLetter.setSelectedGame(selectedGame);
	}
	
	function get_maxScrollY() return Math.ceil(collection.games.length / cols) - 2;
	function get_selectedIndex() {
		var index = Math.floor((scrollY + selectionY) * cols + selectionX);
		if (index < 0) return 0;
		if (index >= collection.numGames) return collection.games.length -1;
		return index;
	}
	
}