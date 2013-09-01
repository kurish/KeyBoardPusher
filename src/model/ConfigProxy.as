package model
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.drm.AddToDeviceGroupSetting;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import utils.GlobalConst;
	
	
	public class ConfigProxy extends Proxy
		
	{
		private static const NAME:String = 'LoadingAssetsProxy';
		
		private var _config:XML;
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		private var _url:String = "config.xml";
		
		
		public function ConfigProxy(data:Object=null)
		{
			super(NAME);
		}
		
		public function loadConfigXML():void
		{
			_urlRequest = new URLRequest(_url);
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			_urlLoader.load(_urlRequest);
		}
		
		private function onXMLLoaded(event:Event):void
		{
			_config = new XML(_urlLoader.data);
			_urlLoader.removeEventListener(Event.COMPLETE, onXMLLoaded);
			
			sendNotification(GlobalConst.CONFIG_LOADED, _config);
		}
		
		public function getConfig():XML 
		{
			return _config;
		}
	}
}