package com.catalystapps.gaf.display;

import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.filter.GAFFilter;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;

/**
 * GAFImage represents static GAF display object that is part of the <code>GAFMovieClip</code>.
 */
class GAFImage extends Image implements IGAFImage implements IMaxSize implements IGAFDebug
{
    public var debugColors(never, set) : Array<Int>;
    public var maxSize(get, set) : Point;
    public var assetTexture(get, never) : IGAFTexture;
    public var pivotMatrix(get, never) : Matrix;

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
    
    private static var HELPER_POINT : Point = new Point();
    private static var HELPER_POINT_3D : Vector3D = new Vector3D();
    private static var HELPER_MATRIX : Matrix = new Matrix();
    private static var HELPER_MATRIX_3D : Matrix3D = new Matrix3D();
    
    private var _assetTexture : IGAFTexture;
    
    private var _filterConfig : CFilter;
    private var _filterScale : Float = Math.NaN;
    
    private var _maxSize : Point;
    
    private var _pivotChanged : Bool;
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private var __debugOriginalAlpha : Float = Math.NaN;
    
    private var _orientationChanged : Bool;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /**
	 * Creates a new <code>GAFImage</code> instance.
	 * @param assetTexture <code>IGAFTexture</code> from which it will be created.
	 */
    public function new(assetTexture : IGAFTexture)
    {
        this._assetTexture = assetTexture.clone();
        
        super(this._assetTexture.texture);
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * Creates a new instance of GAFImage.
	 */
    public function copy() : GAFImage
    {
        return new GAFImage(this._assetTexture);
    }
    
    /** @private */
    public function invalidateOrientation() : Void
    {
        this._orientationChanged = true;
    }
    
    /** @private */
    private function set_debugColors(value : Array<Int>) : Array<Int>
    {
        var alpha0 : Float;
        var alpha1 : Float;
        
        var _sw0_ = (value.length);        

        switch (_sw0_)
        {
            case 1:
                this.color = value[0];
                this.alpha = (value[0] >>> 24) / 255;
            case 2:
                this.setVertexColor(0, value[0]);
                this.setVertexColor(1, value[0]);
                this.setVertexColor(2, value[1]);
                this.setVertexColor(3, value[1]);
                
                alpha0 = (value[0] >>> 24) / 255;
                alpha1 = (value[1] >>> 24) / 255;
                this.setVertexAlpha(0, alpha0);
                this.setVertexAlpha(1, alpha0);
                this.setVertexAlpha(2, alpha1);
                this.setVertexAlpha(3, alpha1);
            case 3:
                this.setVertexColor(0, value[0]);
                this.setVertexColor(1, value[0]);
                this.setVertexColor(2, value[1]);
                this.setVertexColor(3, value[2]);
                
                alpha0 = (value[0] >>> 24) / 255;
                this.setVertexAlpha(0, alpha0);
                this.setVertexAlpha(1, alpha0);
                this.setVertexAlpha(2, (value[1] >>> 24) / 255);
                this.setVertexAlpha(3, (value[2] >>> 24) / 255);
            case 4:
                this.setVertexColor(0, value[0]);
                this.setVertexColor(1, value[1]);
                this.setVertexColor(2, value[2]);
                this.setVertexColor(3, value[3]);
                
                this.setVertexAlpha(0, (value[0] >>> 24) / 255);
                this.setVertexAlpha(1, (value[1] >>> 24) / 255);
                this.setVertexAlpha(2, (value[2] >>> 24) / 255);
                this.setVertexAlpha(3, (value[3] >>> 24) / 255);
        }
        return value;
    }
    
    /**
	 * Change the texture of the <code>GAFImage</code> to a new one.
	 * @param newTexture the new <code>IGAFTexture</code> which will be used to replace existing one.
	 */
    public function changeTexture(newTexture : IGAFTexture) : Void
    {
        this.texture = newTexture.texture;
        this.readjustSize();
        this._assetTexture.copyFrom(newTexture);
    }
    
    /** @private */
    public function setFilterConfig(value : CFilter, scale : Float = 1) : Void
    {
        if (!Starling.current.contextValid)
        {
            return;
        }
        
        if (this._filterConfig != value || this._filterScale != scale)
        {
            if (value != null)
            {
                this._filterConfig = value;
                this._filterScale = scale;
                var gafFilter : GAFFilter;
                if (this.filter != null)
                {
                    if (Std.is(this.filter, GAFFilter))
                    {
                        gafFilter = try cast(this.filter, GAFFilter) catch(e:Dynamic) null;
                    }
                    else
                    {
                        this.filter.dispose();
                        gafFilter = new GAFFilter();
                    }
                }
                else
                {
                    gafFilter = new GAFFilter();
                }
                
                gafFilter.setConfig(this._filterConfig, this._filterScale);
                this.filter = gafFilter;
            }
            else
            {
                if (this.filter != null)
                {
                    this.filter.dispose();
                    this.filter = null;
                }
                this._filterConfig = null;
                this._filterScale = Math.NaN;
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private function __debugHighlight() : Void
    {
        if (Math.isNaN(this.__debugOriginalAlpha))
        {
            this.__debugOriginalAlpha = this.alpha;
        }
        this.alpha = 1;
    }
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private function __debugLowlight() : Void
    {
        if (Math.isNaN(this.__debugOriginalAlpha))
        {
            this.__debugOriginalAlpha = this.alpha;
        }
        this.alpha = .05;
    }
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private function __debugResetLight() : Void
    {
        if (!Math.isNaN(this.__debugOriginalAlpha))
        {
            this.alpha = this.__debugOriginalAlpha;
            this.__debugOriginalAlpha = Math.NaN;
        }
    }
    
    @:final inline private function updateTransformMatrix() : Void
    {
        if (this._orientationChanged)
        {
            this.transformationMatrix = this.transformationMatrix;
            this._orientationChanged = false;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * Disposes all resources of the display object.
	 */
    override public function dispose() : Void
    {
        if (this.filter != null)
        {
            this.filter.dispose();
            this.filter = null;
        }
        this._assetTexture = null;
        this._filterConfig = null;
        
        super.dispose();
    }
    
    override public function getBounds(targetSpace : DisplayObject, resultRect : Rectangle = null) : Rectangle
    {
        if (resultRect == null)
        {
            resultRect = new Rectangle();
        }
        
        if (targetSpace == this) // optimization
		{
            mVertexData.getPosition(3, HELPER_POINT);
            resultRect.setTo(0.0, 0.0, HELPER_POINT.x, HELPER_POINT.y);
        }
        else if (targetSpace == parent && rotation == 0.0 && isEquivalent(skewX, skewY))// optimization
		{
			var scaleX : Float = this.scaleX;
			var scaleY : Float = this.scaleY;
			mVertexData.getPosition(3, HELPER_POINT);
			resultRect.setTo(x - pivotX * scaleX, y - pivotY * scaleY, 
					HELPER_POINT.x * scaleX, HELPER_POINT.y * scaleY
            );
			
			if (scaleX < 0)
			{
				resultRect.width *= -1;resultRect.x -= resultRect.width;
			}
			if (scaleY < 0)
			{
				resultRect.height *= -1;resultRect.y -= resultRect.height;
			}
        }
        else if (is3D && stage != null)
        {
            stage.getCameraPosition(targetSpace, HELPER_POINT_3D);
            getTransformationMatrix3D(targetSpace, HELPER_MATRIX_3D);
            mVertexData.getBoundsProjected(HELPER_MATRIX_3D, HELPER_POINT_3D, 0, 4, resultRect);
        }
        else
        {
            getTransformationMatrix(targetSpace, HELPER_MATRIX);
            mVertexData.getBounds(HELPER_MATRIX, 0, 4, resultRect);
        }
        
        return resultRect;
    }
    
    @:final private function isEquivalent(a : Float, b : Float, epsilon : Float = 0.0001) : Bool
    {
        return (a - epsilon < b) && (a + epsilon > b);
    }
    
    /** @private */
    override private function set_pivotX(value : Float) : Float
    {
        this._pivotChanged = true;
        super.pivotX = value;
        return value;
    }
    
    /** @private */
    override private function set_pivotY(value : Float) : Float
    {
        this._pivotChanged = true;
        super.pivotY = value;
        return value;
    }
    
    /** @private */
    override private function get_x() : Float
    {
        updateTransformMatrix();
        return super.x;
    }
    
    /** @private */
    override private function get_y() : Float
    {
        updateTransformMatrix();
        return super.y;
    }
    
    /** @private */
    override private function get_rotation() : Float
    {
        updateTransformMatrix();
        return super.rotation;
    }
    
    /** @private */
    override private function get_scaleX() : Float
    {
        updateTransformMatrix();
        return super.scaleX;
    }
    
    /** @private */
    override private function get_scaleY() : Float
    {
        updateTransformMatrix();
        return super.scaleY;
    }
    
    /** @private */
    override private function get_skewX() : Float
    {
        updateTransformMatrix();
        return super.skewX;
    }
    
    /** @private */
    override private function get_skewY() : Float
    {
        updateTransformMatrix();
        return super.skewY;
    }
    
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
    
    /** @private */
    private function get_maxSize() : Point
    {
        return this._maxSize;
    }
    
    /** @private */
    private function set_maxSize(value : Point) : Point
    {
        this._maxSize = value;
        return value;
    }
    
    
    /**
	 * Returns current <code>IGAFTexture</code>.
	 * @return current <code>IGAFTexture</code>
	 */
    private function get_assetTexture() : IGAFTexture
    {
        return this._assetTexture;
    }
    
    /** @private */
    private function get_pivotMatrix() : Matrix
    {
        HELPER_MATRIX.copyFrom(this._assetTexture.pivotMatrix);
        
        if (this._pivotChanged)
        {
            HELPER_MATRIX.tx = this.pivotX;
            HELPER_MATRIX.ty = this.pivotY;
        }
        
        return HELPER_MATRIX;
    }
}
