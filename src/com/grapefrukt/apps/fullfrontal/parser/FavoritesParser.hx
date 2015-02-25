package com.grapefrukt.apps.fullfrontal.parser;
import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.models.FavoriteList;
import com.grapefrukt.utils.GoogleDocsData;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class FavoritesParser extends GoogleDocsData<TempFav> {
	
	var collection:Collection;
	var numLoadsComplete:Int = 0;
	
	public function new(collection:Collection) {
		super('1Zz3Iq-H6XFmS_oTtV0L8NIaHRXCV4SNrKLYk2c1Dqxg', _onComplete);
		this.collection = collection;
	}
	
	public function handleParseComplete() {
		numLoadsComplete++;
		apply();
	}
	
	function _onComplete() {
		trace('favorites downloaded');
		numLoadsComplete++;
		apply();
	}
	
	function apply() {
		if (numLoadsComplete < 2) return;
		
		for (item in data) {
			var favlist = new FavoriteList(item.name);
			var ids = item.games.split(' ');
			for (id in ids) {
				var game = collection.getGameByID(id);
				if (game == null) {
					trace('game $id (from ${item.name}) is not in collection');
					continue;
				}
				favlist.addGame(game);
			}
			
			if (favlist.games.length <= 0) {
				trace('favorite list ${item.name} had no games, skipping');
				continue;
			}
			
			collection.addList(favlist);
		}
	}
	
}

private class TempFav {
	
	public var name:String;
	public var games:String;
	
	public function new() {}
}