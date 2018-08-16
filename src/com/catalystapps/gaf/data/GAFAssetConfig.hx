/**
 * Created by Nazar on 19.05.2014.
 */
package com.catalystapps.gaf.data;

import com.catalystapps.gaf.data.config.CSound;
import com.catalystapps.gaf.data.config.CStage;
import com.catalystapps.gaf.data.config.CTextureAtlasScale;

/**
 * @private
 */
class GAFAssetConfig
{
    public var compression(get, set) : Int;
    public var versionMajor(get, set) : Int;
    public var versionMinor(get, set) : Int;
    public var fileLength(get, set) : Int;
    public var scaleValues(get, never) : Array<Float>;
    public var csfValues(get, never) : Array<Float>;
    public var defaultScale(get, set) : Null<Float>;
    public var defaultContentScaleFactor(get, set) : Null<Float>;
    public var timelines(get, never) : Array<GAFTimelineConfig>;
    public var allTextureAtlases(get, never) : Array<CTextureAtlasScale>;
    public var stageConfig(get, set) : CStage;
    public var id(get, never) : String;
    public var sounds(get, never) : Array<CSound>;

    public static inline var MAX_VERSION : Int = 5;
    
    private var _id : String;
    private var _compression : Int;
    private var _versionMajor : Int;
    private var _versionMinor : Int;
    private var _fileLength : Int;
    private var _scaleValues : Array<Float>;
    private var _csfValues : Array<Float>;
    private var _defaultScale : Null<Float> = null;
    private var _defaultContentScaleFactor : Null<Float> = null;
    
    private var _stageConfig : CStage;
    
    private var _timelines : Array<GAFTimelineConfig>;
    private var _allTextureAtlases : Array<CTextureAtlasScale>;
    private var _sounds : Array<CSound>;
    
    public function new(id : String)
    {
        this._id = id;
        this._scaleValues = [];
        this._csfValues = [];
        
        this._timelines = [];
        this._allTextureAtlases = [];
    }
    
    public function addSound(soundData : CSound) : Void
    {
        if(this._sounds == null) this._sounds = [];
        this._sounds.push(soundData);
    }
    
    public function dispose() : Void
    {
        this._allTextureAtlases = null;
        this._stageConfig = null;
        this._scaleValues = null;
        this._csfValues = null;
        this._timelines = null;
        this._sounds = null;
    }
    
    private function get_compression() : Int
    {
        return this._compression;
    }
    
    private function set_compression(value : Int) : Int
    {
        this._compression = value;
        return value;
    }
    
    private function get_versionMajor() : Int
    {
        return this._versionMajor;
    }
    
    private function set_versionMajor(value : Int) : Int
    {
        this._versionMajor = value;
        return value;
    }
    
    private function get_versionMinor() : Int
    {
        return this._versionMinor;
    }
    
    private function set_versionMinor(value : Int) : Int
    {
        this._versionMinor = value;
        return value;
    }
    
    private function get_fileLength() : Int
    {
        return this._fileLength;
    }
    
    private function set_fileLength(value : Int) : Int
    {
        this._fileLength = value;
        return value;
    }
    
    private function get_scaleValues() : Array<Float>
    {
        return this._scaleValues;
    }
    
    private function get_csfValues() : Array<Float>
    {
        return this._csfValues;
    }
    
    private function get_defaultScale() : Null<Float>
    {
        return this._defaultScale;
    }
    
    private function set_defaultScale(value : Null<Float>) : Null<Float>
    {
        this._defaultScale = value;
        return value;
    }
    
    private function get_defaultContentScaleFactor() : Null<Float>
    {
        return this._defaultContentScaleFactor;
    }
    
    private function set_defaultContentScaleFactor(value : Null<Float>) : Null<Float>
    {
        this._defaultContentScaleFactor = value;
        return value;
    }
    
    private function get_timelines() : Array<GAFTimelineConfig>
    {
        return this._timelines;
    }
    
    private function get_allTextureAtlases() : Array<CTextureAtlasScale>
    {
        return this._allTextureAtlases;
    }
    
    private function get_stageConfig() : CStage
    {
        return this._stageConfig;
    }
    
    private function set_stageConfig(value : CStage) : CStage
    {
        this._stageConfig = value;
        return value;
    }
    
    private function get_id() : String
    {
        return this._id;
    }
    
    private function get_sounds() : Array<CSound>
    {
        return this._sounds;
    }
}
