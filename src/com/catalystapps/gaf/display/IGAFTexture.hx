/**
 * Created by Nazar on 05.03.14.
 */
package com.catalystapps.gaf.display;

import flash.geom.Matrix;
import starling.textures.Texture;

/**
	 * An interface describes objects that contain all data used to initialize static GAF display objects such as <code>GAFImage</code>.
	 */
interface IGAFTexture
{
    
    /**
		 * Returns Starling Texture object.
		 * @return a Starling Texture object
		 */
    var texture(get, never) : Texture;    
    
    /**
		 * Returns pivot matrix of the static GAF display object.
		 * @return a Matrix object
		 */
    var pivotMatrix(get, never) : Matrix;    
    
    /**
		 * An internal identifier of the region in a texture atlas.
		 * @return a String identifier
		 */
    var id(get, never) : String;

    
    /**
		 * Returns a new object that is a clone of this object.
		 * @return object with interface <code>IGAFTexture</code>
		 */
    function clone() : IGAFTexture
    ;
    
    /**
		 * Copies all of the data from the source object into the calling <code>IGAFTexture</code> object
		 * @param newTexture the <code>IGAFTexture</code> object from which to copy the data
		 */
    function copyFrom(newTexture : IGAFTexture) : Void
    ;
}

