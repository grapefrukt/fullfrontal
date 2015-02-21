package com.grapefrukt.apps.fullfrontal.data;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class GameData {
	
	var name(default, null):String;
	var description(default, null):String;
	var year(default, null):String;
	var manufacturer(default, null):String;
	var category(default, null):String;
	var nplayers(default, null):Int;

	public function new(name:String, description:String, year:String, manufacturer:String, category:String, nplayers:Int) {
		this.name = name;
		this.description = description;
		this.year = year;
		this.manufacturer = manufacturer;
		this.category = category;
		this.nplayers = nplayers;
	}
	
	public function trace() {
		trace(name, description, year, manufacturer, category, nplayers);
	}
	
}