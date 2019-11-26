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
    public var soundID : Int = 0;
    public var action : Int = 0;
    public var repeatCount : Int = 0;  //0 and 1 means play sound once
    public var linkage : String = null;
    
    //public function new(data : Dynamic)
    public function new(data : {id : Int, action : Int, ?linkage : String, ?repeat : Int})
    {
        this.soundID = data.id;
        this.action = data.action;
		/*
        if (Lambda.has(data, "linkage"))
        {
            this.linkage = data.linkage;
        }
        if (Lambda.has(data, "repeat"))
        {
            this.repeatCount = data.repeat;
        }
		*/
		if (data.linkage != null)
		{
			this.linkage = data.linkage;
		}
		if (data.repeat != null)
		{
			this.repeatCount = data.repeat;
		}
    }
}
