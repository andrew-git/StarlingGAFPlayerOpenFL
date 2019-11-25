/**
 * Created by Nazar on 12.01.2016.
 */
package com.catalystapps.gaf.data.tagfx;

import com.catalystapps.gaf.data.*;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.errors.Error;
import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;

/**
 * @private
 */
class TAGFXSourcePNGURL extends TAGFXBase
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
    
    private var _pngLoader : Loader;
    private var _pngIsLoading : Bool = false;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(source : String, textureSize : Point, format : String = "bgra")
    {
        super();
        
        this._source = source;
        this._textureSize = textureSize;
        this._textureFormat = format;
        
        this._pngLoader = new Loader();
        this._pngLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onPNGLoadComplete);
        this._pngLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onPNGLoadError);
        this._pngLoader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onPNGLoadAsyncError);
        this._pngLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onPNGLoadSecurityError);
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
    
    private function loadBitmapData(url : String) : Void
    {
        if (this._pngIsLoading)
        {
            try
            {
                this._pngLoader.close();
            }
            catch (e : Dynamic)
            {
				
            }
        }
        
        this._pngLoader.load(new URLRequest(url), new LoaderContext());
        this._pngIsLoading = true;
    }
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    
    override private function get_sourceType() : String
    {
        return TAGFXBase.SOURCE_TYPE_PNG_URL;
    }
    
    override private function get_texture() : Texture
    {
        if (this._texture == null)
        {
            this._texture = Texture.empty(
                            this._textureSize.x / this._textureScale, this._textureSize.y / this._textureScale, 
                            true, GAF.useMipMaps, false, this._textureScale, this._textureFormat, false);
            this._texture.root.onRestore = function(concreteTexture : ConcreteTexture) : Void
			{
				_isReady = false;
				loadBitmapData(_source);
			};
            
            loadBitmapData(this._source);
        }
        
        return this._texture;
    }
    
    //--------------------------------------------------------------------------
    //
    //  EVENT HANDLERS
    //
    //--------------------------------------------------------------------------
    
    private function onPNGLoadComplete(event : Event) : Void
    {
        this._pngIsLoading = false;
        
        var info : LoaderInfo = cast(event.currentTarget, LoaderInfo);
        var bmpd : BitmapData = cast((info.content), Bitmap).bitmapData;
        this._texture.root.uploadBitmapData(bmpd);
        
        this._pngLoader.unload();
        bmpd.dispose();
        
        this.onTextureReady(this._texture);
    }
    
    private function onPNGLoadError(event : IOErrorEvent) : Void
    {
        this._pngIsLoading = false;
        
        var info : LoaderInfo = cast(event.currentTarget, LoaderInfo);
        throw new Error("Can't restore lost context from a PNG file. Can't load file: " + info.url, event.errorID);
    }
    
    private function onPNGLoadAsyncError(event : AsyncErrorEvent) : Void
    {
        this._pngIsLoading = false;
        
        var info : LoaderInfo = cast(event.currentTarget, LoaderInfo);
        throw new Error("Can't restore lost context from a PNG file. Can't load file: " + info.url, event.errorID);
    }
    
    private function onPNGLoadSecurityError(event : SecurityErrorEvent) : Void
    {
        this._pngIsLoading = false;
        
        var info : LoaderInfo = cast(event.currentTarget, LoaderInfo);
        throw new Error("Can't restore lost context from a PNG file. Can't load file: " + info.url, event.errorID);
    }
}
