package mvc.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class LoadingViewMediator extends Sprite
	{
		private static const NAME:String = 'LoadingViewMediator';
		//private var view:LoadingView = new LoadingView;
		
		public function LoadingViewMediator(loadingView:LoadingView)
		{
			super(NAME);
			addChild(loadingView as DisplayObject);
		}
		
		/*override private function onRegister():void
		{
		}*/
	}
}