package com.catalystapps.gaf.data.converters;

import com.catalystapps.gaf.data.GAF;
import com.catalystapps.gaf.data.GAFAssetConfig;
import com.catalystapps.gaf.data.GAFTimelineConfig;
import com.catalystapps.gaf.data.config.CAnimationFrame;
import com.catalystapps.gaf.data.config.CAnimationFrameInstance;
import com.catalystapps.gaf.data.config.CAnimationObject;
import com.catalystapps.gaf.data.config.CAnimationSequence;
import com.catalystapps.gaf.data.config.CBlurFilterData;
import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.CFrameAction;
import com.catalystapps.gaf.data.config.CSound;
import com.catalystapps.gaf.data.config.CStage;
import com.catalystapps.gaf.data.config.CTextFieldObject;
import com.catalystapps.gaf.data.config.CTextureAtlasCSF;
import com.catalystapps.gaf.data.config.CTextureAtlasElement;
import com.catalystapps.gaf.data.config.CTextureAtlasElements;
import com.catalystapps.gaf.data.config.CTextureAtlasScale;
import com.catalystapps.gaf.data.config.CTextureAtlasSource;
import com.catalystapps.gaf.utils.MathUtility;
import flash.errors.Error;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;
import flash.utils.CompressionAlgorithm;
import flash.utils.Endian;
import openfl.Lib;
import openfl.Vector;
import starling.core.Starling;
import starling.utils.RectangleUtil;

/**
 * @private
 */
class BinGAFAssetConfigConverter extends EventDispatcher
{
    public var config(get, never) : GAFAssetConfig;
    public var assetID(get, never) : String;
    public var ignoreSounds(never, set) : Bool;
    public var defaultScale(never, set) : Null<Float>;
    public var defaultCSF(never, set) : Null<Float>;

    private static inline var SIGNATURE_GAF : Int = 0x00474146;
    private static inline var SIGNATURE_GAC : Int = 0x00474143;
    private static inline var HEADER_LENGTH : Int = 36;
    
    //tags
    private static inline var TAG_END : Int = 0;
    private static inline var TAG_DEFINE_ATLAS : Int = 1;
    private static inline var TAG_DEFINE_ANIMATION_MASKS : Int = 2;
    private static inline var TAG_DEFINE_ANIMATION_OBJECTS : Int = 3;
    private static inline var TAG_DEFINE_ANIMATION_FRAMES : Int = 4;
    private static inline var TAG_DEFINE_NAMED_PARTS : Int = 5;
    private static inline var TAG_DEFINE_SEQUENCES : Int = 6;
    private static inline var TAG_DEFINE_TEXT_FIELDS : Int = 7;  // v4.0  
    private static inline var TAG_DEFINE_ATLAS2 : Int = 8;  // v4.0  
    private static inline var TAG_DEFINE_STAGE : Int = 9;
    private static inline var TAG_DEFINE_ANIMATION_OBJECTS2 : Int = 10;  // v4.0  
    private static inline var TAG_DEFINE_ANIMATION_MASKS2 : Int = 11;  // v4.0  
    private static inline var TAG_DEFINE_ANIMATION_FRAMES2 : Int = 12;  // v4.0  
    private static inline var TAG_DEFINE_TIMELINE : Int = 13;  // v4.0  
    private static inline var TAG_DEFINE_SOUNDS : Int = 14;  // v5.0  
    private static inline var TAG_DEFINE_ATLAS3 : Int = 15;  // v5.0  
    
    //filters
    private static inline var FILTER_DROP_SHADOW : Int = 0;
    private static inline var FILTER_BLUR : Int = 1;
    private static inline var FILTER_GLOW : Int = 2;
    private static inline var FILTER_COLOR_MATRIX : Int = 6;
    
    private static var sHelperRectangle : Rectangle = new Rectangle();
    private static var sHelperMatrix : Matrix = new Matrix();
    
    private var _assetID : String;
    private var _bytes : ByteArray;
    private var _defaultScale : Null<Float> = null;
    private var _defaultContentScaleFactor : Null<Float> = null;
    private var _config : GAFAssetConfig;
    private var _textureElementSizes : Map<String, Rectangle>;  // Point by texture element id  
    
    private var _time : Int;
    private var _isTimeline : Bool;
    private var _currentTimeline : GAFTimelineConfig;
    private var _async : Bool;
    private var _ignoreSounds : Bool;
    
    
    // --------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    public function new(assetID : String, bytes : ByteArray)
    {
        super();
        this._bytes = bytes;
        this._assetID = assetID;
        this._textureElementSizes = new Map();
    }
    
    public function convert(async : Bool = false) : Void
    {
        this._async = async;
        this._time = Math.round(haxe.Timer.stamp() * 1000);
        if (async)
        {
            Starling.current.juggler.delayCall(this.parseStart, 0.001);
        }
        else
        {
            this.parseStart();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    private function parseStart() : Void
    {
        this._bytes.endian = Endian.LITTLE_ENDIAN;
        
        this._config = new GAFAssetConfig(this._assetID);
        this._config.compression = this._bytes.readInt();
        this._config.versionMajor = this._bytes.readByte();
        this._config.versionMinor = this._bytes.readByte();
        this._config.fileLength = this._bytes.readUnsignedInt();
        
        /*if (this._config.versionMajor > GAFAssetConfig.MAX_VERSION)
		{
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, WarningConstants.UNSUPPORTED_FILE +
			"Library version: " + GAFAssetConfig.MAX_VERSION + ", file version: " + this._config.versionMajor));
			return;
		}*/
        
        var _sw0_ = (this._config.compression);        

        switch (_sw0_)
        {
            case SIGNATURE_GAC:
                this.decompressConfig();
        }
        
        if (this._config.versionMajor < 4)
        {
            this._currentTimeline = new GAFTimelineConfig(this._config.versionMajor + "." + this._config.versionMinor);
            this._currentTimeline.id = "0";
            this._currentTimeline.assetID = this._assetID;
            this._currentTimeline.framesCount = this._bytes.readShort();
            this._currentTimeline.bounds = new Rectangle(this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat());
            this._currentTimeline.pivot = new Point(this._bytes.readFloat(), this._bytes.readFloat());
            this._config.timelines.push(this._currentTimeline);
        }
        else
        {
            var i : Int;
            var l : Int = this._bytes.readUnsignedInt();
            for (i in 0...l)
            {
                this._config.scaleValues.push(this._bytes.readFloat());
            }
            
            l = this._bytes.readUnsignedInt();
            for (i in 0...l)
            {
                this._config.csfValues.push(this._bytes.readFloat());
            }
        }
        
        this.readNextTag();
    }
    
    private function decompressConfig() : Void
    {
        var uncompressedBA : ByteArray = new ByteArray();
        uncompressedBA.endian = Endian.LITTLE_ENDIAN;
        
        this._bytes.readBytes(uncompressedBA);
        this._bytes.clear();
        
        uncompressedBA.uncompress(CompressionAlgorithm.ZLIB);
        
        this._bytes = uncompressedBA;
    }
    
    private function checkForMissedRegions(timelineConfig : GAFTimelineConfig) : Void
    {
        if (timelineConfig.textureAtlas != null && timelineConfig.textureAtlas.contentScaleFactor.elements != null)
        {
            for (ao in timelineConfig.animationObjects.animationObjectsDictionary)
            {
                if (ao.type == CAnimationObject.TYPE_TEXTURE 
				&& timelineConfig.textureAtlas.contentScaleFactor.elements.getElement(ao.regionID) == null)
                {
                    timelineConfig.addWarning(WarningConstants.REGION_NOT_FOUND);
                    break;
                }
            }
        }
    }
    
    private function readNextTag() : Void
    {
        var tagID : Int = this._bytes.readShort();
        var tagLength : Int = this._bytes.readUnsignedInt();
        
        switch (tagID)
        {
            case BinGAFAssetConfigConverter.TAG_DEFINE_STAGE:
                readStageConfig(this._bytes, this._config);
            case BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS, 
					BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS2, 
					BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS3:
                readTextureAtlasConfig(tagID);
            case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS, 
					BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS2:
                readAnimationMasks(tagID, this._bytes, this._currentTimeline);
            case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_OBJECTS, 
					BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_OBJECTS2:
                readAnimationObjects(tagID, this._bytes, this._currentTimeline);
            case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_FRAMES, 
					BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_FRAMES2:
                readAnimationFrames(tagID);
                return;
            case BinGAFAssetConfigConverter.TAG_DEFINE_NAMED_PARTS:
                readNamedParts(this._bytes, this._currentTimeline);
            case BinGAFAssetConfigConverter.TAG_DEFINE_SEQUENCES:
                readAnimationSequences(this._bytes, this._currentTimeline);
            case BinGAFAssetConfigConverter.TAG_DEFINE_TEXT_FIELDS:
                readTextFields(this._bytes, this._currentTimeline);
            case BinGAFAssetConfigConverter.TAG_DEFINE_SOUNDS:
                if (!this._ignoreSounds)
                {
                    readSounds(this._bytes, this._config);
                }
                else
                {
                    this._bytes.position += tagLength;
                }
            case BinGAFAssetConfigConverter.TAG_DEFINE_TIMELINE:
                this._currentTimeline = readTimeline();
            case BinGAFAssetConfigConverter.TAG_END:
                if (this._isTimeline)
                {
                    this._isTimeline = false;
                }
                else
                {
                    this._bytes.position = this._bytes.length;
                    this.endParsing();
                    return;
                }
            default:
                trace(WarningConstants.UNSUPPORTED_TAG);
                this._bytes.position += tagLength;
        }
        
        delayedReadNextTag();
    }
    
    private function delayedReadNextTag() : Void
    {
        if (this._async)
        {
            //var timer : Int = Math.round(haxe.Timer.stamp() * 1000);
            var timer : Int = Lib.getTimer();
            if (timer - this._time >= 20)
            {
                this._time = timer;
                Starling.current.juggler.delayCall(this.readNextTag, 0.001);
            }
            else
            {
                this.readNextTag();
            }
        }
        else
        {
            this.readNextTag();
        }
    }
    
    private function readTimeline() : GAFTimelineConfig
    {
        var timelineConfig : GAFTimelineConfig = new GAFTimelineConfig(this._config.versionMajor + "." + _config.versionMinor);
        timelineConfig.id = Std.string(this._bytes.readUnsignedInt());
        timelineConfig.assetID = this._config.id;
        timelineConfig.framesCount = this._bytes.readUnsignedInt();
        timelineConfig.bounds = new Rectangle(this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat());
        timelineConfig.pivot = new Point(this._bytes.readFloat(), this._bytes.readFloat());
        
        var hasLinkage : Bool = this._bytes.readBoolean();
        if (hasLinkage)
        {
            timelineConfig.linkage = this._bytes.readUTF();
        }
        
        this._config.timelines.push(timelineConfig);
        
        this._isTimeline = true;
        
        return timelineConfig;
    }
    
    private function readMaskMaxSizes() : Void
    {
        for (timeline in this._config.timelines)
        {
            for (frame in timeline.animationConfigFrames.frames)
            {
                for (frameInstance in frame.instances)
                {
                    var animationObject : CAnimationObject = timeline.animationObjects.getAnimationObject(frameInstance.id);
                    if (animationObject.mask)
                    {
                        if (animationObject.maxSize == null)
                        {
                            animationObject.maxSize = new Point();
                        }
                        
                        var maxSize : Point = animationObject.maxSize;
                        
                        if (animationObject.type == CAnimationObject.TYPE_TEXTURE)
                        {
                            sHelperRectangle.copyFrom(this._textureElementSizes.get(animationObject.regionID));
                        }
                        else if (animationObject.type == CAnimationObject.TYPE_TIMELINE)
                        {
                            var maskTimeline : GAFTimelineConfig = null;
                            for (maskTimeline in this._config.timelines)
                            {
                                if (maskTimeline.id == animationObject.regionID)
                                {
                                    break;
                                }
                            }
                            sHelperRectangle.copyFrom(maskTimeline.bounds);
                        }
                        else if (animationObject.type == CAnimationObject.TYPE_TEXTFIELD)
                        {
                            var textField : CTextFieldObject = timeline.textFields.textFieldObjectsDictionary[animationObject.regionID];
                            sHelperRectangle.setTo(
                                    -textField.pivotPoint.x, 
                                    -textField.pivotPoint.y, 
                                    textField.width, 
                                    textField.height
							);
                        }
                        RectangleUtil.getBounds(sHelperRectangle, frameInstance.matrix, sHelperRectangle);
                        maxSize.setTo(
                                Math.max(maxSize.x, Math.abs(sHelperRectangle.width)), 
                                Math.max(maxSize.y, Math.abs(sHelperRectangle.height))
						);
                    }
                }
            }
        }
    }
    
    private function endParsing() : Void
    {
        this._bytes.clear();
        this._bytes = null;
        
        this.readMaskMaxSizes();
        
        var itemIndex : Int = 0;
        if (this._config.defaultScale == null)
        {
            if (this._defaultScale != null)
            {
                itemIndex = MathUtility.getItemIndex(this._config.scaleValues, this._defaultScale);
                if (itemIndex < 0)
                {
                    parseError(this._defaultScale + ErrorConstants.SCALE_NOT_FOUND);
                    return;
                }
            }
            this._config.defaultScale = this._config.scaleValues[itemIndex];
        }
        if (this._config.defaultContentScaleFactor == null)
        {
            itemIndex = 0;
            if (this._defaultContentScaleFactor != null)
            {
                itemIndex = MathUtility.getItemIndex(this._config.csfValues, this._defaultContentScaleFactor);
                if (itemIndex < 0)
                {
                    parseError(this._defaultContentScaleFactor + ErrorConstants.CSF_NOT_FOUND);
                    return;
                }
            }
            this._config.defaultContentScaleFactor = this._config.csfValues[itemIndex];
        }
        
        for (textureAtlasScale in this._config.allTextureAtlases)
        {
            for (textureAtlasCSF in textureAtlasScale.allContentScaleFactors)
            {
                if (MathUtility.equals(this._config.defaultContentScaleFactor, textureAtlasCSF.csf))
                {
                    textureAtlasScale.contentScaleFactor = textureAtlasCSF;
                    break;
                }
            }
        }
        
        for (timelineConfig in this._config.timelines)
        {
            timelineConfig.allTextureAtlases = this._config.allTextureAtlases;
            
            for (textureAtlasScale in this._config.allTextureAtlases)
            {
                if (MathUtility.equals(this._config.defaultScale, textureAtlasScale.scale))
                {
                    timelineConfig.textureAtlas = textureAtlasScale;
                }
            }
            
            timelineConfig.stageConfig = this._config.stageConfig;
            
            this.checkForMissedRegions(timelineConfig);
        }
        
        this.dispatchEvent(new Event(Event.COMPLETE));
    }
    
    private function readAnimationFrames(tagID : Int, startIndex : Int = 0, framesCount : Null<Float> = null, prevFrame : CAnimationFrame = null) : Void
    {
        if (framesCount == null)
        {
            framesCount = this._bytes.readUnsignedInt();
        }
        var missedFrameNumber : Int = 0;
        var filterLength : Int = 0;
        var frameNumber : Int = 0;
        var statesCount : Int = 0;
        var filterType : Int = 0;
        var stateID : Int = 0;
        var zIndex : Int = 0;
        var alpha : Float = 0;
        var matrix : Matrix = null;
        var maskID : String;
        var hasMask : Bool = false;
        var hasEffect : Bool = false;
        var hasActions : Bool = false;
        var hasColorTransform : Bool = false;
        var hasChangesInDisplayList : Bool = false;
        
        var timelineConfig : GAFTimelineConfig = this._config.timelines[this._config.timelines.length - 1];
        var instance : CAnimationFrameInstance = null;
        var currentFrame : CAnimationFrame = null;
        var blurFilter : CBlurFilterData = null;
        var blurFilters : Map<String, CBlurFilterData> = new Map();
        var filter : CFilter = null;
        
        //var cycleTime : Int = Math.round(haxe.Timer.stamp() * 1000);
        var cycleTime : Int = Lib.getTimer();
        
        if ((framesCount != null) && framesCount != 0)
        {
			var i:Int = startIndex;
			while(i < framesCount)
            {
                if (this._async
                    //&& (Math.round(haxe.Timer.stamp() * 1000) - cycleTime >= 20))
                    && (Lib.getTimer() - cycleTime >= 20))
                {
                    //Starling.juggler.delayCall(readAnimationFrames, 0.001, tagID, i, framesCount, prevFrame);
                    Starling.current.juggler.delayCall(readAnimationFrames, 0.001, [tagID, i, framesCount, prevFrame]);
                    return;
                }
                
                frameNumber = this._bytes.readUnsignedInt();
                
                if (tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_FRAMES)
                {
                    hasChangesInDisplayList = true;
                    hasActions = false;
                }
                else
                {
                    hasChangesInDisplayList = this._bytes.readBoolean();
                    hasActions = this._bytes.readBoolean();
                }
                
                if (prevFrame != null)
                {
                    currentFrame = prevFrame.clone(frameNumber);
                    
                    missedFrameNumber = prevFrame.frameNumber + 1;
                    while (missedFrameNumber < currentFrame.frameNumber)
                    {
                        timelineConfig.animationConfigFrames.addFrame(prevFrame.clone(missedFrameNumber));
                        missedFrameNumber++;
                    }
                }
                else
                {
                    currentFrame = new CAnimationFrame(frameNumber);
                    
                    if (currentFrame.frameNumber > 1)
                    {
                        missedFrameNumber = 1;
                        while (missedFrameNumber < currentFrame.frameNumber)
                        {
                            timelineConfig.animationConfigFrames.addFrame(new CAnimationFrame(missedFrameNumber));
                            missedFrameNumber++;
                        }
                    }
                }
                
                if (hasChangesInDisplayList)
                {
                    statesCount = this._bytes.readUnsignedInt();
                    
                    for (j in 0...statesCount)
                    {
                        hasColorTransform = this._bytes.readBoolean();
                        hasMask = this._bytes.readBoolean();
                        hasEffect = this._bytes.readBoolean();
                        
                        stateID = this._bytes.readUnsignedInt();
                        zIndex = this._bytes.readInt();
                        alpha = this._bytes.readFloat();
                        if (alpha == 1)
                        {
                            alpha = GAF.maxAlpha;
                        }
                        matrix = new Matrix(this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat(), 
                                this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat());
                        
                        filter = null;
                        
                        if (hasColorTransform)
                        {
                            var params : Vector<Float> = Vector.ofArray([
                                    this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat(), 
                                    this._bytes.readFloat(), this._bytes.readFloat(), this._bytes.readFloat(), 
                                    this._bytes.readFloat()
							]);
                            params.fixed = true;
                            filter = (filter != null) ? filter : new CFilter();
                            filter.addColorTransform(params);
                        }
                        
                        if (hasEffect)
                        {
                            filter = (filter != null) ? filter : new CFilter();
                            
                            filterLength = this._bytes.readByte();
                            for (k in 0...filterLength)
                            {
                                filterType = this._bytes.readUnsignedInt();
                                var warning : String = "";
                                
                                switch (filterType)
                                {
                                    case BinGAFAssetConfigConverter.FILTER_DROP_SHADOW:
                                        warning = readDropShadowFilter(this._bytes, filter);
                                    case BinGAFAssetConfigConverter.FILTER_BLUR:
                                        warning = readBlurFilter(this._bytes, filter);
                                        blurFilter = cast(filter.filterConfigs[filter.filterConfigs.length - 1], CBlurFilterData);
                                        if ((blurFilter.blurX >= 2) && (blurFilter.blurY >= 2))
                                        {
                                            if (blurFilters.get(Std.string(stateID)) == null)
                                            {
                                                blurFilters.set(Std.string(stateID), blurFilter);
                                            }
                                        }
                                        else
                                        {
                                            blurFilters.set(Std.string(stateID), null);
                                        }
                                    case BinGAFAssetConfigConverter.FILTER_GLOW:
                                        warning = readGlowFilter(this._bytes, filter);
                                    case BinGAFAssetConfigConverter.FILTER_COLOR_MATRIX:
                                        warning = readColorMatrixFilter(this._bytes, filter);
                                    default:
                                        trace(WarningConstants.UNSUPPORTED_FILTERS);
                                }
                                
                                timelineConfig.addWarning(warning);
                            }
                        }
                        
                        if (hasMask)
                        {
                            maskID = this._bytes.readUnsignedInt() + "";
                        }
                        else
                        {
                            maskID = "";
                        }
                        
                        instance = new CAnimationFrameInstance(stateID + "");
                        instance.update(zIndex, matrix, alpha, maskID, filter);
                        
                        if (maskID != null && filter != null)
                        {
                            timelineConfig.addWarning(WarningConstants.FILTERS_UNDER_MASK);
                        }
                        
                        currentFrame.addInstance(instance);
                    }
                    
                    currentFrame.sortInstances();
                }
                
                if (hasActions)
                {
                    var data : Dynamic;
                    var action : CFrameAction;
                    var count : Int = this._bytes.readUnsignedInt();
                    for (a in 0...count)
                    {
                        action = new CFrameAction();
                        action.type = this._bytes.readUnsignedInt();
                        action.scope = this._bytes.readUTF();
                        
                        var paramsLength : Int = this._bytes.readUnsignedInt();
                        if (paramsLength > 0)
                        {
                            var paramsBA : ByteArray = new ByteArray();
                            paramsBA.endian = Endian.LITTLE_ENDIAN;
                            this._bytes.readBytes(paramsBA, 0, paramsLength);
                            paramsBA.position = 0;
                            
                            while (paramsBA.bytesAvailable > 0)
                            {
                                action.params.push(paramsBA.readUTF());
                            }
                            paramsBA.clear();
                        }
                        
                        if (action.type == CFrameAction.DISPATCH_EVENT 
							&& action.params[0] == CSound.GAF_PLAY_SOUND 
							&& action.params.length > 3)
                        {
                            if (this._ignoreSounds)
                            {
								continue; //do not add sound events if they're ignored
                            }
                            data = haxe.Json.parse(action.params[3]);
                            timelineConfig.addSound(data, frameNumber);
                        }
                        
                        currentFrame.addAction(action);
                    }
                }
                
                timelineConfig.animationConfigFrames.addFrame(currentFrame);
                
                prevFrame = currentFrame;
				
				i++;
            }  //end loop  
            
            missedFrameNumber = prevFrame.frameNumber + 1;
            while (missedFrameNumber <= timelineConfig.framesCount)
            {
                timelineConfig.animationConfigFrames.addFrame(prevFrame.clone(missedFrameNumber));
                missedFrameNumber++;
            }
            
            for (currentFrame in timelineConfig.animationConfigFrames.frames)
            {
                for (instance in currentFrame.instances)
                {
                    if (blurFilters.get(instance.id) != null && instance.filter != null)
                    {
                        blurFilter = instance.filter.getBlurFilter();
                        if ((blurFilter != null) && (blurFilter.resolution == 1))
                        {
                            blurFilter.blurX *= 0.5;
                            blurFilter.blurY *= 0.5;
                            blurFilter.resolution = 0.75;
                        }
                    }
                }
            }
        }  //end condition  
        
        this.delayedReadNextTag();
    }
    
    private function readTextureAtlasConfig(tagID : Int) : Void
    {
        var i : Int;
        var j : Int;
        
        var scale : Float = this._bytes.readFloat();
        if (this._config.scaleValues.indexOf(scale) == -1)
        {
            this._config.scaleValues.push(scale);
        }
        
        var textureAtlas : CTextureAtlasScale = this.getTextureAtlasScale(scale);
        
        /////////////////////
        
        var contentScaleFactor : CTextureAtlasCSF;
        var atlasLength : Int = this._bytes.readByte();
        var atlasID : Int;
        var sourceLength : Int;
        var csf : Float;
        var source : String;
        
        var elements : CTextureAtlasElements = null;
        if (textureAtlas.allContentScaleFactors.length > 0)
        {
            elements = textureAtlas.allContentScaleFactors[0].elements;
        }
        
        if (elements == null)
        {
            elements = new CTextureAtlasElements();
        }
        
        for (i in 0...atlasLength)
        {
            atlasID = this._bytes.readUnsignedInt();
            sourceLength = this._bytes.readByte();
            for (j in 0...sourceLength)
            {
                source = this._bytes.readUTF();
                csf = this._bytes.readFloat();
                
                if (this._config.csfValues.indexOf(csf) == -1)
                {
                    this._config.csfValues.push(csf);
                }
                
                contentScaleFactor = this.getTextureAtlasCSF(scale, csf);
                updateTextureAtlasSources(contentScaleFactor, Std.string(atlasID), source);
                if (contentScaleFactor.elements == null)
                {
                    contentScaleFactor.elements = elements;
                }
            }
        }
        
        /////////////////////
        
        var elementsLength : Int = this._bytes.readUnsignedInt();
        var element : CTextureAtlasElement;
        var hasScale9Grid : Bool;
        var scale9Grid : Rectangle = null;
        var pivot : Point;
        var topLeft : Point;
        var elementScaleX : Float = 0;
        var elementScaleY : Float = 0;
        var elementWidth : Float;
        var elementHeight : Float;
        var elementAtlasID : Int;
        var rotation : Bool = false;
        var linkageName : String = null;
        
        for (i in 0...elementsLength)
        {
            pivot = new Point(this._bytes.readFloat(), this._bytes.readFloat());
            topLeft = new Point(this._bytes.readFloat(), this._bytes.readFloat());
            if (tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS 
			|| tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS2)
            {
                elementScaleX = elementScaleY = this._bytes.readFloat();
            }
            
            elementWidth = this._bytes.readFloat();
            elementHeight = this._bytes.readFloat();
            atlasID = this._bytes.readUnsignedInt();
            elementAtlasID = this._bytes.readUnsignedInt();
            
            if (tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS2 
			|| tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS3)
            {
                hasScale9Grid = this._bytes.readBoolean();
                if (hasScale9Grid)
                {
                    scale9Grid = new Rectangle(
						this._bytes.readFloat(), this._bytes.readFloat(), 
						this._bytes.readFloat(), this._bytes.readFloat());
                }
                else
                {
                    scale9Grid = null;
                }
            }
            
            if (tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS3)
            {
                elementScaleX = this._bytes.readFloat();
                elementScaleY = this._bytes.readFloat();
                rotation = this._bytes.readBoolean();
                linkageName = this._bytes.readUTF();
            }
            
            if (elements.getElement(Std.string(elementAtlasID)) == null)
            {
                element = new CTextureAtlasElement(Std.string(elementAtlasID), Std.string(atlasID));
                element.region = new Rectangle(Std.int(topLeft.x), Std.int(topLeft.y), elementWidth, elementHeight);
                element.pivotMatrix = new Matrix(1 / elementScaleX, 0, 0, 1 / elementScaleY, -pivot.x / elementScaleX, -pivot.y / elementScaleY);
                element.scale9Grid = scale9Grid;
                element.linkage = linkageName;
                element.rotated = rotation;
                elements.addElement(element);
                
                if (element.rotated)
                {
                    sHelperRectangle.setTo(0, 0, elementHeight, elementWidth);
                }
                else
                {
                    sHelperRectangle.setTo(0, 0, elementWidth, elementHeight);
                }
                sHelperMatrix.copyFrom(element.pivotMatrix);
                var invertScale : Float = 1 / scale;
                sHelperMatrix.scale(invertScale, invertScale);
                RectangleUtil.getBounds(sHelperRectangle, sHelperMatrix, sHelperRectangle);
                
                if (this._textureElementSizes.get(Std.string(elementAtlasID)) == null)
                {
                    this._textureElementSizes.set(Std.string(elementAtlasID), sHelperRectangle.clone());
                }
                else
                {
                    this._textureElementSizes.set(Std.string(elementAtlasID), this._textureElementSizes.get(Std.string(elementAtlasID)).union(sHelperRectangle));
                }
            }
        }
    }
    
    private function getTextureAtlasScale(scale : Float) : CTextureAtlasScale
    {
        var textureAtlasScale : CTextureAtlasScale = null;
        var textureAtlasScales : Array<CTextureAtlasScale> = this._config.allTextureAtlases;
        
        var i : Int = 0;
        var l : Int = textureAtlasScales.length;
        while (i < l)
        {
            if (MathUtility.equals(textureAtlasScales[i].scale, scale))
            {
                textureAtlasScale = textureAtlasScales[i];
                break;
            }
            i++;
        }
        
        if (textureAtlasScale == null)
        {
            textureAtlasScale = new CTextureAtlasScale();
            textureAtlasScale.scale = scale;
            textureAtlasScales.push(textureAtlasScale);
        }
        
        return textureAtlasScale;
    }
    
    private function getTextureAtlasCSF(scale : Float, csf : Float) : CTextureAtlasCSF
    {
        var textureAtlasScale : CTextureAtlasScale = this.getTextureAtlasScale(scale);
        var textureAtlasCSF : CTextureAtlasCSF = textureAtlasScale.getTextureAtlasForCSF(csf);
        if (textureAtlasCSF == null)
        {
            textureAtlasCSF = new CTextureAtlasCSF(csf, scale);
            textureAtlasScale.allContentScaleFactors.push(textureAtlasCSF);
        }
        
        return textureAtlasCSF;
    }
    
    private function updateTextureAtlasSources(textureAtlasCSF : CTextureAtlasCSF, atlasID : String, source : String) : Void
    {
        var textureAtlasSource : CTextureAtlasSource = null;
        var textureAtlasSources : Array<CTextureAtlasSource> = textureAtlasCSF.sources;
        var i : Int = 0;
        var l : Int = textureAtlasSources.length;
        while (i < l)
        {
            if (textureAtlasSources[i].id == atlasID)
            {
                textureAtlasSource = textureAtlasSources[i];
                break;
            }
            i++;
        }
        
        if (textureAtlasSource == null)
        {
            textureAtlasSource = new CTextureAtlasSource(atlasID, source);
            textureAtlasSources.push(textureAtlasSource);
        }
    }
    
    private function parseError(message : String) : Void
    {
        if (this.hasEventListener(ErrorEvent.ERROR))
        {
            this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, message));
        }
        else
        {
            throw new Error(message);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    private function get_config() : GAFAssetConfig
    {
        return this._config;
    }
    
    private function get_assetID() : String
    {
        return this._assetID;
    }
    
    private function set_ignoreSounds(ignoreSounds : Bool) : Bool
    {
        this._ignoreSounds = ignoreSounds;
        return ignoreSounds;
    }
    
    //--------------------------------------------------------------------------
    //
    //  STATIC METHODS
    //
    //--------------------------------------------------------------------------
    
    private static function readStageConfig(tagContent : ByteArray, config : GAFAssetConfig) : Void
    {
        var stageConfig : CStage = new CStage();
        
        stageConfig.fps = tagContent.readByte();
        stageConfig.color = tagContent.readInt();
        stageConfig.width = tagContent.readUnsignedShort();
        stageConfig.height = tagContent.readUnsignedShort();
        
        config.stageConfig = stageConfig;
    }
    
    
    
    private static function readDropShadowFilter(source : ByteArray, filter : CFilter) : String
    {
        var color : Array<Float> = readColorValue(source);
        var blurX : Float = source.readFloat();
        var blurY : Float = source.readFloat();
        var angle : Float = source.readFloat();
        var distance : Float = source.readFloat();
        var strength : Float = source.readFloat();
        var inner : Bool = source.readBoolean();
        var knockout : Bool = source.readBoolean();
        
        return filter.addDropShadowFilter(blurX, blurY, Std.int(color[1]), color[0], angle, distance, strength, inner, knockout);
    }
    
    private static function readBlurFilter(source : ByteArray, filter : CFilter) : String
    {
        return filter.addBlurFilter(source.readFloat(), source.readFloat());
    }
    
    private static function readGlowFilter(source : ByteArray, filter : CFilter) : String
    {
        var color : Array<Float> = readColorValue(source);
        var blurX : Float = source.readFloat();
        var blurY : Float = source.readFloat();
        var strength : Float = source.readFloat();
        var inner : Bool = source.readBoolean();
        var knockout : Bool = source.readBoolean();
        
        return filter.addGlowFilter(blurX, blurY, Std.int(color[1]), color[0], strength, inner, knockout);
    }
    
    private static function readColorMatrixFilter(source : ByteArray, filter : CFilter) : String
    {
        var matrix : Vector<Float> = new Vector<Float>();
        for (i in 0...20)
        {
            matrix[i] = source.readFloat();
        }
        
        return filter.addColorMatrixFilter(matrix);
    }
    
    private static function readColorValue(source : ByteArray) : Array<Float>
    {
        var argbValue : Int = source.readUnsignedInt();
        var alpha : Float = Std.int(((argbValue >> 24) & 0xFF) * 100 / 255) / 100;
        var color : Int = argbValue & 0xFFFFFF;
        
        return [alpha, color];
    }
    
    private static function readAnimationMasks(tagID : Int, tagContent : ByteArray, timelineConfig : GAFTimelineConfig) : Void
    {
        var length : Int = tagContent.readUnsignedInt();
        var objectID : Int;
        var regionID : Int;
        var type : String;
        
        for (i in 0...length)
        {
            objectID = tagContent.readUnsignedInt();
            regionID = tagContent.readUnsignedInt();
            if (tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS)
            {
                type = CAnimationObject.TYPE_TEXTURE;
            }
            else // BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS2
            {
                type = getAnimationObjectTypeString(tagContent.readUnsignedShort());
            }
            timelineConfig.animationObjects.addAnimationObject(new CAnimationObject(objectID + "", regionID + "", type, true));
        }
    }
    
    private static function getAnimationObjectTypeString(type : Int) : String
    {
        var typeString : String = CAnimationObject.TYPE_TEXTURE;
        switch (type)
        {
            case 0:
                typeString = CAnimationObject.TYPE_TEXTURE;
            case 1:
                typeString = CAnimationObject.TYPE_TEXTFIELD;
            case 2:
                typeString = CAnimationObject.TYPE_TIMELINE;
        }
        
        return typeString;
    }
    
    private static function readAnimationObjects(tagID : Int, tagContent : ByteArray, timelineConfig : GAFTimelineConfig) : Void
    {
        var length : Int = tagContent.readUnsignedInt();
        var objectID : Int;
        var regionID : Int;
        var type : String;
        
        for (i in 0...length)
        {
            objectID = tagContent.readUnsignedInt();
            regionID = tagContent.readUnsignedInt();
            if (tagID == BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_OBJECTS)
            {
                type = CAnimationObject.TYPE_TEXTURE;
            }
            else
            {
                type = getAnimationObjectTypeString(tagContent.readUnsignedShort());
            }
            timelineConfig.animationObjects.addAnimationObject(new CAnimationObject(objectID + "", regionID + "", type, false));
        }
    }
    
    private static function readAnimationSequences(tagContent : ByteArray, timelineConfig : GAFTimelineConfig) : Void
    {
        var length : Int = tagContent.readUnsignedInt();
        var sequenceID : String;
        var startFrameNo : Int;
        var endFrameNo : Int;
        
        for (i in 0...length)
        {
            sequenceID = tagContent.readUTF();
            startFrameNo = tagContent.readShort();
            endFrameNo = tagContent.readShort();
            timelineConfig.animationSequences.addSequence(new CAnimationSequence(sequenceID, startFrameNo, endFrameNo));
        }
    }
    
    private static function readNamedParts(tagContent : ByteArray, timelineConfig : GAFTimelineConfig) : Void
    {
        timelineConfig.namedParts = new Map();
        
        var length : Int = tagContent.readUnsignedInt();
        var partID : Int;
        for (i in 0...length)
        {
            partID = tagContent.readUnsignedInt();
            timelineConfig.namedParts.set(Std.string(partID), tagContent.readUTF());
        }
    }
    
    private static function readTextFields(tagContent : ByteArray, timelineConfig : GAFTimelineConfig) : Void
    {
        var length : Int = tagContent.readUnsignedInt();
        var pivotX : Float;
        var pivotY : Float;
        var textFieldID : Int;
        var width : Float;
        var height : Float;
        var text : String;
        var embedFonts : Bool;
        var multiline : Bool;
        var wordWrap : Bool;
        var restrict : String = "";
        var editable : Bool;
        var selectable : Bool;
        var displayAsPassword : Bool;
        var maxChars : Int;
        
        var textFormat : TextFormat;
        
        for (i in 0...length)
        {
            textFieldID = tagContent.readUnsignedInt();
            pivotX = tagContent.readFloat();
            pivotY = tagContent.readFloat();
            width = tagContent.readFloat();
            height = tagContent.readFloat();
            
            text = tagContent.readUTF();
            
            embedFonts = tagContent.readBoolean();
            multiline = tagContent.readBoolean();
            wordWrap = tagContent.readBoolean();
            
            var hasRestrict : Bool = tagContent.readBoolean();
            if (hasRestrict)
            {
                restrict = tagContent.readUTF();
            }
            
            editable = tagContent.readBoolean();
            selectable = tagContent.readBoolean();
            displayAsPassword = tagContent.readBoolean();
            maxChars = tagContent.readUnsignedInt();
            
            // read textFormat
            var alignFlag : Int = tagContent.readUnsignedInt();
            var align : String = "";
            switch (alignFlag)
            {
                case 0:
                    align = TextFormatAlign.LEFT;
                case 1:
                    align = TextFormatAlign.RIGHT;
                case 2:
                    align = TextFormatAlign.CENTER;
                case 3:
                    align = TextFormatAlign.JUSTIFY;
                case 4:
                    align = TextFormatAlign.START;
                case 5:
                    align = TextFormatAlign.END;
            }
            
            var blockIndent : Int = tagContent.readUnsignedInt();
            var bold : Bool = tagContent.readBoolean();
            var bullet : Bool = tagContent.readBoolean();
            var color : Int = tagContent.readUnsignedInt();
            
            var font : String = tagContent.readUTF();
            var indent : Int = tagContent.readUnsignedInt();
            var italic : Bool = tagContent.readBoolean();
            var kerning : Bool = tagContent.readBoolean();
            var leading : Int = tagContent.readUnsignedInt();
            var leftMargin : Int = tagContent.readUnsignedInt();
            var letterSpacing : Float = tagContent.readFloat();
            var rightMargin : Int = tagContent.readUnsignedInt();
            var size : Int = tagContent.readUnsignedInt();
            
            var l : Int = tagContent.readUnsignedInt();
            var tabStops : Array<Int> = [];
            for (j in 0...l)
            {
                tabStops.push(tagContent.readUnsignedInt());
            }
            
            var target : String = tagContent.readUTF();
            var underline : Bool = tagContent.readBoolean();
            var url : String = tagContent.readUTF();
            
            /* var display: String = tagContent.readUTF();*/
            
            textFormat = new TextFormat(font, size, color, bold, italic, underline, url, target, align, leftMargin, 
										rightMargin, blockIndent, leading);
            textFormat.bullet = bullet;
            textFormat.kerning = kerning;
            //textFormat.display = display;
            textFormat.letterSpacing = letterSpacing;
            textFormat.tabStops = tabStops;
            textFormat.indent = indent;
            
            var textFieldObject : CTextFieldObject = new CTextFieldObject(Std.string(textFieldID), text, textFormat, 
																			width, height);
            textFieldObject.pivotPoint.x = -pivotX;
            textFieldObject.pivotPoint.y = -pivotY;
            textFieldObject.embedFonts = embedFonts;
            textFieldObject.multiline = multiline;
            textFieldObject.wordWrap = wordWrap;
            textFieldObject.restrict = restrict;
            textFieldObject.editable = editable;
            textFieldObject.selectable = selectable;
            textFieldObject.displayAsPassword = displayAsPassword;
            textFieldObject.maxChars = maxChars;
            timelineConfig.textFields.addTextFieldObject(textFieldObject);
        }
    }
    
    private static function readSounds(bytes : ByteArray, config : GAFAssetConfig) : Void
    {
        var soundData : CSound;
        var count : Int = bytes.readShort();
        for (i in 0...count)
        {
            soundData = new CSound();
            soundData.soundID = bytes.readShort();
            soundData.linkageName = bytes.readUTF();
            soundData.source = bytes.readUTF();
            soundData.format = bytes.readByte();
            soundData.rate = bytes.readByte();
            soundData.sampleSize = bytes.readByte();
            soundData.stereo = bytes.readBoolean();
            soundData.sampleCount = bytes.readUnsignedInt();
            config.addSound(soundData);
        }
    }
    
    private function set_defaultScale(defaultScale : Null<Float>) : Null<Float>
    {
        _defaultScale = defaultScale;
        return defaultScale;
    }
    
    private function set_defaultCSF(csf : Null<Float>) : Null<Float>
    {
        _defaultContentScaleFactor = csf;
        return csf;
    }
}
