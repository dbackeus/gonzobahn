/*
Sweet way to implement FLVPlayback component for minimum hassle.

:D
*/

import de.alex_uhlmann.animationpackage.animation.*
import com.robertpenner.easing.*

import mx.video.*
import utils.*
import video.*

class video.AbstractVideoPlayer extends ExtendedMovieClip
{
	var className:String = "AbstractVideoPlayer"
	
	var HIGHEST_DEPTH:Number = 10000
	
	var versionWarning:MovieClip
	var image:MovieClip
	var player:FLVPlayback
	var controls:MovieClip
	
	var isEnlarged:Boolean
	
	var originalX:Number
	var originalY:Number
	var originalPlayerX:Number
	var originalPlayerY:Number
	var originalPlayerWidth:Number
	var originalPlayerHeight:Number
	
	var isCompletelyShrunk:Boolean
	
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------
	
	function AbstractVideoPlayer()
	{
		super()
		
		controls.enlargeButton.onRelease = Delegate.create( this, toggleFullScreen )
		
		controls.background.onRelease = function() {}
		controls.background.useHandCursor = false
		
		controls.progress._x = controls.seekBar._x
		controls.progress._y = controls.seekBar._y
		
		originalX = _x
		originalY = _y
		originalPlayerX = player._x
		originalPlayerY = player._y
		originalPlayerWidth = player._width
		originalPlayerHeight = player._height
		
		versionWarning._visible = false
		
		_global.setTimeout( this, "init", 50 )
	}
	
	function init()
	{
		//myTrace( "init: "+player.addEventListener )
		
    player["0"]._video.smoothing = true
    player["0"]._video.deblocking = 2
    
    player.autoPlay = false
    player.bufferTime = 3
    player.volume = 90
		
		player.playPauseButton = controls.playPauseButton
		player.stopButton = controls.stopButton
		player.seekBar = controls.seekBar
		player.volumeBar = controls.volumeBar
		
		player.addEventListener( "stateChange", Delegate.create( this, onPlayerStateChange ) )
		player.addEventListener( "playheadUpdate", this )
		player.addEventListener( "ready", Delegate.create( this, onVideoLoaded ) )
		player.addEventListener( "complete", Delegate.create( this, onPlaybackComplete ) )
	}
	
	//-------------------------------------------------------------------
	//	BUTTON EVENTS
	//-------------------------------------------------------------------
	
	function toggleFullScreen()
	{
		if( isEnlarged )
		{
			shrink()
		}
		else
		{
			enlarge()
		}
	}
	
	//-------------------------------------------------------------------
	//	PUBLIC FUNCTIONS
	//-------------------------------------------------------------------
	
	function requireH264()
	{
		if( !VersionDetector.hasVersion( 9, 0, 115 ) )
		{
			versionWarning._visible = true
			player._visible = false
		}
	}
	
	function enlarge()
	{
		isEnlarged = true
		player.onRelease = Delegate.create( this, toggleFullScreen )
	}
	
	function shrink()
	{
		isEnlarged = false
		delete player.onRelease
	}
	
	function resetTime()
	{
		controls.elapsedTime.text = "00:00"
		controls.totalTime.text = "00:00"
	}
	
	function updateElapsedTime()
	{
		controls.progress.setPercent( player.playheadTime / player.totalTime )
		controls.elapsedTime.text = timeToText( player.playheadTime, controls.totalTime.text.length > 5 ) 
	}
	
	function updateTotalTime(time)
	{
	  time = time || player.totalTime
		if(time > 0)
		{
		  controls.totalTime.text = timeToText( time )
		}
	}
	
	function loadVideo( url )
	{
		myTrace( "Loading: "+url+" to: "+player )
		player.contentPath = url
	}
	
	//-------------------------------------------------------------------
	//	PRIVATE FUNCTIONS
	//-------------------------------------------------------------------
	
	private function timeToText( seconds, useHours:Boolean )
	{
		seconds = Math.round( seconds )
		var hours = Math.floor( seconds / 60 / 60 )
		seconds = seconds - (hours * 60 * 60)
		var minutes = Math.floor( seconds / 60 )
		seconds = Math.round( seconds - (minutes * 60) )
		var text:String = minutes.zerofy()+":"+seconds.zerofy()
		
		if( hours > 0 || useHours ) text = hours.zerofy()+":"+text
		
		return text
	}
	
	private function refresh()
	{
		// OVERRIDE
	}
	
	//-------------------------------------------------------------------
	//	FLVPLAYBACK EVENTS
	//-------------------------------------------------------------------
	
	function onVideoLoaded( e:Object )
	{
		myTrace( "onVideoLoaded: "+player.totalTime )
		// Reset seekBar on new movie
		controls.enlargeButton.enabled = true
		controls.resetControls()
		//player.seekBar = null
		//player.seekBar = controls.seekBar
		updateTotalTime()
	}
	
	function playheadUpdate( e:Object ) 
	{
		updateElapsedTime()
	}
	
	function onPlayerStateChange()
	{
		//myTrace( "Playerstate: "+player.state )
		if( isBuffering || isPlaying || isPaused || isSeeking )
		{
			image.fadeDown()
		}
		else
		{
			image.fadeUp()
		}
		
		if( isStopped )
		{
			// Reset timeline when changing movies etc
			updateElapsedTime()
		}
	}
	
	function onPlaybackComplete( e:Object )
	{
		//myTrace( "onPlaybackComplete()" )
	}
	
	//-------------------------------------------------------------------
	//	PROPERTIES
	//-------------------------------------------------------------------

	function get isPlaying():Boolean
	{
		return player.state == FLVPlayback.PLAYING
	}
	
	function get isStopped():Boolean
	{
		return player.state == FLVPlayback.STOPPED
	}
	
	function get isPaused():Boolean
	{
		return player.state == FLVPlayback.PAUSED
	}
	
	function get isBuffering():Boolean
	{
		return player.state == FLVPlayback.BUFFERING
	}
	
	function get isSeeking():Boolean
	{
		return player.state == FLVPlayback.SEEKING
	}
	
	function get isRewinding():Boolean
	{
		return player.state == FLVPlayback.REWINDING
	}
}