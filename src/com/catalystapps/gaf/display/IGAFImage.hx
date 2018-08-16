/**
 * Created by Nazar on 05.03.14.
 */
package com.catalystapps.gaf.display;


/**
	 * @private
	 */
interface IGAFImage extends IGAFDisplayObject
{
    
    var assetTexture(get, never) : IGAFTexture;    
    
    var smoothing(get, set) : String;

}

