package com.catalystapps.gaf.data;

import com.catalystapps.gaf.data.config.CAnimationObject;
import com.catalystapps.gaf.data.config.CFrameSound;
import com.catalystapps.gaf.data.config.CTextureAtlas;
import com.catalystapps.gaf.data.config.CTextureAtlasCSF;
import com.catalystapps.gaf.data.config.CTextureAtlasScale;
import com.catalystapps.gaf.data.converters.ErrorConstants;
import com.catalystapps.gaf.display.IGAFTexture;
import com.catalystapps.gaf.sound.GAFSoundData;
import com.catalystapps.gaf.sound.GAFSoundManager;
import flash.errors.Error;
import flash.media.Sound;
import starling.textures.Texture;

/**
 * <p>GAFTimeline represents converted GAF file. It is like a library symbol in Flash IDE that contains all information about GAF animation.
 * It is used to create <code>GAFMovieClip</code> that is ready animation object to be used in starling display list</p>
 */
class GAFTimeline
{
    public var id(get, never) : String;
    public var linkage(get, never) : String;
    public var assetID(get, never) : String;
    public var textureAtlas(get, never) : CTextureAtlas;
    public var config(get, never) : GAFTimelineConfig;
    public var scale(get, set) : Float;
    public var contentScaleFactor(get, set) : Float;
    public var gafgfxData(get, set) : GAFGFXData;
    public var gafAsset(get, set) : GAFAsset;
    public var gafSoundData(get, set) : GAFSoundData;

    //--------------------------------------------------------------------------
    //
    //  PUBLIC VARIABLES
    //
    //--------------------------------------------------------------------------
    
    public static inline var CONTENT_ALL : String = "contentAll";
    public static inline var CONTENT_DEFAULT : String = "contentDefault";
    public static inline var CONTENT_SPECIFY : String = "contentSpecify";
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE VARIABLES
    //
    //--------------------------------------------------------------------------
    
    private var _config : GAFTimelineConfig;
    
    private var _gafSoundData : GAFSoundData;
    private var _gafgfxData : GAFGFXData;
    private var _gafAsset : GAFAsset;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /**
		 * Creates an GAFTimeline object
		 * @param timelineConfig GAF timeline config
		 */
    public function new(timelineConfig : GAFTimelineConfig)
    {
        this._config = timelineConfig;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    // --------------------------------------------------------------------------
    
    /**
	 * Returns GAF Texture by name of an instance inside a timeline.
	 * @param animationObjectName name of an instance inside a timeline
	 * @return GAF Texture
	 */
    public function getTextureByName(animationObjectName : String) : IGAFTexture
    {
        var instanceID : String = this._config.getNamedPartID(animationObjectName);
        if (instanceID != null)
        {
            var part : CAnimationObject = this._config.animationObjects.getAnimationObject(instanceID);
            if (part != null)
            {
                return this.textureAtlas.getTexture(part.regionID);
            }
        }
        return null;
    }
    
    /**
	 * Disposes the underlying GAF timeline config
	 */
    public function dispose() : Void
    {
        this._config.dispose();
        this._config = null;
        this._gafAsset = null;
        this._gafgfxData = null;
        this._gafSoundData = null;
    }
    
    /**
	 * Load all graphical data connected with this asset in device GPU memory. Used in case of manual control of GPU memory usage.
	 * Works only in case when all graphical data stored in RAM (<code>Starling.handleLostContext</code> should be set to <code>true</code>
	 * before asset conversion)
	 *
	 * @param content content type that should be loaded. Available types: <code>CONTENT_ALL, CONTENT_DEFAULT, CONTENT_SPECIFY</code>
	 * @param scale in case when specified content is <code>CONTENT_SPECIFY</code> scale and csf should be set in required values
	 * @param csf in case when specified content is <code>CONTENT_SPECIFY</code> scale and csf should be set in required values
	 */
    public function loadInVideoMemory(content : String = "contentDefault", scale : Null<Float> = null, csf : Null<Float> = null) : Void
    {
        if (this._config.textureAtlas == null || this._config.textureAtlas.contentScaleFactor.elements == null)
        {
            return;
        }
        
        var textures : Map<String, Texture>;
        var csfConfig : CTextureAtlasCSF;
        
        switch (content)
        {
            case CONTENT_ALL:
                for (scaleConfig in this._config.allTextureAtlases)
                {
                    for (csfConfig in scaleConfig.allContentScaleFactors)
                    {
                        this._gafgfxData.createTextures(scaleConfig.scale, csfConfig.csf);
                        
                        textures = this._gafgfxData.getTextures(scaleConfig.scale, csfConfig.csf);
                        if (csfConfig.atlas == null && textures != null)
                        {
                            csfConfig.atlas = CTextureAtlas.createFromTextures(textures, csfConfig);
                        }
                    }
                }
                return;
            
            case CONTENT_DEFAULT:
                csfConfig = this._config.textureAtlas.contentScaleFactor;
                
                if (csfConfig == null)
                {
                    return;
                }
                
                if (csfConfig.atlas == null && this._gafgfxData.createTextures(this.scale, this.contentScaleFactor))
                {
                    csfConfig.atlas = CTextureAtlas.createFromTextures(this._gafgfxData.getTextures(this.scale, this.contentScaleFactor), csfConfig);
                }
                
                return;
            
            case CONTENT_SPECIFY:
                csfConfig = this.getCSFConfig(scale, csf);
                
                if (csfConfig == null)
                {
                    return;
                }
                
                if (csfConfig.atlas == null && this._gafgfxData.createTextures(scale, csf))
                {
                    csfConfig.atlas = CTextureAtlas.createFromTextures(this._gafgfxData.getTextures(scale, csf), csfConfig);
                }
                return;
        }
    }
    
    /**
	 * Unload all all graphical data connected with this asset from device GPU memory. Used in case of manual control of video memory usage
	 *
	 * @param content content type that should be loaded (CONTENT_ALL, CONTENT_DEFAULT, CONTENT_SPECIFY)
	 * @param scale in case when specified content is CONTENT_SPECIFY scale and csf should be set in required values
	 * @param csf in case when specified content is CONTENT_SPECIFY scale and csf should be set in required values
	 */
    public function unloadFromVideoMemory(content : String = "contentDefault", scale : Null<Float> = null, csf : Null<Float> = null) : Void
    {
        if (this._config.textureAtlas == null || this._config.textureAtlas.contentScaleFactor.elements == null)
        {
            return;
        }
		
        var csfConfig : CTextureAtlasCSF;
        
        switch (content)
        {
            case CONTENT_ALL:
                this._gafgfxData.disposeTextures();
                this._config.dispose();
                return;
            case CONTENT_DEFAULT:
                this._gafgfxData.disposeTextures(this.scale, this.contentScaleFactor);
                this._config.textureAtlas.contentScaleFactor.dispose();
                return;
            case CONTENT_SPECIFY:
                csfConfig = this.getCSFConfig(scale, csf);
                if (csfConfig != null)
                {
                    this._gafgfxData.disposeTextures(scale, csf);
                    csfConfig.dispose();
                }
                return;
        }
    }
    
    /** @private */
    public function startSound(frame : Int) : Void
    {
        var frameSoundConfig : CFrameSound = this._config.getSound(frame);
        if (frameSoundConfig != null)
        {
            if (frameSoundConfig.action == CFrameSound.ACTION_STOP)
            {
                GAFSoundManager.getInstance().stop(frameSoundConfig.soundID, this._config.assetID);
            }
            else
            {
                var sound : Sound;
                if (frameSoundConfig.linkage != null && frameSoundConfig.linkage != "")
                {
                    sound = this.gafSoundData.getSoundByLinkage(frameSoundConfig.linkage);
                }
                else
                {
                    sound = this.gafSoundData.getSound(frameSoundConfig.soundID, this._config.assetID);
                }
                var soundOptions : Dynamic = { };
                Reflect.setField(soundOptions, "continue", frameSoundConfig.action == CFrameSound.ACTION_CONTINUE);
                Reflect.setField(soundOptions, "repeatCount", frameSoundConfig.repeatCount);
                GAFSoundManager.getInstance().play(sound, frameSoundConfig.soundID, soundOptions, this._config.assetID);
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    private function getCSFConfig(scale : Float, csf : Float) : CTextureAtlasCSF
    {
        var scaleConfig : CTextureAtlasScale = this._config.getTextureAtlasForScale(scale);
        
        if (scaleConfig != null)
        {
            var csfConfig : CTextureAtlasCSF = scaleConfig.getTextureAtlasForCSF(csf);
            
            if (csfConfig != null)
            {
                return csfConfig;
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
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
    
    /**
	 * Timeline identifier (name given at animation's upload or assigned by developer)
	 */
    private function get_id() : String
    {
        return this.config.id;
    }
    
    /**
	 * Timeline linkage in a *.fla file library
	 */
    private function get_linkage() : String
    {
        return this.config.linkage;
    }
    
    /** @private
	 * Asset identifier (name given at animation's upload or assigned by developer)
	 */
    private function get_assetID() : String
    {
        return this.config.assetID;
    }
    
    /** @private */
    private function get_textureAtlas() : CTextureAtlas
    {
        if (this._config.textureAtlas == null)
        {
            return null;
        }
        if (this._config.textureAtlas.contentScaleFactor.atlas == null)
        {
            this.loadInVideoMemory(CONTENT_DEFAULT);
        }
        
        return this._config.textureAtlas.contentScaleFactor.atlas;
    }
    
    /** @private */
    private function get_config() : GAFTimelineConfig
    {
        return this._config;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    /**
	 * Texture atlas scale that will be used for <code>GAFMovieClip</code> creation. To create <code>GAFMovieClip's</code>
	 * with different scale assign appropriate scale to <code>GAFTimeline</code> and only after that instantiate <code>GAFMovieClip</code>.
	 * Possible values are values from converted animation config. They are depends from project settings on site converter
	 */
    private function set_scale(value : Null<Float>) : Null<Float>
    {
        var scale : Null<Float> = this._gafAsset.getValidScale(value);
        if (scale == null)
        {
            throw new Error(ErrorConstants.SCALE_NOT_FOUND);
        }
        else
        {
            this._gafAsset.scale = scale;
        }
        
        if (this._config.textureAtlas == null)
        {
            return value;
        }
        
        var csf : Float = this.contentScaleFactor;
        var taScale : CTextureAtlasScale = this._config.getTextureAtlasForScale(scale);
        if (taScale != null)
        {
            this._config.textureAtlas = taScale;
            
            var taCSF : CTextureAtlasCSF = this._config.textureAtlas.getTextureAtlasForCSF(csf);
            
            if (taCSF != null)
            {
                this._config.textureAtlas.contentScaleFactor = taCSF;
            }
            else
            {
                throw new Error("There is no csf " + csf + "in timeline config for scalse " + scale);
            }
        }
        else
        {
            throw new Error("There is no scale " + scale + "in timeline config");
        }
        return value;
    }
    
    private function get_scale() : Float
    {
        return this._gafAsset.scale;
    }
    
    /**
	 * Texture atlas content scale factor (csf) that will be used for <code>GAFMovieClip</code> creation. To create <code>GAFMovieClip's</code>
	 * with different csf assign appropriate csf to <code>GAFTimeline</code> and only after that instantiate <code>GAFMovieClip</code>.
	 * Possible values are values from converted animation config. They are depends from project settings on site converter
	 */
    private function set_contentScaleFactor(csf : Float) : Float
    {
        if (this._gafAsset.hasCSF(csf))
        {
            this._gafAsset.csf = csf;
        }
        
        if (this._config.textureAtlas == null)
        {
            return csf;
        }
        
        var taCSF : CTextureAtlasCSF = this._config.textureAtlas.getTextureAtlasForCSF(csf);
        
        if (taCSF != null)
        {
            this._config.textureAtlas.contentScaleFactor = taCSF;
        }
        else
        {
            throw new Error("There is no csf " + csf + "in timeline config");
        }
        return csf;
    }
    
    private function get_contentScaleFactor() : Float
    {
        return this._gafAsset.csf;
    }
    
    /**
	 * Graphical data storage that used by <code>GAFTimeline</code>.
	 */
    private function set_gafgfxData(gafgfxData : GAFGFXData) : GAFGFXData
    {
        this._gafgfxData = gafgfxData;
        return gafgfxData;
    }
    
    private function get_gafgfxData() : GAFGFXData
    {
        return this._gafgfxData;
    }
    
    /** @private */
    private function get_gafAsset() : GAFAsset
    {
        return this._gafAsset;
    }
    
    /** @private */
    private function set_gafAsset(asset : GAFAsset) : GAFAsset
    {
        this._gafAsset = asset;
        return asset;
    }
    
    /** @private */
    private function get_gafSoundData() : GAFSoundData
    {
        return this._gafSoundData;
    }
    
    /** @private */
    private function set_gafSoundData(gafSoundData : GAFSoundData) : GAFSoundData
    {
        this._gafSoundData = gafSoundData;
        return gafSoundData;
    }
}
