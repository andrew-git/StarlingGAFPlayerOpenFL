package com.catalystapps.gaf.data.config;


/**
	 * @private
	 */
class CAnimationSequences
{
    public var sequences(get, never) : Array<CAnimationSequence>;

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
    
    private var _sequences : Array<CAnimationSequence>;
    
    private var _sequencesStartDictionary : Dynamic;
    private var _sequencesEndDictionary : Dynamic;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new()
    {
        this._sequences = new Array<CAnimationSequence>();
        
        this._sequencesStartDictionary = { };
        this._sequencesEndDictionary = { };
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function addSequence(sequence : CAnimationSequence) : Void
    {
        this._sequences.push(sequence);
        
        if (this._sequencesStartDictionary[sequence.startFrameNo] == null)
        {
            this._sequencesStartDictionary[sequence.startFrameNo] = sequence;
        }
        
        if (this._sequencesEndDictionary[sequence.endFrameNo] == null)
        {
            this._sequencesEndDictionary[sequence.endFrameNo] = sequence;
        }
    }
    
    public function getSequenceStart(frameNo : Int) : CAnimationSequence
    {
        return this._sequencesStartDictionary[frameNo];
    }
    
    public function getSequenceEnd(frameNo : Int) : CAnimationSequence
    {
        return this._sequencesEndDictionary[frameNo];
    }
    
    public function getStartFrameNo(sequenceID : String) : Int
    {
        var result : Int = 0;
        
        for (sequence/* AS3HX WARNING could not determine type for var: sequence exp: EField(EIdent(this),_sequences) type: null */ in this._sequences)
        {
            if (sequence.id == sequenceID)
            {
                return sequence.startFrameNo;
            }
        }
        
        return result;
    }
    
    public function getSequenceByID(id : String) : CAnimationSequence
    {
        for (sequence/* AS3HX WARNING could not determine type for var: sequence exp: EField(EIdent(this),_sequences) type: null */ in this._sequences)
        {
            if (sequence.id == id)
            {
                return sequence;
            }
        }
        
        return null;
    }
    
    public function getSequenceByFrame(frameNo : Int) : CAnimationSequence
    {
        var i : Int = 0;
        while (i < this._sequences.length)
        {
            if (this._sequences[i].isSequenceFrame(frameNo))
            {
                return this._sequences[i];
            }
            i++;
        }
        
        return null;
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
    
    private function get_sequences() : Array<CAnimationSequence>
    {
        return this._sequences;
    }
}

