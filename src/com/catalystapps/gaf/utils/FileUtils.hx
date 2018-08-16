/**
 * Created by Nazar on 12.01.2016.
 */
package com.catalystapps.gaf.utils;

import com.catalystapps.gaf.data.tagfx.GAFATFData;
import flash.display3D.Context3DTextureFormat;
import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

/**
 * @private
 */
class FileUtils
{
    private static var PNG_HEADER : Array<Int> = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    //private static const PNG_IHDR: Vector.<uint> = new <uint>[0x49, 0x48, 0x44, 0x52];
    /**
	 * Determines texture atlas size in pixels from file.
	 * @param file Texture atlas file.
	 */
    public static function getPNGSize(file : Dynamic) : Point
    {
        if (file == null || Type.getClassName(Type.getClass(file)) != "flash.filesystem::File")
        {
            throw new ArgumentError("Argument \"file\" is not \"flash.filesystem::File\" type.");
        }
        
        var FileStreamClass : Class<Dynamic> = Type.getClass(Type.resolveClass("flash.filesystem::FileStream"));
        var fileStream : Dynamic = Type.createInstance(FileStreamClass, []);
        fileStream.open(file, "read");
        
        var size : Point = null;
        if (isPNGData(fileStream))
        {
            fileStream.position = 16;
            size = new Point(fileStream.readUnsignedInt(), fileStream.readUnsignedInt());
        }
        
        fileStream.close();
        
        return size;
    }
    
    /**
	 * Determines texture atlas size in pixels from file.
	 * @param file Texture atlas file.
	 */
    public static function getPNGBASize(png : ByteArray) : Point
    {
        if (png == null)
        {
            throw new ArgumentError("Argument \"png\" must be not null.");
        }
        
        var oldPos : Int = png.position;
        
        var size : Point = null;
        if (isPNGData(png))
        {
            png.position = 16;
            size = new Point(png.readUnsignedInt(), png.readUnsignedInt());
        }
        
        png.position = oldPos;
        
        return size;
    }
    
    public static function getATFData(file : Dynamic) : GAFATFData
    {
        if (file == null || Type.getClassName(Type.getClass(file)) != "flash.filesystem::File")
        {
            throw new ArgumentError("Argument \"file\" is not \"flash.filesystem::File\" type.");
        }
        
        var FileStreamClass : Class<Dynamic> = Type.getClass(Type.resolveClass("flash.filesystem::FileStream"));
        var fileStream : Dynamic = Type.createInstance(FileStreamClass, []);
        fileStream.open(file, "read");
        
        if (isAtfData(fileStream))
        {
            fileStream.position = 6;
            if (fileStream.readUnsignedByte() == 255) // new file version
			{
                fileStream.position = 12;
            }
            else
            {
                fileStream.position = 6;
            }
            
            var atfData : GAFATFData = new GAFATFData();
            
            var format : Int = fileStream.readUnsignedByte();
            var _sw0_ = (format & 0x7f);            

            switch (_sw0_)
            {
                case 0, 1:atfData.format = Context3DTextureFormat.BGRA;
                case 12, 2, 3:atfData.format = Context3DTextureFormat.COMPRESSED;
                case 13, 4, 5:atfData.format = "compressedAlpha";  // explicit string for compatibility  
                default:throw new Error("Invalid ATF format");
            }
            
            atfData.width = Std.int(Math.pow(2, fileStream.readUnsignedByte()));
            atfData.height = Std.int(Math.pow(2, fileStream.readUnsignedByte()));
            atfData.numTextures = fileStream.readUnsignedByte();
            atfData.isCubeMap = (format & 0x80) != 0;
            
            return atfData;
        }
        
        return null;
    }
    
    /** Checks the first 3 bytes of the data for the 'ATF' signature. */
    public static function isAtfData(data : IDataInput) : Bool
    {
        if (data.bytesAvailable < 3)
        {
            return false;
        }
        else
        {
            var signature : String = String.fromCharCode(data.readUnsignedByte())
									+ String.fromCharCode(data.readUnsignedByte())
									+ String.fromCharCode(data.readUnsignedByte());
			
            return signature == "ATF";
        }
    }
    
    /** Checks the first 3 bytes of the data for the 'ATF' signature. */
    public static function isPNGData(data : IDataInput) : Bool
    {
        if (data.bytesAvailable < 16)
        {
            return false;
        }
        else
        {
			
            var i : Int;
            var l : Int = PNG_HEADER.length;
            for (i in 0...l)
            {
                if (PNG_HEADER[i] != data.readUnsignedByte())
                {
                    return false;
                }
            }
			
            
            data.readUnsignedInt();  // seek IHDR  
            
            var ihdr : String = String.fromCharCode(data.readUnsignedByte())
								+String.fromCharCode(data.readUnsignedByte())
								+String.fromCharCode(data.readUnsignedByte())
								+String.fromCharCode(data.readUnsignedByte());
								
            return ihdr == "IHDR";
        }
    }
}
