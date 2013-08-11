package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	
	import flashx.textLayout.debug.assert;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	import utils.AssetsManager;
	import utils.GlobalConst;
	
	import view.LoadingViewLogic;
	
	[SWF (width="1024", height="768")]
	public class KeyBoardPusher extends Sprite
	{
		
		public function KeyBoardPusher()
		{
			ApplicationFacade.getInstance().sendNotification(GlobalConst.STARTUP, stage);
		}
		
		
		// Old functions. TODO: Move to other classes
		
		private var _config:XML;
		private static const CONFIG_URL:String = "config.xml";
		private var test1:Bitmap = new Bitmap;
		
		private var _urlLoader:URLLoader;
		private var LoadingView:LoadingViewLogic = new LoadingViewLogic;
		
		private function oldFunctions():void {
			_urlLoader = new URLLoader();
			var urlrequest:URLRequest = new URLRequest(CONFIG_URL);
			_urlLoader.addEventListener(Event.COMPLETE, onConfigLoaded);
			_urlLoader.load(urlrequest);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addChild(LoadingView);
			test1 = AssetsManager.instance.getAsset("dolphin") as Bitmap;
			addChild(test1);
		}
		
				
		protected function onConfigLoaded(event:Event):void
		{
			_config = new XML(_urlLoader.data);
			_urlLoader.removeEventListener(Event.COMPLETE, onConfigLoaded);
			var assetsXML:XML = _config.assets[0];
			var assetsList:XMLList = assetsXML.children();
			
			var assetsMgrCfg:Object = {}; 
			
			for (var i:int=0; i<assetsList.length(); i++)
			{
				var xml:XML = assetsList[i];
				var url:String = xml.@url;
				assetsMgrCfg[xml.@id] = { url : url };
				
			}
			
			var am:AssetsManager = AssetsManager.instance;
			am.initialize(assetsMgrCfg);
		}
		
	
		
	}
}