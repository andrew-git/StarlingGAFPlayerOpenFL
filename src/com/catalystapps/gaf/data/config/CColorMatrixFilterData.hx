package com.catalystapps.gaf.data.config;

import com.catalystapps.gaf.utils.VectorUtility;
import openfl.Vector;

/**
 * @private
 */
class CColorMatrixFilterData implements ICFilterData
{
    public var matrix : Vector<Float> = new Vector<Float>(20, true);
    
    public function clone() : ICFilterData
    {
        var copy : CColorMatrixFilterData = new CColorMatrixFilterData();
        
        VectorUtility.copyMatrix(copy.matrix, this.matrix);
        
        return copy;
    }

    public function new()
    {
    }
}
