package com.grapefrukt.apps.fullfrontal.models;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Category {
	
	public var name(default, null):String;
	
	public function new(name:String) {
		this.name = name;
	}
	
}