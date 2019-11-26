/**
 * Created by Nazar on 12.01.2016.
 */
package com.catalystapps.gaf.data.tagfx;

import flash.events.IEventDispatcher;
import flash.geom.Point;
import starling.textures.Texture;

/**
 * @private
 */
interface ITAGFX extends IEventDispatcher
{
    
    var texture(get, never) : Texture;    
    var textureSize(get, never) : Point;    
    var textureScale(get, never) : Float;    
    var textureFormat(get, never) : String;    
    var sourceType(get, never) : String;    
    var source(get, never) : Dynamic;    
    var ready(get, never) : Bool;

}
