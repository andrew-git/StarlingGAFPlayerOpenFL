/**
 * Created by Nazar on 11.06.2015.
 */
package com.catalystapps.gaf.data;

import com.catalystapps.gaf.data.config.CTextureAtlasCSF;
import com.catalystapps.gaf.data.config.CTextureAtlasElement;
import com.catalystapps.gaf.data.config.CTextureAtlasScale;
import com.catalystapps.gaf.display.GAFScale9Texture;
import com.catalystapps.gaf.display.GAFTexture;
import com.catalystapps.gaf.display.IGAFTexture;
import com.catalystapps.gaf.utils.MathUtility;
import flash.errors.Error;
import flash.geom.Matrix;
import starling.textures.Texture;

/** @private */
class GAFAsset
{
    public var timelines(get, never) : Array<GAFTimeline>;
    public var id(get, never) : String;
    public var scale(get, set) : Null<Float>;
    public var csf(get, set) : Null<Float>;

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
    
    private var _config : GAFAssetConfig;
    
    private var _timelines : Array<GAFTimeline>;
    private var _timelinesDictionary : Map<String, GAFTimeline> = new Map();
    private var _timelinesByLinkage : Map<String, GAFTimeline> = new Map();
    
    private var _scale : Null<Float> = null;
    private var _csf : Null<Float> = null;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(config : GAFAssetConfig)
    {
        this._config = config;
        
        this._scale = config.defaultScale;
        this._csf = config.defaultContentScaleFactor;
        
        this._timelines = [];
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * Disposes all assets in bundle
	 */
    public function dispose() : Void
    {
        if (this._timelines.length > 0)
        {
            for (timeline in this._timelines)
            {
                timeline.dispose();
            }
        }
        this._timelines = null;
        
        this._config.dispose();
        this._config = null;
    }
    
    /** @private */
    public function addGAFTimeline(timeline : GAFTimeline) : Void
    {
        if (this._timelinesDictionary.get(timeline.id) == null)
        {
            this._timelinesDictionary.set(timeline.id, timeline);
            this._timelines.push(timeline);
            
            if (timeline.config.linkage != null && timeline.config.linkage != "")
            {
                this._timelinesByLinkage.set(timeline.linkage, timeline);
            }
        }
        else
        {
            throw new Error("Bundle error. More then one timeline use id: '" + timeline.id + "'");
        }
    }
    
    /**
	 * Returns <code>GAFTimeline</code> from gaf asset by linkage
	 * @param linkage linkage in a *.fla file library
	 * @return <code>GAFTimeline</code> from gaf asset
	 */
    public function getGAFTimelineByLinkage(linkage : String) : GAFTimeline
    {
		/*
        var gafTimeline : GAFTimeline = this._timelinesByLinkage.get(linkage);
        
        return gafTimeline;
		*/
		return this._timelinesByLinkage.get(linkage);
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    /** @private
	 * Returns <code>GAFTimeline</code> from gaf asset by ID
	 * @param id internal timeline id
	 * @return <code>GAFTimeline</code> from gaf asset
	 */
    public function getGAFTimelineByID(id : String) : GAFTimeline
    {
        return this._timelinesDictionary.get(id);
    }
    
    /** @private
		 * Returns <code>GAFTimeline</code> from gaf asset bundle by linkage
		 * @param linkage linkage in a *.fla file library
		 * @return <code>GAFTimeline</code> from gaf asset
		 */
/*
    private function getGAFTimelineByLinkage(linkage : String) : GAFTimeline
    {
        return this._timelinesByLinkage.get(linkage);
    }
*/
    public function getCustomRegion(linkage : String, scale : Null<Float> = null, csf : Null<Float> = null) : IGAFTexture
    {
        if (scale == null)
        {
            scale = this._scale;
        }
        if (csf == null)
        {
            csf = this._csf;
        }
        
        var gafTexture : IGAFTexture = null;
        var atlasScale : CTextureAtlasScale;
        var atlasCSF : CTextureAtlasCSF;
        var element : CTextureAtlasElement;
        var i : Int = 0;
        var tasl : Int = this._config.allTextureAtlases.length;
        while (i < tasl)
        {
            atlasScale = this._config.allTextureAtlases[i];
            if (atlasScale.scale == scale)
            {
                var j : Int = 0;
                var tacsfl : Int = atlasScale.allContentScaleFactors.length;
                while (j < tacsfl)
                {
                    atlasCSF = atlasScale.allContentScaleFactors[j];
                    if (atlasCSF.csf == csf)
                    {
                        element = atlasCSF.elements.getElementByLinkage(linkage);
                        
                        if (element != null)
                        {
                            var texture : Texture = atlasCSF.atlas.getTextureByIDAndAtlasID(element.id, element.atlasID);
                            var pivotMatrix : Matrix = element.pivotMatrix;
                            if (element.scale9Grid != null)
                            {
                                gafTexture = new GAFScale9Texture(id, texture, pivotMatrix, element.scale9Grid);
                            }
                            else
                            {
                                gafTexture = new GAFTexture(id, texture, pivotMatrix);
                            }
                        }
                        
                        break;
                    }
                    j++;
                }
                break;
            }
            i++;
        }
        
        return gafTexture;
    }
    
    /** @private */
    public function getValidScale(value : Null<Float>) : Null<Float>
    {
        var index : Int = MathUtility.getItemIndex(this._config.scaleValues, value);
        if (index != -1)
        {
            return this._config.scaleValues[index];
        }
        return null;
    }
    
    /** @private */
    public function hasCSF(value : Float) : Bool
    {
        return MathUtility.getItemIndex(this._config.csfValues, value) >= 0;
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
		 * Returns all <code>GAFTimeline's</code> from gaf asset as <code>Vector</code>
		 * @return <code>GAFTimeline's</code> from gaf asset
		 */
    private function get_timelines() : Array<GAFTimeline>
    {
        return this._timelines;
    }
    
    private function get_id() : String
    {
        return this._config.id;
    }
    
    private function get_scale() : Null<Float>
    {
        return this._scale;
    }
    
    private function set_scale(value : Null<Float>) : Null<Float>
    {
        this._scale = value;
        return value;
    }
    
    private function get_csf() : Null<Float>
    {
        return this._csf;
    }
    
    private function set_csf(value : Null<Float>) : Null<Float>
    {
        this._csf = value;
        return value;
    }
}
