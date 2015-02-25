package com.grapefrukt.apps.fullfrontal.models;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class List {
	public var name(default, null):String;
	public var games(default, null):Array<Game>;
	public var numGames(get, never):Int;

	public function new(name:String) {
		this.name = name;
		games = [];
	}
	
	public function addGame(game:Game) {
		var i = 0;
		while (i < games.length && game.description > games[i].description) i++;
		games.insert(i, game);
	}
	
	public function getGameByIndex(index:Int):Game {
		if (index < 0) return null;
		if (index > games.length - 1) return null;
		return games[index];
	}
	
	public function getGameByID(id:String):Game {
		for (game in games) if (game.name == id) return game;
		return null;
	}
	
	function get_numGames() return games.length;
}