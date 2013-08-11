package view
{
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.TextField;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LoadingViewLogic extends MovieClip
	{
		private static const NAME:String = "LoadingMediator";
		
		private var _progressBar:MovieClip;
		private var progress:Number;
		
		public function LoadingViewLogic()
		{
			super();
			drawloadingbar();
		}
		
		private function drawloadingbar():void
		{
			addEventListener(BulkProgressEvent.PROGRESS, onprogressOn);
			_progressBar = new MovieClip();
			_progressBar.graphics.beginFill(0xFF0000);
			_progressBar.graphics.drawRect(0, 0, 300, 30);
			_progressBar.graphics.endFill();
			_progressBar.x = 100;
			_progressBar.y = 150;
			addChild(_progressBar);
			_progressBar.scaleX = progress;
						
		}
		
		private function onprogressOn(event:BulkProgressEvent):void
		{
		progress = event._percentLoaded;
		}
		
		
		
	}
}