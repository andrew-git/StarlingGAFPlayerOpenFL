package com.catalystapps.gaf.sound;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.SoundChannel;

/**
	 * @author Ivan Avdeenko
	 * @private
	 */
class GAFSoundChannel extends EventDispatcher
{
    public var soundChannel(get, set) : SoundChannel;
    public var soundID(get, never) : Int;
    public var swfName(get, never) : String;

    private var _soundChannel : SoundChannel;
    private var _soundID : Int;
    private var _swfName : String;
    
    public function new(swfName : String, soundID : Int)
    {
        super();
        this._swfName = swfName;
        this._soundID = soundID;
    }
    
    public function stop() : Void
    {
        this._soundChannel.stop();
    }
    
    private function get_soundChannel() : SoundChannel
    {
        return this._soundChannel;
    }
    
    private function set_soundChannel(soundChannel : SoundChannel) : SoundChannel
    {
        if (this._soundChannel != null)
        {
            this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
        }
        this._soundChannel = soundChannel;
        this._soundChannel.addEventListener(Event.SOUND_COMPLETE, onComplete);
        return soundChannel;
    }
    
    private function onComplete(event : Event) : Void
    {
        this.dispatchEvent(event);
    }
    
    private function get_soundID() : Int
    {
        return this._soundID;
    }
    
    private function get_swfName() : String
    {
        return this._swfName;
    }
}

