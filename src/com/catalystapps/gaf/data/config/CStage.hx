package com.catalystapps.gaf.data.config;


/**
 * @private
 */
class CStage
{
    public var fps : Int = 0;
    public var color : Int = 0;
    public var width : Int = 0;
    public var height : Int = 0;
    
    //public function clone(source : Dynamic) : CStage
    public function clone(source : {fps : Int, color : Int, width : Int, height : Int}) : CStage
    {
        fps = source.fps;
        color = source.color;
        width = source.width;
        height = source.height;
        
        return this;
    }

    public function new()
    {
    }
}
