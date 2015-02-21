package com.grapefrukt.apps.fullfrontal;
import com.grapefrukt.apps.fullfrontal.data.GameData;
import com.grapefrukt.apps.fullfrontal.Parser.Tag;
import cpp.vm.Thread;
import haxe.io.Eof;
import openfl.Lib;
import sys.io.File;
import sys.FileSystem;
import sys.io.FileSeek;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
 
class Parser {

	var startTime:Int = 0;
	var data:Array<GameData>;
	
	public function new() {	
		startTime = Lib.getTimer();
		var numThreads = 1;
		for (i in 0 ... numThreads){
			var t = Thread.create(parse);
			t.sendMessage(onParseProgress);
			t.sendMessage(i / numThreads);
			t.sendMessage((i + 1) / numThreads);
		}
	}
	
	function onParseProgress(progress:Float, data:List<GameData>) {
		trace('parsed ${Math.round(progress * 100)}%');
		if (data != null) {
			//this.data = data;
			trace('parsed ${data.length} entries in ' + (Lib.getTimer() - startTime) + 'ms');
			
			//this.data[Std.int(Math.random() * data.length)].trace();
		}
	}
	
	private static function parse() {
		var games:List<GameData> = new List();
		
		var tagName 		= new Tag('<game name="', '"');
		var tagDescription 	= new Tag('<description>', '</description>');
		var tagYear 		= new Tag('<year>', '</year>');
		var tagManufacturer = new Tag('<manufacturer>', '</manufacturer>');
		var tagCategory 	= new Tag('<category>', '</category>');
		var tagNPlayers 	= new Tag('<nplayers>', '</nplayers>');
		
		var onProgress:Float->List<GameData>->Void = Thread.readMessage(true);
		var startFraction:Float = Thread.readMessage(true);
		var endFraction:Float = Thread.readMessage(true);
		
		var path = Main.home + '\\mame_filtered.xml';
		
		var stat = FileSystem.stat(path);
		var numBytes = stat.size * (endFraction - startFraction);
		
		var f = File.read(path);
		f.seek(Std.int(numBytes * startFraction), FileSeek.SeekCur);
		
		var charsRead = 0;
		var callbackCounter = 5000 * startFraction;
		
		try {
			var game:GameData = null;
			var name:String = '';
			
			while (true) {
				var str = f.readLine();
				
				if (!tagName.canMatch) {
					name = tagName.result;
					tagName.clear();
				}
				
				if (tagDescription.canMatch && tagDescription.match(str)) {
				} else if (tagYear.canMatch && tagYear.match(str)) {
				} else if (tagManufacturer.canMatch && tagManufacturer.match(str)) {
				} else if (tagCategory.canMatch && tagCategory.match(str)) {
				} else if (tagNPlayers.canMatch && tagNPlayers.match(str)) {
				} else if (tagName.canMatch && tagName.match(str)) {
					if (name.length > 0) {
						//games.add(
						new GameData(name, tagDescription.result, tagYear.result, tagManufacturer.result, tagCategory.result, Std.parseInt(tagNPlayers.result));
						//);
						
						tagDescription.clear();
						tagYear.clear();
						tagManufacturer.clear();
						tagCategory.clear();
						tagNPlayers.clear();
						
						if (charsRead > numBytes) break;
					}
				}
				
				charsRead += str.length;
				
				if (callbackCounter-- <= 0) {
					callbackCounter = 4000;
					onProgress(charsRead / numBytes, null);
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
	public var canMatch(get, never):Bool;
	
	public function new(start:String, end:String) {
		this.start = start;
		this.end = end;
	}
	
	public inline function clear() {
		result = '';
	}
	
	public function match(string:String) {
		// if this already is matched no need to look
		var startIndex = string.indexOf(start);
		if (startIndex == -1) return false;
		var endIndex = string.indexOf(end, startIndex + start.length);
		if (endIndex == -1) return false;
		result = string.substring(startIndex + start.length, endIndex);
		return true;
	}
	
	inline function get_canMatch() return result.length == 0;
}
