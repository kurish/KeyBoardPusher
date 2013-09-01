package model
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import utils.GlobalConst;
	import utils.URLLoaderEx;
	
	public class LoadLevelProxy extends Proxy
	{
		public static const NAME:String = "LoadLevelProxy";
		
		private var levelsConfig:XML;
		
		public function LoadLevelProxy(levelsCfg:XML)
		{
			super(NAME, levelsCfg);
			levelsConfig = levelsCfg;
		}
		
		public function loadLevel(id:String):void {
			var levelCfg:XML = levelsConfig.level.(@id == id)[0];
			var xmlUrl:String = levelCfg.@xmlUrl;
			var urlReq:URLRequest = new URLRequest(xmlUrl);
			var urlLoader:URLLoaderEx = new URLLoaderEx(null, id);
			urlLoader.addEventListener(Event.COMPLETE, onLevelXMLLoaded);
			urlLoader.load(urlReq);
		}
		
		private function onLevelXMLLoaded(event:Event):void 
		{
			var loader:URLLoaderEx = URLLoaderEx(event.target);
			loader.removeEventListener(Event.COMPLETE, onLevelXMLLoaded);
			var levelConfig:XML = new XML(loader.data);
			sendNotification(GlobalConst.LEVEL_LOADED, new LevelConfigVO(loader.additionalData, levelConfig));
		}
	}
}