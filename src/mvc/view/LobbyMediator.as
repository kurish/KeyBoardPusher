package mvc.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import utils.GlobalConst;
	
	public class LobbyMediator extends Mediator
	{
		public static const NAME:String = "LobbyMediator";
		
		private var _view:MovieClip;
		
		private static const BUTTON_OK_PREFIX:String = "btn_lvl_ok_";
		private static const BUTTON_DIS_PREFIX:String = "btn_lvl_dis_";
		
		private static const BTN_COUNT:int = 3;
		
		private var vBtnOk:Vector.<SimpleButton>;
		private var vBtnDis:Vector.<SimpleButton>;
		
		public function LobbyMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			vBtnDis = new Vector.<SimpleButton>(BTN_COUNT);
			vBtnOk  = new Vector.<SimpleButton>(BTN_COUNT);
			
			_view = viewComponent as MovieClip;
			initialize();
		}
		
		private function initialize():void {
			// TODO: Определить максимальный доступный уровень
			// Пока допустим значение вручную
			var maxLvl:int = 2;
			
			for (var i:int = 0; i < BTN_COUNT; i++) {
				var btnOk:SimpleButton  = _view.getChildByName(BUTTON_OK_PREFIX  + String(i + 1)) as SimpleButton;
				var btnDis:SimpleButton = _view.getChildByName(BUTTON_DIS_PREFIX + String(i + 1)) as SimpleButton;
				vBtnOk[i] = btnOk;
				vBtnDis[i] = btnDis;
				if (i < maxLvl) {
					btnDis.visible = false;
					btnOk.addEventListener(MouseEvent.CLICK, onButtonOkClick);
				} else {
					btnOk.visible = false;
					btnDis.addEventListener(MouseEvent.CLICK, onButtonDisClick);
				}
			}
		}
		
		private function onButtonOkClick(event:Event):void {
			var btn:SimpleButton = event.target as SimpleButton;
			trace("Enabled Button " + btn.name  + " clicked");
			var str:String = btn.name;
			var index:int = str.lastIndexOf("_");
			var lvlNum:int = int(str.substr(index + 1));
			sendNotification(GlobalConst.START_LEVEL, lvlNum);
		}
		
		private function onButtonDisClick(event:Event):void {
			var btn:SimpleButton = event.target as SimpleButton;
			trace("Disabled Button " + btn.name  + " clicked");
			switch (btn.name) {
				
			}
		}
	}
}