package com.grapefrukt.apps.fullfrontal.models;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Collection {
	
	public var games:Array<Game>;
	public var categories:Array<Category>;
	var categoryMap:Map<String, Category>;

	public var numGames(get, never):Int;
	
	public function new() {
		games = [];
		categories = [];
		categoryMap = new Map();
	}
	
	public function addGame(game:Game) {
		games.push(game);
	}
	
	public function getCategory(name:String) {
		var category = categoryMap.get(name);
		if (category == null) {
			category = new Category(name);
			categoryMap.set(name, category);
		}
		
		return category;
	}
	
	function get_numGames() return games.length;
	
}