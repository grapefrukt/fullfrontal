package com.grapefrukt.apps.fullfrontal.views;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import com.grapefrukt.apps.fullfrontal.models.Game;
import openfl.display.Sprite;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class CurrentLetterView extends Sprite {

	var isAlpha = ~/[a-z]/i;
	var currentChar:String = '';
	var text:BitmapTextField;
	
	public function new() {
		super();
		y -= 20;
		text = FontSettings.getDefaultTextField(Settings.STAGE_W - Settings.VIEW_MARGIN_X * 2);
		text.alignment = BitmapTextAlign.LEFT;
		addChild(text);
	}
	
	public function setSelectedGame(game:Game) {
		var newChar = getChar(game);
		if (newChar == currentChar) return;
		currentChar = newChar;
		trace('currentChar: $currentChar');
		text.text = currentChar;
	}
	
	function getChar(game:Game) {
		var char = game.description.charAt(0);
		if (isAlpha.match(char)) return char.toUpperCase();
		return '#';
	}
	
}