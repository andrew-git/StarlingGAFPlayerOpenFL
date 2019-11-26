/**
 * Created by Nazar on 03.03.14.
 */
package com.catalystapps.gaf.data.config;


/**
 * @private
 */
class CTextFieldObjects
{
    public var textFieldObjectsDictionary(get, never) : Map<String, CTextFieldObject>;

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
    
    private var _textFieldObjectsDictionary : Map<String, CTextFieldObject> = null;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new()
    {
        _textFieldObjectsDictionary = new Map();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function addTextFieldObject(textFieldObject : CTextFieldObject) : Void
    {
        if (this._textFieldObjectsDictionary.get(textFieldObject.id) == null)
        {
            this._textFieldObjectsDictionary.set(textFieldObject.id, textFieldObject);
        }
    }
    
	//typo???
	/*
    public function getAnimationObject(id : String) : CAnimationObject
    {
        if (this._textFieldObjectsDictionary.get(id) != null)
        {
            return this._textFieldObjectsDictionary.get(id);
        }
        else
        {
            return null;
        }
    }
	*/
    public function getTextFieldObject(id : String) : CTextFieldObject
    {
        if (this._textFieldObjectsDictionary.get(id) != null)
        {
            return this._textFieldObjectsDictionary.get(id);
        }
        else
        {
            return null;
        }
    }
    
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
    
    private function get_textFieldObjectsDictionary() : Map<String, CTextFieldObject>
    {
        return this._textFieldObjectsDictionary;
    }
}
