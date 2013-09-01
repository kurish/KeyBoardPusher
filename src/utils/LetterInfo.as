package utils
{
	import flash.ui.Keyboard;

	public class LetterInfo
	{
		private var _letter:String;
		private var _code:int;
		
		public function LetterInfo(letter:String)
		{
			_letter = letter;
			_code = Keyboard[letter.toUpperCase()];
		}
		
		public function get letter():String
		{
			return _letter;
		}
		
		public function get code():int
		{
			return _code;
		}
	}
}