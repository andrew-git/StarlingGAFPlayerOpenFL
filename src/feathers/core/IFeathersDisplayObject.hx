/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Stage;
import starling.filters.FragmentFilter;
import starling.rendering.Painter;

/**
 * Public properties and functions from <code>starling.display.DisplayObject</code>
 * in helpful interface form.
 *
 * <p>Never cast an object to this type. Cast to <code>DisplayObject</code>
 * instead. This interface exists only to support easier code hinting for
 * interfaces.</p>
 *
 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html Full description of starling.display.DisplayObject in Gamua's Starling Framework API Reference
 *
 * @productversion Feathers 1.1.0
 */
interface IFeathersDisplayObject extends IFeathersEventDispatcher
{
    /**
	 * @private
	 */
    
    /**
	 * The x, or horizontal, position of the display object in the parent's
	 * coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#x Full description of starling.display.DisplayObject.x in Gamua's Starling Framework API Reference
	 */
    var x(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The y, or vertical, position of the display object in the parent's
	 * coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#y Full description of starling.display.DisplayObject.y in Gamua's Starling Framework API Reference
	 */
    var y(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The width of the display object in the parent's coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#width Full description of starling.display.DisplayObject.width in Gamua's Starling Framework API Reference
	 */
    var width(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The height of the display object in the parent's coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#height Full description of starling.display.DisplayObject.height in Gamua's Starling Framework API Reference
	 */
    var height(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The x coordinate of the display object's origin in its own coordinate
	 * space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#pivotX Full description of starling.display.DisplayObject.pivotX in Gamua's Starling Framework API Reference
	 */
    var pivotX(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The y coordinate of the display object's origin in its own coordinate
	 * space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#pivotY Full description of starling.display.DisplayObject.pivotY in Gamua's Starling Framework API Reference
	 */
    var pivotY(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * This horizontal scale factor.
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#scaleX Full description of starling.display.DisplayObject.scaleX in Gamua's Starling Framework API Reference
	 */
    var scaleX(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The vertical scale factor.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#scaleY Full description of starling.display.DisplayObject.scaleY in Gamua's Starling Framework API Reference
	 */
    var scaleY(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The horizontal skew, in radians.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#skewX Full description of starling.display.DisplayObject.skewX in Gamua's Starling Framework API Reference
	 */
    var skewX(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The vertical skew, in radians.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#skewY Full description of starling.display.DisplayObject.skewY in Gamua's Starling Framework API Reference
	 */
    var skewY(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The blend mode used when rendering the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#blendMode Full description of starling.display.DisplayObject.blendMode in Gamua's Starling Framework API Reference
	 */
    var blendMode(get, set) : String;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The name of the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#name Full description of starling.display.DisplayObject.name in Gamua's Starling Framework API Reference
	 */
    var name(get, set) : String;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * Determines if the display object may be touched.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#touchable Full description of starling.display.DisplayObject.touchable in Gamua's Starling Framework API Reference
	 */
    var touchable(get, set) : Bool;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * Determines the visibility of the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#visible Full description of starling.display.DisplayObject.visible in Gamua's Starling Framework API Reference
	 */
    var visible(get, set) : Bool;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The opacity of the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#alpha Full description of starling.display.DisplayObject.alpha in Gamua's Starling Framework API Reference
	 */
    var alpha(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The rotation of the display object, in radians.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#rotation Full description of starling.display.DisplayObject.rotation in Gamua's Starling Framework API Reference
	 */
    var rotation(get, set) : Float;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The display object's mask.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#mask Full description of starling.display.DisplayObject.mask in Gamua's Starling Framework API Reference
	 */
    var mask(get, set) : DisplayObject;    
    
    /**
	 * The display object's parent, or <code>null</code> if it doesn't have
	 * a parent.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#parent Full description of starling.display.DisplayObject.parent in Gamua's Starling Framework API Reference
	 */
    var parent(get, never) : DisplayObjectContainer;    
    
    /**
	 * The top-most object of the display tree that the display object is
	 * connected to.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#base Full description of starling.display.DisplayObject.base in Gamua's Starling Framework API Reference
	 */
    var base(get, never) : DisplayObject;    
    
    /**
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#root Full description of starling.display.DisplayObject.root in Gamua's Starling Framework API Reference
	 */
    var root(get, never) : DisplayObject;    
    
    /**
	 * The stage that the display object is connected to, or <code>null</code>
	 * if it is not connected to a stage.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#stage Full description of starling.display.DisplayObject.stage in Gamua's Starling Framework API Reference
	 */
    var stage(get, never) : Stage;    
    
    /**
	 * The transformation matrix of the display object, relative to its
	 * parent.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#transformationMatrix Full description of starling.display.DisplayObject.transformationMatrix in Gamua's Starling Framework API Reference
	 */
    var transformationMatrix(get, never) : Matrix;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * Determines if the mouse cursor should turn into a hand when the mouse
	 * is over the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#useHandCursor Full description of starling.display.DisplayObject.useHandCursor in Gamua's Starling Framework API Reference
	 */
    var useHandCursor(get, set) : Bool;    
    
    /**
	 * The bounds of the display object in its local coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#bounds Full description of starling.display.DisplayObject.bounds in Gamua's Starling Framework API Reference
	 */
    var bounds(get, never) : Rectangle;    
    
    /**
	 * @private
	 */
    
    
    /**
	 * The filter used when rendering the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#filter Full description of starling.display.DisplayObject.filter in Gamua's Starling Framework API Reference
	 */
    var filter(get, set) : FragmentFilter;

    
    /**
	 * Removes a display object from its parent.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#removeFromParent() Full description of starling.display.DisplayObject.removeFromParent() in Gamua's Starling Framework API Reference
	 */
    function removeFromParent(dispose : Bool = false) : Void;
    
    /**
	 * Determines if a point exists within the display object's bounds.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#hitTest() Full description of starling.display.DisplayObject.hitTest() in Gamua's Starling Framework API Reference
	 */
    function hitTest(localPoint : Point) : DisplayObject;
    
    /**
	 * Converts a point from the display object's coordinate space to the
	 * stage's coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#localToGlobal() Full description of starling.display.DisplayObject.localToGlobal() in Gamua's Starling Framework API Reference
	 */
    function localToGlobal(localPoint : Point, resultPoint : Point = null) : Point;
    
    /**
	 * Converts a point from the stage's coordinate space to the display
	 * object's coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#globalToLocal() Full description of starling.display.DisplayObject.globalToLocal() in Gamua's Starling Framework API Reference
	 */
    function globalToLocal(globalPoint : Point, resultPoint : Point = null) : Point;
    
    /**
	 * Calculates a transformation matrix to convert values from the display
	 * object's coordinate space to a target coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#getTransformationMatrix() Full description of starling.display.DisplayObject.getTransformationMatrix() in Gamua's Starling Framework API Reference
	 */
    function getTransformationMatrix(targetSpace : DisplayObject, resultMatrix : Matrix = null) : Matrix;
    
    /**
	 * Gets the display object's bounds in the target coordinate space.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#getBounds() Full description of starling.display.DisplayObject.getBounds() in Gamua's Starling Framework API Reference
	 */
    function getBounds(targetSpace : DisplayObject, resultRect : Rectangle = null) : Rectangle;
    
    /**
	 * Renders the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#render() Full description of starling.display.DisplayObject.render() in Gamua's Starling Framework API Reference
	 */
    function render(painter : Painter) : Void;
    
    /**
	 * Disposes the display object.
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() Full description of starling.display.DisplayObject.dispose() in Gamua's Starling Framework API Reference
	 */
    function dispose() : Void;
}

