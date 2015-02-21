package com.grapefrukt.apps.fullfrontal;
import com.grapefrukt.apps.fullfrontal.data.GameData;
import com.grapefrukt.apps.fullfrontal.Parser.Tag;
import cpp.vm.Thread;
import haxe.io.Eof;
import openfl.Lib;
import sys.io.File;
import sys.FileSystem;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
 
class Parser {

	var startTime:Int = 0;
	var data:Array<GameData>;
	
	public function new() {	
		startTime = Lib.getTimer();
		var t = Thread.create(parse);
		t.sendMessage(onParseProgress);
	}
	
	function onParseProgress(progress:Float, data:Array<GameData>) {
		trace('parsed ${Math.round(progress * 100)}%');
		if (data != null) {
			this.data = data;
			trace('parsed ${data.length} entries in ' + (Lib.getTimer() - startTime) + 'ms');
			
			this.data[Std.int(Math.random() * data.length)].trace();
		}
	}
	
	private static function parse() {
		var games:Array<GameData> = [];
		
		var tagName 		= new Tag('<game name="', '"');
		var tagDescription 	= new Tag('<description>', '</description>');
		var tagYear 		= new Tag('<year>', '</year>');
		var tagManufacturer = new Tag('<manufacturer>', '</manufacturer>');
		var tagCategory 	= new Tag('<category>', '</category>');
		var tagNPlayers 	= new Tag('<nplayers>', '</nplayers>');
		
		var onProgress:Float->Array<GameData>->Void = Thread.readMessage(true);
		
		var path = Main.home + '\\mame_filtered.xml';
		
		var stat = FileSystem.stat(path);
		var bytes = stat.size;
		
		var f = File.read(path);
		var charsRead = 0;
		var callbackCounter = 0;
		
		try {
			var game:GameData = null;
			var name:String = '';
			
			while (true) {
				var str = f.readLine();
				
				if (tagName.result != '') {
					name = tagName.result;
					tagName.clear();
				}
				
				if (tagDescription.match(str)) {
				} else if (tagYear.match(str)) {
				} else if (tagManufacturer.match(str)) {
				} else if (tagCategory.match(str)) {
				} else if (tagNPlayers.match(str)) {
				} else if (tagName.match(str)) {
					if (name != '') {
						games.push(new GameData(name, tagDescription.result, tagYear.result, tagManufacturer.result, tagCategory.result, Std.parseInt(tagNPlayers.result)));
						tagDescription.clear();
						tagYear.clear();
						tagManufacturer.clear();
						tagCategory.clear();
						tagNPlayers.clear();
					}
				}
				
				charsRead += str.length;
				
				if (callbackCounter-- <= 0) {
					callbackCounter = 2000;
					onProgress(charsRead / bytes, null);
				}
			}
		} catch (ex:Eof) {
			f.close();
		}
		
		onProgress(1, games);
	}
}


class Tag {
	
	var start:String;
	var end:String;
	
	public var result(default, null):String;
	
	public function new(start:String, end:String) {
		this.start = start;
		this.end = end;
	}
	
	public function clear() {
		result = '';
	}
	
	public function match(string:String) {
		// if this already is matched no need to look
		if (result != '') return false;
		var startIndex = string.indexOf(start);
		if (startIndex == -1) return false;
		var endIndex = string.indexOf(end, startIndex + start.length);
		if (endIndex == -1) return false;
		result = string.substring(startIndex + start.length, endIndex);
		return true;
	}
}
