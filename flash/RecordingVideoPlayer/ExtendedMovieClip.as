import mx.events.*;

class ExtendedMovieClip extends MovieClip
{
	var addEventListener:Function
	var removeEventListener:Function
	var dispatchEvent:Function
	
	var eachChild:Function
	var centerX:Number
	var centerY:Number
	
	var onFadeDownComplete:Function
	var onFadeUpComplete:Function
	
	var className:String = "ExtendedMovieClip"
	
	private var fadeId:Number;
	
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------
	
	function ExtendedMovieClip()
	{
		EventDispatcher.initialize(this)
	}
	
	//-------------------------------------------------------------------
	//	PUBLIC FUNCTIONS
	//-------------------------------------------------------------------
	
	public function fadeUp( speed:Number ):Void
	{
		if( this._alpha == 100 )
		{
			this.onFadeUpComplete()
			return
		}
		speed = speed || 5;
		clearInterval( fadeId );
		fadeId = setInterval( this, "fade", 30, 100, speed );
	}
	
	public function fadeDown( speed:Number ):Void
	{
		if( this._alpha == 0 )
		{
			this.onFadeDownComplete()
			return
		}
		speed = speed || 5;
		clearInterval( fadeId );
		fadeId = setInterval( this, "fade", 30, 0, speed );
	}
	
	//public function onFadeDownComplete() {}
	
	//public function onFadeUpComplete() {}
	
	function get isMouseOver():Boolean
	{
		return this.hitTest( _root._xmouse, _root._ymouse, true )
	}
	
	function toString()
	{
		return "["+className+"] "+String(this)
	}
	
	//-------------------------------------------------------------------
	//	FUNCTIONS: Private
	//-------------------------------------------------------------------
	
	private function fade( to:Number, difference:Number ):Void
	{
		if( _alpha < to )
		{
			_alpha += difference;
			if( _alpha >= to )
			{
				_alpha = to;
				clearInterval( fadeId );
				onFadeUpComplete();
			}
		}
		else
		{
			_alpha -= difference;
			if( _alpha <= to )
			{
				_alpha = to;
				clearInterval( fadeId );
				onFadeDownComplete();
			}
		}
	}
	
	//-------------------------------------------------------------------
	//	CLASS TRACE
	//-------------------------------------------------------------------
	
	private function myTrace( msg )
	{
		trace( "#"+className+"# "+msg )
	}
}