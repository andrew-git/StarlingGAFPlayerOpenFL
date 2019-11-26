package com.catalystapps.gaf.sound;

import flash.errors.Error;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundTransform;

/**
 * @author Ivan Avdeenko
 */
/**
 * The <code>GAFSoundManager</code> provides an interface to control GAF sound playback.
 * All adjustments made through <code>GAFSoundManager</code> affects all GAF sounds.
 */
class GAFSoundManager
{
    private var volume : Float = 1;
    private var soundChannels : Map<String, Map<Int, Array<GAFSoundChannel>>>;
    private static var _getInstance : GAFSoundManager;
    
    /**
	 * @private
	 * @param singleton
	 */
    public function new(singleton : Singleton)
    {
        if (singleton == null)
        {
            throw new Error("GAFSoundManager is Singleton. Use GAFSoundManager.instance or GAF.soundManager instead");
        }
    }
    
    /**
	 * The volume of the GAF sounds, ranging from 0 (silent) to 1 (full volume).
	 * @param volume the volume of the sound
	 */
    public function setVolume(volume : Float) : Void
    {
        this.volume = volume;
        
		if (soundChannels != null)
		{
			var channels : Array<GAFSoundChannel>;
			for (swfName in soundChannels.keys())
			{
				for (soundID in soundChannels.get(swfName).keys())
				{
					channels = soundChannels.get(swfName).get(soundID);
					
					for (i in 0...channels.length) 
					{
						channels[i].soundChannel.soundTransform = new SoundTransform(volume);
					}
				}
			}
		}
    }
    
    /**
	 * Stops all GAF sounds currently playing
	 */
    public function stopAll() : Void
    {
		if (soundChannels != null)
		{
			var channels : Array<GAFSoundChannel>;
			for (swfName in soundChannels.keys())
			{
				for (soundID in soundChannels.get(swfName).keys())
				{
					channels = soundChannels.get(swfName).get(soundID);
					for (i in 0...channels.length) 
					{
						channels[i].stop();
					}
				}
			}
			soundChannels = null;
		}
    }
    
    /**
	 * @private
	 * @param sound
	 * @param soundID
	 * @param soundOptions
	 * @param swfName
	 */
	@:allow(com.catalystapps.gaf)
    private function play(sound : Sound, soundID : Int, soundOptions : Dynamic, swfName : String) : Void
    {
        if (Reflect.field(soundOptions, "continue") == true
            && soundChannels != null
			&& soundChannels.get(swfName) != null
            && soundChannels.get(swfName).get(soundID) != null)
        {
			return; //sound already in play - no need to launch it again
        }
        var soundData : GAFSoundChannel = new GAFSoundChannel(swfName, soundID);
        soundData.soundChannel = sound.play(0, Reflect.field(soundOptions, "repeatCount"), new SoundTransform(this.volume));
        soundData.addEventListener(Event.SOUND_COMPLETE, onSoundPlayEnded);
		
        if (soundChannels == null)
		{
            soundChannels = new Map();
        }
        if (soundChannels.get(swfName) == null)
		{
            soundChannels.set(swfName, new Map());
        }
        if (soundChannels.get(swfName).get(soundID) == null)
		{
            soundChannels.get(swfName).set(soundID, []);
        }
		soundChannels.get(swfName).get(soundID).push(soundData);		
    }
    
    /**
	 * @private
	 * @param soundID
	 * @param swfName
	 */
	@:allow(com.catalystapps.gaf)
    private function stop(soundID : Int, swfName : String) : Void
    {
        if (soundChannels != null
            && soundChannels.get(swfName) != null
            && soundChannels.get(swfName).get(soundID) != null)
        {
            var channels : Array<GAFSoundChannel> = soundChannels.get(swfName).get(soundID);
			for (i in 0...channels.length) 
			{
                channels[i].stop();
            }
            soundChannels.get(swfName).set(soundID, null);
			soundChannels.get(swfName).remove(soundID);
        }
    }
    
    /**
	 * @private
	 * @param event
	 */
    private function onSoundPlayEnded(event : Event) : Void
    {
        var soundChannel : GAFSoundChannel = cast(event.target, GAFSoundChannel);
        soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlayEnded);
        
        soundChannels.get(soundChannel.swfName).set(soundChannel.soundID, null);
        soundChannels.get(soundChannel.swfName).remove(soundChannel.soundID);
    }
    
    /**
	 * The instance of the <code>GAFSoundManager</code> (singleton)
	 * @return The instance of the <code>GAFSoundManager</code>
	 */
    public static function getInstance() : GAFSoundManager
    {
        if (_getInstance == null) _getInstance = new GAFSoundManager(new Singleton());
        return _getInstance;
    }
}

/** @private */
class Singleton
{

    @:allow(com.catalystapps.gaf.sound)
    private function new()
    {
    }
}
