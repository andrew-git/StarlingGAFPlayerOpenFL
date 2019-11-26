package com.catalystapps.gaf.data.config;


/**
 * @private
 */
class CTextureAtlasElements
{
    public var elementsVector(get, never) : Array<CTextureAtlasElement>;

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
    
    private var _elementsVector : Array<CTextureAtlasElement> = null;
    private var _elementsDictionary : Map<String, CTextureAtlasElement> = null;
    private var _elementsByLinkage : Map<String, CTextureAtlasElement> = null;
    
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    
    public function new()
    {
        this._elementsVector = [];
        this._elementsDictionary = new Map();
        this._elementsByLinkage = new Map();
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function addElement(element : CTextureAtlasElement) : Void
    {
        if (this._elementsDictionary.get(element.id) == null)
        {
            this._elementsDictionary.set(element.id, element);
            
            this._elementsVector.push(element);
            
            if (element.linkage != null)
            {
                this._elementsByLinkage.set(element.linkage, element);
            }
        }
    }
    
    public function getElement(id : String) : CTextureAtlasElement
    {
		/*
        if (this._elementsDictionary.get(id) != null)
        {
            return this._elementsDictionary.get(id);
        }
        else
        {
            return null;
        }
		*/
		return this._elementsDictionary.get(id);
    }
    
    public function getElementByLinkage(linkage : String) : CTextureAtlasElement
    {
		/*
        if (this._elementsByLinkage.get(linkage) != null)
        {
            return this._elementsByLinkage.get(linkage);
        }
        else
        {
            return null;
        }
		*/
		return this._elementsByLinkage.get(linkage);
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
    
    private function get_elementsVector() : Array<CTextureAtlasElement>
    {
        return this._elementsVector;
    }
}
