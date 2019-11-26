/**
 * Created by Nazar on 13.01.2016.
 */
package com.catalystapps.gaf.data.tagfx;

import com.catalystapps.gaf.data.*;
import flash.errors.Error;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;


/**
 * @private
 */
class TAGFXSourceATFURL extends TAGFXBase
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
    
    private var _numTextures : Int = 0;
    private var _isCubeMap : Bool = false;
    
    private var _atfLoader : ATFLoader = null;
    private var _atfIsLoading : Bool = false;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(source : String, atfData : GAFATFData)
    {
        super();
        
        this._source = source;
        this._textureFormat = atfData.format;
        this._numTextures = atfData.numTextures;
        this._isCubeMap = atfData.isCubeMap;
        
        this.textureSize = new Point(atfData.width, atfData.height);
        
        this._atfLoader = new ATFLoader();
        this._atfLoader.dataFormat = URLLoaderDataFormat.BINARY;
        
        this._atfLoader.addEventListener(Event.COMPLETE, this.onATFLoadComplete);
        this._atfLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onATFLoadIOError);
        this._atfLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onATFLoadSecurityError);
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
    
    private function loadATFData(url : String) : Void
    {
        if (this._atfIsLoading)
        {
            try
            {
                this._atfLoader.close();
            }
            catch (e : Error)
            {
            }
        }
        
        this._atfLoader.load(new URLRequest(url));
        this._atfIsLoading = true;
    }
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    
    override private function get_sourceType() : String
    {
        return TAGFXBase.SOURCE_TYPE_ATF_URL;
    }
    
    override private function get_texture() : Texture
    {
        if (this._texture == null)
        {
            this._texture = Texture.empty(
                            this._textureSize.x / this._textureScale, this._textureSize.y / this._textureScale, 
                            false, GAF.useMipMaps && this._numTextures > 1, false, 
                            this._textureScale, this._textureFormat, false
                );
            
            this._texture.root.onRestore = function(concreteTexture : ConcreteTexture) : Void
                    {
                        _isReady = false;
                        loadATFData(_source);
                    };
            
            loadATFData(this._source);
        }
        
        return this._texture;
    }
    
    //--------------------------------------------------------------------------
    //
    //  EVENT HANDLERS
    //
    //--------------------------------------------------------------------------
    
    private function onATFLoadComplete(event : Event) : Void
    {
        this._atfIsLoading = false;
        
        var loader : ATFLoader = cast(event.currentTarget, ATFLoader);
        var sourceBA : ByteArray = cast(loader.data, ByteArray);
        this._texture.root.uploadAtfData(sourceBA, 0, 
                function(texture : Texture) : Void
                {
                    sourceBA.clear();
                    onTextureReady(texture);
                }
        );
    }
    
    private function onATFLoadIOError(event : IOErrorEvent) : Void
    {
        this._atfIsLoading = false;
        var loader : ATFLoader = cast(event.currentTarget, ATFLoader);
        throw new Error("Can't restore lost context from a ATF file. Can't load file: " + loader.urlRequest.url, event.errorID);
    }
    
    private function onATFLoadSecurityError(event : SecurityErrorEvent) : Void
    {
        this._atfIsLoading = false;
        var loader : ATFLoader = cast(event.currentTarget, ATFLoader);
        throw new Error("Can't restore lost context from a ATF file. Can't load file: " + loader.urlRequest.url, event.errorID);
    }
}



class ATFLoader extends URLLoader
{
    public var urlRequest(get, never) : URLRequest;

    private var _req : URLRequest = null;
    
    public function new(request : URLRequest = null)
    {
        super(request);
        this._req = request;
    }
    
    override public function load(request : URLRequest) : Void
    {
        this._req = request;
        super.load(request);
    }
    
    private function get_urlRequest() : URLRequest
    {
        return this._req;
    }
}
