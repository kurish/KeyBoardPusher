package controller
{
	import flash.display.MovieClip;
	
	import model.AssetsManager;
	
	import mvc.view.LobbyMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import utils.GlobalConst;
	
	public class StartGameCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			trace("zbs, dalshe mediator");
			var am:AssetsManager = facade.retrieveProxy(AssetsManager.NAME) as AssetsManager;
			
			var lobbyContent:MovieClip = am.getAsset("Lobby") as MovieClip;
			sendNotification(GlobalConst.ADD_TO_STAGE, lobbyContent);
			var lobbyMediator:LobbyMediator = new LobbyMediator(lobbyContent);
		}
	}
}