package controller
{
	import flash.display.Stage;
	
	import model.ConfigProxy;
	
	import mvc.view.LevelMediator1;
	import mvc.view.StageMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import utils.GlobalConst;
	
	public class StartupCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var stage:Stage = notification.getBody() as Stage;
			
			// Proxies
			var loadConfigProxy:ConfigProxy = new ConfigProxy();
			facade.registerProxy(loadConfigProxy);
			
			// Mediators
			facade.registerMediator(new StageMediator(stage));
			
			// Commands
			facade.registerCommand(GlobalConst.CONFIG_LOADED, ParseConfigCommand);
			facade.registerCommand(GlobalConst.ASSETS_LOADED, StartGameCommand);
			facade.registerCommand(GlobalConst.START_LEVEL, StartLevelCommand);
			
			loadConfigProxy.loadConfigXML();
		}
		
	}
}