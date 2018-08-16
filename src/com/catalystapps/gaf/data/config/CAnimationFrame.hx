package com.catalystapps.gaf.data.config;

import haxe.ds.ArraySort;


/**
 * @private
 */
class CAnimationFrame
{
    public var instances(get, never) : Array<CAnimationFrameInstance>;
    public var frameNumber(get, never) : Int;
    public var actions(get, never) : Array<CFrameAction>;

    // --------------------------------------------------------------------------
    //
    // PUBLIC VARIABLES
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // PRIVATE VARIABLES
    //
    // --------------------------------------------------------------------------
    private var _instancesDictionary : Map<String, CAnimationFrameInstance> = null;
    private var _instances : Array<CAnimationFrameInstance> = null;
    private var _actions : Array<CFrameAction> = null;
    
    private var _frameNumber : Int = 0;
    
    // --------------------------------------------------------------------------
    //
    // CONSTRUCTOR
    //
    // --------------------------------------------------------------------------
    public function new(frameNumber : Int)
    {
        this._frameNumber = frameNumber;
        
        this._instancesDictionary = new Map();
        this._instances = [];
    }
    
    // --------------------------------------------------------------------------
    //
    // PUBLIC METHODS
    //
    // --------------------------------------------------------------------------
    public function clone(frameNumber : Int) : CAnimationFrame
    {
        var result : CAnimationFrame = new CAnimationFrame(frameNumber);
        
        for (instance in this._instances)
        {
            result.addInstance(instance);
			// .clone());
        }
        
        return result;
    }
    
    public function addInstance(instance : CAnimationFrameInstance) : Void
    {
        if (this._instancesDictionary.get(instance.id) != null)
        {
            if (instance.alpha != null && instance.alpha != 0)
            {
                this._instances[this._instances.indexOf(this._instancesDictionary.get(instance.id))] = instance;
                
                this._instancesDictionary.set(instance.id, instance);
            }
            else
            {
				// Poping the last element and set it as the removed element
                var index : Int = this._instances.indexOf(this._instancesDictionary.get(instance.id));
                // If index is last element, just pop
                if (index == (this._instances.length - 1))
                {
                    this._instances.pop();
                }
                else
                {
                    this._instances[index] = this._instances.pop();
                }
                
				this._instancesDictionary.remove(instance.id);
            }
        }
        else
        {
            this._instances.push(instance);
            
            this._instancesDictionary.set(instance.id, instance);
        }
    }
    
    public function addAction(action : CFrameAction) : Void
    {
        if (_actions == null) _actions = [];
        _actions.push(action);
    }
    
    public function sortInstances() : Void
    {
        ArraySort.sort(this._instances, this.sortByZIndex);
    }
    
    public function getInstanceByID(id : String) : CAnimationFrameInstance
    {
        return this._instancesDictionary.get(id);
    }
    
    // --------------------------------------------------------------------------
    //
    // PRIVATE METHODS
    //
    // --------------------------------------------------------------------------
    private function sortByZIndex(instance1 : CAnimationFrameInstance, instance2 : CAnimationFrameInstance) : Int
    {
        if (instance1.zIndex < instance2.zIndex)
        {
            return -1;
        }
        else if (instance1.zIndex > instance2.zIndex)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    
    // --------------------------------------------------------------------------
    //
    // OVERRIDDEN METHODS
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // EVENT HANDLERS
    //
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    //
    // GETTERS AND SETTERS
    //
    // --------------------------------------------------------------------------
    private function get_instances() : Array<CAnimationFrameInstance>
    {
        return this._instances;
    }
    
    private function get_frameNumber() : Int
    {
        return this._frameNumber;
    }
    private function get_actions() : Array<CFrameAction>
    {
        return this._actions;
    }
}
