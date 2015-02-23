package com.grapefrukt.apps.fullfrontal.models;
import com.grapefrukt.apps.fullfrontal.utils.Snapshots;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Collection {
	
	public var games:Array<Game>;
	public var categories:Array<Category>;
	var categoryMap:Map<String, Category>;

	public var numGames(get, never):Int;
	public var snapshots(default, null):Snapshots;
	
	public function new() {
		games = [];
		categories = [];
		categoryMap = new Map();
		snapshots = new Snapshots();
	}
	
	public function addGame(game:Game) {
		game.setCollection(this);
		var i = 0;
		while (i < games.length && game.description > games[i].description) i++;
		games.insert(i, game);
	}
	
	public function getCategory(name:String) {
		var category = categoryMap.get(name);
		if (category == null) {
			category = new Category(name);
			categoryMap.set(name, category);
		}
		
		return category;
	}
	
	public function getGameByIndex(index:Int):Game {
		if (index < 0) return null;
		if (index > games.length - 1) return null;
		return games[index];
	}
	
	function get_numGames() return games.length;
	
}