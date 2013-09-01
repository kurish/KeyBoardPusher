package utils
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class URLLoaderEx extends URLLoader
	{
		private var _additionalData:*;
		
		public function URLLoaderEx(request:URLRequest=null, additionalData:* = null)
		{
			super(request);
			_additionalData = additionalData;
		}
		
		public function get additionalData():* 
		{
			return _additionalData;
		}
	}
}