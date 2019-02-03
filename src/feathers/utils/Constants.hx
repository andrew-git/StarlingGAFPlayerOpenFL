package feathers.utils;

/**
 * ...
 * @author andrew (abyss)
 */
class Constants 
{

	
    /**
     * Runtime value of FLOAT_MAX depends on target platform
     */
    public static var FLOAT_MAX(get, never):Float;
    static inline function get_FLOAT_MAX():Float {
        #if flash
        return untyped __global__['Number'].MAX_VALUE;
        #elseif js
        return untyped __js__('Number.MAX_VALUE');
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