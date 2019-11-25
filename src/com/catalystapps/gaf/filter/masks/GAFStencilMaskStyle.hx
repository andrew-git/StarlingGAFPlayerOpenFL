/**
 * Created by Roman Lipovskiy on 16.01.2017.
 */
package com.catalystapps.gaf.filter.masks;

import starling.display.Mesh;
import starling.rendering.MeshEffect;
import starling.rendering.VertexDataFormat;
import starling.styles.MeshStyle;


class GAFStencilMaskStyle extends MeshStyle
{
    public var threshold(get, set) : Float;

    public static var VERTEX_FORMAT : VertexDataFormat = MeshStyle.VERTEX_FORMAT.extend("threshold:float1");
    
    private var _threshold : Float;
    
    public function new(threshold : Float = 0.5)
    {
        super();
		
        _threshold = threshold;
    }
    
    override public function copyFrom(meshStyle : MeshStyle) : Void
    {
		if (meshStyle != null && Std.is(meshStyle, GAFStencilMaskStyle))
		{
			var otherStyle : GAFStencilMaskStyle = cast(meshStyle, GAFStencilMaskStyle);
			if (otherStyle != null)
			{
				_threshold = otherStyle._threshold;
			}
		}
        
        super.copyFrom(meshStyle);
    }
    
    override public function createEffect() : MeshEffect
    {
        return new GAFStencilMaskStyleEffect();
    }
    
    override private function get_vertexFormat() : VertexDataFormat
    {
        return VERTEX_FORMAT;
    }
    
    override private function onTargetAssigned(target : Mesh) : Void
    {
        updateVertices();
    }
    
    private function updateVertices() : Void
    {
        var numVertices : Int = vertexData.numVertices;
        for (i in 0 ... numVertices)
        {
            vertexData.setFloat(i, "threshold", _threshold);
        }
        
        setRequiresRedraw();
    }
    
    // properties
    
    private function get_threshold() : Float
    {
        return _threshold;
    }
    
    private function set_threshold(value : Float) : Float
    {
        if (_threshold != value && target != null)
        {
            _threshold = value;
            updateVertices();
        }
        return value;
    }
}
