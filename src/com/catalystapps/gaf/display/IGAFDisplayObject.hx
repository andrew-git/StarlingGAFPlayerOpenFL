package com.catalystapps.gaf.display;

import com.catalystapps.gaf.data.config.CFilter;
import starling.display.DisplayObjectContainer;
import flash.geom.Matrix;

/**
	 * @private
	 */
interface IGAFDisplayObject
{
    
    var alpha(get, set) : Float;    
    
    var parent(get, never) : DisplayObjectContainer;    
    
    
    //		function get smoothing(): String;
    //		function set smoothing(value: String): void;
    
    var visible(get, set) : Bool;    
    
    
    var transformationMatrix(get, set) : Matrix;    
    
    var pivotMatrix(get, never) : Matrix;    
    
    
    var name(get, set) : String;

    function setFilterConfig(value : CFilter, scale : Float = 1) : Void;
    function invalidateOrientation() : Void;
    function dispose() : Void;
}

