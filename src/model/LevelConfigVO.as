package model
{
	public class LevelConfigVO
	{
		private var _id:String;
		private var _config:XML;
		
		public function LevelConfigVO(id:String, config:XML)
		{
			_id = id;
			_config = config;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get config():XML
		{
			return _config;
		}
	}
}