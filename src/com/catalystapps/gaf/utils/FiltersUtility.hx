/**
 * Created by Nazar on 11.03.2015.
 */
package com.catalystapps.gaf.utils;

import com.catalystapps.gaf.data.config.CBlurFilterData;
import com.catalystapps.gaf.data.config.CColorMatrixFilterData;
import com.catalystapps.gaf.data.config.ICFilterData;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;

/**
 * @private
 */
class FiltersUtility
{
    public static function getNativeFilter(data : ICFilterData, scale : Float = 1) : BitmapFilter
    {
        var nativeFilter : BitmapFilter;
        if (Std.is(data, CBlurFilterData))
        {
            var blurFilterData : CBlurFilterData = cast(data, CBlurFilterData);
            if (blurFilterData.angle != 0) // DropShadowFilter
			{
				nativeFilter = new DropShadowFilter(
						blurFilterData.distance * scale, 
						blurFilterData.angle, 
						blurFilterData.color, 
						blurFilterData.alpha, 
						blurFilterData.blurX * scale, 
						blurFilterData.blurY * scale, 
						blurFilterData.strength, 
						BitmapFilterQuality.HIGH, 
						blurFilterData.inner, 
						blurFilterData.knockout);
            }
            else if (blurFilterData.color >= 0) // GlowFilter
			{
				nativeFilter = new GlowFilter(
						blurFilterData.color, 
						blurFilterData.alpha, 
						blurFilterData.blurX * scale, 
						blurFilterData.blurY * scale, 
						blurFilterData.strength, 
						BitmapFilterQuality.HIGH, 
						blurFilterData.inner, 
						blurFilterData.knockout);
            }
            else // BlurFilter
            {
				nativeFilter = new BlurFilter(
						blurFilterData.blurX * scale, 
						blurFilterData.blurY * scale, 
						BitmapFilterQuality.HIGH);
            }
        }
        else //if (data is CColorMatrixFilterData)
        {
            
			var cmFilterData : CColorMatrixFilterData = cast(data, CColorMatrixFilterData);
			nativeFilter = new ColorMatrixFilter([].concat(cmFilterData.matrix));
        }
        
        return nativeFilter;
    }
}
