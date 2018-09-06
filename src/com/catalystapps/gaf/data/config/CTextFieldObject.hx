/**
 * Created by Nazar on 03.03.14.
 */
package com.catalystapps.gaf.data.config;

import flash.geom.Point;
import flash.text.TextFormat;

/**
	 * @private
	 */
class CTextFieldObject
{
    public var id(get, set) : String;
    public var text(get, set) : String;
    public var textFormat(get, set) : TextFormat;
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var embedFonts(get, set) : Bool;
    public var multiline(get, set) : Bool;
    public var wordWrap(get, set) : Bool;
    public var restrict(get, set) : String;
    public var editable(get, set) : Bool;
    public var selectable(get, set) : Bool;
    public var displayAsPassword(get, set) : Bool;
    public var maxChars(get, set) : Int;
    public var pivotPoint(get, set) : Point;

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
    
    private var _id : String;
    private var _width : Float = Math.NaN;
    private var _height : Float = Math.NaN;
    private var _text : String;
    private var _embedFonts : Bool;
    private var _multiline : Bool;
    private var _wordWrap : Bool;
    private var _restrict : String;
    private var _editable : Bool;
    private var _selectable : Bool;
    private var _displayAsPassword : Bool;
    private var _maxChars : Int;
    private var _textFormat : TextFormat;
    private var _pivotPoint : Point;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new(id : String, text : String, textFormat : TextFormat, width : Float,
            height : Float)
    {
        _id = id;
        _text = text;
        _textFormat = textFormat;
        
        _width = width;
        _height = height;
        
        _pivotPoint = new Point();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    //--------------------------------------------------------------------------
    
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
    
    private function get_id() : String
    {
        return this._id;
    }
    
    private function set_id(value : String) : String
    {
        this._id = value;
        return value;
    }
    
    private function get_text() : String
    {
        return this._text;
    }
    
    private function set_text(value : String) : String
    {
        this._text = value;
        return value;
    }
    
    private function get_textFormat() : TextFormat
    {
        return this._textFormat;
    }
    
    private function set_textFormat(value : TextFormat) : TextFormat
    {
        this._textFormat = value;
        return value;
    }
    
    private function get_width() : Float
    {
        return this._width;
    }
    
    private function set_width(value : Float) : Float
    {
        this._width = value;
        return value;
    }
    
    private function get_height() : Float
    {
        return this._height;
    }
    
    private function set_height(value : Float) : Float
    {
        this._height = value;
        return value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  STATIC METHODS
    //
    //--------------------------------------------------------------------------
    
    private function get_embedFonts() : Bool
    {
        return this._embedFonts;
    }
    
    private function set_embedFonts(value : Bool) : Bool
    {
        this._embedFonts = value;
        return value;
    }
    
    private function get_multiline() : Bool
    {
        return this._multiline;
    }
    
    private function set_multiline(value : Bool) : Bool
    {
        this._multiline = value;
        return value;
    }
    
    private function get_wordWrap() : Bool
    {
        return this._wordWrap;
    }
    
    private function set_wordWrap(value : Bool) : Bool
    {
        this._wordWrap = value;
        return value;
    }
    
    private function get_restrict() : String
    {
        return this._restrict;
    }
    
    private function set_restrict(value : String) : String
    {
        this._restrict = value;
        return value;
    }
    
    private function get_editable() : Bool
    {
        return this._editable;
    }
    
    private function set_editable(value : Bool) : Bool
    {
        this._editable = value;
        return value;
    }
    
    private function get_selectable() : Bool
    {
        return this._selectable;
    }
    
    private function set_selectable(value : Bool) : Bool
    {
        this._selectable = value;
        return value;
    }
    
    private function get_displayAsPassword() : Bool
    {
        return this._displayAsPassword;
    }
    
    private function set_displayAsPassword(value : Bool) : Bool
    {
        this._displayAsPassword = value;
        return value;
    }
    
    private function get_maxChars() : Int
    {
        return this._maxChars;
    }
    
    private function set_maxChars(value : Int) : Int
    {
        this._maxChars = value;
        return value;
    }
    
    private function get_pivotPoint() : Point
    {
        return this._pivotPoint;
    }
    
    private function set_pivotPoint(value : Point) : Point
    {
        this._pivotPoint = value;
        return value;
    }
}

