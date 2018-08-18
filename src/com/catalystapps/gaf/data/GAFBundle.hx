package com.catalystapps.gaf.data;

import com.catalystapps.gaf.display.IGAFTexture;
import com.catalystapps.gaf.sound.GAFSoundData;
import com.catalystapps.gaf.sound.GAFSoundManager;
import flash.errors.Error;

/**
 * GAFBundle is utility class that used to save all converted GAFTimelines from bundle in one place with easy access after conversion complete
 */
class GAFBundle
{
    public var timelines(get, never) : Array<GAFTimeline>;
    public var soundData(get, set) : GAFSoundData;
    public var gafAssets(get, never) : Array<GAFAsset>;
    public var name(get, set) : String;

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
    
    private var _name : String = null;
    private var _soundData : GAFSoundData;
    private var _gafAssets : Array<GAFAsset>;
    private var _gafAssetsDictionary : Map<String, GAFAsset>;  // GAFAsset by SWF name  
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    public function new()
    {
        this._gafAssets = [];
        this._gafAssetsDictionary = new Map();
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
        if (this._gafAssets != null)
        {
            GAFSoundManager.getInstance().stopAll();
            this._soundData.dispose();
            this._soundData = null;
            
            for (gafAsset in this._gafAssets)
            {
                gafAsset.dispose();
            }
            this._gafAssets = null;
            this._gafAssetsDictionary = null;
        }
    }
    
    /**
	 * Returns <code>GAFTimeline</code> from bundle by timelineID
	 * @param swfName is the name of swf file, used to create gaf file
	 * @return <code>GAFTimeline</code> on the stage of swf file
	 */
    @:meta(Deprecated(replacement="com.catalystapps.gaf.data.GAFBundle.getGAFTimeline()",since="5.0"))
    public function getGAFTimelineByID(swfName : String) : GAFTimeline
    {
        var gafTimeline : GAFTimeline = null;
        var gafAsset : GAFAsset = this._gafAssetsDictionary.get(swfName);
        if (gafAsset != null && gafAsset.timelines.length > 0)
        {
            gafTimeline = gafAsset.timelines[0];
        }
        
        return gafTimeline;
    }
    
    /**
	 * Returns <code>GAFTimeline</code> from bundle by linkage
	 * @param linkage linkage in a *.fla file library
	 * @return <code>GAFTimeline</code> from bundle
	 */
    @:meta(Deprecated(replacement="com.catalystapps.gaf.data.GAFBundle.getGAFTimeline()",since="5.0"))
    public function getGAFTimelineByLinkage(linkage : String) : GAFTimeline
    {
        var i : Int = 0;
        var gafAsset : GAFAsset = null;
        var gafTimeline : GAFTimeline = null;
        while (gafAsset == null && (i < this._gafAssets.length))
        {
            gafAsset = this._gafAssets[i++];
            gafTimeline = gafAsset.getGAFTimelineByLinkage(linkage);
        }
        
        return gafTimeline;
    }
    
    /**
	 * Returns <code>GAFTimeline</code> from bundle by <code>swfName</code> and <code>linkage</code>.
	 * @param swfName is the name of SWF file where original timeline was located (or the name of the *.gaf config file where it is located).
	 * @param linkage is the linkage name of the timeline. If you need to get the Main Timeline from SWF use the "rootTimeline" linkage name.
	 * @return <code>GAFTimeline</code> from bundle
	 */
    public function getGAFTimeline(swfName : String, linkage : String = "rootTimeline") : GAFTimeline
    {
        var gafTimeline : GAFTimeline = null;
        var gafAsset : GAFAsset = this._gafAssetsDictionary.get(swfName);
        if (gafAsset != null)
        {
            gafTimeline = gafAsset.getGAFTimelineByLinkage(linkage);
        }
        
        return gafTimeline;
    }
    
    /**
	 * Returns <code>IGAFTexture</code> (custom image) from bundle by <code>swfName</code> and <code>linkage</code>.
	 * Then it can be used to replace animation parts or create new animation parts.
	 * @param swfName is the name of SWF file where original Bitmap/Sprite was located (or the name of the *.gaf config file where it is located)
	 * @param linkage is the linkage name of the Bitmap/Sprite
	 * @param scale Texture atlas Scale that will be used for <code>IGAFTexture</code> creation. Possible values are values from converted animation config.
	 * @param csf Texture atlas content scale factor (CSF) that will be used for <code>IGAFTexture</code> creation. Possible values are values from converted animation config.
	 * @return <code>IGAFTexture</code> (custom image) from bundle.
	 * @see com.catalystapps.gaf.display.GAFImage
	 * @see com.catalystapps.gaf.display.GAFImage#changeTexture()
	 */
    public function getCustomRegion(swfName : String, linkage : String, scale : Null<Float> = null, csf : Null<Float> = null) : IGAFTexture
    {
        var gafTexture : IGAFTexture = null;
        var gafAsset : GAFAsset = this._gafAssetsDictionary.get(swfName);
        if (gafAsset != null)
        {
            gafTexture = gafAsset.getCustomRegion(linkage, scale, csf);
        }
        
        return gafTexture;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * @private
	 */
	@:allow(com.catalystapps.gaf)
    private function getGAFTimelineBySWFNameAndID(swfName : String, id : String) : GAFTimeline
    {
        var gafTimeline : GAFTimeline = null;
        var gafAsset : GAFAsset = this._gafAssetsDictionary.get(swfName);
        if (gafAsset != null)
        {
            gafTimeline = gafAsset.getGAFTimelineByID(id);
        }
        
        return gafTimeline;
    }
    
    /**
	 * @private
	 */
	@:allow(com.catalystapps.gaf)
    private function addGAFAsset(gafAsset : GAFAsset) : Void
    {
        if (this._gafAssetsDictionary.get(gafAsset.id) == null)
        {
            this._gafAssetsDictionary.set(gafAsset.id, gafAsset);
            this._gafAssets.push(gafAsset);
        }
        else
        {
            throw new Error("Bundle error. More then one gaf asset use id: '" + gafAsset.id + "'");
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
	 * Returns all <code>GAFTimeline's</code> from bundle as <code>Vector</code>
	 */
    @:meta(Deprecated(replacement="com.catalystapps.gaf.data.GAFBundle.getGAFTimeline()",since="5.0"))
    private function get_timelines() : Array<GAFTimeline>
    {
        var gafAsset : GAFAsset;
        var timelines : Array<GAFTimeline> = [];
        
        var i : Int = 0;
        var al : Int = this._gafAssets.length;
        while (i < al)
        {
            gafAsset = this._gafAssets[i];
            var j : Int = 0;
            var tl : Int = gafAsset.timelines.length;
            while (j < tl)
            {
                timelines.push(gafAsset.timelines[j]);
                j++;
            }
            i++;
        }
        
        return timelines;
    }
    
    /**
	 * @private
	 */
    private function get_soundData() : GAFSoundData
    {
        return this._soundData;
    }
    
    /**
	 * @private
	 * @param soundData
	 */
    private function set_soundData(soundData : GAFSoundData) : GAFSoundData
    {
        this._soundData = soundData;
        return soundData;
    }
    
    /** @private */
    private function get_gafAssets() : Array<GAFAsset>
    {
        return this._gafAssets;
    }
    
    /**
	 * The name of the bundle. Used in GAFTimelinesManager to identify specific bundle.
	 * Should be specified by user using corresponding setter or by passing the name as second parameter in GAFTimelinesManager.addGAFBundle().
	 * The name can be auto-setted by ZipToGAFAssetConverter in two cases:
	 * 1) If ZipToGAFAssetConverter.id is not empty ZipToGAFAssetConverter sets the bundle name equal to it's id;
	 * 2) If ZipToGAFAssetConverter.id is empty, but gaf package (zip or folder) contain only one *.gaf config file,
	 * ZipToGAFAssetConverter sets the bundle name equal to the name of the *.gaf config file.
	 */
    private function get_name() : String
    {
        return this._name;
    }
    
    private function set_name(name : String) : String
    {
        this._name = name;
        return name;
    }
}
