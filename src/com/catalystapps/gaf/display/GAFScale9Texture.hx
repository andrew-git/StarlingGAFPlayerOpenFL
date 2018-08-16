/**
 * Created by Nazar on 05.03.14.
 */
package com.catalystapps.gaf.display;

import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import starling.textures.Texture;

/**
	 * @private
	 */
class GAFScale9Texture implements IGAFTexture
{
    public var id(get, never) : String;
    public var pivotMatrix(get, never) : Matrix;
    public var texture(get, never) : Texture;
    public var scale9Grid(get, never) : Rectangle;
    public var topLeft(get, never) : Texture;
    public var topCenter(get, never) : Texture;
    public var topRight(get, never) : Texture;
    public var middleLeft(get, never) : Texture;
    public var middleCenter(get, never) : Texture;
    public var middleRight(get, never) : Texture;
    public var bottomLeft(get, never) : Texture;
    public var bottomCenter(get, never) : Texture;
    public var bottomRight(get, never) : Texture;

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
    
    /**
	 * @private
	 */
    private static inline var DIMENSIONS_ERROR : String = "The width and height of the scale9Grid must be greater than zero.";
    /**
	 * @private
	 */
    private static var HELPER_RECTANGLE : Rectangle = new Rectangle();
    
    private var _id : String;
    private var _texture : Texture;
    private var _pivotMatrix : Matrix;
    private var _scale9Grid : Rectangle;
    
    private var _topLeft : Texture;
    private var _topCenter : Texture;
    private var _topRight : Texture;
    private var _middleLeft : Texture;
    private var _middleCenter : Texture;
    private var _middleRight : Texture;
    private var _bottomLeft : Texture;
    private var _bottomCenter : Texture;
    private var _bottomRight : Texture;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(id : String, texture : Texture, pivotMatrix : Matrix, scale9Grid : Rectangle)
    {
        this._id = id;
        this._pivotMatrix = pivotMatrix;
        
        if (scale9Grid.width <= 0 || scale9Grid.height <= 0)
        {
            throw new ArgumentError(DIMENSIONS_ERROR);
        }
        this._texture = texture;
        this._scale9Grid = scale9Grid;
        this.initialize();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    public function copyFrom(_newTexture : IGAFTexture) : Void
    {
        if (Std.is(_newTexture, GAFScale9Texture))
        {
			var newTexture = cast(_newTexture, GAFScale9Texture);
			
            this._id = newTexture.id;
            this._texture = newTexture.texture;
            this._pivotMatrix.copyFrom(newTexture.pivotMatrix);
            this._scale9Grid.copyFrom(newTexture.scale9Grid);
            this._topLeft = newTexture.topLeft;
            this._topCenter = newTexture.topCenter;
            this._topRight = newTexture.topRight;
            this._middleLeft = newTexture.middleLeft;
            this._middleCenter = newTexture.middleCenter;
            this._middleRight = newTexture.middleRight;
            this._bottomLeft = newTexture.bottomLeft;
            this._bottomCenter = newTexture.bottomCenter;
            this._bottomRight = newTexture.bottomRight;
        }
        else
        {
            //throw new Error("Incompatiable types GAFScale9Texture and " + Type.getClassName(newTexture));
            throw new Error("Incompatiable types GAFScale9Texture and " + Type.getClassName(Type.getClass(_newTexture)));
        }
    }
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    private function initialize() : Void
    {
        var textureFrame : Rectangle = this._texture.frame;
        if (textureFrame == null)
        {
            textureFrame = HELPER_RECTANGLE;
            textureFrame.setTo(0, 0, this._texture.width, this._texture.height);
        }
        var leftWidth : Float = this._scale9Grid.left;
        var centerWidth : Float = this._scale9Grid.width;
        var rightWidth : Float = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
        var topHeight : Float = this._scale9Grid.y;
        var middleHeight : Float = this._scale9Grid.height;
        var bottomHeight : Float = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;
        
        var regionLeftWidth : Float = leftWidth + textureFrame.x;
        var regionTopHeight : Float = topHeight + textureFrame.y;
        var regionRightWidth : Float = rightWidth - (textureFrame.width - this._texture.width) - textureFrame.x;
        var regionBottomHeight : Float = bottomHeight - (textureFrame.height - this._texture.height) - textureFrame.y;
        
        var hasLeftFrame : Bool = regionLeftWidth != leftWidth;
        var hasTopFrame : Bool = regionTopHeight != topHeight;
        var hasRightFrame : Bool = regionRightWidth != rightWidth;
        var hasBottomFrame : Bool = regionBottomHeight != bottomHeight;
        
        var topLeftRegion : Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
        var topLeftFrame : Rectangle = ((hasLeftFrame || hasTopFrame)) ? new Rectangle(textureFrame.x, textureFrame.y, leftWidth, topHeight) : null;
        this._topLeft = Texture.fromTexture(this._texture, topLeftRegion, topLeftFrame);
        
        var topCenterRegion : Rectangle = new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
        var topCenterFrame : Rectangle = (hasTopFrame) ? new Rectangle(0, textureFrame.y, centerWidth, topHeight) : null;
        this._topCenter = Texture.fromTexture(this._texture, topCenterRegion, topCenterFrame);
        
        var topRightRegion : Rectangle = new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
        var topRightFrame : Rectangle = ((hasTopFrame || hasRightFrame)) ? new Rectangle(0, textureFrame.y, rightWidth, topHeight) : null;
        this._topRight = Texture.fromTexture(this._texture, topRightRegion, topRightFrame);
        
        var middleLeftRegion : Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
        var middleLeftFrame : Rectangle = (hasLeftFrame) ? new Rectangle(textureFrame.x, 0, leftWidth, middleHeight) : null;
        this._middleLeft = Texture.fromTexture(this._texture, middleLeftRegion, middleLeftFrame);
        
        var middleCenterRegion : Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
        this._middleCenter = Texture.fromTexture(this._texture, middleCenterRegion);
        
        var middleRightRegion : Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
        var middleRightFrame : Rectangle = (hasRightFrame) ? new Rectangle(0, 0, rightWidth, middleHeight) : null;
        this._middleRight = Texture.fromTexture(this._texture, middleRightRegion, middleRightFrame);
        
        var bottomLeftRegion : Rectangle = new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
        var bottomLeftFrame : Rectangle = ((hasLeftFrame || hasBottomFrame)) ? new Rectangle(textureFrame.x, 0, leftWidth, bottomHeight) : null;
        this._bottomLeft = Texture.fromTexture(this._texture, bottomLeftRegion, bottomLeftFrame);
        
        var bottomCenterRegion : Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
        var bottomCenterFrame : Rectangle = (hasBottomFrame) ? new Rectangle(0, 0, centerWidth, bottomHeight) : null;
        this._bottomCenter = Texture.fromTexture(this._texture, bottomCenterRegion, bottomCenterFrame);
        
        var bottomRightRegion : Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
        var bottomRightFrame : Rectangle = ((hasBottomFrame || hasRightFrame)) ? new Rectangle(0, 0, rightWidth, bottomHeight) : null;
        this._bottomRight = Texture.fromTexture(this._texture, bottomRightRegion, bottomRightFrame);
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
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    private function get_id() : String
    {
        return this._id;
    }
    
    private function get_pivotMatrix() : Matrix
    {
        return this._pivotMatrix;
    }
    
    private function get_texture() : Texture
    {
        return this._texture;
    }
    
    private function get_scale9Grid() : Rectangle
    {
        return this._scale9Grid;
    }
    
    private function get_topLeft() : Texture
    {
        return this._topLeft;
    }
    
    private function get_topCenter() : Texture
    {
        return this._topCenter;
    }
    
    private function get_topRight() : Texture
    {
        return this._topRight;
    }
    
    private function get_middleLeft() : Texture
    {
        return this._middleLeft;
    }
    
    private function get_middleCenter() : Texture
    {
        return this._middleCenter;
    }
    
    private function get_middleRight() : Texture
    {
        return this._middleRight;
    }
    
    private function get_bottomLeft() : Texture
    {
        return this._bottomLeft;
    }
    
    private function get_bottomCenter() : Texture
    {
        return this._bottomCenter;
    }
    
    private function get_bottomRight() : Texture
    {
        return this._bottomRight;
    }
    
    public function clone() : IGAFTexture
    {
        return new GAFScale9Texture(this._id, this._texture, this._pivotMatrix.clone(), this._scale9Grid);
    }
}
