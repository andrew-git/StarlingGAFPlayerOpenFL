package com.catalystapps.gaf.data.config;

import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * @private
 */
class CTextureAtlasElement
{
    public var id(get, never) : String;
    public var region(get, set) : Rectangle;
    public var pivotMatrix(get, set) : Matrix;
    public var atlasID(get, never) : String;
    public var scale9Grid(get, set) : Rectangle;
    public var linkage(get, set) : String;
    public var rotated(get, set) : Bool;

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
    
    private var _id : String = null;
    private var _linkage : String = null;
    private var _atlasID : String = null;
    private var _region : Rectangle = null;
    private var _pivotMatrix : Matrix = null;
    private var _scale9Grid : Rectangle = null;
    private var _rotated : Bool = false;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(id : String, atlasID : String)
    {
        this._id = id;
        this._atlasID = atlasID;
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
    
    private function get_id() : String
    {
        return this._id;
    }
    
    private function get_region() : Rectangle
    {
        return this._region;
    }
    
    private function set_region(region : Rectangle) : Rectangle
    {
        _region = region;
        return region;
    }
    
    private function get_pivotMatrix() : Matrix
    {
        return this._pivotMatrix;
    }
    
    private function set_pivotMatrix(pivotMatrix : Matrix) : Matrix
    {
        this._pivotMatrix = pivotMatrix;
        return pivotMatrix;
    }
    
    private function get_atlasID() : String
    {
        return this._atlasID;
    }
    
    private function get_scale9Grid() : Rectangle
    {
        return this._scale9Grid;
    }
    
    private function set_scale9Grid(value : Rectangle) : Rectangle
    {
        this._scale9Grid = value;
        return value;
    }
    
    private function get_linkage() : String
    {
        return this._linkage;
    }
    
    private function set_linkage(value : String) : String
    {
        this._linkage = value;
        return value;
    }
    
    private function get_rotated() : Bool
    {
        return this._rotated;
    }
    
    private function set_rotated(value : Bool) : Bool
    {
        this._rotated = value;
        return value;
    }
}
