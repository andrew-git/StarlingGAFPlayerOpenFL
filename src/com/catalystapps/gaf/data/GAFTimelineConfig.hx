package com.catalystapps.gaf.data;

import com.catalystapps.gaf.data.config.CAnimationFrames;
import com.catalystapps.gaf.data.config.CAnimationObjects;
import com.catalystapps.gaf.data.config.CAnimationSequences;
import com.catalystapps.gaf.data.config.CFrameSound;
import com.catalystapps.gaf.data.config.CStage;
import com.catalystapps.gaf.data.config.CTextFieldObjects;
import com.catalystapps.gaf.data.config.CTextureAtlasScale;
import com.catalystapps.gaf.utils.MathUtility;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * @private
 */
class GAFTimelineConfig
{
    public var textureAtlas(get, set) : CTextureAtlasScale;
    public var animationObjects(get, set) : CAnimationObjects;
    public var animationConfigFrames(get, set) : CAnimationFrames;
    public var animationSequences(get, set) : CAnimationSequences;
    public var textFields(get, set) : CTextFieldObjects;
    public var allTextureAtlases(get, set) : Array<CTextureAtlasScale>;
    public var version(get, never) : String;
    public var debugRegions(get, set) : Array<GAFDebugInformation>;
    public var warnings(get, never) : Array<String>;
    public var id(get, set) : String;
    public var assetID(get, set) : String;
    public var namedParts(get, set) : Map<String, String>;
    public var linkage(get, set) : String;
    public var stageConfig(get, set) : CStage;
    public var framesCount(get, set) : Int;
    public var bounds(get, set) : Rectangle;
    public var pivot(get, set) : Point;
    public var disposed(get, never) : Bool;

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
    private var _version : String;
    private var _stageConfig : CStage;
    
    private var _id : String;
    private var _assetID : String;
    
    private var _allTextureAtlases : Array<CTextureAtlasScale>;
    private var _textureAtlas : CTextureAtlasScale;
    
    private var _animationConfigFrames : CAnimationFrames;
    private var _animationObjects : CAnimationObjects;
    private var _animationSequences : CAnimationSequences;
    private var _textFields : CTextFieldObjects;
    
    private var _namedParts : Map<String, String>;
    private var _linkage : String = null;
    
    private var _debugRegions : Array<GAFDebugInformation>;
    
    private var _warnings : Array<String>;
    private var _framesCount : Int;
    private var _bounds : Rectangle;
    private var _pivot : Point;
    private var _sounds : Map<Int, CFrameSound>;
    private var _disposed : Bool = false;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(version : String)
    {
        this._version = version;
        
        this._animationConfigFrames = new CAnimationFrames();
        this._animationObjects = new CAnimationObjects();
        this._animationSequences = new CAnimationSequences();
        this._textFields = new CTextFieldObjects();
        this._sounds = new Map();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function dispose() : Void
    {
        for (cTextureAtlasScale in this._allTextureAtlases)
        {
            cTextureAtlasScale.dispose();
        }
        this._allTextureAtlases = null;
        
        this._animationConfigFrames = null;
        this._animationSequences = null;
        this._animationObjects = null;
        this._textureAtlas = null;
        this._textFields = null;
        this._namedParts = null;
        this._warnings = null;
        this._bounds = null;
        this._sounds = null;
        this._pivot = null;
        
        this._disposed = true;
    }
    
    public function getTextureAtlasForScale(scale : Float) : CTextureAtlasScale
    {
        for (cTextureAtlas in this._allTextureAtlases)
        {
            if (MathUtility.equals(cTextureAtlas.scale, scale))
            {
                return cTextureAtlas;
            }
        }
        
        return null;
    }
    
    public function addSound(data : Dynamic, frame : Int) : Void
    {
        this._sounds[frame] = new CFrameSound(data);
    }
    
    public function getSound(frame : Int) : CFrameSound
    {
        return this._sounds[frame];
    }
    
    public function addWarning(text : String) : Void
    {
        if (text == null)
        {
            return;
        }
        
        if (this._warnings == null)
        {
            this._warnings = [];
        }
        
        if (this._warnings.indexOf(text) == -1)
        {
            trace(text);
            this._warnings.push(text);
        }
    }
    
    public function getNamedPartID(name : String) : String
    {
		for (id in _namedParts.keys()) 
		{
			if (_namedParts.get(id) == name)
			{
				return id;
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
    
    private function get_textureAtlas() : CTextureAtlasScale
    {
        return this._textureAtlas;
    }
    
    private function set_textureAtlas(textureAtlas : CTextureAtlasScale) : CTextureAtlasScale
    {
        this._textureAtlas = textureAtlas;
        return textureAtlas;
    }
    
    private function get_animationObjects() : CAnimationObjects
    {
        return this._animationObjects;
    }
    
    private function set_animationObjects(animationObjects : CAnimationObjects) : CAnimationObjects
    {
        this._animationObjects = animationObjects;
        return animationObjects;
    }
    
    private function get_animationConfigFrames() : CAnimationFrames
    {
        return this._animationConfigFrames;
    }
    
    private function set_animationConfigFrames(animationConfigFrames : CAnimationFrames) : CAnimationFrames
    {
        this._animationConfigFrames = animationConfigFrames;
        return animationConfigFrames;
    }
    
    private function get_animationSequences() : CAnimationSequences
    {
        return this._animationSequences;
    }
    
    private function set_animationSequences(animationSequences : CAnimationSequences) : CAnimationSequences
    {
        this._animationSequences = animationSequences;
        return animationSequences;
    }
    
    private function get_textFields() : CTextFieldObjects
    {
        return this._textFields;
    }
    
    private function set_textFields(textFields : CTextFieldObjects) : CTextFieldObjects
    {
        this._textFields = textFields;
        return textFields;
    }
    
    private function get_allTextureAtlases() : Array<CTextureAtlasScale>
    {
        return this._allTextureAtlases;
    }
    
    private function set_allTextureAtlases(allTextureAtlases : Array<CTextureAtlasScale>) : Array<CTextureAtlasScale>
    {
        this._allTextureAtlases = allTextureAtlases;
        return allTextureAtlases;
    }
    
    private function get_version() : String
    {
        return this._version;
    }
    
    private function get_debugRegions() : Array<GAFDebugInformation>
    {
        return this._debugRegions;
    }
    
    private function set_debugRegions(debugRegions : Array<GAFDebugInformation>) : Array<GAFDebugInformation>
    {
        this._debugRegions = debugRegions;
        return debugRegions;
    }
    
    private function get_warnings() : Array<String>
    {
        return this._warnings;
    }
    
    private function get_id() : String
    {
        return this._id;
    }
    
    private function set_id(value : String) : String
    {
        this._id = value;
        return value;
    }
    
    private function get_assetID() : String
    {
        return this._assetID;
    }
    
    private function set_assetID(value : String) : String
    {
        this._assetID = value;
        return value;
    }
    
    private function get_namedParts() : Map<String, String>
    {
        return this._namedParts;
    }
    
    private function set_namedParts(value : Map<String, String>) : Map<String, String>
    {
        this._namedParts = value;
        return value;
    }
    
    private function get_linkage() : String
    {
        return this._linkage;
    }
    
    private function set_linkage(value : String) : String
    {
        this._linkage = value;
        return value;
    }
    
    private function get_stageConfig() : CStage
    {
        return this._stageConfig;
    }
    
    private function set_stageConfig(stageConfig : CStage) : CStage
    {
        this._stageConfig = stageConfig;
        return stageConfig;
    }
    
    private function get_framesCount() : Int
    {
        return this._framesCount;
    }
    
    private function set_framesCount(value : Int) : Int
    {
        this._framesCount = value;
        return value;
    }
    
    private function get_bounds() : Rectangle
    {
        return this._bounds;
    }
    
    private function set_bounds(value : Rectangle) : Rectangle
    {
        this._bounds = value;
        return value;
    }
    
    private function get_pivot() : Point
    {
        return this._pivot;
    }
    
    private function set_pivot(value : Point) : Point
    {
        this._pivot = value;
        return value;
    }
    
    private function get_disposed() : Bool
    {
        return _disposed;
    }
}
