package com.grapefrukt.apps.fullfrontal.sound;

import com.grapefrukt.apps.fullfrontal.Settings;
import com.grapefrukt.utils.SettingsLoader;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;
import openfl.events.IOErrorEvent;
import openfl.Lib;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;
/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

enum Sfx {
	error;
	move;
	start;
	complete;
	list;
}

enum Music {
	
}

typedef Effect = {
	sfx:Sfx,
	sounds:Array<Sound>,
	shuffled:Array<Int>,
	loaded:Bool,
	channel:SoundChannel,
	lastPlayed:Float,
}

typedef Track = {
	music:Music,
	sound:Sound,
	channel:SoundChannel,
}

#if haxe3
	typedef Hash<T> = Map <String, T>;
#end

class SoundManager {
	
	private static var effects:Hash<Effect>;
	private static var tracks:Hash<Track>;
	public static var volumes:SoundSettingsLoader;
	
	private static var currentTrack:Track;

	public static function init() {
		#if bakeassets
			trace("SoundManager init, using baked assets");
		#else
			trace("SoundManager init, loading assets at runtime");
		#end
		
		SoundLogger.init();
		
		effects = new Hash<Effect>();
		tracks = new Hash<Track>();
		volumes = new SoundSettingsLoader();
		reload();
	}
	
	public static function playMusic(music:Music, useFade:Bool = true) {
		if (!Settings.SOUND_PLAY_MUSIC) return;
		
		var track = tracks.get(Std.string(music));
		
		if (track == null) {
			track = { music : music, sound : getSound(Std.string(music), true), channel : null };
			tracks.set(Std.string(music), track);
		}
		
		// if this track is already playing, do nothing
		if (currentTrack == track) return;
				
		// if no track was found, don't try to play it
		if (track.sound != null && track.sound.bytesLoaded > 0) {
			if (track.channel != null) {
				// if sound isn't stopped yet, remove tween and forcefully stop it
				Actuate.stop(track.channel);
				if (track.channel != null) track.channel.stop();
			}
			
			var volume = volumes.getVolume(Std.string(music));
			// start playing track as silent if we're fading
			track.channel = track.sound.play(0, 999999, new SoundTransform(useFade ? 0 : volume, 0));
			// fade in track, again, if we're fading
			if (useFade) Actuate.transform(track.channel, Settings.SOUND_MUSIC_FADEIN_DURATION, true).sound(volume, 0).ease(Quad.easeOut);
		}
		
		// fade out the old track and stop it
		if (currentTrack != null && currentTrack.channel != null) {
			if (!useFade) {
				Actuate.stop(currentTrack.channel);
				currentTrack.channel.stop();
				currentTrack.channel = null;
			} else {
				var currentMusicForClosure = currentTrack;
				Actuate.transform(currentTrack.channel, Settings.SOUND_MUSIC_FADEOUT_DURATION, true).sound(0, 0).ease(Quad.easeOut).onComplete(function() {
					currentMusicForClosure.channel.stop();
					currentMusicForClosure.channel = null;
				});
			}
		}
		
		currentTrack = track;
		
	}
	
	public static function reload() {
		trace("Reloading sounds");
		volumes.reload();
		for (sfx in Type.getEnumConstructs(Sfx)) {
			var sounds:Array<Sound> = [];
			
			// checks for multisound
			var multiIndex = 1;
			while (soundExists(sfx + multiIndex)) {
				sounds.push(getSound(sfx + multiIndex));
				multiIndex++;
			}
			
			// no multisound found
			if (multiIndex == 1) {
				sounds.push(getSound(sfx));
			}
			
			var shuffled = [ for (i in 0 ... sounds.length) i ];
			shuffle(shuffled);
			
			effects.set(sfx, { sounds: sounds, shuffled: shuffled, sfx : Type.createEnum(Sfx, sfx), loaded : sounds != null, channel : null, lastPlayed : 0 } );
		}
	}
	
	private static function shuffle<T>(arr:Array<T>){
		var n = arr.length;
		while (n > 1){
			var k = Std.random(n);
			n--;
			var temp = arr[n];
			arr[n] = arr[k];
			arr[k]= temp;
		}
	}
	
	private static function getSound(name:String, isMusic:Bool = false):Sound {
		var sound:Sound = null;
		
		#if bakeassets
			sound = Assets.getSound(getSfxURL(name, isMusic));
		#else
			sound = new Sound(new URLRequest(getSfxURL(name, isMusic)));
			sound.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		#end
		
		return sound;
	}
	
	private static function soundExists(name:String) {
		#if (bakeassets || flash)
			return Assets.exists(getSfxURL(name, false), AssetType.SOUND);
		#else
			return sys.FileSystem.exists(getSfxURL(name, false));
		#end
	}
	
	private static function getSfxURL(sfx:String, isMusic:Bool):String {
		if (isMusic) return "music/" + sfx + #if flash ".mp3" #else ".ogg" #end;
		return "sounds/" + sfx + ".wav";
	}
	
	static private function handleIOError(e:IOErrorEvent):Void {
		trace("error loading: " + e);
		/*for (effect in effects) {
			if (effect.sound == e.target) {
				effect.loaded = false;
			}
		}*/
	}
	
	public static function play(sfx:Sfx, stageX:Float = -9999, duration:Float = -1) {
		var effect = effects.get(Std.string(sfx));
		if (effect == null) return null;
		if (!effect.loaded) return null;
		
		var index = effect.shuffled[0];
		effect.shuffled.insert(1 + Math.floor((Math.random() * (effect.shuffled.length - 1))), effect.shuffled.shift());
		
		return playMulti(sfx, index, stageX, duration);
	}
	
	public static function playMulti(sfx:Sfx, index:Int, stageX:Float = -9999, duration:Float = -1) {
		SoundLogger.log(sfx, index, stageX, duration);
		
		var effect = effects.get(Std.string(sfx));
		if (effect == null) return null;
		if (!effect.loaded) return null;
		
		var loops = getLoops(Std.string(sfx));
		
		if (effect.sounds[0] == null || (effect.sounds[0].isBuffering)) {
			trace("sound not available: " + sfx);
			return null;
		}
		
		if (loops == 0 && Lib.getTimer() - effect.lastPlayed < Settings.SOUND_MIN_REPEAT_DELAY) {
			//trace("skipping playback of: " + sfx + " was played only " + Math.round(Lib.getTimer() - effect.lastPlayed) + "ms ago");
			return null;
		}
		
		if (index >= effect.sounds.length) {
			trace('can\'t play $index for sound $sfx, out of range, playing last available sound instead');
			index = effect.sounds.length - 1;
		}
		
		var volume = volumes.getVolume(Std.string(sfx));
		volume *= volumes.getVolume('global');
		
		var pan = getPan(stageX);
		
		var tf:SoundTransform = new SoundTransform(volume, pan);
		effect.channel = effect.sounds[index].play(0, loops, tf);
		effect.lastPlayed = Lib.getTimer();
		
		if (duration > 0) Actuate.transform(effect.channel, .1).sound(0).delay(duration);
		
		return effect.channel;
	}
	
	static function getLoops(sfx:String) {
		return volumes.getValue('${sfx}_loopforever') > 0 ? 99999999 : 0;
	}
	
	public static function getPan(stageX:Float) {
		var stageW = Settings.STAGE_W;
		return stageX == -9999 ? .5 : ((stageX / stageW) * 2 - 1) * volumes.getVolume('pan_scale');
	}
	
	static public function setPanVolume(channel:SoundChannel, volume:Float, stageX:Float) {
		if (channel == null) return;
		var stf = channel.soundTransform;
		stf.volume = volume;
		stf.pan = SoundManager.getPan(stageX);
		channel.soundTransform = stf;
	}
}

private class SoundSettingsLoader extends SettingsLoader {
	
	private var volumes:Hash<Float>;
	
	public function new() {
		super("config/sounds.cfg");
	}
	
	override public function reload(url:String = "", target:Dynamic = null):Void {
		volumes = new Hash<Float>();
		super.reload(url);
	}
	
	override public function setValue(name:String, value:Dynamic):Void {
		volumes.set(name, Std.parseFloat(value));
	}
	
	override public function getValue(key:String):Dynamic {
		return volumes.get(key);
	}
	
	public function getVolume(key:String):Float {
		if (volumes.exists(key)) {
			return volumes.get(key);
		}
		return 1;
	}
	
	override public function listKeys():Array<String> {
		var keys = [];
		for (key in volumes.keys()) keys.push(key);
		return keys;
	}
}