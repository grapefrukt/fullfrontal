package com.grapefrukt.apps.fullfrontal;
import com.grapefrukt.apps.fullfrontal.data.GameData;
import com.grapefrukt.apps.fullfrontal.Parser.Tag;
import cpp.vm.Thread;
import haxe.io.Eof;
import haxe.Timer;
import openfl.Lib;
import sys.io.File;
import sys.FileSystem;
import sys.io.FileInput;
import sys.io.FileSeek;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
 
class Parser {

	var startTime:Int = 0;
	var workThread:Thread;
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
	var games:Array<GameData>;
	
	public var progress(get, never):Float;
	
	public function new() {			
		startTime = Lib.getTimer();
		
		prepare();
		
		parseTimer = new Timer(16);
		parseTimer.run = parse;
		
		parse();
	}
	
	private function prepare() {
		games = [];
		
		tagName = new Tag('<game name="', '"');
		tagDescription = new Tag('<description>', '</description>');
		tagYear = new Tag('<year>', '</year>');
		tagManufacturer = new Tag('<manufacturer>', '</manufacturer>');
		tagCategory = new Tag('<category>', '</category>');
		tagNPlayers = new Tag('<nplayers>', '</nplayers>');
		
		var path = Main.home + '\\mame_filtered.xml';
		var stat = FileSystem.stat(path);
		
		numBytes = stat.size;
		file = File.read(path, false);
		
		name = '';
	}
	
	private function parse() {
		for (i in 0 ... 2000) if (!_parse()) break;
		if (file == null) {
			parseTimer.stop();
			trace('parsed ${games.length} entries in ' + (Lib.getTimer() - startTime) + 'ms');
		} else {
			trace(Math.round(charsRead / numBytes * 100) + '%');
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
		
		games.push(new GameData(name, tagDescription.result, Std.parseInt(tagYear.result), tagManufacturer.result, tagCategory.result, Std.parseInt(tagNPlayers.result)));
		tagDescription.clear();
		tagYear.clear();
		tagManufacturer.clear();
		tagCategory.clear();
		tagNPlayers.clear();
	}
	
	function get_progress() return charsRead / numBytes;
}


class Tag {
	
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
