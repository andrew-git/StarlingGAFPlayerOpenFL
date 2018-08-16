package com.catalystapps.gaf.data.config;

import com.catalystapps.gaf.utils.MathUtility;

/**
	 * @private
	 */
class CTextureAtlasScale
{
    public var scale(get, set) : Null<Float>;
    public var allContentScaleFactors(get, set) : Array<CTextureAtlasCSF>;
    public var contentScaleFactor(get, set) : CTextureAtlasCSF;

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
    
    private var _scale : Null<Float> = null;
    
    private var _allContentScaleFactors : Array<CTextureAtlasCSF>;
    private var _contentScaleFactor : CTextureAtlasCSF;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new()
    {
        this._allContentScaleFactors = []; // new Array<CTextureAtlasCSF>();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function dispose() : Void
    {
        for (cTextureAtlasCSF in this._allContentScaleFactors)
        {
            cTextureAtlasCSF.dispose();
        }
    }
    
    public function getTextureAtlasForCSF(csf : Null<Float>) : CTextureAtlasCSF
    {
        for (textureAtlas in this._allContentScaleFactors)
        {
            if (MathUtility.equals(textureAtlas.csf, csf))
            {
                return textureAtlas;
            }
        }
        
        return null;
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
    
    private function set_scale(scale : Null<Float>) : Null<Float>
    {
        this._scale = scale;
        return scale;
    }
    
    private function get_scale() : Null<Float>
    {
        return this._scale;
    }
    
    private function get_allContentScaleFactors() : Array<CTextureAtlasCSF>
    {
        return this._allContentScaleFactors;
    }
    
    private function set_allContentScaleFactors(value : Array<CTextureAtlasCSF>) : Array<CTextureAtlasCSF>
    {
        this._allContentScaleFactors = value;
        return value;
    }
    
    private function get_contentScaleFactor() : CTextureAtlasCSF
    {
        return this._contentScaleFactor;
    }
    
    private function set_contentScaleFactor(value : CTextureAtlasCSF) : CTextureAtlasCSF
    {
        this._contentScaleFactor = value;
        return value;
    }
}

