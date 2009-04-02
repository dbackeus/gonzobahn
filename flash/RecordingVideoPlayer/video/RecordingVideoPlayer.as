﻿import video.*

class video.RecordingVideoPlayer extends AbstractVideoPlayer
{
  var loader:MovieClip
	var megaphone:MovieClip
	
	var url:String
  var hasBegunLoading:Boolean
	
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------
	
	function RecordingVideoPlayer()
	{
	  super()
	  
	  megaphone._alpha = 0
		loader._alpha = 0
	  
	  if( isInternal )
	  {
	    image._visible = false
	  }
	  else
	  {
      image.imageHolder.loadMovie( _root.imageUrl )
      image.onRelease = Delegate.create( this, playIt )
	  }
	}
	
	function init()
	{
		// Because the FLVPlayback clip on stage will not have initialized its class
		// until at least one frame has passed we have to delay the modification
		// of its properties and calling of its functions and not call them directly
		// in the constructor. Because of this we have the init function that you can
		// look upon as a delayed constructor that will guarantee your player instance
		// to behave the way you expect it to. Don't forget to call super.init() 
		// when overriding!
		
		super.init()
		
		player.bufferingBar = loader
		player.autoPlay = true
	}
	
	//-------------------------------------------------------------------
	// FUNCTIONS
	//-------------------------------------------------------------------
	
	function playIt()
	{
	  if( hasBegunLoading )
	  {
  	  player.play()	    
	  }
	  else
	  {
	    loadVideo()
	  }
	}
	
	function setVideoUrl( url )
	{
    this.url = url
	  if( isInternal )
	  {
	    loadVideo()
	  }
	}
	
	function loadVideo()
	{
	  super.loadVideo( this.url )
	  hasBegunLoading = true
	  loader._alpha = 100
	}
	
	//-------------------------------------------------------------------
	//	FLVPLAYBACK EVENTS
	//-------------------------------------------------------------------
	
	function onPlayerStateChange()
	{
		super.onPlayerStateChange()
		
		if( isPlaying && megaphone._alpha == 0 )
		{
			megaphone.fadeUp()
		}
	}
	
	//-------------------------------------------------------------------
	// PROPERTIES
	//-------------------------------------------------------------------
	
	function get isInternal()
	{
	  return _root.internal
	}
}