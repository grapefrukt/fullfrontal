package com.grapefrukt.apps.fullfrontal.parser;
import com.grapefrukt.apps.fullfrontal.models.Collection;
import com.grapefrukt.apps.fullfrontal.models.Game;
import haxe.io.Eof;
import haxe.Timer;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
 
class XMLParser extends EventDispatcher {

	var startTime:Int = 0;
	
	var tagName:Tag;
	var tagDescription:Tag;
	var tagYear:Tag;
	var tagManufacturer:Tag;
	var tagCategory:Tag;
	var tagNPlayers:Tag;
	
	var file:FileInput;
	var numBytes:Int;
	var charsRead:Int;
	var name:String;
	
	var parseTimer:Timer;
	var games:Collection;
	var preloadCount:Int;
	
	public var progress(get, never):Float;
	
	public function new(games:Collection, preloadCount:Int = 200) {
		super();
		this.preloadCount = preloadCount;
		this.games = games;
		
		startTime = Lib.getTimer();
		
		prepare();
		parseTimer = new Timer(16);
		parseTimer.run = parse;
	}
	
	private function prepare() {
		tagName = new Tag('<game name="', '"');
		tagDescription = new Tag('<description>', '</description>');
		tagYear = new Tag('<year>', '</year>');
		tagManufacturer = new Tag('<manufacturer>', '</manufacturer>');
		tagCategory = new Tag('<category>', '</category>');
		tagNPlayers = new Tag('<nplayers>', '</nplayers>');
		
		Sys.setCwd(Main.home);
		var path = Settings.PATH_XML;
		var stat = FileSystem.stat(path);
		
		numBytes = stat.size;
		file = File.read(path, false);
		
		name = '';
	}
	
	private function parse() {
		for (i in 0 ... 500) if (!_parse()) break;
		if (file == null) {
			parseTimer.stop();
			trace('parsed ${games.numGames} entries in ' + (Lib.getTimer() - startTime) + 'ms');
			dispatchEvent(new ParserEvent(ParserEvent.COMPLETE, 1));
		} else {
			//trace(Math.round(charsRead / numBytes * 100) + '%');
		}
	}
	
	private function _parse() {
		var line = '';
		
		try {
			line = file.readLine();
		} catch (ex:Eof) {
			file.close();
			file = null;
			addGame();
			return false;
		}
		
		charsRead += line.length + 2;
		
		if (!tagName.canMatch) {
			name = tagName.result;
			tagName.clear();
		}
		
		if (tagDescription.canMatch && tagDescription.match(line)) {
		} else if (tagYear.canMatch && tagYear.match(line)) {
		} else if (tagManufacturer.canMatch && tagManufacturer.match(line)) {
		} else if (tagCategory.canMatch && tagCategory.match(line)) {
		} else if (tagNPlayers.canMatch && tagNPlayers.match(line)) {
		} else if (tagName.canMatch && tagName.match(line)) {
			addGame();
		}
		
		return true;
	}
	
	function addGame() {
		if (name.length == 0) return;
		
		var category = games.getCategory(replaceEntities(tagCategory.result));
		var game = new Game(	replaceEntities(name), 
								replaceEntities(tagDescription.result), 
								Std.parseInt(tagYear.result), 
								replaceEntities(tagManufacturer.result), 
								category, 
								Std.parseInt(tagNPlayers.result)
							);
		games.addGame(game);
		
		tagDescription.clear();
		tagYear.clear();
		tagManufacturer.clear();
		tagCategory.clear();
		tagNPlayers.clear();
		
		if (games.numGames == preloadCount) dispatchEvent(new ParserEvent(ParserEvent.READY, progress));
		if (games.numGames % 5 == 0) dispatchEvent(new ParserEvent(ParserEvent.PROGRESS, progress));
	}
	
	function replaceEntities(string:String) {
		string = StringTools.replace(string, '&amp;', '&');
		string = StringTools.replace(string, '&apos;', '\'');
		string = StringTools.replace(string, '&gt;', '<');
		string = StringTools.replace(string, '&lt;', '>');
		return string;
	}
	
	function get_progress() return charsRead / numBytes;
}


private class Tag {
	
	var start:String;
	var end:String;
	
	public var result(default, null):String;
	public var canMatch(get, never):Bool;
	
	public function new(start:String, end:String) {
		this.start = start;
		this.end = end;
	}
	
	public inline function clear() {
		result = '';
	}
	
	public function match(string:String) {
		var startIndex = string.indexOf(start);
		if (startIndex == -1) return false;
		var endIndex = string.indexOf(end, startIndex + start.length);
		if (endIndex == -1) return false;
		result = string.substring(startIndex + start.length, endIndex);
		return true;
	}
	
	inline function get_canMatch() return result.length == 0;
}

class ParserEvent extends Event {
	
	public static inline var PROGRESS	:String = 'launchevent_progress';
	public static inline var READY		:String = 'launchevent_ready';
	public static inline var COMPLETE	:String = 'launchevent_complete';
	
	public var progress(default, null):Float;
	
	public function new(type:String, progress:Float) {
		super(type);
		this.progress = progress;
	}
}
