package com.catalystapps.gaf.utils;


/**
 * Class for copyArray
 */
@:final class ClassForCopyArray
{
    /**
	 * @private
	 */
    public function copyArray(from : Array<Dynamic>, to : Array<Dynamic>) : Void
    {
        var l : Int = from.length;
        
        for (i in 0...l)
        {
            to[i] = from[i];
        }
    }

    public function new()
    {
    }
}
