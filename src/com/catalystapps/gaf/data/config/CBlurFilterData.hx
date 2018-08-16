package com.catalystapps.gaf.data.config;


/**
	 * @private
	 */
class CBlurFilterData implements ICFilterData
{
    public var blurX : Float;
    public var blurY : Float;
    public var color : Int;
    public var angle : Float = 0;
    public var distance : Float = 0;
    public var strength : Float = 0;
    public var alpha : Float = 1;
    public var inner : Bool;
    public var knockout : Bool;
    public var resolution : Float = 1;
    
    public function clone() : ICFilterData
    {
        var copy : CBlurFilterData = new CBlurFilterData();
        
        copy.blurX = this.blurX;
        copy.blurY = this.blurY;
        copy.color = this.color;
        copy.angle = this.angle;
        copy.distance = this.distance;
        copy.strength = this.strength;
        copy.alpha = this.alpha;
        copy.inner = this.inner;
        copy.knockout = this.knockout;
        copy.resolution = this.resolution;
        
        return copy;
    }

    public function new()
    {
    }
}
