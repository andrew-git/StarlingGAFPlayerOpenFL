/**
 * Created by Roman Lipovskiy on 26.01.2017.
 */
package com.catalystapps.gaf.filter;

import com.catalystapps.gaf.data.config.CBlurFilterData;
import com.catalystapps.gaf.data.config.CColorMatrixFilterData;
import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.ICFilterData;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.filters.DropShadowFilter;
import starling.filters.FilterChain;
import starling.filters.FragmentFilter;
import starling.filters.GlowFilter;


class GAFFilterChain extends FilterChain
{
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC VARIABLES
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE VARIABLES
    //
    //--------------------------------------------------------------------------
    private var _filterData : CFilter = null;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    public function new(args:Array<FragmentFilter> = null)
    {
		if (args == null) args = [];
		
        super(args);
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    public function setFilterData(filterData : CFilter) : Void
    {
        _filterData = filterData;
        
        createFiltersChain();
    }
	
	public function setFilterDataSimulateNative(filterData : CFilter) : Void
    {
        _filterData = filterData;
        
        createFiltersChainSimulateNative();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    private function createFiltersChain() : Void
    {
        var currentFilterConfig : ICFilterData;
        
        var blurFilter : BlurFilter;
        var dropShadowFilter : DropShadowFilter;
        var colorMatrixFilter : ColorMatrixFilter;
        
        for (i in 0 ... _filterData.filterConfigs.length)
        {
            currentFilterConfig = _filterData.filterConfigs[i];
            
            if (Std.is(currentFilterConfig, CBlurFilterData))
            {
				var blurFilterData : CBlurFilterData = cast(currentFilterConfig, CBlurFilterData);
                if (blurFilterData.distance != 0)
                {
                    dropShadowFilter = new DropShadowFilter();
                    dropShadowFilter.distance = blurFilterData.distance;
                    dropShadowFilter.angle = blurFilterData.angle;
                    dropShadowFilter.color = blurFilterData.color;
                    dropShadowFilter.alpha = blurFilterData.strength;
                    dropShadowFilter.blur = blurFilterData.blurX;
                    
                    addFilter(dropShadowFilter);
                }
                else
                {
                    blurFilter = new BlurFilter();
                    blurFilter.blurX = blurFilterData.blurX;
                    blurFilter.blurY = blurFilterData.blurY;
                    
                    addFilter(blurFilter);
                }
            }
            else if (Std.is(currentFilterConfig, CColorMatrixFilterData))
            {
                colorMatrixFilter = new ColorMatrixFilter();
                colorMatrixFilter.matrix = cast(currentFilterConfig, CColorMatrixFilterData).matrix;
                
                addFilter(colorMatrixFilter);
            }
        }
    }
	
	private function createFiltersChainSimulateNative() : Void
    {
        var currentFilterConfig : ICFilterData;
        
        var blurFilter : BlurFilter;
        var glowFilter : GlowFilter;
        var dropShadowFilter : DropShadowFilter;
        var colorMatrixFilter : ColorMatrixFilter;
        
        for (i in 0 ... _filterData.filterConfigs.length)
        {
            currentFilterConfig = _filterData.filterConfigs[i];
            
            if (Std.is(currentFilterConfig, CBlurFilterData))
            {
				var blurFilterData : CBlurFilterData = cast(currentFilterConfig, CBlurFilterData);
				if (blurFilterData.angle != 0) // DropShadowFilter
				{
					dropShadowFilter = new DropShadowFilter(
							blurFilterData.distance, 
							blurFilterData.angle, 
							blurFilterData.color, 
							blurFilterData.strength, 
							blurFilterData.blurX,
							1.0);
							
					addFilter(dropShadowFilter);
				}
				else if (blurFilterData.color >= 0) // GlowFilter
				{
					glowFilter = new GlowFilter(
							blurFilterData.color, 
							blurFilterData.strength,
							blurFilterData.blurX / blurFilterData.strength,
							1.0);
							
					addFilter(glowFilter);
				}
				else // BlurFilter
				{
					blurFilter = new BlurFilter(
							blurFilterData.blurX, 
							blurFilterData.blurY); 
					blurFilter.quality = 1.0;
					
					addFilter(blurFilter);
				}
            }
            else if (Std.is(currentFilterConfig, CColorMatrixFilterData))
            {
                colorMatrixFilter = new ColorMatrixFilter();
                colorMatrixFilter.matrix = cast(currentFilterConfig, CColorMatrixFilterData).matrix;
                
                addFilter(colorMatrixFilter);
            }
        }
    }
	
	
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    override public function dispose() : Void
    {
        super.dispose();
    }
}
