package controller
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import model.AssetsManager;
	import model.LoadLevelProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import utils.GlobalConst;
	
	public class StartLevelCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var lvlNum:int = int(notification.getBody());
			trace("Start level " + lvlNum);
			var am:AssetsManager = facade.retrieveProxy(AssetsManager.NAME) as AssetsManager;
			var lvlContent:MovieClip = am.getAsset("Level" + lvlNum) as MovieClip;
			if (lvlContent) {
				// Создаем медиатор
				var mediator:IMediator;
				var mediatorClassName:String = "mvc.view.LevelMediator" + String(lvlNum);
				try {
					var mediatorCls:Class = getDefinitionByName(mediatorClassName) as Class;
					if (!mediatorCls) {
						trace("No class found");
					}
					mediator = new mediatorCls(lvlContent);
					facade.registerMediator(mediator);
					var loadLevelProxy:LoadLevelProxy = facade.retrieveProxy(LoadLevelProxy.NAME) as LoadLevelProxy;
					loadLevelProxy.loadLevel(String(lvlNum));
					sendNotification(GlobalConst.ADD_TO_STAGE, lvlContent);
				} catch (e:Error) {
					trace("Could not create mediator '" + mediatorClassName + "'");
				}
			} else {
				trace("No level content");
			}
		}
		
	}
}