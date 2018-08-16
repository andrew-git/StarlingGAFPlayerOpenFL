package com.catalystapps.gaf.data.config;


/**
	 * @author Ivan Avdeenko
	 * @private
	 */
class CFrameSound
{
    public static inline var ACTION_STOP : Int = 1;
    public static inline var ACTION_START : Int = 2;
    public static inline var ACTION_CONTINUE : Int = 3;
    public var soundID : Int;
    public var action : Int;
    public var repeatCount : Int;  //0 and 1 means play sound once  
    public var linkage : String;
    
    public function new(data : Dynamic)
    {
        this.soundID = data.id;
        this.action = data.action;
        if (Lambda.has(data, "linkage"))
        {
            this.linkage = data.linkage;
        }
        if (Lambda.has(data, "repeat"))
        {
            this.repeatCount = data.repeat;
        }
    }
}

