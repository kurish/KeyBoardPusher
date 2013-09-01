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
	
	import model.AssetsManager;
	import utils.EmbedClasses;
	import utils.GlobalConst;
	
	
	
	[SWF (width="1024", height="768")]
	public class KeyBoardPusher extends Sprite
	{
		
		public function KeyBoardPusher()
		{
			new EmbedClasses();
			ApplicationFacade.getInstance().sendNotification(GlobalConst.STARTUP, stage);
		}
		
		
	}
}