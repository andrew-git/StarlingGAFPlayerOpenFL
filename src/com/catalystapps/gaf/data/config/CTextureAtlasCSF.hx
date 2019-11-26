package com.catalystapps.gaf.data.config;


/**
 * @private
 */
class CTextureAtlasCSF
{
    public var csf(get, never) : Float;
    public var sources(get, set) : Array<CTextureAtlasSource>;
    public var atlas(get, set) : CTextureAtlas;
    public var elements(get, set) : CTextureAtlasElements;

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
    
    private var _scale : Float = Math.NaN;
    private var _csf : Float = Math.NaN;
    
    private var _sources : Array<CTextureAtlasSource> = null;
    
    private var _elements : CTextureAtlasElements = null;
    
    private var _atlas : CTextureAtlas = null;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(csf : Float, scale : Float)
    {
        this._csf = csf;
        this._scale = scale;
        
        this._sources = [];// new Array<CTextureAtlasSource>();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function dispose() : Void
    {
        (this._atlas != null) ? this._atlas.dispose() : null;
        
        this._atlas = null;
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
    
    private function get_csf() : Float
    {
        return this._csf;
    }
    
    private function get_sources() : Array<CTextureAtlasSource>
    {
        return this._sources;
    }
    
    private function set_sources(sources : Array<CTextureAtlasSource>) : Array<CTextureAtlasSource>
    {
        this._sources = sources;
        return sources;
    }
    
    private function get_atlas() : CTextureAtlas
    {
        return this._atlas;
    }
    
    private function set_atlas(atlas : CTextureAtlas) : CTextureAtlas
    {
        this._atlas = atlas;
        return atlas;
    }
    
    private function get_elements() : CTextureAtlasElements
    {
        return this._elements;
    }
    
    private function set_elements(elements : CTextureAtlasElements) : CTextureAtlasElements
    {
        this._elements = elements;
        return elements;
    }
}
