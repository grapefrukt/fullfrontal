package com.grapefrukt.apps.fullfrontal;
import cpp.vm.Thread;
import haxe.io.Eof;
import openfl.Lib;
import sys.io.File;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Parser {

	var t:Int = 0;
	
	public function new() {
		t = Lib.getTimer();
		var t = Thread.create(parse);
		t.sendMessage(onParseProgress);
	}
	
	function onParseProgress(numLines:Int, isComplete:Bool) {
		trace('parsed $numLines');
		if (isComplete) trace('parsing completed in ' + (Lib.getTimer() - t) + 'ms');
	}
	
	private static function parse() {
		var onProgress:Int->Bool->Void = Thread.readMessage(true);
		
		var f = File.read(Main.home + '\\mame_filtered.xml');
		
		var numLines = 0;
		var lastReported = 0;
		try {
			while (true) {
				var str = f.readLine();
				numLines++;
				
				if (numLines - lastReported > 1000) {
					onProgress(numLines, false);
					lastReported = numLines;
				}
			}
		} catch (ex:Eof) {
			f.close();
		}
		
		onProgress(numLines, true);
	}
}