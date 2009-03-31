import video.*

class video.RecordingVideoPlayer extends AbstractVideoPlayer
{
	var megaphone:MovieClip
	
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------
	
	function RecordingVideoPlayer()
	{
	  super()
	  
	  megaphone._alpha = 0
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
		
		//player.autoRewind = false
		player.autoPlay = true
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
}