package
{
	import controller.StartupCommand;
	
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import utils.GlobalConst;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public function ApplicationFacade()
		{
		}
		
		public static function getInstance():ApplicationFacade {
			if (!instance) {
				instance = new ApplicationFacade();
			}
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(GlobalConst.STARTUP, StartupCommand);
			
		}
		
		
	}
}