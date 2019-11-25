package com.catalystapps.gaf.display.text;

import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.CTextFieldObject;
import com.catalystapps.gaf.filter.GAFFilterChain;
import starling.display.Sprite;

/**
 * @author andrew
 */
class CustomTextField
{
	private var _filterChain : GAFFilterChain = null;
	
	private var parent : Sprite = null;
	private var _scale : Float = Math.NaN;
	private var _csf : Float = Math.NaN;
	
	public var text(never, set) : String;
	public var color(never, set) : Int;
	public var hAlign(get, set):String;
	
	public function new(parent : Sprite, config : CTextFieldObject, scale : Float, csf : Float) 
	{
        this.parent = parent;
		this._scale = scale;
        this._csf = csf;
		
		init(config);
	}
	
	public function applyFilter(_filterConfig : CFilter, _filterScale : Float):Void
	{
		
	}
	
	function init(config : CTextFieldObject):Void 
	{
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS EXTENDED
	//
	//--------------------------------------------------------------------------
	
	function get_hAlign():String 
	{
		return null;
	}
	
	function set_text(value : String) : String
	{
		return value;
	}
	
	function set_color(value : Int) : Int
	{
		return value;
	}
	
	function set_hAlign(value:String):String
	{
		return value;
	}
}