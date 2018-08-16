package com.catalystapps.gaf.data.config;

import flash.geom.Matrix;

/**
 * @private
 */
class CAnimationFrameInstance
{
    public var id(get, never) : String;
    public var matrix(get, never) : Matrix;
    public var alpha(get, never) : Null<Float>;
    public var maskID(get, never) : String;
    public var filter(get, never) : CFilter;
    public var zIndex(get, never) : Int;

    // --------------------------------------------------------------------------
    //
    // PUBLIC VARIABLES
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // PRIVATE VARIABLES
    //
    // --------------------------------------------------------------------------
    private var _id : String = null;
    private var _zIndex : Int = 0;
    private var _matrix : Matrix = null;
    private var _alpha : Null<Float> = null;
    private var _maskID : String = null;
    private var _filter : CFilter = null;
    
    private static var tx : Float;
	private static var ty : Float;
    
    // --------------------------------------------------------------------------
    //
    // CONSTRUCTOR
    //
    // --------------------------------------------------------------------------
    public function new(id : String)
    {
        this._id = id;
    }
    
    // --------------------------------------------------------------------------
    //
    // PUBLIC METHODS
    //
    // --------------------------------------------------------------------------
    public function clone() : CAnimationFrameInstance
    {
        var result : CAnimationFrameInstance = new CAnimationFrameInstance(this._id);
        
        var filterCopy : CFilter = null;
        
        if (this._filter != null)
        {
            filterCopy = this._filter.clone();
        }
        
        result.update(this._zIndex, this._matrix.clone(), this._alpha, this._maskID, filterCopy);
        
        return result;
    }
    
    public function update(zIndex : Int, matrix : Matrix, alpha : Float, maskID : String, filter : CFilter) : Void
    {
        this._zIndex = zIndex;
        this._matrix = matrix;
        this._alpha = alpha;
        this._maskID = maskID;
        this._filter = filter;
    }
    
    public function getTransformMatrix(pivotMatrix : Matrix, scale : Float) : Matrix
    {
        var result : Matrix = pivotMatrix.clone();
        tx = this._matrix.tx;
        ty = this._matrix.ty;
        this._matrix.tx *= scale;
        this._matrix.ty *= scale;
        result.concat(this._matrix);
        this._matrix.tx = tx;
        this._matrix.ty = ty;
        
        return result;
    }
    
    public function applyTransformMatrix(transformationMatrix : Matrix, pivotMatrix : Matrix, scale : Float) : Void
    {
        transformationMatrix.copyFrom(pivotMatrix);
        tx = this._matrix.tx;
        ty = this._matrix.ty;
        this._matrix.tx *= scale;
        this._matrix.ty *= scale;
        transformationMatrix.concat(this._matrix);
        this._matrix.tx = tx;
        this._matrix.ty = ty;
    }
    
    public function calculateTransformMatrix(transformationMatrix : Matrix, pivotMatrix : Matrix, scale : Float) : Matrix
    {
        applyTransformMatrix(transformationMatrix, pivotMatrix, scale);
        return transformationMatrix;
    }
    
    // --------------------------------------------------------------------------
    //
    // PRIVATE METHODS
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // EVENT HANDLERS
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // GETTERS AND SETTERS
    //
    // --------------------------------------------------------------------------
    private function get_id() : String
    {
        return this._id;
    }
    
    private function get_matrix() : Matrix
    {
        return this._matrix;
    }
    
    private function get_alpha() : Null<Float>
    {
        return this._alpha;
    }
    
    private function get_maskID() : String
    {
        return this._maskID;
    }
    
    private function get_filter() : CFilter
    {
        return this._filter;
    }
    
    private function get_zIndex() : Int
    {
        return this._zIndex;
    }
}
