package com.catalystapps.gaf.sound;

import com.catalystapps.gaf.data.config.CSound;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import haxe.Constraints.Function;

/** @private
 * @author Ivan Avdeenko
 * @private
 */
class GAFSoundData
{
    public var hasSoundsToLoad(get, never) : Bool;

    private var onFail : Function;
    private var onSuccess : Function;
    //private var _sounds : Map<String, Sound>;
    private var _sounds : Map<String, Dynamic>;
    private var _soundQueue : Array<CSound>;
    
    public function getSoundByLinkage(linkage : String) : Sound
    {
        if (this._sounds != null)
        {
            return this._sounds.get(linkage);
        }
        return null;
    }
    
    public function addSound(soundData : CSound, swfName : String, soundBytes : ByteArray) : Void
    {
        var sound : Sound = new Sound();
        if (soundBytes != null)
        {
            if (soundBytes.position > 0)
            {
                soundData.sound = this._sounds.get(soundData.linkageName);
                return;
            }
            else
            {
                sound.loadCompressedDataFromByteArray(soundBytes, soundBytes.length);
            }
        }
        else
        {
			if (this._soundQueue == null) this._soundQueue = [];
            this._soundQueue.push(soundData);
        }
        
        soundData.sound = sound;
        
		if (this._sounds == null) this._sounds = new Map();
        if (soundData.linkageName.length > 0)
        {
            this._sounds.set(soundData.linkageName, sound);
        }
        else
        {
			if (this._sounds.get(swfName) == null) this._sounds.set(swfName, {});
			Reflect.setField(this._sounds.get(swfName), Std.string(soundData.soundID), sound);
        }
    }
    
    public function getSound(soundID : Int, swfName : String) : Sound
    {
        if (this._sounds != null)
        {
            return Reflect.field(this._sounds.get(swfName), Std.string(soundID));
        }
        return null;
    }
    
    public function loadSounds(onSuccess : Function, onFail : Function) : Void
    {
        this.onSuccess = onSuccess;
        this.onFail = onFail;
        this.loadSound();
    }
    
    public function dispose() : Void
    {
        for (sound in this._sounds)
        {
			if (Std.is(sound, Sound))
			{
				cast(sound, Sound).close();
			}
			else
			{
				for (soundName in Reflect.fields(sound)) 
				{
					cast(Reflect.field(sound, soundName), Sound).close();
				}
			}
        }
    }
    
    private function loadSound() : Void
    {
        var soundDataConfig : CSound = _soundQueue.pop();
		
        soundDataConfig.sound.addEventListener(Event.COMPLETE, onSoundLoaded);
        soundDataConfig.sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
        soundDataConfig.sound.load(new URLRequest(soundDataConfig.source));
    }
    
    private function onSoundLoaded(event : Event) : Void
    {
        this.removeListeners(event);
        
        if (this._soundQueue.length > 0)
        {
            this.loadSound();
        }
        else
        {
            this.onSuccess();
            this.onSuccess = null;
            this.onFail = null;
        }
    }
    
    private function onError(event : IOErrorEvent) : Void
    {
        this.removeListeners(event);
        this.onFail(event);
        this.onFail = null;
        this.onSuccess = null;
    }
    
    private function removeListeners(event : Event) : Void
    {
        var sound : Sound = cast(event.target, Sound);
        sound.removeEventListener(Event.COMPLETE, onSoundLoaded);
        sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
    }
    
    private function get_hasSoundsToLoad() : Bool
    {
        return this._soundQueue != null && this._soundQueue.length > 0;
    }

    public function new()
    {
    }
}
