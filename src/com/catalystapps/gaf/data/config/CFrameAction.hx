package com.catalystapps.gaf.data.config;


/**
	 * @private
	 */
class CFrameAction
{
    public var type : Int;
    public var scope : String;
    public var params : Array<String> = new Array<String>();
    
    public static inline var STOP : Int = 0;
    public static inline var PLAY : Int = 1;
    public static inline var GOTO_AND_STOP : Int = 2;
    public static inline var GOTO_AND_PLAY : Int = 3;
    public static inline var DISPATCH_EVENT : Int = 4;

    public function new()
    {
    }
}

