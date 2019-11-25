package com.catalystapps.gaf.display.text;

import com.catalystapps.gaf.data.GAF;
import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.CTextFieldObject;
import com.catalystapps.gaf.utils.FiltersUtility;
import openfl.display.BitmapData;
import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * ...
 * @author andrew
 */
class CustomTextFieldOpenFL extends CustomTextField 
{
	private var textField : TextField = null;
	private var textFormat : TextFormat = null;
	
	private var tfDX : Int = 0;
	private var tfDY : Int = 0;
	private var tfMatrix : Matrix = null;
	private var tfTexture : Texture;
	private var tfImg : Image;


	public function new(parent : Sprite, config : CTextFieldObject, scale : Float, csf : Float) 
	{
		super(parent, config, scale, csf);
	}
	
	override function init(config:CTextFieldObject):Void 
	{
		textFormat = cloneTextFormat(config.textFormat);
		
		textField = new TextField();
		tfDX = Math.floor(config.width / 10);
		tfDY = Math.floor(config.height / 10);
		tfMatrix = new Matrix();
		tfMatrix.tx = tfDX;
		tfMatrix.ty = tfDY;
		
		
		textField.text = config.text;
		textField.selectable = false;
		textField.mouseEnabled = false;
		textField.displayAsPassword = config.displayAsPassword;
		
		textField.defaultTextFormat = textFormat;
		textField.embedFonts = (GAF.useDeviceFonts) ? false : config.embedFonts; //true;
		textField.multiline = config.multiline;
		textField.wordWrap = config.wordWrap;
		
		
		textField.width = Math.floor(config.width);
		textField.height = Math.floor(config.height);
		
		drawTextField();
	}
	
	override public function applyFilter(_filterConfig:CFilter, _filterScale:Float):Void 
	{
		var filters : Array<openfl.filters.BitmapFilter> = [];
		if (_filterConfig != null && !Math.isNaN(_filterScale))
		{
			for (filter in _filterConfig.filterConfigs)
			{
				filters.push(FiltersUtility.getNativeFilter(filter, _filterScale * _csf));
			}
			
			textField.filters = filters;
			drawTextField();
		}
		else if (textField.filters != null)
		{
			for (i in 0 ... textField.filters.length)
			{
				textField.filters[i] = null;
			}
			
			textField.filters = null;
		}
	}
	
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS EXTENDED
    //
    //--------------------------------------------------------------------------
	
	override function get_hAlign():String 
	{
		return textFormat.align;
	}
	
	
	override function set_text(value : String) : String
	{
		if (textField.text != value)
		{
			textField.text = value;
			drawTextField();
		}
		
		return value;
	}
	
	override function set_color(value : Int) : Int
	{
		if (textField.textColor != value)
		{
			textFormat.color = value;
			textField.textColor = value;
			drawTextField();
		}
		
		return value;
	}
	
    override function set_hAlign(value:String):String
    {
		if (textFormat.align != value
		&& (value == TextFormatAlign.CENTER || value == TextFormatAlign.LEFT || value == TextFormatAlign.RIGHT)
		)
		{
			textFormat.align = value;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			drawTextField();
		}
		
		return value;
    }
	
	//--------------------------------------------------------------------------
	
	
	function drawTextField()
	{
		var bmd = new BitmapData(Math.floor(textField.width) + 2 * tfDX, Math.floor(textField.height) + 2 * tfDY, true, 0x00000000);
		bmd.draw(textField,tfMatrix);
		tfTexture = Texture.fromBitmapData(bmd, false);
		
		if (tfImg != null)
		{
			tfImg.texture = tfTexture;
		}
		else
		{
			tfImg = new Image(tfTexture);
			tfImg.x = -tfDX;
			tfImg.y = -tfDY;
			parent.addChild(tfImg);
		}
	}

    private function cloneTextFormat(textFormat : TextFormat) : TextFormat
    {
        if (textFormat == null)
        {
            throw new ArgumentError("Argument \"textFormat\" must be not null.");
        }
        
        var result = new TextFormat(
        textFormat.font, 
        textFormat.size, 
        textFormat.color, 
        textFormat.bold, 
        textFormat.italic, 
        textFormat.underline, 
        textFormat.url, 
        textFormat.target, 
        textFormat.align, 
        textFormat.leftMargin, 
        textFormat.rightMargin, 
        textFormat.indent, 
        textFormat.leading);
        
        return result;
    }
}