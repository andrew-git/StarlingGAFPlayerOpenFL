//Base temporary GAFTextField replacement Feathers TextInput with Sprite and Starling TextField
/**
 * Created by Nazar on 17.03.2014.
 */
package com.catalystapps.gaf.display;

import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.CTextFieldObject;
import com.catalystapps.gaf.filter.GAFFilter;
import com.catalystapps.gaf.utils.DebugUtility;
import flash.errors.ArgumentError;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextFormat;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.VAlign;


/*
import com.catalystapps.gaf.data.GAF;
import feathers.controls.TextInput;
import feathers.controls.text.TextFieldTextEditor;
import feathers.core.ITextEditor;
*/


/**
 * GAFTextField is a text entry control that extends functionality of the <code>feathers.controls.TextInput</code>
 * for the GAF library needs.
 * All dynamic text fields (including input text fields) in GAF library are instances of the GAFTextField.
 */
//class GAFTextFieldDummy extends TextInput implements IGAFDebug implements IMaxSize implements IGAFDisplayObject
class GAFTextField extends Sprite implements IGAFDebug implements IMaxSize implements IGAFDisplayObject
{
    public var debugColors(never, set) : Array<Int>;
    public var pivotMatrix(get, never) : Matrix;
    public var maxSize(get, set) : Point;
    public var textWidth(get, never) : Float;
    public var textHeight(get, never) : Float;

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
    
    private static var HELPER_POINT : Point = new Point();
    private static var HELPER_MATRIX : Matrix = new Matrix();
    
    private var _pivotMatrix : Matrix = null;
    
    private var _filterConfig : CFilter = null;
    private var _filterScale : Float = Math.NaN;
    
    private var _maxSize : Point = null;
    
    private var _pivotChanged : Bool = false;
    private var _scale : Float = Math.NaN;
    private var _csf : Float = Math.NaN;
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private var __debugOriginalAlpha : Float = Math.NaN;
    
    private var _orientationChanged : Bool = false;
    
    private var _config : CTextFieldObject = null;
	
	
	static public var useFlatten : Bool = true;
	static public var useTempTextField : Bool = true;
	private var tempTF : TextField = null;
	
	public var text(never, set) : String;
	public var color(never, set) : Int;
	public var hAlign(get, set):String;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /**
	 * @private
	 * GAFTextField represents text field that is part of the <code>GAFMovieClip</code>
	 * @param config
	 * @param scale
	 * @param csf
	 */
    public function new(config : CTextFieldObject, scale : Float = 1, csf : Float = 1)
    {
        super();
        
        if (Math.isNaN(scale))
        {
            scale = 1;
        }
        if (Math.isNaN(csf))
        {
            csf = 1;
        }
        
        this._scale = scale;
        this._csf = csf;
        
        this._pivotMatrix = new Matrix();
        this._pivotMatrix.tx = config.pivotPoint.x;
        this._pivotMatrix.ty = config.pivotPoint.y;
        this._pivotMatrix.scale(scale, scale);
        
        if (!Math.isNaN(config.width))
        {
            this.width = config.width;
        }
        
        if (!Math.isNaN(config.height))
        {
            this.height = config.height;
        }
        
		
/*
        this.text = config.text;
        this.restrict = config.restrict;
        this.isEditable = config.editable;
        this.isEnabled = this.isEditable || config.selectable;  // editable text must be selectable anyway  
        this.displayAsPassword = config.displayAsPassword;
        this.maxChars = config.maxChars;
		
        this.verticalAlign = TextInput.VERTICAL_ALIGN_TOP;
        
        this.textEditorProperties.textFormat = cloneTextFormat(config.textFormat);
        this.textEditorProperties.embedFonts = (GAF.useDeviceFonts) ? false : config.embedFonts;
        this.textEditorProperties.multiline = config.multiline;
        this.textEditorProperties.wordWrap = config.wordWrap;
        this.textEditorFactory = function() : ITextEditor
		{
			return new GAFTextFieldTextEditor(_scale, _csf);
		};
/*/
		if (useTempTextField)
		{
			tempTF = new TextField(Std.int(config.width), Std.int(config.height), config.text, 
									config.textFormat.font, config.textFormat.size, config.textFormat.color, config.textFormat.bold);
				
			addChild(tempTF);
			
			tempTF.vAlign = VAlign.TOP;
			
			if (starling.utils.HAlign.isValid(config.textFormat.align))
			{
				tempTF.hAlign = config.textFormat.align;
			}
			tempTF.italic = config.textFormat.italic;
			tempTF.leading = config.textFormat.leading;
			tempTF.underline = config.textFormat.underline;
			
			
			if(useFlatten) this.flatten();
		}
//*/
		
        this.invalidateSize();
        
        this._config = config;
    }
	
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS EXTENDED
    //
    //--------------------------------------------------------------------------
	
	function get_hAlign():String 
	{
		if (useTempTextField)
		{
			return tempTF.hAlign;
		}
		
		return null;
	}
	
	
	function set_text(value : String) : String
	{
		if (useTempTextField)
		{
			if(useFlatten) this.unflatten();
			
			tempTF.text = value;
			
			if(useFlatten) this.flatten();
		}
		
		return value;
	}
	
	function set_color(value : Int) : Int
	{
		if (useTempTextField)
		{
			if(useFlatten) this.unflatten();
			
			tempTF.color = value;
			
			if(useFlatten) this.flatten();
		}
		
		return value;
	}
	
    function set_hAlign(value:String):String
    {
		if (useTempTextField)
		{
			if(useFlatten) this.unflatten();
			
			tempTF.hAlign = value;
			
			if(useFlatten) this.flatten();
		}
		
		return value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * Creates a new instance of GAFTextField.
	 */
    public function copy() : GAFTextField
    {
        var clone : GAFTextField = new GAFTextField(this._config, this._scale, this._csf);
        clone.alpha = this.alpha;
        clone.visible = this.visible;
        clone.transformationMatrix = this.transformationMatrix;
/*
        clone.textEditorFactory = this.textEditorFactory;
*/
        clone.setFilterConfig(_filterConfig, _filterScale);
        
        return clone;
    }
    
    /**
	 * @private
	 * We need to update the textField size after the textInput was transformed
	 */
    public function invalidateSize() : Void
    {
/*
        if (this.textEditor != null && Std.is(this.textEditor, TextFieldTextEditor))
        {
            cast(this.textEditor, TextFieldTextEditor).invalidate(INVALIDATION_FLAG_SIZE);
        }
        this.invalidate(INVALIDATION_FLAG_SIZE);
*/
    }
    
    /** @private */
    public function invalidateOrientation() : Void
    {
        this._orientationChanged = true;
    }
    
    /** @private */
    private function set_debugColors(value : Array<Int>) : Array<Int>
    {
        var t : Texture = Texture.fromColor(1, 1, DebugUtility.RENDERING_NEUTRAL_COLOR, true);
        var bgImage : Image = new Image(t);
        var alpha0 : Float;
        var alpha1 : Float;
        
        var _sw6_ = (value.length);        

        switch (_sw6_)
        {
            case 1:
                bgImage.color = value[0];
                bgImage.alpha = (value[0] >>> 24) / 255;
            case 2:
                bgImage.setVertexColor(0, value[0]);
                bgImage.setVertexColor(1, value[0]);
                bgImage.setVertexColor(2, value[1]);
                bgImage.setVertexColor(3, value[1]);
                
                alpha0 = (value[0] >>> 24) / 255;
                alpha1 = (value[1] >>> 24) / 255;
                bgImage.setVertexAlpha(0, alpha0);
                bgImage.setVertexAlpha(1, alpha0);
                bgImage.setVertexAlpha(2, alpha1);
                bgImage.setVertexAlpha(3, alpha1);
            case 3:
                bgImage.setVertexColor(0, value[0]);
                bgImage.setVertexColor(1, value[0]);
                bgImage.setVertexColor(2, value[1]);
                bgImage.setVertexColor(3, value[2]);
                
                alpha0 = (value[0] >>> 24) / 255;
                bgImage.setVertexAlpha(0, alpha0);
                bgImage.setVertexAlpha(1, alpha0);
                bgImage.setVertexAlpha(2, (value[1] >>> 24) / 255);
                bgImage.setVertexAlpha(3, (value[2] >>> 24) / 255);
            case 4:
                bgImage.setVertexColor(0, value[0]);
                bgImage.setVertexColor(1, value[1]);
                bgImage.setVertexColor(2, value[2]);
                bgImage.setVertexColor(3, value[3]);
                
                bgImage.setVertexAlpha(0, (value[0] >>> 24) / 255);
                bgImage.setVertexAlpha(1, (value[1] >>> 24) / 255);
                bgImage.setVertexAlpha(2, (value[2] >>> 24) / 255);
                bgImage.setVertexAlpha(3, (value[3] >>> 24) / 255);
        }
/*      
        this.backgroundSkin = bgImage;
*/
        return value;
    }
    
    /** @private */
    public function setFilterConfig(value : CFilter, scale : Float = 1) : Void
    {
        if (this._filterConfig != value || this._filterScale != scale)
        {
            if (value != null)
            {
                this._filterConfig = value;
                this._filterScale = scale;
            }
            else
            {
                this._filterConfig = null;
                this._filterScale = Math.NaN;
            }
            
            this.applyFilter();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    private function applyFilter() : Void
    {
/*
        if (this.textEditor)
        {
            if (Std.is(this.textEditor, GAFTextFieldTextEditor))
            {
                cast(this.textEditor, GAFTextFieldTextEditor).setFilterConfig(this._filterConfig, this._filterScale);
            }
            else if (this._filterConfig && !Math.isNaN(this._filterScale))
            {
                var gafFilter : GAFFilter;
                if (this.filter)
                {
                    if (Std.is(this.filter, GAFFilter))
                    {
                        gafFilter = cast(this.filter, GAFFilter);
                    }
                    else
                    {
                        this.filter.dispose();
                        gafFilter = new GAFFilter();
                    }
                }
                else
                {
                    gafFilter = new GAFFilter();
                }
                
                gafFilter.setConfig(this._filterConfig, this._filterScale);
                this.filter = gafFilter;
            }
            else if (this.filter)
            {
                this.filter.dispose();
                this.filter = null;
            }
        }
*/
		if (useTempTextField)
		{
			if (tempTF != null)
			{
				if(useFlatten) this.unflatten();
				
				if (this._filterConfig != null && !Math.isNaN(this._filterScale))
				{
					var gafFilter : GAFFilter;
					if (tempTF.filter != null)
					{
						if (Std.is(tempTF.filter, GAFFilter))
						{
							gafFilter = cast(tempTF.filter, GAFFilter);
						}
						else
						{
							tempTF.filter.dispose();
							gafFilter = new GAFFilter();
						}
					}
					else
					{
						gafFilter = new GAFFilter();
					}
					
					gafFilter.setConfig(this._filterConfig, this._filterScale);
					tempTF.filter = gafFilter;
				}
				else if (tempTF.filter != null)
				{
					tempTF.filter.dispose();
					tempTF.filter = null;
				}
				
				if(useFlatten) this.flatten();
			}
		}
    }
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private function __debugHighlight() : Void
    {
        if (Math.isNaN(this.__debugOriginalAlpha))
        {
            this.__debugOriginalAlpha = this.alpha;
        }
        this.alpha = 1;
    }
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private function __debugLowlight() : Void
    {
        if (Math.isNaN(this.__debugOriginalAlpha))
        {
            this.__debugOriginalAlpha = this.alpha;
        }
        this.alpha = .05;
    }
    
    /** @private */
	@:allow(com.catalystapps.gaf)
    private function __debugResetLight() : Void
    {
        if (!Math.isNaN(this.__debugOriginalAlpha))
        {
            this.alpha = this.__debugOriginalAlpha;
            this.__debugOriginalAlpha = Math.NaN;
        }
    }
    
    /** @private */
    @:final inline private function updateTransformMatrix() : Void
    {
        if (this._orientationChanged)
        {
            this.transformationMatrix = this.transformationMatrix;
            this._orientationChanged = false;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
/*
    override private function createTextEditor() : Void
    {
        super.createTextEditor();
        
        this.applyFilter();
    }
*/
    
    /** @private */
    override public function dispose() : Void
    {
        super.dispose();
        this._config = null;
    }
    
    /** @private */
    override private function set_transformationMatrix(matrix : Matrix) : Matrix
    {
        super.transformationMatrix = matrix;
        
        this.invalidateSize();
        return matrix;
    }
    
    /** @private */
    override private function set_pivotX(value : Float) : Float
    {
        this._pivotChanged = true;
        super.pivotX = value;
        return value;
    }
    
    /** @private */
    override private function set_pivotY(value : Float) : Float
    {
        this._pivotChanged = true;
        super.pivotY = value;
        return value;
    }
    
    /** @private */
    override private function get_x() : Float
    {
        updateTransformMatrix();
        return super.x;
    }
    
    /** @private */
    override private function get_y() : Float
    {
        updateTransformMatrix();
        return super.y;
    }
    
    /** @private */
    override private function get_rotation() : Float
    {
        updateTransformMatrix();
        return super.rotation;
    }
    
    /** @private */
    override private function get_scaleX() : Float
    {
        updateTransformMatrix();
        return super.scaleX;
    }
    
    /** @private */
    override private function get_scaleY() : Float
    {
        updateTransformMatrix();
        return super.scaleY;
    }
    
    /** @private */
    override private function get_skewX() : Float
    {
        updateTransformMatrix();
        return super.skewX;
    }
    
    /** @private */
    override private function get_skewY() : Float
    {
        updateTransformMatrix();
        return super.skewY;
    }
    
    //--------------------------------------------------------------------------
    //
    //  EVENT HANDLERS
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  GETTERS AND SETTERS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    private function get_pivotMatrix() : Matrix
    {
        HELPER_MATRIX.copyFrom(this._pivotMatrix);
        
        if (this._pivotChanged)
        {
            HELPER_MATRIX.tx = this.pivotX;
            HELPER_MATRIX.ty = this.pivotY;
        }
        
        return HELPER_MATRIX;
    }
    
    /** @private */
    private function get_maxSize() : Point
    {
        return this._maxSize;
    }
    
    /** @private */
    private function set_maxSize(value : Point) : Point
    {
        this._maxSize = value;
        return value;
    }
    
    /**
	 * The width of the text in pixels.
	 * @return {Number}
	 */
    private function get_textWidth() : Float
    {
/*
        this.validate();
        this.textEditor.measureText(HELPER_POINT);
*/
		
        return HELPER_POINT.x;
    }
    
    /**
	 * The height of the text in pixels.
	 * @return {Number}
	 */
    private function get_textHeight() : Float
    {
/*
        this.validate();
        this.textEditor.measureText(HELPER_POINT);
*/
		
        return HELPER_POINT.y;
    }
    
    //--------------------------------------------------------------------------
    //
    //  STATIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /** @private */
    private function cloneTextFormat(textFormat : TextFormat) : TextFormat
    {
        if (textFormat == null)
        {
            throw new ArgumentError("Argument \"textFormat\" must be not null.");
        }
        
        var result : TextFormat = new TextFormat(
        textFormat.font, 
        textFormat.size, 
        textFormat.color, 
        textFormat.bold, 
        textFormat.italic, 
        textFormat.underline, 
        textFormat.url, 
        textFormat.target, 
        textFormat.align, 
        textFormat.leftMargin, 
        textFormat.rightMargin, 
        textFormat.indent, 
        textFormat.leading);
        
        return result;
    }
}
