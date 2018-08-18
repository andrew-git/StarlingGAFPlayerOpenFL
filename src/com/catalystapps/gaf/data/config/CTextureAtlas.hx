package com.catalystapps.gaf.data.config;

import com.catalystapps.gaf.display.GAFScale9Texture;
import com.catalystapps.gaf.display.GAFTexture;
import com.catalystapps.gaf.display.IGAFTexture;
import flash.geom.Matrix;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * @private
 */
class CTextureAtlas
{
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
    
    private var _textureAtlasesDictionary : Map<String, TextureAtlas>;
    private var _textureAtlasConfig : CTextureAtlasCSF;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(textureAtlasesDictionary : Map<String, TextureAtlas>, textureAtlasConfig : CTextureAtlasCSF)
    {
        this._textureAtlasesDictionary = textureAtlasesDictionary;
        this._textureAtlasConfig = textureAtlasConfig;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public static function createFromTextures(texturesDictionary : Map<String, Texture>,
            textureAtlasConfig : CTextureAtlasCSF) : CTextureAtlas
    {
        var atlasesDictionary : Map<String, TextureAtlas> = new Map();
        
        var atlas : TextureAtlas;
        
        for (element in textureAtlasConfig.elements.elementsVector)
        {
            if (atlasesDictionary.get(element.atlasID) == null)
            {
                atlasesDictionary.set(element.atlasID, new TextureAtlas(texturesDictionary.get(element.atlasID)));
            }
            
            atlas = atlasesDictionary.get(element.atlasID);
            
            atlas.addRegion(element.id, element.region, null, element.rotated);
        }
        
        return new CTextureAtlas(atlasesDictionary, textureAtlasConfig);
    }
    
    public function dispose() : Void
    {
        for (textureAtlas in this._textureAtlasesDictionary)
        {
            textureAtlas.dispose();
        }
    }
    
    public function getTexture(id : String) : IGAFTexture
    {
        var textureAtlasElement : CTextureAtlasElement = this._textureAtlasConfig.elements.getElement(id);
        if (textureAtlasElement != null)
        {
            var texture : Texture = this.getTextureByIDAndAtlasID(id, textureAtlasElement.atlasID);
            
            var pivotMatrix : Matrix;
            
            if (this._textureAtlasConfig.elements.getElement(id) != null)
            {
                pivotMatrix = this._textureAtlasConfig.elements.getElement(id).pivotMatrix;
            }
            else
            {
                pivotMatrix = new Matrix();
            }
            
            if (textureAtlasElement.scale9Grid != null)
            {
                return new GAFScale9Texture(id, texture, pivotMatrix, textureAtlasElement.scale9Grid);
            }
            else
            {
                return new GAFTexture(id, texture, pivotMatrix);
            }
        }
        
        return null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    @:allow(com.catalystapps.gaf)
    private function getTextureByIDAndAtlasID(id : String, atlasID : String) : Texture
    {
		/*
        var textureAtlas : TextureAtlas = this._textureAtlasesDictionary.get(atlasID);
        
        return textureAtlas.getTexture(id);
		*/
		return this._textureAtlasesDictionary.get(atlasID).getTexture(id);
    }
}
