package controller
{
	import model.AssetsManager;
	import model.ConfigProxy;
	import model.LoadLevelProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ParseConfigCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var config:XML = notification.getBody() as XML;
			
			createAssetsMgr(config);
			createLoadLevelProxy(config);
		}
		
		private function createAssetsMgr(config:XML):void {
			var assetsXML:XML = config.assets[0];
			var assetsList:XMLList = assetsXML.children();
			var assetsMgrCfg:Object = {}; 
			
			for (var i:int=0; i<assetsList.length(); i++)
			{
				var xml:XML = assetsList[i];
				var url:String = xml.@url;
				var id : String = xml.@id;
				var type:String = xml.@type;
				var obj:Object = {};
				obj.url = url;
				assetsMgrCfg[id] = obj;
			}
			var am:AssetsManager = new AssetsManager(assetsMgrCfg);
			facade.registerProxy(am);
			am.loadAssets();
		}
		
		private function createLoadLevelProxy(config:XML):void
		{
			var levelsXML:XML = config.levels[0];
			var loadLevelProxy:LoadLevelProxy = new LoadLevelProxy(levelsXML);
			facade.registerProxy(loadLevelProxy);
		}
	}
}