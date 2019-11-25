package com.catalystapps.gaf.display.text;

import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.CTextFieldObject;
import com.catalystapps.gaf.filter.GAFFilterChain;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Align;

/**
 * ...
 * @author andrew
 */
class CustomTextFieldStarling extends CustomTextField 
{
	private var textField : TextField = null;
	private var textFormat : TextFormat = null;

	public function new(parent : Sprite, config : CTextFieldObject, scale : Float, csf : Float) 
	{
        super(parent, config, scale, csf);
	}
	
	override function init(config:CTextFieldObject):Void 
	{
		textFormat = new TextFormat(config.textFormat.font, 
									config.textFormat.size, 
									config.textFormat.color, 
									Align.isValidHorizontal(config.textFormat.align) ? config.textFormat.align : Align.CENTER,
									Align.TOP
									);
		textFormat.bold = config.textFormat.bold;
		textFormat.italic = config.textFormat.italic;
		textFormat.underline = config.textFormat.underline;
		textFormat.leading = config.textFormat.leading;
		
		textField = new TextField(Std.int(config.width), Std.int(config.height), config.text, textFormat);
		
		parent.addChild(textField);
	}
	
	override public function applyFilter(_filterConfig:CFilter, _filterScale:Float):Void 
	{
		if (_filterConfig != null && !Math.isNaN(_filterScale))
		{
			if (_filterChain != null)
			{
				_filterChain.dispose();
			}
			else
			{
				_filterChain = new GAFFilterChain();
			}
			
			//_filterChain.setFilterData(_filterConfig);
			_filterChain.setFilterDataSimulateNative(_filterConfig);
			
			textField.filter = _filterChain;
		}
		else if (textField.filter != null)
		{
			textField.filter.dispose();
			textField.filter = null;
			
			_filterChain = null;
		}
	}

	
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS EXTENDED
    //
    //--------------------------------------------------------------------------
	
	override function get_hAlign():String 
	{
		return textFormat.horizontalAlign;
	}
	
	
	override function set_text(value : String) : String
	{
		textField.text = value;
		
		return value;
	}
	
	override function set_color(value : Int) : Int
	{
		if (Std.int(textFormat.color) != value)
		{
			textFormat.color = value;
			textField.format = textFormat;
		}
		
		return value;
	}
	
    override function set_hAlign(value:String):String
    {
		if (textFormat.horizontalAlign != value
		&& Align.isValidHorizontal(value)
		)
		{
			textFormat.horizontalAlign = value;
			textField.format = textFormat;
		}
		
		return value;
    }
}