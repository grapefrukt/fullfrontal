package com.grapefrukt.apps.fullfrontal;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Settings {

	public static var STAGE_W:Int = 320;
	public static var STAGE_H:Int = 240;
	public static var FULLSCREEN:Bool = true;
	
	public static var PATH_MAME	:String = 'c:/files/games/emu/mame/mame64.exe';
	public static var PATH_XML	:String = 'mame_filtered.xml';
	public static var PATH_SNAPS:String = 'c:/files/games/emu/mame/snap';
	
	public static var VIEW_GAME_NUM_COLUMNS		:Int = 3;
	public static var VIEW_GAME_NUM_ROWS		:Int = 4;
	
	public static inline var VIEW_MARGIN_X	:Int = 18;
	public static inline var VIEW_MARGIN_Y	:Int = 10;
	
	public static inline var VIEW_GAME_SNAP_W	:Int = 89;
	public static inline var VIEW_GAME_SNAP_H	:Int = 67;
	public static inline var VIEW_GAME_MARGIN	:Int = 8;
	public static inline var VIEW_GAME_SELECT_OUTLINE	:Int = 3;
	
	public static var VIEW_GAME_W:Int = VIEW_GAME_SNAP_W + VIEW_GAME_MARGIN;
	public static var VIEW_GAME_H:Int = VIEW_GAME_SNAP_H + VIEW_GAME_MARGIN;
	
	static public inline var INPUT_DEADZONE:Float = .25;
	static public inline var INPUT_TIME_TO_REPEAT:Int = 200;
	static public inline var INPUT_TIME_TO_MAX:Int = 4000;
	static public inline var INPUT_REPEAT_SPEED_MIN:Float = .06;
	static public inline var INPUT_REPEAT_SPEED_MAX:Float = 3;
	
	static public inline var COLOR_BASE:Int = 0xc9db00;
	static public inline var COLOR_SNAP:Int = 0x3f3f3f;
	
	public static inline var SOUND_MUSIC_FADEIN_DURATION	:Float = 1.0;
	public static inline var SOUND_MUSIC_FADEOUT_DURATION	:Float = 1.0;
	public static inline var SOUND_PLAY_MUSIC				:Bool = false;
	public static inline var SOUND_MIN_REPEAT_DELAY			:Float = 50;
}