package com.catalystapps.gaf.data.config;


/**
 * Data object that describe sequence
 */
class CAnimationSequence
{
    public var id(get, never) : String;
    public var startFrameNo(get, never) : Int;
    public var endFrameNo(get, never) : Int;

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
    
    private var _id : String = null;
    private var _startFrameNo : Int = 0;
    private var _endFrameNo : Int = 0;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    /**
	 * @private
	 */
    public function new(id : String, startFrameNo : Int, endFrameNo : Int)
    {
        this._id = id;
        this._startFrameNo = startFrameNo;
        this._endFrameNo = endFrameNo;
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
	 * @private
	 */
    public function isSequenceFrame(frameNo : Int) : Bool
    {
        // first frame is "1" !!!
        
        if (frameNo >= this._startFrameNo && frameNo <= this._endFrameNo)
        {
            return true;
        }
        else
        {
            return false;
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
    
    /**
	 * Sequence ID
	 * @return Sequence ID
	 */
    private function get_id() : String
    {
        return this._id;
    }
    
    /**
	 * Sequence start frame number
	 * @return Sequence start frame number
	 */
    private function get_startFrameNo() : Int
    {
        return this._startFrameNo;
    }
    
    /**
	 * Sequence end frame number
	 * @return Sequence end frame number
	 */
    private function get_endFrameNo() : Int
    {
        return this._endFrameNo;
    }
}
