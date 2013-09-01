package model
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import utils.GlobalConst;

	public class AssetsManager extends Proxy
	{
		public static const NAME:String = "AssetsManager";
		
		public static const ASSETS_LOADING_COMPLETE:String = "ASSETS_LOADING_COMPLETE";
		
		private var _config:Object;
		private var _warehouse:Object;
		private var _bulkLoader:BulkLoader;
		private var _callbacks:Object;
		
		private static var _instance:AssetsManager;
		
		public function AssetsManager(config:Object)
		{
			super(NAME);
			_config = config;
			_warehouse = {};
		}
		
		public function getAsset(assetName:String, namespace:String = null):Object
		{
			var cls:Class;
			var res:Object;
			var container:MovieClip;
			if (namespace) {
				container = _warehouse[namespace];
				if (container) {
					try {
						cls = container.loaderInfo.applicationDomain.getDefinition(assetName) as Class;
					} catch (e:Error) {
						trace("Class '" + assetName + "' was not found");
					}
				}
			} else {
				for (var key:String in _warehouse) {
					container = _warehouse[key];
					if (container) {
						try {
							cls = container.loaderInfo.applicationDomain.getDefinition(assetName) as Class;
						} catch (e:Error) {
							trace("Class '" + assetName + "' was not found");
						}
						if (cls) {
							break;
						}
					}
				}
			}
			if (cls) {
				res = new cls();
			}
			return res;
		}
			
		public function loadAssets():void
		{
			_bulkLoader = new BulkLoader("BulkassetsLoader");
			for (var key:String in _config) { // key поочередно принимает значение каждого ключа в объекте config
				var obj:Object = _config[key]; // config[key] - достаем и конфига значение по ключу key.
				_bulkLoader.add(obj["url"], { id: key }).addEventListener(Event.COMPLETE, onItemLoaded);
			}
			_bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, onAllAssetsLoaded);
			_bulkLoader.start();
		}
		
		private function onAllAssetsLoaded(event:BulkProgressEvent):void {
			_bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE, onAllAssetsLoaded);
			sendNotification(GlobalConst.ASSETS_LOADED);
		}
		
		private function onItemLoaded(event:Event):void
		{
			// Достаем LoadingItem, который и послал событие об окончании загрузки
			var loadingItem:LoadingItem = (event.target as LoadingItem);
			loadingItem.removeEventListener(Event.COMPLETE, onItemLoaded);
			// Получаем id ассета
			var id:String = loadingItem.id;
			
			// Заносим загруженный ассет в warehouse
			_warehouse[id] = loadingItem.content;
		}
	}
}
