package mvc.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import utils.GlobalConst;
	
	public class StageMediator extends Mediator
	{
		private static const NAME:String = 'StageMediator';

		private var _stage:Stage;
		
		public function StageMediator(viewComponent:Object=null)
		{
			super(NAME);
			_stage = viewComponent as Stage;
		}
		
		override public function listNotificationInterests():Array
		{
			return [GlobalConst.ADD_TO_STAGE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case GlobalConst.ADD_TO_STAGE:
					_stage.addChild(notification.getBody() as DisplayObject);
					break;					
			}
		}
	}
}