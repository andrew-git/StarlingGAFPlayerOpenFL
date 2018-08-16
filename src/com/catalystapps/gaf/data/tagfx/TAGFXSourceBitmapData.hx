/**
 * Created by Nazar on 12.01.2016.
 */
package com.catalystapps.gaf.data.tagfx;

import com.catalystapps.gaf.data.GAF;
import flash.display.BitmapData;
import starling.textures.Texture;

/**
 * @private
 */
class TAGFXSourceBitmapData extends TAGFXBase
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
    
    public function new(source : BitmapData, format : String)
    {
        super();
        this._source = source;
        this._textureFormat = format;
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
        return TAGFXBase.SOURCE_TYPE_BITMAP_DATA;
    }
    
    override private function get_texture() : Texture
    {
        if (this._texture == null)
        {
            this._texture = Texture.fromBitmapData(this._source, GAF.useMipMaps, false, this._textureScale, this._textureFormat);
            if (this._clearSourceAfterTextureCreated)
            {
                cast(this._source, BitmapData).dispose();
            }
            
            this._texture.root.onRestore = function() : Void
			{
				_isReady = false;
				_texture.root.uploadBitmapData(_source);
				onTextureReady(_texture);
			};
            
            this.onTextureReady(this._texture);
        }
        
        return this._texture;
    }
}
