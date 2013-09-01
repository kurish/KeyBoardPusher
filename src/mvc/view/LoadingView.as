package mvc.view
{
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	public class LoadingView extends Sprite
	{
		private var _progressBar:MovieClip;
		private var _progress:Number;
		
		public function LoadingView()
		{
			_progressBar = new MovieClip();
			_progressBar.graphics.beginFill(0xFF0000);
			_progressBar.graphics.drawRect(0, 0, 300, 30);
			_progressBar.graphics.endFill();
			_progressBar.x = 100;
			_progressBar.y = 150;
			_progressBar.scaleX = _progress;
			
			
		}
		
		private function setProgress(event:BulkProgressEvent):void
		{
		_progress = event._percentLoaded;
		}
		
	}
}