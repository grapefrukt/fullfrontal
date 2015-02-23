package com.grapefrukt.apps.fullfrontal.models;
import com.grapefrukt.apps.fullfrontal.models.Collection;
import openfl.display.BitmapData;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Game {
	var collection:Collection;
	
	public var name(default, null):String;
	public var description(default, null):String;
	public var year(default, null):Int;
	public var manufacturer(default, null):String;
	public var category(default, null):Category;
	public var nplayers(default, null):Int;
	public var snap(default, null):BitmapData;
	
	public function new(name:String, description:String, year:Int, manufacturer:String, category:Category, nplayers:Int) {
		this.name = name;
		this.description = description;
		this.year = year;
		this.manufacturer = manufacturer;
		this.category = category;
		this.nplayers = nplayers;
	}
	
	public function generateSnap(highPriority:Bool = true) {
		if (snap != null) return;
		snap = new BitmapData(Settings.VIEW_GAME_SNAP_W, Settings.VIEW_GAME_SNAP_H, false, Std.int(Math.random() * 0xffffff));
		collection.snapshots.request(this, highPriority);
	}
	
	public function disposeSnap() {
		//collection.snapshots.cancelRequest(this);
	}
	
	public function trace() {
		trace(name, description, year, manufacturer, category, nplayers);
	}
	
	public function setCollection(collection:Collection) {
		this.collection = collection;
	}
	
}