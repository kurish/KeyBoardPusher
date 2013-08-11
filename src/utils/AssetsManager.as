package utils
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.events.Event;

	public class AssetsManager
	{
		private var _config:Object;
		private var _warehouse:Object;
		private var _bulkLoader:BulkLoader;
		private var _callbacks:Object;
		
		private static var _instance:AssetsManager;
		
		public static function get instance():AssetsManager{
			if (!_instance)
			{
				_instance = new AssetsManager();
			}
			return _instance;
		}
		
		public function AssetsManager()
		{
			_warehouse = {};
			_bulkLoader = new BulkLoader("assetsLoader");
		}
		
		public function initialize(config:Object):void 
		{
			_config = config; 
		}
		
		
		public function getAsset(id:String):Object
		{
			// проверяем, есть ли в warehouse свойство с ключем id и не является ли оно null.
			if (_warehouse.hasOwnProperty(id) && (_warehouse[id] != null)) {
			
				return _warehouse[id];
				
			}
		
			// На данное этапе ясно, что ассет не загружен в память.
			// Нужно выполнить проверку, имеются ли параметры для загрузки этого ассета в конфиге (то есть имеется ли запись по ключу id).
			if (_config.hasOwnProperty(id)) 
			{
				var params:Object = _config[id];
				var url:String = params["url"];
				_bulkLoader.add(url, { id: id }).addEventListener(Event.COMPLETE, onItemLoaded);
				if (!_bulkLoader.isRunning)
				{
					_bulkLoader.start();
				}
			return _warehouse[id];
			
			}
		return _warehouse[id];
		}
		
		private function onItemLoaded(event:Event):void
		{
			// Достаем LoadingItem, который и послал событие об окончании загрузки
			var loadingItem:LoadingItem = (event.target as LoadingItem);
			
			// Получаем id ассета
			var id:String = loadingItem.id;
			
			// Заносим загруженный ассет в warehouse
			_warehouse[id] = loadingItem.content;
			
		}
	}
}