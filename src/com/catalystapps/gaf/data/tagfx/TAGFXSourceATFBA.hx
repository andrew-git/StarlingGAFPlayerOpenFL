/**
 * Created by Nazar on 13.01.2016.
 */
package com.catalystapps.gaf.data.tagfx;

import com.catalystapps.gaf.data.GAF;
import flash.utils.ByteArray;
import starling.textures.Texture;

/**
 * @private
 */
class TAGFXSourceATFBA extends TAGFXBase
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
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(source : ByteArray)
    {
        super();
        this._source = source;
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
    
    override private function get_sourceType() : String
    {
        return SOURCE_TYPE_ATF_BA;
    }
    
    override private function get_texture() : Texture
    {
        if (this._texture == null)
        {
            this._texture = Texture.fromAtfData(this._source, this._textureScale, GAF.useMipMaps, this.onTextureReady);
            this._texture.root.onRestore = function() : Void
                    {
                        _isReady = false;
                        _texture.root.uploadAtfData(_source, 0, onTextureReady);
                    };
        }
        
        return this._texture;
    }
    
    //--------------------------------------------------------------------------
    //
    //  EVENT HANDLERS
    //
    //--------------------------------------------------------------------------
    
    override private function onTextureReady(texture : Texture) : Void
    {
        if (this._clearSourceAfterTextureCreated)
        {
            cast(this._source, ByteArray).clear();
        }
        
        super.onTextureReady(texture);
    }
}

