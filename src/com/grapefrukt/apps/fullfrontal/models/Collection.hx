package com.grapefrukt.apps.fullfrontal.models;
import com.grapefrukt.apps.fullfrontal.utils.Snapshots;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Collection extends EventDispatcher {
	
	public var games(get, never):Array<Game>;
	public var all(default, null):AllList;
	
	public var categories:Array<Category>;
	var categoryMap:Map<String, Category>;
	
	public var lists:Array<List>;

	public var currentList(get, never):List;
	public var numGames(get, never):Int;
	public var snapshots(default, null):Snapshots;
	
	var listIndex:Int = 0;
	
	public function new() {
		super();
		all = new AllList();		
		categories = [];
		categoryMap = new Map();
		snapshots = new Snapshots();
		lists = [all];
	}
	
	public function addGame(game:Game) {
		game.setCollection(this);
		all.addGame(game);
	}
	
	public function cycleList() {
		listIndex++;
		if (listIndex >= lists.length) listIndex = 0;
		trace('cycle list $listIndex');
		dispatchEvent(new CollectionEvent(CollectionEvent.CHANGE_LIST));
	}
	
	public function addList(list:List) {
		lists.push(list);
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
		return lists[listIndex].getGameByIndex(index);
	}
	
	public function getGameByID(id:String):Game {
		return lists[listIndex].getGameByID(id);
	}
	
	function get_numGames() return currentList.numGames;
	function get_games() return currentList.games;
	inline function get_currentList() return lists[listIndex];
	
}

class CollectionEvent extends Event {
	
	public static inline var CHANGE_LIST:String = 'collectionevent_change_list';
	
	public function new(type:String) {
		super(type);
	}
}