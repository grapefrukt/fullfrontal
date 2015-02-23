package com.grapefrukt.apps.fullfrontal.views;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class FontSettings {
	
	public static function getDefaultTextField(width:Float = 100) {
		var font = BitmapFont.fromXNA('mini7', Assets.getBitmapData('images/font-mini7.png'));
		var textfield = new BitmapTextField(font, '');
		textfield.autoSize = false;
		textfield.width = width;
		textfield.alignment = BitmapTextAlign.CENTER;
		return textfield;
		
		//return tf;
	}
	
	public static function center(tf:TextField, x:Float = 0) {
		tf.x = x - tf.textWidth / 2;
	}
	
	public static function centerY(tf:TextField, y:Float = 0) {
		tf.y = y - tf.textHeight / 2;
	}
	
}