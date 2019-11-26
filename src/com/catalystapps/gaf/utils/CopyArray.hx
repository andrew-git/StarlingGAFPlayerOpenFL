package com.catalystapps.gaf.utils;


/**
 * Class for copyArray
 */
@:final class ClassForCopyArray
{
    /**
	 * @private
	 */
    public function copyArray<T>(from : Array<T>, to : Array<T>) : Void
    {
        var l : Int = from.length;
        
        for (i in 0 ... l)
        {
            to[i] = from[i];
        }
    }

    public function new()
    {
    }
}
