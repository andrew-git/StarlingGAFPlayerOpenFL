package com.catalystapps.gaf.display;

import flash.display3D.Context3DBlendFactor;
import flash.errors.Error;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.events.Event;
import starling.rendering.Painter;
import starling.textures.RenderTexture;

/**
 * @private
 */
@:meta(Deprecated(replacement="Use GAFStencilMaskStyle for styling Starling display objects",message="Starling 2.0+ support stencil mask"))
class GAFPixelMaskDisplayObject extends DisplayObjectContainer
{
    public var pixelMask(get, set) : DisplayObject;
    public var mustReorder(get, set) : Bool;

    private static inline var MASK_MODE : String = "mask";
    
    private static inline var PADDING : Int = 1;
    
    private static var sHelperRect : Rectangle = new Rectangle();
    
    private var _mask : DisplayObject = null;
    
    private var _renderTexture : RenderTexture = null;
    private var _maskRenderTexture : RenderTexture = null;
    
    private var _image : Image = null;
    private var _maskImage : Image = null;
    
    private var _superRenderFlag : Bool = false;
    
    private var _maskSize : Point = null;
    private var _staticMaskSize : Bool = false;
    private var _scaleFactor : Float;
    
    private var _mustReorder : Bool = false;
    
    public function new(scaleFactor : Float = -1)
    {
        super();
        this._scaleFactor = scaleFactor;
        this._maskSize = new Point();
        
        BlendMode.register(MASK_MODE, Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        
        // Handle lost context. By using the conventional event, we can make a weak listener.
        // This avoids memory leaks when people forget to call "dispose" on the object.
        Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, 
                this.onContextCreated, false, 0, true
        );
    }
    
    override public function dispose() : Void
    {
        this.clearRenderTextures();
        Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        super.dispose();
    }
    
    private function onContextCreated(event : Dynamic) : Void
    {
        this.refreshRenderTextures();
    }
    
    private function set_pixelMask(value : DisplayObject) : DisplayObject
    {
		// clean up existing mask if there is one
        if (this._mask != null)
        {
            this._mask = null;
            this._maskSize.setTo(0, 0);
        }
        
        if (value != null)
        {
            this._mask = value;
            
            if (this._mask.width == 0 || this._mask.height == 0)
            {
                throw new Error("Mask must have dimensions. Current dimensions are " + this._mask.width + "x" + this._mask.height + ".");
            }
            
            var objectWithMaxSize : IMaxSize = try cast(this._mask, IMaxSize) catch(e:Dynamic) null;
            if (objectWithMaxSize != null && objectWithMaxSize.maxSize != null)
            {
                this._maskSize.copyFrom(objectWithMaxSize.maxSize);
                this._staticMaskSize = true;
            }
            else
            {
                this._mask.getBounds(null, sHelperRect);
                this._maskSize.setTo(sHelperRect.width, sHelperRect.height);
                this._staticMaskSize = false;
            }
            
            this.refreshRenderTextures(null);
        }
        else
        {
            this.clearRenderTextures();
        }
        return value;
    }
    
    private function get_pixelMask() : DisplayObject
    {
        return this._mask;
    }
    
    private function clearRenderTextures() : Void
    {
		// clean up old render textures and images
        if (this._maskRenderTexture != null)
        {
            this._maskRenderTexture.dispose();
        }
        
        if (this._renderTexture != null)
        {
            this._renderTexture.dispose();
        }
        
        if (this._image != null)
        {
            this._image.dispose();
        }
        
        if (this._maskImage != null)
        {
            this._maskImage.dispose();
        }
    }
    
    private function refreshRenderTextures(event : Event = null) : Void
    {
        if (Starling.current.contextValid)
        {
            if (this._mask != null)
            {
                this.clearRenderTextures();
                
                this._renderTexture = new RenderTexture(Std.int(this._maskSize.x), Std.int(this._maskSize.y), false, this._scaleFactor);
                this._maskRenderTexture = new RenderTexture(Std.int(this._maskSize.x + PADDING * 2), Std.int(this._maskSize.y + PADDING * 2), false, this._scaleFactor);
                
                // create image with the new render texture
                this._image = new Image(this._renderTexture);
                // create image to blit the mask onto
                this._maskImage = new Image(this._maskRenderTexture);
                this._maskImage.x = this._maskImage.y = -PADDING;
                // set the blending mode to MASK (ZERO, SRC_ALPHA)
                this._maskImage.blendMode = MASK_MODE;
            }
        }
    }
    
    override public function render(painter : Painter) : Void
    {
        if (this._superRenderFlag || this._mask == null)
        {
            super.render(painter);
        }
        else if (this._mask != null)
        {
            var previousStencilRefValue : Int = painter.stencilReferenceValue;
            if (previousStencilRefValue != 0)
            {
                painter.stencilReferenceValue = 0;
            }
            
            _tx = this._mask.transformationMatrix.tx;
            _ty = this._mask.transformationMatrix.ty;
            
            this._mask.getBounds(null, sHelperRect);
            
            if (!this._staticMaskSize
				//&& (sHelperRect.width > this._maskSize.x || sHelperRect.height > this._maskSize.y)  
                && (sHelperRect.width != this._maskSize.x || sHelperRect.height != this._maskSize.y)  
			)
            {
                this._maskSize.setTo(sHelperRect.width, sHelperRect.height);
                this.refreshRenderTextures();
            }
            
            this._mask.transformationMatrix.tx = _tx - sHelperRect.x + PADDING;
            this._mask.transformationMatrix.ty = _ty - sHelperRect.y + PADDING;
//			this._maskRenderTexture.draw(this._mask);
            this._image.transformationMatrix.tx = sHelperRect.x;
            this._image.transformationMatrix.ty = sHelperRect.y;
            this._mask.transformationMatrix.tx = _tx;
            this._mask.transformationMatrix.ty = _ty;
            
//			this._renderTexture.drawBundled(this.drawRenderTextures);
            
            if (previousStencilRefValue != 0)
            {
                painter.stencilReferenceValue = previousStencilRefValue;
            }
            
//			support.pushMatrix();
//			support.transformMatrix(this._image);
            
            painter.drawMask(_mask, _image);
            super.render(painter);
            painter.eraseMask(_mask, _image);
//			support.popMatrix();
        }
    }
    
    private static var _a : Float;
    private static var _b : Float;
    private static var _c : Float;
    private static var _d : Float;
    private static var _tx : Float;
    private static var _ty : Float;
    
    private function drawRenderTextures(object : DisplayObject = null, matrix : Matrix = null, alpha : Float = 1.0) : Void
    {
        _a = this.transformationMatrix.a;
        _b = this.transformationMatrix.b;
        _c = this.transformationMatrix.c;
        _d = this.transformationMatrix.d;
        _tx = this.transformationMatrix.tx;
        _ty = this.transformationMatrix.ty;
        
        this.transformationMatrix.copyFrom(this._image.transformationMatrix);
        this.transformationMatrix.invert();
        
        this._superRenderFlag = true;
        this._renderTexture.draw(this);
        this._superRenderFlag = false;
        
        this.transformationMatrix.a = _a;
        this.transformationMatrix.b = _b;
        this.transformationMatrix.c = _c;
        this.transformationMatrix.d = _d;
        this.transformationMatrix.tx = _tx;
        this.transformationMatrix.ty = _ty;
        
        //-----------------------------------------------------------------------------------------------------------------
        
        this._renderTexture.draw(this._maskImage);
    }
    
    private function get_mustReorder() : Bool
    {
        return this._mustReorder;
    }
    
    private function set_mustReorder(value : Bool) : Bool
    {
        this._mustReorder = value;
        return value;
    }
}
