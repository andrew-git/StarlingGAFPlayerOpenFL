package com.catalystapps.gaf.data;

import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * @private
	 */
class GAFDebugInformation
{
    public static inline var TYPE_POINT : Int = 0;
    public static inline var TYPE_RECT : Int = 1;
    
    public var type : Int;
    public var point : Point;
    public var rect : Rectangle;
    public var color : Int;
    public var alpha : Float;

    public function new()
    {
    }
}

