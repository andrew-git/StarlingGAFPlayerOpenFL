package com.catalystapps.gaf.data.config;

import flash.geom.Point;

/**
	 * @private
	 */
class CAnimationObject
{
    public var instanceID(get, never) : String;
    public var regionID(get, never) : String;
    public var mask(get, never) : Bool;
    public var type(get, never) : String;
    public var maxSize(get, set) : Point;

    //--------------------------------------------------------------------------
    //
    //  PUBLIC VARIABLES
    //
    //--------------------------------------------------------------------------
    
    public static inline var TYPE_TEXTURE : String = "texture";
    public static inline var TYPE_TEXTFIELD : String = "textField";
    public static inline var TYPE_TIMELINE : String = "timeline";
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE VARIABLES
    //
    //--------------------------------------------------------------------------
    
    private var _instanceID : String;
    private var _regionID : String;
    private var _type : String;
    private var _mask : Bool;
    private var _maxSize : Point;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(instanceID : String, regionID : String, type : String, mask : Bool)
    {
        this._instanceID = instanceID;
        this._regionID = regionID;
        this._type = type;
        this._mask = mask;
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
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    private function get_instanceID() : String
    {
        return this._instanceID;
    }
    
    private function get_regionID() : String
    {
        return this._regionID;
    }
    
    private function get_mask() : Bool
    {
        return this._mask;
    }
    
    private function get_type() : String
    {
        return this._type;
    }
    
    private function get_maxSize() : Point
    {
        return this._maxSize;
    }
    
    private function set_maxSize(value : Point) : Point
    {
        this._maxSize = value;
        return value;
    }
}

