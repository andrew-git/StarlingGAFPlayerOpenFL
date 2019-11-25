package com.catalystapps.gaf.data;

import com.catalystapps.gaf.data.tagfx.ITAGFX;
import com.catalystapps.gaf.data.tagfx.TAGFXBase;
import com.catalystapps.gaf.utils.DebugUtility;
import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.errors.Error;
import starling.textures.Texture;

/**
 * Dispatched when he texture is decoded. It can only be used when the callback has been executed.
 */
@:meta(Event(name="texturesReady",type="flash.events.Event"))

/**
 * Graphical data storage that used by <code>GAFTimeline</code>. It contain all created textures and all
 * saved images as <code>BitmapData</code>.
 * Used as shared graphical data storage between several GAFTimelines if they are used the same texture atlas (bundle created using "Create bundle" option)
 */
class GAFGFXData extends EventDispatcher
{
    public var isTexturesReady(get, never) : Bool;

    public static inline var EVENT_TYPE_TEXTURES_READY : String = "texturesReady";
    
    @:meta(Deprecated(since="5.0"))
    public static inline var ATF : String = "ATF";
	
    @:meta(Deprecated(replacement="Context3DTextureFormat.BGRA",since="5.0"))
    public static var BGRA : String = Context3DTextureFormat.BGRA;
	
    @:meta(Deprecated(replacement="Context3DTextureFormat.BGR_PACKED",since="5.0"))
    public static var BGR_PACKED : String = Context3DTextureFormat.BGR_PACKED;
	
    @:meta(Deprecated(replacement="Context3DTextureFormat.BGRA_PACKED",since="5.0"))
    public static var BGRA_PACKED : String = Context3DTextureFormat.BGRA_PACKED;
    //--------------------------------------------------------------------------
    //
    //  PUBLIC VARIABLES
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE VARIABLES
    //
    //--------------------------------------------------------------------------
    
	//*
    private var _texturesDictionary : Map<Int, Map<Int, Map<String, Texture>>> = new Map();
    private var _taGFXDictionary 	: Map<Int, Map<Int, Map<String, ITAGFX>>> = new Map();	
	/*/
    private var _texturesDictionary : Map<String, Map<String, Map<String, Texture>>> = new Map();
    private var _taGFXDictionary 	: Map<String, Map<String, Map<String, ITAGFX>>> = new Map();
	//*/
    
    private var _textureLoadersSet : Map<ITAGFX, ITAGFX> = new Map();
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    public function new()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    public function addTAGFX(_scale : Float, _csf : Float, imageID : String, taGFX : ITAGFX) : Void
    {
		var scale = mapToConvert(_scale);
		var csf = mapToConvert(_csf);
		
		if (this._taGFXDictionary.get(scale) == null) this._taGFXDictionary.set(scale, new Map());
		if (this._taGFXDictionary.get(scale).get(csf) == null) this._taGFXDictionary.get(scale).set(csf, new Map());
		if (this._taGFXDictionary.get(scale).get(csf).get(imageID) == null) this._taGFXDictionary.get(scale).get(csf).set(imageID, taGFX);
    }
    
    /** @private */
    public function getTAGFXs(_scale : Float, _csf : Float) : Map<String, ITAGFX>
    {
		var scale = mapToConvert(_scale);
		var csf = mapToConvert(_csf);
		
        if (this._taGFXDictionary != null)
        {
            if (this._taGFXDictionary.get(scale) != null)
            {
                return this._taGFXDictionary.get(scale).get(csf);
            }
        }
        
        return null;
    }
    
    /** @private */
    public function getTAGFX(_scale : Float, _csf : Float, imageID : String) : ITAGFX
    {
		var scale = mapToConvert(_scale);
		var csf = mapToConvert(_csf);
		
        if (this._taGFXDictionary != null)
        {
            if (this._taGFXDictionary.get(scale) != null)
            {
                if (this._taGFXDictionary.get(scale).get(csf) != null)
                {
                    return this._taGFXDictionary.get(scale).get(csf).get(imageID);
                }
            }
        }
        
        return null;
    }
    
    /**
	 * Creates textures from all images for specified scale and csf.
	 * @param scale
	 * @param csf
	 * @return {Boolean}
	 * @see #createTexture()
	 */
    public function createTextures(_scale : Float, _csf : Float) : Bool
    {
        var taGFXs : Map<String, ITAGFX> = this.getTAGFXs(_scale, _csf);
        if (taGFXs != null)
        {
			var scale = mapToConvert(_scale);
			var csf = mapToConvert(_csf);
			
			if (this._texturesDictionary.get(scale) == null) this._texturesDictionary.set(scale, new Map());
			if (this._texturesDictionary.get(scale).get(csf) == null) this._texturesDictionary.get(scale).set(csf, new Map());
            
            for (imageAtlasID in taGFXs.keys())
            {
                if (taGFXs.get(imageAtlasID) != null)
                {
                    addTexture(this._texturesDictionary.get(scale).get(csf), taGFXs.get(imageAtlasID), imageAtlasID);
                }
            }
            return true;
        }
        
        return false;
    }
    
    /**
	 * Creates texture from specified image.
	 * @param scale
	 * @param csf
	 * @param imageID
	 * @return {Boolean}
	 * @see #createTextures()
	 */
    public function createTexture(_scale : Float, _csf : Float, imageID : String) : Bool
    {
        var taGFX : ITAGFX = this.getTAGFX(_scale, _csf, imageID);
        if (taGFX != null)
        {
			var scale = mapToConvert(_scale);
			var csf = mapToConvert(_csf);
			
			if (this._texturesDictionary.get(scale) == null) this._texturesDictionary.set(scale, new Map());
			if (this._texturesDictionary.get(scale).get(csf) == null) this._texturesDictionary.get(scale).set(csf, new Map());
            
            addTexture(this._texturesDictionary.get(scale).get(csf), taGFX, imageID);
			
            
            return true;
        }
        
        return false;
    }
    
    /**
	 * Returns texture by unique key consist of scale + csf + imageID
	 */
    public function getTexture(_scale : Float, _csf : Float, imageID : String) : Texture
    {
		var scale = mapToConvert(_scale);
		var csf = mapToConvert(_csf);
		
        if (this._texturesDictionary != null)
        {
            if (this._texturesDictionary.get(scale) != null)
            {
                if (this._texturesDictionary.get(scale).get(csf) != null)
                {
                    if (this._texturesDictionary.get(scale).get(csf).get(imageID) != null)
                    {
                        return this._texturesDictionary.get(scale).get(csf).get(imageID);
                    }
                }
            }
        }
        
        // in case when there is no texture created
        // create texture and check if it successfully created
        if (this.createTexture(_scale, _csf, imageID))
        {
            return this._texturesDictionary.get(scale).get(csf).get(imageID);
        }
        
        return null;
    }
    
    /**
	 * Returns textures for specified scale and csf in Object as combination key-value where key - is imageID and value - is Texture
	 */
    public function getTextures(_scale : Float, _csf : Float) : Map<String, Texture>
    {
        if (this._texturesDictionary != null)
        {
			var scale = mapToConvert(_scale);
			var csf = mapToConvert(_csf);
			
            if (this._texturesDictionary.get(scale) != null)
            {
                return this._texturesDictionary.get(scale).get(csf);
            }
        }
        
        return null;
    }
    
    /**
	 * Dispose specified texture or textures for specified combination scale and csf. If nothing was specified - dispose all texturea
	 */
    public function disposeTextures(_scale : Null<Float> = null, _csf : Null<Float> = null, imageID : String = null) : Void
    {
        if (_scale == null)
        {
			for (scaleToDispose in this._texturesDictionary.keys()) 
			{
				this.disposeTextures(mapFromConvert(scaleToDispose));
			}
            
            this._texturesDictionary = null;
        }
		else
		{
			var scale = mapToConvert(_scale);
			
			if (_csf == null)
			{
				for (csfToDispose in this._texturesDictionary.get(scale).keys())
				{
					this.disposeTextures(_scale, mapFromConvert(csfToDispose));
				}
				
				this._texturesDictionary.remove(scale);
			}
			else
			{
				var csf = mapToConvert(_csf);
				
				if (imageID != null)
				{
					this._texturesDictionary.get(scale).get(csf).get(imageID).dispose();
					
					this._texturesDictionary.get(scale).get(csf).remove(imageID);
				}
				else
				{
					if (this._texturesDictionary.get(scale) != null && this._texturesDictionary.get(scale).get(csf) != null)
					{
						for (atlasIDToDispose in this._texturesDictionary.get(scale).get(csf).keys())
						{
							this.disposeTextures(_scale, _csf, atlasIDToDispose);
						}
						this._texturesDictionary.get(scale).remove(csf);
					}
				}
			}
		}
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    private function addTexture(dictionary : Map<String, Texture>, tagfx : ITAGFX, imageID : String) : Void
    {
        if (DebugUtility.RENDERING_DEBUG)
        {
            var bitmapData : BitmapData = null;
            if (tagfx.sourceType == TAGFXBase.SOURCE_TYPE_BITMAP_DATA)
            {
                bitmapData = setGrayScale(tagfx.source.clone());
            }
            
            if (bitmapData != null)
            {
                dictionary[imageID] = Texture.fromBitmapData(bitmapData, GAF.useMipMaps, false, tagfx.textureScale, tagfx.textureFormat);
            }
            else
            {
                if (tagfx.texture != null)
                {
                    dictionary[imageID] = tagfx.texture;
                }
                else
                {
                    throw new Error("GAFGFXData texture for rendering not found!");
                }
            }
        }
        else if (dictionary.get(imageID) == null)
        {
            if (!tagfx.ready)
            {
                _textureLoadersSet.set(tagfx, tagfx);
                tagfx.addEventListener(TAGFXBase.EVENT_TYPE_TEXTURE_READY, this.onTextureReady);
            }
            
            dictionary.set(imageID, tagfx.texture);
        }
    }
    
    private function setGrayScale(image : BitmapData) : BitmapData
    {
        var matrix : Array<Float> = [
			0.26231, 0.51799, 0.0697, 0, 81.775, 
			0.26231, 0.51799, 0.0697, 0, 81.775, 
			0.26231, 0.51799, 0.0697, 0, 81.775, 
			0, 0, 0, 1, 0
		];
        
        var filter : ColorMatrixFilter = new ColorMatrixFilter(matrix);
        image.applyFilter(image, new Rectangle(0, 0, image.width, image.height), new Point(0, 0), filter);
        
        return image;
    }
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  EVENT HANDLERS
    //
    //--------------------------------------------------------------------------
    
    private function onTextureReady(event : Event) : Void
    {
        var tagfx : ITAGFX = try cast(event.currentTarget, ITAGFX) catch(e:Dynamic) null;
        tagfx.removeEventListener(TAGFXBase.EVENT_TYPE_TEXTURE_READY, this.onTextureReady);
        
        //This is an intentional compilation error. See the README for handling the delete keyword
        //delete _textureLoadersSet[tagfx];
        _textureLoadersSet.remove(tagfx);
        
        if (this.isTexturesReady)
        {
            this.dispatchEvent(new Event(EVENT_TYPE_TEXTURES_READY));
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    private function get_isTexturesReady() : Bool
    {
        var empty : Bool = true;
		for (tagfx in _textureLoadersSet) 
		{
            empty = false;
            break;
		}
		
        return empty;
    }
	
//*
	@:extern inline
	static function mapToConvert(value:Float):Int
	{
		return Math.round(value * 100);
	}
	
	@:extern inline
	static function mapFromConvert(value:Int):Float
	{
		return value / 100;
	}
/*/
	@:extern inline
	static function mapToConvert(value:Float):String
	{
		return Std.string(value);
	}
	
	@:extern inline
	static function mapFromConvert(value:String):Float
	{
		return Std.parseFloat(value);
	}
//*/
}
