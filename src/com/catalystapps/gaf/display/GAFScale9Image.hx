/*
 Feathers
 Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it in
 accordance with the terms of the accompanying license agreement.
 */
package com.catalystapps.gaf.display;

import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.filter.GAFFilter;
import com.catalystapps.gaf.utils.MathUtility;
import feathers.core.IValidating;
import feathers.core.ValidationQueue;
import flash.errors.IllegalOperationError;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.MatrixUtil;

@:meta(Exclude(name="numChildren",kind="property"))

@:meta(Exclude(name="isFlattened",kind="property"))

@:meta(Exclude(name="addChild",kind="method"))

@:meta(Exclude(name="addChildAt",kind="method"))

@:meta(Exclude(name="broadcastEvent",kind="method"))

@:meta(Exclude(name="broadcastEventWith",kind="method"))

@:meta(Exclude(name="contains",kind="method"))

@:meta(Exclude(name="getChildAt",kind="method"))

@:meta(Exclude(name="getChildByName",kind="method"))

@:meta(Exclude(name="getChildIndex",kind="method"))

@:meta(Exclude(name="removeChild",kind="method"))

@:meta(Exclude(name="removeChildAt",kind="method"))

@:meta(Exclude(name="removeChildren",kind="method"))

@:meta(Exclude(name="setChildIndex",kind="method"))

@:meta(Exclude(name="sortChildren",kind="method"))

@:meta(Exclude(name="swapChildren",kind="method"))

@:meta(Exclude(name="swapChildrenAt",kind="method"))

@:meta(Exclude(name="flatten",kind="method"))

@:meta(Exclude(name="unflatten",kind="method"))

/**
 * @private
 */
class GAFScale9Image extends Sprite implements IValidating implements IGAFImage implements IMaxSize implements IGAFDebug
{
    public var debugColors(never, set) : Array<Int>;
    public var assetTexture(get, never) : IGAFTexture;
    public var textures(get, set) : GAFScale9Texture;
    public var textureScale(get, set) : Float;
    public var smoothing(get, set) : String;
    public var color(get, set) : Int;
    public var useSeparateBatch(get, set) : Bool;
    public var depth(get, never) : Int;
    public var maxSize(get, set) : Point;
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
    
    private static var HELPER_MATRIX : Matrix = new Matrix();
    private static var HELPER_POINT : Point = new Point();
    private static var sHelperImage : Image = null;
    private var _propertiesChanged : Bool = true;
    private var _layoutChanged : Bool = true;
    private var _renderingChanged : Bool = true;
    private var _frame : Rectangle;
    private var _textures : GAFScale9Texture;
    private var _width : Float = Math.NaN;
    private var _height : Float = Math.NaN;
    private var _textureScale : Float = 1;
    private var _smoothing : String = TextureSmoothing.BILINEAR;
    private var _color : Int = 0xffffff;
    private var _useSeparateBatch : Bool = true;
    private var _hitArea : Rectangle;
    private var _batch : QuadBatch;
    private var _isValidating : Bool = false;
    private var _isInvalid : Bool = false;
    private var _validationQueue : ValidationQueue;
    private var _depth : Int = -1;
    
    private var _debugColors : Array<Int>;
    private var _debugAlphas : Array<Float>;
    
    private var _filterConfig : CFilter;
    private var _filterScale : Float = Math.NaN;
    
    private var _maxSize : Point;
    
    private var _pivotChanged : Bool;
    
    private var __debugOriginalAlpha : Float = Math.NaN;
    
    private var _orientationChanged : Bool;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /**
	 * GAFScale9Image represents display object that is part of the <code>GAFMovieClip</code>
	 * Scales an image with nine regions to maintain the aspect ratio of the
	 * corners regions. The top and bottom regions stretch horizontally, and the
	 * left and right regions scale vertically. The center region stretches in
	 * both directions to fill the remaining space.
	 * @param textures  The textures displayed by this image.
	 * @param textureScale The amount to scale the texture. Useful for DPI changes.
	 * @see com.catalystapps.gaf.display.GAFImage
	 */
    public function new(textures : GAFScale9Texture, textureScale : Float = 1)
    {
        super();
        
        this.textures = textures;
        this._textureScale = textureScale;
        this._hitArea = new Rectangle();
        this.invalidateSize();
        
        this._batch = new QuadBatch();
        this._batch.touchable = false;
        this.addChild(this._batch);
        
        this.addEventListener(Event.FLATTEN, this.flattenHandler);
        this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
		 * Creates a new instance of GAFScale9Image.
		 */
    public function copy() : GAFScale9Image
    {
        return new GAFScale9Image(this._textures, this._textureScale);
    }
    
    private function set_debugColors(value : Array<Int>) : Array<Int>
    {
        this._debugColors = [];
        this._debugAlphas = [];
        
        var alpha0 : Float;
        var alpha1 : Float;
        
        var _sw5_ = (value.length);        

        switch (_sw5_)
        {
            case 1:
                this._debugColors[0] = value[0];
                this._debugColors[1] = value[0];
                this._debugColors[2] = value[0];
                this._debugColors[3] = value[0];
                alpha0 = (value[0] >>> 24) / 255;
                this._debugAlphas[0] = alpha0;
                this._debugAlphas[1] = alpha0;
                this._debugAlphas[2] = alpha0;
                this._debugAlphas[3] = alpha0;
            case 2:
                this._debugColors[0] = value[0];
                this._debugColors[1] = value[0];
                this._debugColors[2] = value[1];
                this._debugColors[3] = value[1];
                alpha0 = (value[0] >>> 24) / 255;
                alpha1 = (value[1] >>> 24) / 255;
                this._debugAlphas[0] = alpha0;
                this._debugAlphas[1] = alpha0;
                this._debugAlphas[2] = alpha1;
                this._debugAlphas[3] = alpha1;
            case 3:
                this._debugColors[0] = value[0];
                this._debugColors[1] = value[0];
                this._debugColors[2] = value[1];
                this._debugColors[3] = value[2];
                alpha0 = (value[0] >>> 24) / 255;
                this._debugAlphas[0] = alpha0;
                this._debugAlphas[1] = alpha0;
                this._debugAlphas[2] = (value[1] >>> 24) / 255;
                this._debugAlphas[3] = (value[2] >>> 24) / 255;
            case 4:
                this._debugColors[0] = value[0];
                this._debugColors[1] = value[1];
                this._debugColors[2] = value[2];
                this._debugColors[3] = value[3];
                this._debugAlphas[0] = (value[0] >>> 24) / 255;
                this._debugAlphas[1] = (value[1] >>> 24) / 255;
                this._debugAlphas[2] = (value[2] >>> 24) / 255;
                this._debugAlphas[3] = (value[3] >>> 24) / 255;
        }
        return value;
    }
    
    /**
	 * @copy feathers.core.IValidating#validate()
	 */
    public function validate() : Void
    {
        if (!this._isInvalid)
        {
            return;
        }
        if (this._isValidating)
        {
            if (this._validationQueue != null)
			{
				//we were already validating, and something else told us to
                //validate. that's bad.
				
                this._validationQueue.addControl(this, true);
            }
            return;
        }
        this._isValidating = true;
        if (this._propertiesChanged || this._layoutChanged || this._renderingChanged)
        {
            this._batch.batchable = !this._useSeparateBatch;
            this._batch.reset();
            
            if (sHelperImage == null)
			{
				//because Scale9Textures enforces it, we know for sure that
                //this texture will have a size greater than zero, so there
                //won't be an error from Quad.
                sHelperImage = new Image(this._textures.middleCenter);
            }
            sHelperImage.smoothing = this._smoothing;
            
            if (!setDebugVertexColors([0, 1, 2, 3]))
            {
                sHelperImage.color = this._color;
            }
            
            var grid : Rectangle = this._textures.scale9Grid;
            var scaledLeftWidth : Float = grid.x * this._textureScale;
            var scaledRightWidth : Float = (this._frame.width - grid.x - grid.width) * this._textureScale;
            var sumLeftAndRight : Float = scaledLeftWidth + scaledRightWidth;
			var distortionScale : Float = 0;
            if (sumLeftAndRight > this._width)
            {
                distortionScale = (this._width / sumLeftAndRight);
                scaledLeftWidth *= distortionScale;
                scaledRightWidth *= distortionScale;
                sumLeftAndRight + scaledLeftWidth + scaledRightWidth;
            }
            var scaledCenterWidth : Float = this._width - sumLeftAndRight;
            var scaledTopHeight : Float = grid.y * this._textureScale;
            var scaledBottomHeight : Float = (this._frame.height - grid.y - grid.height) * this._textureScale;
            var sumTopAndBottom : Float = scaledTopHeight + scaledBottomHeight;
            if (sumTopAndBottom > this._height)
            {
                distortionScale = (this._height / sumTopAndBottom);
                scaledTopHeight *= distortionScale;
                scaledBottomHeight *= distortionScale;
                sumTopAndBottom = scaledTopHeight + scaledBottomHeight;
            }
            var scaledMiddleHeight : Float = this._height - sumTopAndBottom;
            
            if (scaledTopHeight > 0)
            {
                if (scaledLeftWidth > 0)
                {
                    this.setDebugColor(0);
                    sHelperImage.texture = this._textures.topLeft;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledLeftWidth;
                    sHelperImage.height = scaledTopHeight;
                    sHelperImage.x = scaledLeftWidth - sHelperImage.width;
                    sHelperImage.y = scaledTopHeight - sHelperImage.height;
                    this._batch.addImage(sHelperImage);
                }
                
                if (scaledCenterWidth > 0)
                {
                    this.setDebugVertexColors([0, 1, 0, 1]);
                    sHelperImage.texture = this._textures.topCenter;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledCenterWidth;
                    sHelperImage.height = scaledTopHeight;
                    sHelperImage.x = scaledLeftWidth;
                    sHelperImage.y = scaledTopHeight - sHelperImage.height;
                    this._batch.addImage(sHelperImage);
                }
                
                if (scaledRightWidth > 0)
                {
                    this.setDebugColor(1);
                    sHelperImage.texture = this._textures.topRight;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledRightWidth;
                    sHelperImage.height = scaledTopHeight;
                    sHelperImage.x = this._width - scaledRightWidth;
                    sHelperImage.y = scaledTopHeight - sHelperImage.height;
                    this._batch.addImage(sHelperImage);
                }
            }
            
            if (scaledMiddleHeight > 0)
            {
                if (scaledLeftWidth > 0)
                {
                    this.setDebugVertexColors([0, 0, 2, 2]);
                    sHelperImage.texture = this._textures.middleLeft;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledLeftWidth;
                    sHelperImage.height = scaledMiddleHeight;
                    sHelperImage.x = scaledLeftWidth - sHelperImage.width;
                    sHelperImage.y = scaledTopHeight;
                    this._batch.addImage(sHelperImage);
                }
                
                if (scaledCenterWidth > 0)
                {
                    this.setDebugVertexColors([0, 1, 2, 3]);
                    sHelperImage.texture = this._textures.middleCenter;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledCenterWidth;
                    sHelperImage.height = scaledMiddleHeight;
                    sHelperImage.x = scaledLeftWidth;
                    sHelperImage.y = scaledTopHeight;
                    this._batch.addImage(sHelperImage);
                }
                
                if (scaledRightWidth > 0)
                {
                    this.setDebugVertexColors([1, 1, 3, 3]);
                    sHelperImage.texture = this._textures.middleRight;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledRightWidth;
                    sHelperImage.height = scaledMiddleHeight;
                    sHelperImage.x = this._width - scaledRightWidth;
                    sHelperImage.y = scaledTopHeight;
                    this._batch.addImage(sHelperImage);
                }
            }
            
            if (scaledBottomHeight > 0)
            {
                if (scaledLeftWidth > 0)
                {
                    this.setDebugColor(2);
                    sHelperImage.texture = this._textures.bottomLeft;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledLeftWidth;
                    sHelperImage.height = scaledBottomHeight;
                    sHelperImage.x = scaledLeftWidth - sHelperImage.width;
                    sHelperImage.y = this._height - scaledBottomHeight;
                    this._batch.addImage(sHelperImage);
                }
                
                if (scaledCenterWidth > 0)
                {
                    this.setDebugVertexColors([2, 3, 2, 3]);
                    sHelperImage.texture = this._textures.bottomCenter;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledCenterWidth;
                    sHelperImage.height = scaledBottomHeight;
                    sHelperImage.x = scaledLeftWidth;
                    sHelperImage.y = this._height - scaledBottomHeight;
                    this._batch.addImage(sHelperImage);
                }
                
                if (scaledRightWidth > 0)
                {
                    this.setDebugColor(3);
                    sHelperImage.texture = this._textures.bottomRight;
                    sHelperImage.readjustSize();
                    sHelperImage.width = scaledRightWidth;
                    sHelperImage.height = scaledBottomHeight;
                    sHelperImage.x = this._width - scaledRightWidth;
                    sHelperImage.y = this._height - scaledBottomHeight;
                    this._batch.addImage(sHelperImage);
                }
            }
        }
        
        this._propertiesChanged = false;
        this._layoutChanged = false;
        this._renderingChanged = false;
        this._isInvalid = false;
        this._isValidating = false;
    }
    
    /**
	 * Readjusts the dimensions of the image according to its current
	 * textures. Call this method to synchronize image and texture size
	 * after assigning textures with a different size.
	 */
    public function readjustSize() : Void
    {
        this.invalidateSize();
    }
    
    public function invalidateSize() : Void
    {
        var mtx : Matrix = this.transformationMatrix;
        var scaleX : Float = Math.sqrt(mtx.a * mtx.a + mtx.b * mtx.b);
        var scaleY : Float = Math.sqrt(mtx.c * mtx.c + mtx.d * mtx.d);
        
        if (scaleX < 0.99 || scaleX > 1.01 || scaleY < 0.99 || scaleY > 1.01)
        {
            this._width = this._frame.width * scaleX;
            this._height = this._frame.height * scaleY;
            
            HELPER_POINT.x = mtx.a;
            HELPER_POINT.y = mtx.b;
            HELPER_POINT.normalize(1);
            mtx.a = HELPER_POINT.x;
            mtx.b = HELPER_POINT.y;
            
            HELPER_POINT.x = mtx.c;
            HELPER_POINT.y = mtx.d;
            HELPER_POINT.normalize(1);
            mtx.c = HELPER_POINT.x;
            mtx.d = HELPER_POINT.y;
        }
        else
        {
            this._width = this._frame.width;
            this._height = this._frame.height;
        }
        
        this._layoutChanged = true;
        this.invalidate();
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
                if (this._batch.filter != null)
                {
                    if (Std.is(this._batch.filter, GAFFilter))
                    {
                        gafFilter = cast(this._batch.filter, GAFFilter);
                    }
                    else
                    {
                        this._batch.filter.dispose();
                        gafFilter = new GAFFilter();
                    }
                }
                else
                {
                    gafFilter = new GAFFilter();
                }
                
                gafFilter.setConfig(this._filterConfig, this._filterScale);
                this._batch.filter = gafFilter;
            }
            else
            {
                if (this._batch.filter != null)
                {
                    this._batch.filter.dispose();
                    this._batch.filter = null;
                }
                this._filterConfig = null;
                this._filterScale = Math.NaN;
            }
        }
    }
    
    /** @private */
    public function invalidateOrientation() : Void
    {
        this._orientationChanged = true;
        invalidateSize();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * @private
	 */
    public function invalidate() : Void
    {
        if (this._isInvalid)
        {
            return;
        }
        this._isInvalid = true;
        if (this._validationQueue ==  null)
        {
            return;
        }
        this._validationQueue.addControl(this, false);
    }
    
    private function setDebugColor(idx : Int) : Void
    {
        if (this._debugColors != null)
        {
            sHelperImage.color = this._debugColors[idx];
            sHelperImage.alpha = this._debugAlphas[idx];
        }
    }
    
    private function setDebugVertexColors(indexes : Array<Int>) : Bool
    {
        if (this._debugColors != null)
        {
			for (i in 0...indexes.length) 
			{
                sHelperImage.setVertexColor(i, this._debugColors[indexes[i]]);
                sHelperImage.setVertexAlpha(i, this._debugAlphas[indexes[i]]);
            }
        }
        return this._debugColors != null;
    }
    
	@:allow(com.catalystapps.gaf)
    private function __debugHighlight() : Void
    {
        if (Math.isNaN(this.__debugOriginalAlpha))
        {
            this.__debugOriginalAlpha = this.alpha;
        }
        this.alpha = 1;
    }
    
	@:allow(com.catalystapps.gaf)
    private function __debugLowlight() : Void
    {
        if (Math.isNaN(this.__debugOriginalAlpha))
        {
            this.__debugOriginalAlpha = this.alpha;
        }
        this.alpha = .05;
    }
    
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
	 * @private
	 */
    override private function set_transformationMatrix(matrix : Matrix) : Matrix
    {
        super.transformationMatrix = matrix;
        this._layoutChanged = true;
        this.invalidate();
        return matrix;
    }
    
    /**
	 * @private
	 */
    override public function getBounds(targetSpace : DisplayObject, resultRect : Rectangle = null) : Rectangle
    {
        if (resultRect == null) resultRect = new Rectangle();
        
        if (targetSpace == this) // optimization
		{
            resultRect.copyFrom(this._hitArea);
        }
        else
        {
            var minX : Float = MathUtility.FLOAT_MAX;
            var maxX : Float = -MathUtility.FLOAT_MAX;
            var minY : Float = MathUtility.FLOAT_MAX;
            var maxY : Float = -MathUtility.FLOAT_MAX;
            
            this.getTransformationMatrix(targetSpace, HELPER_MATRIX);
            
            var coordsX : Float;
            var coordsY : Float;
            
            for (i in 0...4)
            {
                coordsX = (i < 2) ? this._hitArea.x : this._hitArea.right;
                coordsY = (i % 2 < 1) ? this._hitArea.y : this._hitArea.bottom;
                MatrixUtil.transformCoords(HELPER_MATRIX, coordsX, coordsY, HELPER_POINT);
                minX = Math.min(minX, HELPER_POINT.x);
                maxX = Math.max(maxX, HELPER_POINT.x);
                minY = Math.min(minY, HELPER_POINT.y);
                maxY = Math.max(maxY, HELPER_POINT.y);
            }
            
            resultRect.x = minX;
            resultRect.y = minY;
            resultRect.width = maxX - minX;
            resultRect.height = maxY - minY;
        }
        
        return resultRect;
    }
    
    /**
	 * @private
	 */
    override public function hitTest(localPoint : Point, forTouch : Bool = false) : DisplayObject
    {
        if (forTouch && (!this.visible || !this.touchable))
        {
            return null;
        }
        return (this._hitArea.containsPoint(localPoint)) ? this : null;
    }
    
    /**
	 * @private
	 */
    override private function get_width() : Float
    {
        return this._width;
    }
    
    /**
	 * @private
	 */
    override private function set_width(value : Float) : Float
    {
        if (this._width == value)
        {
            return value;
        }
        
        super.width = value;
        
        this._width = this._hitArea.width = value;
        this._layoutChanged = true;
        this.invalidate();
        return value;
    }
    
    /**
	 * @private
	 */
    override private function get_height() : Float
    {
        return this._height;
    }
    
    /**
	 * @private
	 */
    override private function set_height(value : Float) : Float
    {
        if (this._height == value)
        {
            return value;
        }
        
        super.height = value;
        
        this._height = this._hitArea.height = value;
        this._layoutChanged = true;
        this.invalidate();
        return value;
    }
    
    override private function set_scaleX(value : Float) : Float
    {
        if (this.scaleX != value)
        {
            super.scaleX = value;
            
            this._layoutChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    override private function set_scaleY(value : Float) : Float
    {
        if (this.scaleY != value)
        {
            super.scaleY = value;
            
            this._layoutChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    override private function set_pivotX(value : Float) : Float
    {
        this._pivotChanged = true;
        super.pivotX = value;
        return value;
    }
    
    override private function set_pivotY(value : Float) : Float
    {
        this._pivotChanged = true;
        super.pivotY = value;
        return value;
    }
    
    override private function get_x() : Float
    {
        updateTransformMatrix();
        return super.x;
    }
    
    override private function get_y() : Float
    {
        updateTransformMatrix();
        return super.y;
    }
    
    override private function get_rotation() : Float
    {
        updateTransformMatrix();
        return super.rotation;
    }
    
    override private function get_scaleX() : Float
    {
        updateTransformMatrix();
        return super.scaleX;
    }
    
    override private function get_scaleY() : Float
    {
        updateTransformMatrix();
        return super.scaleY;
    }
    
    override private function get_skewX() : Float
    {
        updateTransformMatrix();
        return super.skewX;
    }
    
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
    
    private function flattenHandler(event : Event) : Void
    {
        this.validate();
    }
    
    private function addedToStageHandler(event : Event) : Void
    {
        this._depth = getDisplayObjectDepthFromStage(this);
        this._validationQueue = ValidationQueue.forStarling(Starling.current);
        if (this._isInvalid)
        {
            this._validationQueue.addControl(this, false);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    private function get_assetTexture() : IGAFTexture
    {
        return this._textures;
    }
    
    /**
	 * The textures displayed by this image.
	 *
	 * <p>In the following example, the textures are changed:</p>
	 *
	 * <listing version="3.0">
	 * image.textures = new Scale9Textures( texture, scale9Grid );</listing>
	 */
    private function get_textures() : GAFScale9Texture
    {
        return this._textures;
    }
    
    /**
	 * @private
	 */
    private function set_textures(value : GAFScale9Texture) : GAFScale9Texture
    {
        if (value == null)
        {
            throw new IllegalOperationError("Scale9Image textures cannot be null.");
        }
        
        if (this._textures != value)
        {
            this._textures = value;
            var texture : Texture = this._textures.texture;
            this._frame = texture.frame;
            if (this._frame == null)
            {
                this._frame = new Rectangle(0, 0, texture.width, texture.height);
            }
            this._layoutChanged = true;
            this._renderingChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    /**
	 * The amount to scale the texture. Useful for DPI changes.
	 *
	 * <p>In the following example, the texture scale is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.textureScale = 2;</listing>
	 *
	 * @default 1
	 */
    private function get_textureScale() : Float
    {
        return this._textureScale;
    }
    
    /**
	 * @private
	 */
    private function set_textureScale(value : Float) : Float
    {
        if (!MathUtility.equals(this._textureScale, value))
        {
            this._textureScale = value;
            this._layoutChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    /**
	 * The smoothing value to pass to the images.
	 *
	 * <p>In the following example, the smoothing is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.smoothing = TextureSmoothing.NONE;</listing>
	 *
	 * @default starling.textures.TextureSmoothing.BILINEAR
	 *
	 * @see starling.textures.TextureSmoothing
	 */
    private function get_smoothing() : String
    {
        return this._smoothing;
    }
    
    /**
	 * @private
	 */
    private function set_smoothing(value : String) : String
    {
        if (this._smoothing != value)
        {
            this._smoothing = value;
            this._propertiesChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    /**
	 * The color value to pass to the images.
	 *
	 * <p>In the following example, the color is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.color = 0xff00ff;</listing>
	 *
	 * @default 0xffffff
	 */
    private function get_color() : Int
    {
        return this._color;
    }
    
    /**
	 * @private
	 */
    private function set_color(value : Int) : Int
    {
        if (this._color != value)
        {
            this._color = value;
            this._propertiesChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    /**
	 * Determines if the regions are batched normally by Starling or if
	 * they're batched separately.
	 *
	 * <p>In the following example, the separate batching is disabled:</p>
	 *
	 * <listing version="3.0">
	 * image.useSeparateBatch = false;</listing>
	 *
	 * @default true
	 */
    private function get_useSeparateBatch() : Bool
    {
        return this._useSeparateBatch;
    }
    
    /**
	 * @private
	 */
    private function set_useSeparateBatch(value : Bool) : Bool
    {
        if (this._useSeparateBatch != value)
        {
            this._useSeparateBatch = value;
            this._renderingChanged = true;
            this.invalidate();
        }
        return value;
    }
    
    /**
	 * @copy feathers.core.IValidating#depth
	 */
    private function get_depth() : Int
    {
        return this._depth;
    }
    
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
    
    /** @private */
    private function get_pivotMatrix() : Matrix
    {
        HELPER_MATRIX.copyFrom(this._textures.pivotMatrix);
        
        if (this._pivotChanged)
        {
            HELPER_MATRIX.tx = HELPER_MATRIX.a * this.pivotX;
            HELPER_MATRIX.ty = HELPER_MATRIX.d * this.pivotY;
        }
        
        return HELPER_MATRIX;
    }
	
	//import feathers.utils.display.getDisplayObjectDepthFromStage;
	inline
	function getDisplayObjectDepthFromStage(target:DisplayObject):Int
	{
		if(target.stage == null)
		{
			return -1;
		}
		var count:Int = 0;
		while(target.parent != null)
		{
			target = target.parent;
			count++;
		}
		return count;
	}
}
