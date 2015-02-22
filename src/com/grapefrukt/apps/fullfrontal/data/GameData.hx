package com.grapefrukt.apps.fullfrontal.data;
import openfl.display.BitmapData;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameData {
	
	public var name(default, null):String;
	public var description(default, null):String;
	public var year(default, null):Int;
	public var manufacturer(default, null):String;
	public var category(default, null):String;
	public var nplayers(default, null):Int;
	public var snap(default, null):BitmapData;
	
	public function new(name:String, description:String, year:Int, manufacturer:String, category:String, nplayers:Int) {
		this.name = name;
		this.description = description;
		this.year = year;
		this.manufacturer = manufacturer;
		this.category = category;
		this.nplayers = nplayers;
	}
	
	public function generateSnap() {
		snap = new BitmapData(60, 45, false, Std.int(Math.random() * 0xffffff));
	}
	
	public function trace() {
		trace(name, description, year, manufacturer, category, nplayers);
	}
	
}