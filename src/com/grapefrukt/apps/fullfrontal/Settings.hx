package com.grapefrukt.apps.fullfrontal;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Settings {

	public static var STAGE_W:Int = 320;
	public static var STAGE_H:Int = 244;
	
	public static var PATH_MAME	:String = 'c:/files/games/emu/mame/mame64.exe';
	public static var PATH_XML	:String = 'mame_filtered.xml';
	
	public static var VIEW_GAME_SNAPS_PER_LINE:Int = 3;
	
	public static inline var VIEW_MARGIN_LEFT	:Int = 18;
	public static inline var VIEW_MARGIN_TOP	:Int = 10;
	
	public static inline var VIEW_GAME_SNAP_W:Int = 89;
	public static inline var VIEW_GAME_SNAP_H:Int = 67;
	public static inline var VIEW_GAME_MARGIN:Int = 8;
	
	public static var VIEW_GAME_W:Int = VIEW_GAME_SNAP_W + VIEW_GAME_MARGIN;
	public static var VIEW_GAME_H:Int = VIEW_GAME_SNAP_H + VIEW_GAME_MARGIN;
}