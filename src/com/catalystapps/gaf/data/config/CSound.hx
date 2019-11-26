package com.catalystapps.gaf.data.config;

import flash.media.Sound;

/**
 * @author Ivan Avdeenko
 * @private
 */
class CSound
{
    public static inline var GAF_PLAY_SOUND : String = "gafPlaySound";
    public static inline var WAV : Int = 0;
    public static inline var MP3 : Int = 1;
    
    public var soundID : Int = 0;
    public var linkageName : String = null;
    public var source : String = null;
    public var format : Int = 0;
    public var rate : Int = 0;
    public var sampleSize : Int = 0;
    public var sampleCount : Int = 0;
    public var stereo : Bool = false;
    public var sound : Sound = null;

    public function new()
    {
    }
}
