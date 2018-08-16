package com.catalystapps.gaf.data.config;


/**
 * @private
 */
class CAnimationObjects
{
    public var animationObjectsDictionary(get, never) : Map<String, CAnimationObject>;

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
    
    private var _animationObjectsDictionary : Map<String, CAnimationObject>;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new()
    {
        this._animationObjectsDictionary = new Map();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function addAnimationObject(animationObject : CAnimationObject) : Void
    {
        if (this._animationObjectsDictionary.get(animationObject.instanceID) == null)
        {
            this._animationObjectsDictionary.set(animationObject.instanceID, animationObject);
        }
    }
    
    public function getAnimationObject(instanceID : String) : CAnimationObject
    {
		/*
        if (this._animationObjectsDictionary.get(instanceID) != null)
        {
            return this._animationObjectsDictionary.get(instanceID);
        }
        else
        {
            return null;
        }
		*/
		return this._animationObjectsDictionary.get(instanceID);
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
    
    private function get_animationObjectsDictionary() : Map<String, CAnimationObject>
    {
        return this._animationObjectsDictionary;
    }
}
