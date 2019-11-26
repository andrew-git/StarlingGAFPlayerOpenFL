/**
 * Created by Nazar on 12.01.2016.
 */
package com.catalystapps.gaf.data.tagfx;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.system.Capabilities;
import starling.errors.AbstractClassError;
import starling.errors.AbstractMethodError;
import starling.textures.Texture;

/**
 * Dispatched when he texture is decoded. It can only be used when the callback has been executed.
 */
@:meta(Event(name="textureReady",type="flash.events.Event"))

/**
 * @private
 */
class TAGFXBase extends EventDispatcher implements ITAGFX
{
    public var texture(get, never) : Texture;
    public var textureSize(get, set) : Point;
    public var textureScale(get, set) : Float;
    public var textureFormat(get, set) : String;
    public var sourceType(get, never) : String;
    public var source(get, never) : Dynamic;
    public var clearSourceAfterTextureCreated(get, set) : Dynamic;
    public var ready(get, never) : Bool;

    //--------------------------------------------------------------------------
    //
    //  PUBLIC VARIABLES
    //
    //--------------------------------------------------------------------------
    
    public static inline var EVENT_TYPE_TEXTURE_READY : String = "textureReady";
    
    public static inline var SOURCE_TYPE_BITMAP_DATA : String = "sourceTypeBitmapData";
    public static inline var SOURCE_TYPE_BITMAP : String = "sourceTypeBitmap";
    public static inline var SOURCE_TYPE_PNG_BA : String = "sourceTypePNGBA";
    public static inline var SOURCE_TYPE_ATF_BA : String = "sourceTypeATFBA";
    public static inline var SOURCE_TYPE_PNG_URL : String = "sourceTypePNGURL";
    public static inline var SOURCE_TYPE_ATF_URL : String = "sourceTypeATFURL";
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE VARIABLES
    //
    //--------------------------------------------------------------------------
    
    private var _texture : Texture = null;
    private var _textureSize : Point = null;
    private var _textureScale : Float = -1;
    private var _textureFormat : String = null;
    private var _source : Dynamic = null;
    private var _clearSourceAfterTextureCreated : Bool = false;
    private var _isReady : Bool = false;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new()
    {
        super();
        if (Capabilities.isDebugger &&
            Type.getClassName(Type.getClass(this)) == "com.catalystapps.gaf.data::TAGFXBase")
        {
            throw new AbstractClassError();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
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
    
    private function onTextureReady(texture : Texture) : Void
    {
        this._isReady = true;
        this.dispatchEvent(new Event(EVENT_TYPE_TEXTURE_READY));
    }
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    private function get_texture() : Texture
    {
        return this._texture;
    }
    
    private function get_textureSize() : Point
    {
        return this._textureSize;
    }
    
    private function set_textureSize(value : Point) : Point
    {
        this._textureSize = value;
        return value;
    }
    
    private function get_textureScale() : Float
    {
        return this._textureScale;
    }
    
    private function set_textureScale(value : Float) : Float
    {
        this._textureScale = value;
        return value;
    }
    
    private function get_textureFormat() : String
    {
        return this._textureFormat;
    }
    
    private function set_textureFormat(value : String) : String
    {
        this._textureFormat = value;
        return value;
    }
    
    private function get_sourceType() : String
    {
        throw new AbstractMethodError();
    }
    
    private function get_source() : Dynamic
    {
        return _source;
    }
    
    private function get_clearSourceAfterTextureCreated() : Bool
    {
        return this._clearSourceAfterTextureCreated;
    }
    
    private function set_clearSourceAfterTextureCreated(value : Bool) : Bool
    {
        this._clearSourceAfterTextureCreated = value;
        return value;
    }
    
    private function get_ready() : Bool
    {
        return this._isReady;
    }
}
