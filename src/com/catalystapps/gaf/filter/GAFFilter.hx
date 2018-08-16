package com.catalystapps.gaf.filter;

import com.catalystapps.gaf.data.config.CBlurFilterData;
import com.catalystapps.gaf.data.config.CColorMatrixFilterData;
import com.catalystapps.gaf.data.config.CFilter;
import com.catalystapps.gaf.data.config.ICFilterData;
import com.catalystapps.gaf.utils.VectorUtility;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import flash.errors.ArgumentError;
import openfl.Vector;
import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.filters.FragmentFilter;
import starling.filters.FragmentFilterMode;
import starling.textures.Texture;
import starling.utils.Color;

/**
 * @private
 */
class GAFFilter extends FragmentFilter
{
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
    
    private static inline var NORMAL_PROGRAM_NAME : String = "BF_n";
    private static inline var TINTED_PROGRAM_NAME : String = "BF_t";
    private static inline var COLOR_TRANSFORM_PROGRAM_NAME : String = "CMF";
    private var MAX_SIGMA(default, never) : Float = 2.0;
    private static var IDENTITY : Vector<Float> = Vector.ofArray([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    private static var MIN_COLOR : Vector<Float> = Vector.ofArray([0, 0, 0, 0.0001]);
    
    private var mNormalProgram : Program3D;
    private var mTintedProgram : Program3D;
    private var cUserMatrix : Vector<Float> = new Vector<Float>(20, true);
    private var cShaderMatrix : Vector<Float> = new Vector<Float>(20, true);
    private var cShaderProgram : Program3D;
    
    private var mOffsets : Vector<Float> = Vector.ofArray([0, 0, 0, 0]);
    private var mWeights : Vector<Float> = Vector.ofArray([0, 0, 0, 0]);
    private var mColor : Vector<Float> = Vector.ofArray([1, 1, 1, 1]);
    
    private var mBlurX : Float = 0;
    private var mBlurY : Float = 0;
    private var mUniformColor : Bool;
    
    private var changeColor : Bool;
    
    /** helper object */
    private static var sTmpWeights : Vector<Float> = new Vector<Float>(5, true);
    //private static var sTmpWeights : Array<Float> = [];
    
    private var _currentScale : Float = 1;
    //private var mResolution : Float = 1;
    
    public function new(resolution : Float = 1)
    {
        super(1, resolution);
        
        this.mode = "test";
    }
    
    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    
    public function setConfig(cFilter : CFilter, scale : Float) : Void
    {
        _currentScale = scale;
        updateFilters(cFilter);
    }
    
    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    
    private function updateFilters(cFilter : CFilter) : Void
    {
        var i : Int;
        var l : Int = cFilter.filterConfigs.length;
        var filterConfig : ICFilterData;
        
        var blurUpdated : Bool = false;
        var ctmUpdated : Bool = false;
        
        mUniformColor = false;
        
        for (i in 0...l)
        {
            filterConfig = cFilter.filterConfigs[i];
            
            if (Std.is(filterConfig, CBlurFilterData))
            {
                updateBlurFilter(try cast(filterConfig, CBlurFilterData) catch(e:Dynamic) null);
                blurUpdated = true;
            }
            else if (Std.is(filterConfig, CColorMatrixFilterData))
            {
                updateColorMatrixFilter(try cast(filterConfig, CColorMatrixFilterData) catch(e:Dynamic) null);
                ctmUpdated = true;
            }
        }
        
        if (!blurUpdated)
        {
            resetBlurFilter();
        }
        
        if (!ctmUpdated)
        {
            resetColorMatrixFilter();
        }
        
        updateMarginsAndPasses();
    }
    
    private function resetBlurFilter() : Void
    {
        mOffsets[0] = mOffsets[1] = mOffsets[2] = mOffsets[3] = 0;
        mWeights[0] = mWeights[1] = mWeights[2] = mWeights[3] = 0;
        mColor[0] = mColor[1] = mColor[2] = mColor[3] = 1;
        mBlurX = 0;
        mBlurY = 0;
        mResolution = 1;
    }
    
    private function resetColorMatrixFilter() : Void
    {
        VectorUtility.copyMatrix(cUserMatrix, IDENTITY);
        VectorUtility.copyMatrix(cShaderMatrix, IDENTITY);
        changeColor = false;
    }
    
    private function updateMarginsAndPasses() : Void
    {
        if (mBlurX == 0 && mBlurY == 0)
        {
            mBlurX = 0.001;
        }
        
        numPasses = Math.ceil(mBlurX) + Math.ceil(mBlurY);
        marginX = (3 + Math.ceil(mBlurX)) / resolution + Math.abs(offsetX);
        marginY = (3 + Math.ceil(mBlurY)) / resolution + Math.abs(offsetY);
        
        if ((mBlurX > 0 || mBlurY > 0) && changeColor)
        {
            numPasses++;
        }
    }
    
    private function updateBlurFilter(cBlurFilterData : CBlurFilterData) : Void
    {
        mBlurX = cBlurFilterData.blurX * _currentScale;
        mBlurY = cBlurFilterData.blurY * _currentScale;
        
        var maxBlur : Float = Math.max(mBlurX, mBlurY);
        //resolution = 1 / Math.sqrt(maxBlur * 0.1);
        if (maxBlur <= 10)
        {
            resolution = 1 + (10 - maxBlur) * 0.1;
        }
        else
        {
            resolution = 1 - maxBlur * 0.01;
        }
        
        var angleInRadians : Float = cBlurFilterData.angle * Math.PI / 180;
        offsetX = Math.cos(angleInRadians) * cBlurFilterData.distance * _currentScale;
        offsetY = Math.sin(angleInRadians) * cBlurFilterData.distance * _currentScale;
        
        setUniformColor(cBlurFilterData.color > -1, cBlurFilterData.color, cBlurFilterData.alpha * cBlurFilterData.strength);
    }
    
    /** A uniform color will replace the RGB values of the input color, while the alpha
	 *  value will be multiplied with the given factor. Pass <code>false</code> as the
	 *  first parameter to deactivate the uniform color. */
    public function setUniformColor(enable : Bool, color : Int = 0x0, alpha : Float = 1.0) : Void
    {
        mColor[0] = Color.getRed(color) / 255.0;
        mColor[1] = Color.getGreen(color) / 255.0;
        mColor[2] = Color.getBlue(color) / 255.0;
        mColor[3] = alpha;
        mUniformColor = enable;
    }
    
    private function updateColorMatrixFilter(cColorMatrixFilterData : CColorMatrixFilterData) : Void
    {
        var value : Vector<Float> = cColorMatrixFilterData.matrix;
        
        changeColor = false;
        
        if (value != null && value.length != 20)
        {
            throw new ArgumentError("Invalid matrix length: must be 20");
        }
        
        if (value == null)
        {
            VectorUtility.copyMatrix(cUserMatrix, IDENTITY);
        }
        else
        {
            changeColor = true;
            VectorUtility.copyMatrix(cUserMatrix, value);
        }
        
        updateShaderMatrix();
    }
    
    private function updateShaderMatrix() : Void
    {
		// the shader needs the matrix components in a different order,
        // and it needs the offsets in the range 0-1.
        
        VectorUtility.fillMatrix(cShaderMatrix, cUserMatrix[0], cUserMatrix[1], cUserMatrix[2], cUserMatrix[3], 
                cUserMatrix[5], cUserMatrix[6], cUserMatrix[7], cUserMatrix[8], 
                cUserMatrix[10], cUserMatrix[11], cUserMatrix[12], cUserMatrix[13], 
                cUserMatrix[15], cUserMatrix[16], cUserMatrix[17], cUserMatrix[18], 
                cUserMatrix[4], cUserMatrix[9], cUserMatrix[14], 
                cUserMatrix[19]
        );
    }
    
    /** @private */
    override private function activate(pass : Int, context : Context3D, texture : Texture) : Void
    {
        if (pass == numPasses - 1 && changeColor) //color transform filter
		{
			if (mode != FragmentFilterMode.REPLACE)
			{
				mode = FragmentFilterMode.REPLACE;
			}
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, cShaderMatrix);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, MIN_COLOR);
			context.setProgram(cShaderProgram);
        }
        else //blur, drop shadow or glow
        {
			if (mUniformColor)
			{
				mode = FragmentFilterMode.BELOW;
			}
			else
			{
				mode = FragmentFilterMode.REPLACE;
			}
			updateParameters(pass, Std.int(texture.nativeWidth), Std.int(texture.nativeHeight));
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mOffsets);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mWeights);
			
			if (changeColor)
			{
				if ((pass == numPasses - 2) && mUniformColor)
				{
					context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mColor);
					context.setProgram(mTintedProgram);
				}
				else
				{
					context.setProgram(mNormalProgram);
				}
			}
			if ((pass == numPasses - 1) && mUniformColor)
			{
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mColor);
				context.setProgram(mTintedProgram);
			}
			else
			{
				context.setProgram(mNormalProgram);
			}
        }
    }
    
    override public function render(object : DisplayObject, support : RenderSupport, parentAlpha : Float) : Void
    {
        super.render(object, support, parentAlpha);
    }
    
    /** @private */
    override private function createPrograms() : Void
    {
        mNormalProgram = createProgram(false);
        mTintedProgram = createProgram(true);
        cShaderProgram = createCProgram();
    }
    
    private function createProgram(tinted : Bool) : Program3D
    {
        var programName : String = (tinted) ? TINTED_PROGRAM_NAME : NORMAL_PROGRAM_NAME;
        var target : Starling = Starling.current;
        
        if (target.hasProgram(programName))
        {
            return target.getProgram(programName);
        }
        
        // vc0-3 - mvp matrix
        // vc4   - kernel offset
        // va0   - position
        // va1   - texture coords
        
        var vertexProgramCode : String = 
        "m44 op, va0, vc0       \n" +  // 4x4 matrix transform to output space  
        "mov v0, va1            \n" +  // pos:  0 |  
        "sub v1, va1, vc4.zwxx  \n" +  // pos: -2 |  
        "sub v2, va1, vc4.xyxx  \n" +  // pos: -1 | --> kernel positions  
        "add v3, va1, vc4.xyxx  \n" +  // pos: +1 |     (only 1st two parts are relevant)  
        "add v4, va1, vc4.zwxx  \n";   // pos: +2 |  
        
        // v0-v4 - kernel position
        // fs0   - input texture
        // fc0   - weight data
        // fc1   - color (optional)
        // ft0-4 - pixel color from texture
        // ft5   - output color
        
        var fragmentProgramCode : String = 
        "tex ft0,  v0, fs0 <2d, clamp, linear, mipnone> \n" +  // read center pixel  
        "mul ft5, ft0, fc0.xxxx                         \n" +  // multiply with center weight  
        
        "tex ft1,  v1, fs0 <2d, clamp, linear, mipnone> \n" +  // read pixel -2  
        "mul ft1, ft1, fc0.zzzz                         \n" +  // multiply with weight  
        "add ft5, ft5, ft1                              \n" +  // add to output color  
        
        "tex ft2,  v2, fs0 <2d, clamp, linear, mipnone> \n" +  // read pixel -1  
        "mul ft2, ft2, fc0.yyyy                         \n" +  // multiply with weight  
        "add ft5, ft5, ft2                              \n" +  // add to output color  
        
        "tex ft3,  v3, fs0 <2d, clamp, linear, mipnone> \n" +  // read pixel +1  
        "mul ft3, ft3, fc0.yyyy                         \n" +  // multiply with weight  
        "add ft5, ft5, ft3                              \n" +  // add to output color  
        
        "tex ft4,  v4, fs0 <2d, clamp, linear, mipnone> \n" +  // read pixel +2  
        "mul ft4, ft4, fc0.zzzz                         \n";   // multiply with weight  
        
        if (tinted)
        {
            fragmentProgramCode +=
            "add ft5, ft5, ft4                          \n" +  // add to output color  
            "mul ft5.xyz, fc1.xyz, ft5.www              \n" +  // set rgb with correct alpha  
            "mul oc, ft5, fc1.wwww                      \n";
        }
        else
        {
            fragmentProgramCode +=
            "add  oc, ft5, ft4                          \n";
        }
        
        return target.registerProgramFromSource(programName, vertexProgramCode, fragmentProgramCode);
    }
    
    private function createCProgram() : Program3D
    {
        var programName : String = COLOR_TRANSFORM_PROGRAM_NAME;
        var target : Starling = Starling.current;
        
        if (target.hasProgram(programName))
        {
            return target.getProgram(programName);
        }
        
        // fc0-3: matrix
        // fc4:   offset
        // fc5:   minimal allowed color value
        
        var fragmentProgramCode : String = 
        "tex ft0, v0,  fs0 <2d, clamp, linear, mipnone>  \n" +  // read texture color  
        "max ft0, ft0, fc5              \n" +  // avoid division through zero in next step  
        "div ft0.xyz, ft0.xyz, ft0.www  \n" +  // restore original (non-PMA) RGB values  
        "m44 ft0, ft0, fc0              \n" +  // multiply color with 4x4 matrix  
        "add ft0, ft0, fc4              \n" +  // add offset  
        "mul ft0.xyz, ft0.xyz, ft0.www  \n" +  // multiply with alpha again (PMA)  
        "mov oc, ft0                    \n";  // copy to output  
        
        return target.registerProgramFromSource(programName, FragmentFilter.STD_VERTEX_SHADER, fragmentProgramCode);
    }
    
    private function updateParameters(pass : Int, textureWidth : Int, textureHeight : Int) : Void
    {
		// algorithm described here:
        // http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
        //
        // To run in constrained mode, we can only make 5 texture lookups in the fragment
        // shader. By making use of linear texture sampling, we can produce similar output
        // to what would be 9 lookups.
        
        var sigma : Float;
        var horizontal : Bool = pass < mBlurX;
        var pixelSize : Float;
        
        if (horizontal)
        {
            sigma = Math.min(1.0, mBlurX - pass) * MAX_SIGMA;
            pixelSize = 1.0 / textureWidth;
        }
        else
        {
            sigma = Math.min(1.0, mBlurY - (pass - Math.ceil(mBlurX))) * MAX_SIGMA;
            pixelSize = 1.0 / textureHeight;
        }
        
        var twoSigmaSq : Float = 2 * sigma * sigma;
        var multiplier : Float = 1.0 / Math.sqrt(twoSigmaSq * Math.PI);
        
        // get weights on the exact pixels (sTmpWeights) and calculate sums (mWeights)
        
        for (i in 0...5)
        {
            sTmpWeights[i] = multiplier * Math.exp(-i * i / twoSigmaSq);
        }
        
        mWeights[0] = sTmpWeights[0];
        mWeights[1] = sTmpWeights[1] + sTmpWeights[2];
        mWeights[2] = sTmpWeights[3] + sTmpWeights[4];
        
        // normalize weights so that sum equals "1.0"
        
        var weightSum : Float = mWeights[0] + 2 * mWeights[1] + 2 * mWeights[2];
        var invWeightSum : Float = 1.0 / weightSum;
        
        mWeights[0] *= invWeightSum;
        mWeights[1] *= invWeightSum;
        mWeights[2] *= invWeightSum;
        
        // calculate intermediate offsets
        
        var offset1 : Float = (pixelSize * sTmpWeights[1] + 2 * pixelSize * sTmpWeights[2]) / mWeights[1];
        var offset2 : Float = (3 * pixelSize * sTmpWeights[3] + 4 * pixelSize * sTmpWeights[4]) / mWeights[2];
        
        // depending on pass, we move in x- or y-direction
        
        if (horizontal)
        {
            mOffsets[0] = offset1;
            mOffsets[1] = 0;
            mOffsets[2] = offset2;
            mOffsets[3] = 0;
        }
        else
        {
            mOffsets[0] = 0;
            mOffsets[1] = offset1;
            mOffsets[2] = 0;
            mOffsets[3] = offset2;
        }
    }

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

}
