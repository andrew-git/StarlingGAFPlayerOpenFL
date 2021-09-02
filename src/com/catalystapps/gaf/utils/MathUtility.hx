package com.catalystapps.gaf.utils;


/**
 * @private
 */
class MathUtility
{
    public static inline var epsilon : Float = 0.00001;
    
    public static var PI_Q : Float = Math.PI / 4.0;
    
	@:extern inline
    public static function equals(a : Null<Float>, b : Null<Float>) : Bool
    {
        //if (Math.isNaN(a) || Math.isNaN(b))
        if ((a == null) || (b == null)
		|| Math.isNaN(a) || Math.isNaN(b)
		)
        {
            return false;
        }
		
        return Math.abs(a - b) < epsilon;
    }
    
    public static function getItemIndex(source : Array<Float>, target : Float) : Int
    {
		for (i in 0...source.length) 
		{
            if (equals(source[i], target))
            {
                return i;
            }
        }
        return -1;
    }
	
	//from as3hx
    /**
     * Runtime value of FLOAT_MAX depends on target platform
     */
    public static var FLOAT_MAX(get, never):Float;
    static inline function get_FLOAT_MAX():Float {
        #if flash
        return untyped __global__['Number'].MAX_VALUE;
        #elseif js
			#if !haxe4
				return untyped __js__('Number.MAX_VALUE');
			#else
				return js.Syntax.code('Number.MAX_VALUE');
			#end
        #elseif cs
        return untyped __cs__('double.MaxValue');
        #elseif java
        return untyped __java__('Double.MAX_VALUE');
        #elseif cpp
        //return 1.79769313486232e+308;
        return 1.7976931348623158e+308;
        #elseif python
        return PythonSysAdapter.float_info.max;
        #else
        return 1.79e+308;
        #end
    }
}
