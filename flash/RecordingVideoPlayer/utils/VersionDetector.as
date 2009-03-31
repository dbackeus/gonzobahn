class utils.VersionDetector
{
	private static var majorVersion:Number;
	private static var minorVersion:Number;
	private static var revision:Number;
	
	public static function hasVersion( major:Number, minor:Number, rev:Number ):Boolean
	{
		if(!majorVersion) setVersion()
		
		if(majorVersion < major) return false;
		if(majorVersion > major) return true;
		if(minorVersion < minor) return false;
		if(minorVersion > minor) return true;
		if(revision < rev) return false;
		return true;
	}
	
	private static function setVersion():Void
	{
		var versions:Array = System.capabilities.version.split(" ")[1].split(",");
		majorVersion = int(versions[0]);
		minorVersion = int(versions[1]);
		revision = int(versions[2]);
	}
}