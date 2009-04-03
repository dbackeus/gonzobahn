import mx.utils.Delegate
import flash.external.ExternalInterface;
import mx.controls.*

class MainRoot extends MovieClip
{
  var videoDropdown:ComboBox
  var audioDropdown:ComboBox
  
  var videoContainer:Video
  var recordButton:MovieClip
  var stopButton:MovieClip
  var vuMeter:MovieClip
  
  var nc:NetConnection
  var ns:NetStream
  
  var mic:Microphone
  var cam:Camera
  
  var lastVideoName:String
  var cameraActive:Boolean
  
  var checkCamInterval:Number
  
  // Parameters
  var host:String
  
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------
	
	static function initialize( target:MovieClip )
	{
		target.__proto__ = MainRoot.prototype
		Function(MainRoot).apply( target )
	}
	
	function MainRoot()
	{
    host = host || "localhost"

    nc = new NetConnection()
    nc.connect("rtmp://"+host+"/oflaDemo")
    nc.onStatus = Delegate.create( this, onNetConnectionStatus )
    
    ns = new NetStream(nc)
    ns.onMetaData = Delegate.create( this, onMetaData )
    
    setCam()
    setMic()
    
    setupInputDropdowns()

    // listen for the button clicks
    recordButton.addEventListener("click", Delegate.create(this, recordClick))
    stopButton.addEventListener("click", Delegate.create(this, stopClick))

    setInterval( this, "checkMicActivity", 50 )
	}
	
	private function setupInputDropdowns()
	{
	  videoDropdown.dataProvider = Camera.names
	  videoDropdown.selectedIndex = cam.index
	  videoDropdown.addEventListener( "change", Delegate.create( this, onNewVideoInput ) )
	  
	  audioDropdown.dataProvider = Microphone.names
	  audioDropdown.selectedIndex = mic.index
	  audioDropdown.addEventListener( "change", Delegate.create( this, onNewAudioInput ) )
	}
  
  //-------------------------------------------------------------------
  //  BUTTON EVENTS
  //-------------------------------------------------------------------
  
  function recordClick()
  {
  	// This FLV is recorded to webapps/oflaDemo/streams/ directory
  	// attach cam and mic to the NetStream Object
  	ns.attachVideo(cam)
  	ns.attachAudio(mic)
  	videoContainer.attachVideo(cam)

  	// create a random number to store a unique name
  	lastVideoName = new Date().valueOf().toString()
  	ns.publish(lastVideoName, "record")

  	// disable the recordButton
  	recordButton.enabled = false

  	// enable the stop button
  	stopButton.enabled = true

  	// Set camera active to false, its up to checker to prove camera activity
  	myTrace( "Assuming no camera is being used..." )
  	cameraActive = false
  	checkCamInterval = setInterval( this, "checkCamActivity", 200 )
  }

  function stopClick()
  {
  	clearInterval( checkCamInterval )

  	ns.close()

  	recordButton.enabled = true
  	stopButton.enabled = false

  	playLastVideo()
  }
  
  //-------------------------------------------------------------------
  //  PRIVATE FUNCTIONS
  //-------------------------------------------------------------------
  
  private function checkMicActivity()
  {
  	vuMeter.setLevel( mic.activityLevel )
  }

  // Camera activity is checked during recording to see if webcam is used
  private function checkCamActivity()
  {
  	if( cameraActive == false && cam.currentFps > 0 )
  	{
  		trace( "Detected use of camera!" )
  		cameraActive = true
  	}
  }
  
  private function playLastVideo()
  {
  	// attach the netStream object to the video object
  	videoContainer.attachVideo(ns)

  	// play back the recorded stream
  	ns.play(lastVideoName)
  }
  
  private function setCam( index )
  {
    cam = Camera.get( index )
  	cam.setMode(320, 240, 25)
  	cam.setQuality(500000,95)
  	cam.setMotionLevel(0)
  	
  	// attach the cam to the videoContainer on stage so we can see ourselves
  	videoContainer.attachVideo(cam)
  	videoContainer.clear()
  }
  
  private function setMic( index )
  {
  	mic = Microphone.get( index )
  	mic.setRate(44)
  	mic.setSilenceLevel(0)
  	ns.attachAudio(mic)
  }
  
  //-------------------------------------------------------------------
  //  DROP DOWN EVENTS
  //-------------------------------------------------------------------
  
  function onNewAudioInput( e:Object )
  {
    setMic( audioDropdown.selectedIndex )
  }
  
  function onNewVideoInput( e:Object )
  {
    setCam( videoDropdown.selectedIndex )
  }
  
  //-------------------------------------------------------------------
  //  NET CONNECTION EVENTS
  //-------------------------------------------------------------------
  
  function onNetConnectionStatus( info )
  {
  	myTrace( info.code )
  }
  
  //-------------------------------------------------------------------
  //  NET STREAM EVENTS
  //-------------------------------------------------------------------
  
  function onMetaData( e:Object )
  {
  	myTrace( "Recording complete..." )
  	var stream:Object = new Object()
  	stream.fileName = lastVideoName+".flv"
  	stream.length = e.duration
  	stream.hasAudio = true
  	stream.hasVideo = cameraActive

  	myTrace( "duration: "+stream.length )
  	myTrace( "fileName: "+stream.fileName )
  	myTrace( "hasAudio: "+stream.hasAudio )
  	myTrace( "hasVideo: "+stream.hasVideo )

  	ExternalInterface.call( "onStreamRecorded", stream )
  }
  
	//-------------------------------------------------------------------
	//	CLASS TRACE
	//-------------------------------------------------------------------
	
	private function myTrace( msg )
	{
		trace( "#MainRoot# "+msg )
	}
}