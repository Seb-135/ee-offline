package
{
	public class TextSign
	{
		private var _text:String = "";
		private var _type:int = -1;
		
		public function TextSign(text:String, type:int)
		{
			_text = text;
			_type = type;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function get type():int
		{
			return _type;
		}
	}
}