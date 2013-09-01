package mvc.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import model.AssetsManager;
	import model.LevelConfigVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import utils.GlobalConst;
	import utils.LetterInfo;
	
	public class LevelMediator1 extends Mediator
	{
		public static const NAME:String = "Level1Mediator";
		
		public static const STATE_UP:int = 0;
		public static const STATE_ANIM_DOWN:int = 1;
		public static const STATE_DOWN:int = 2;
		public static const STATE_ANIM_UP:int = 3;
		
		private var view:MovieClip;
		
		private var levelConfig:XML;
		
		private var letters:Array;
		private var timeout:int;
		
		private var maxErrors:int;
		private var currentErrors:int;
		
		private var currentLetter:LetterInfo;
		
		private var rounds:int;
		private var currentRound:int;
		
		private var targetState:int;
		private var isInitialized:Boolean = false;
		
		private var scorePerLetter:int;
		
		private var errorAnim:MovieClip;
		
		private var scoreTF:TextField;
		private var _score:int;
		
		private var _timer:Timer;
		private var timeMeter:MovieClip;
		
		private static const INTERVAL:int = 10;
		
		public function LevelMediator1(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			view = viewComponent as MovieClip;
			view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mcRightGun = view.getChildByName("rightGun") as MovieClip;
			mcLeftGun = view.getChildByName("leftGun") as MovieClip;
			timeMeter = view.getChildByName("timeMeter") as MovieClip;
			initXR = mcRightGun.x;
			initYR = mcRightGun.y;
			initXL = mcLeftGun.x;
			initYL = mcLeftGun.y;
			
			scoreTF = view.getChildByName("scoreTF") as TextField;
		}
		
		override public function listNotificationInterests():Array
		{
			return [GlobalConst.LEVEL_LOADED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GlobalConst.LEVEL_LOADED:
				{
					var levelConfigVO:LevelConfigVO = notification.getBody() as LevelConfigVO;
					levelConfig = levelConfigVO.config;
					initializeLevel();
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		
		protected function initializeLevel():void 
		{
			timeout = levelConfig.timeout * 1000;
			maxErrors = levelConfig.errors;
			rounds = levelConfig.rounds;
			var tmpLetters:Array = levelConfig.letters.split(",");
			letters = [];
			for (var i:int = 0; i < tmpLetters.length; i++) 
			{
				letters[i] = new LetterInfo(tmpLetters[i]);
			}
			scorePerLetter = levelConfig.scorePerLetter;
			isInitialized = true;
			_timer = new Timer(INTERVAL, timeout / INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			startLevel();
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			onTimeout();
		}
		
		private function onTimerTick(event:TimerEvent):void
		{
			timeMeter.scaleX = (_timer.repeatCount - _timer.currentCount) / _timer.repeatCount;
		}
		
		protected function startLevel():void 
		{
			currentErrors = 0;
			currentRound = 0;
			setTargetLetter(letters[Math.floor(Math.random() * letters.length)]);
			putTargetUp();
			setScore(0);
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private var _targetAnim:MovieClip;
		private var _targetText:TextField;
		
		private function onAddedToStage(event:Event):void {
			view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_targetAnim = view.getChildByName("targetAnim") as MovieClip;
			putTargetDown(false);
			var target:MovieClip = _targetAnim.getChildByName("target") as MovieClip;
			_targetText = target.getChildByName("label") as TextField;
			_targetText.text = "";
			
			var am:AssetsManager = facade.retrieveProxy(AssetsManager.NAME) as AssetsManager;
			
			errorAnim = am.getAsset("mc_errorAnim") as MovieClip;
			errorAnim.gotoAndStop(1);
			errorAnim.mouseChildren = errorAnim.mouseEnabled = false;
			view.addChild(errorAnim);
		}
		
		protected function playErrorAnim():void
		{
			view.setChildIndex(errorAnim, view.numChildren - 1);
			errorAnim.gotoAndPlay(1);
		}
		
		private function setTargetLetter(letterInfo:LetterInfo):void {
			currentLetter = letterInfo;
			_targetText.text = letterInfo.letter;
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			shakeGun();
			var code:int = event.keyCode;
			if (code == currentLetter.code) {
				setScore(_score + scorePerLetter * timeMeter.scaleX);
				_timer.reset();
				_timer.stop();
				timeMeter.scaleX = 1;
				currentRound++;
				putTargetDown();
			} else {
				onError();
			}
		}
		
		private function onError():void 
		{
			currentErrors++;
			playErrorAnim();
			if (currentErrors == maxErrors) {
				// TODO: Error Pop Up.
				trace("You are looser!");
				closeView();
			}
		}
		
		private function onTimeout():void 
		{
			onError();
			if (currentErrors < maxErrors) {
				putTargetDown();
			}
		}
		
		public function closeView():void
		{
			trace("Your score is " + _score);
			view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			view.parent.removeChild(view);
			facade.removeMediator(NAME);
		}
		
		private function putTargetDown(playAnim:Boolean = true):void
		{
			if (playAnim) {
				_targetAnim.gotoAndPlay("up");
				_targetAnim.addEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
				targetState = STATE_ANIM_DOWN;
			} else {
				_targetAnim.gotoAndStop("down");
				targetState = STATE_DOWN;
				onTargetDown();
			}
		}
		
		private function putTargetUp(playAnim:Boolean = true):void
		{
			if (playAnim) {
				_targetAnim.gotoAndPlay("down");
				_targetAnim.addEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
				targetState = STATE_ANIM_UP;
			} else {
				_targetAnim.gotoAndStop("up");
				targetState = STATE_UP;
				onTargetUp();
			}
		}
		
		private function onTargetDown():void
		{
			trace("Target down");
			if (isInitialized) {
				if (currentRound == rounds) {
					trace("Level finished!");
					// TODO: Pop Up: Winner!
					closeView();
				} else {
					setTargetLetter(letters[Math.floor(Math.random() * letters.length)]);
					putTargetUp();
				}
			}
		}
		
		private function onTargetUp():void
		{
			trace("Target up");
			_timer.reset();
			_timer.start();
		}
		
		private function onTargetEnterFrame(event:Event):void
		{
			trace("EF");
			if (targetState == STATE_ANIM_DOWN) {
				if (_targetAnim.currentLabel == "down") {
					_targetAnim.removeEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
					targetState = STATE_DOWN;
					_targetAnim.stop();
					onTargetDown();
				}
			} else if (targetState == STATE_ANIM_UP) {
				if (_targetAnim.currentLabel == "up") {
					_targetAnim.removeEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
					targetState = STATE_UP;
					_targetAnim.stop();
					onTargetUp();
				}
			}
		}
		
		public function setScore(value:int):void 
		{
			_score = value;
			scoreTF.text = String(_score);
		}
		
		private var isGunShaking:Boolean = false;
		private var framesCount:int;
		private var mcRightGun:MovieClip;
		private var mcLeftGun:MovieClip;
		private var initXR:int;
		private var initYR:int;
		private var initXL:int;
		private var initYL:int;
		private var isLeftGun:Boolean = false;
		
		private function shakeGun():void {
			if (isGunShaking) {
				return;
			}
			isGunShaking = true;
			framesCount = 0;
			view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			framesCount++;
			
			if (isLeftGun) {
				if ((framesCount == 5))
				{
					view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					mcLeftGun.rotation = 0;
					mcLeftGun.x = initXL;
					mcLeftGun.y = initYL;
					isGunShaking = false;
					isLeftGun = false;
				}
				else {
					mcLeftGun.rotation = Math.random() * 2;
					mcLeftGun.x = initXL + (Math.random() * 2);
					mcLeftGun.y = initYL + (Math.random() * 0.5);
				}
			} else {
				if (framesCount == 5)
				{
					view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					mcRightGun.rotation = 0;
					mcRightGun.x = initXR;
					mcRightGun.y = initYR;
					isGunShaking = false;
					isLeftGun = true;
				} else 
				{
					mcRightGun.rotation = Math.random() * 2;
					mcRightGun.x = initXR + (Math.random() * 2);
					mcRightGun.y = initYR + (Math.random() * 0.5);
				}
			}
		}
		
		override public function onRemove():void 
		{
			view = null;
			mcLeftGun = null;
			mcRightGun = null;
			errorAnim.parent.removeChild(errorAnim);
			errorAnim = null;
			if (_targetAnim) {
				_targetAnim.removeEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
				_targetAnim = null;
			}
			_targetText = null;
			scoreTF = null;
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.stop();
				_timer = null;
			}
			timeMeter = null;
		}
		
	}
}