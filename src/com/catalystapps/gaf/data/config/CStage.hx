package com.catalystapps.gaf.data.config;


/**
	 * @private
	 */
class CStage
{
    public var fps : Int;
    public var color : Int;
    public var width : Int;
    public var height : Int;
    
    public function clone(source : Dynamic) : CStage
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

