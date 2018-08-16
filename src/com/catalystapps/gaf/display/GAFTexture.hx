package com.catalystapps.gaf.display;

import flash.errors.Error;
import flash.geom.Matrix;
import starling.textures.Texture;

/**
 * @private
 */
class GAFTexture implements IGAFTexture
{
    public var texture(get, never) : Texture;
    public var pivotMatrix(get, never) : Matrix;
    public var id(get, never) : String;

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
    
    private var _id : String;
    private var _texture : Texture;
    private var _pivotMatrix : Matrix;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(id : String, texture : Texture, pivotMatrix : Matrix)
    {
        this._id = id;
        this._texture = texture;
        this._pivotMatrix = pivotMatrix;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    public function copyFrom(newTexture : IGAFTexture) : Void
    {
        if (Std.is(newTexture, GAFTexture))
        {
            this._id = newTexture.id;
            this._texture = newTexture.texture;
            this._pivotMatrix.copyFrom(newTexture.pivotMatrix);
        }
        else
        {
            //throw new Error("Incompatiable types GAFexture and " + Type.getClassName(newTexture));
            throw new Error("Incompatiable types GAFexture and " + Type.getClassName(Type.getClass(newTexture)));
        }
    }
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
    
    private function get_texture() : Texture
    {
        return this._texture;
    }
    
    private function get_pivotMatrix() : Matrix
    {
        return this._pivotMatrix;
    }
    
    private function get_id() : String
    {
        return this._id;
    }
    
    public function clone() : IGAFTexture
    {
        return new GAFTexture(this._id, this._texture, this._pivotMatrix.clone());
    }
}
