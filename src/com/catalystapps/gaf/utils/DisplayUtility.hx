package com.catalystapps.gaf.utils;

import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.geom.Rectangle;

/** @private */
class DisplayUtility
{
    public static function getBoundsWithFilters(maxRect : Rectangle, filters : Array<BitmapFilter>) : Rectangle
    {
        var filtersLen : Int = filters.length;
        if (filtersLen > 0)
        {
            var filterMinX : Float = 0;
            var filterMinY : Float = 0;
            var filterGeneratorRect : Rectangle = new Rectangle(0, 0, maxRect.width, maxRect.height);
            var bitmapData : BitmapData;
			var filterRect : Rectangle;
			
            for (i in 0...filtersLen)
			{
				//bitmapData = new BitmapData(filterGeneratorRect.width, filterGeneratorRect.height, true, 0x00000000);
                bitmapData = new BitmapData(1, 1, false, 0x00000000);
                var filter : BitmapFilter = filters[i];
                filterRect = bitmapData.generateFilterRect(filterGeneratorRect, filter);
                filterRect.width += filterGeneratorRect.width - 1;
                filterRect.height += filterGeneratorRect.height - 1;
                
                filterMinX += filterRect.x;
                filterMinY += filterRect.y;
                
                filterGeneratorRect = filterRect.clone();
                filterGeneratorRect.x = 0;
                filterGeneratorRect.y = 0;
                
                bitmapData.dispose();
            }
            // Reposition filterRect back to global coordinates
            filterRect.x = maxRect.x + filterMinX;
            filterRect.y = maxRect.y + filterMinY;
            
            maxRect = filterRect.clone();
        }
        
        return maxRect;
    }
}
