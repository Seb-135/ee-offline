package ui.chat {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TabTextField extends Sprite{
		public var field:TextField;
		private var defaultCheckWords:Object = {};
		private var matches:Array;
		private var before:String = "";
		private var after:String = "";
		private var resetText:Boolean = false;
		private var componentHeight:Number
		function TabTextField(){
			
			this.field = new TextField()
			this.addChild(field)
			
			//Thanks for this!
			field.useRichTextClipboard = false
			
			field.type = TextFieldType.INPUT
			
			field.multiline = false;
			field.maxChars = 140
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.color = 0x000000
			format.size = 12;
			field.defaultTextFormat = format
			
			componentHeight = field.height
			realign()
			
			//			field.height = 18
			field.width = 20
			field.height = field.textHeight+5
			
			field.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleTabRequest)
			field.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown)
			field.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp)
			
			field.text = ""
			
			
			matches = null
			
		}
		
		private var gw:Function = null
		private function get checkWords():Object{
			return gw != null ? gw() : {};
		}
		
		public function SetWordFunction(f:Function):void{
			gw = f;
		}
		
		public function AddCheckWords(commandhelp:Object):void{
			defaultCheckWords = commandhelp;
		}
		
		/*	public function AddWord(word:String):void{
		checkWords[word] = checkWords[word] || 0
		}
		
		public function RemoveWord(word:String):void{
		delete checkWords[word] 
		}*/
		
		public override function set width(w:Number):void{
			field.width = w
		}
		public override function set height(h:Number):void{
			componentHeight = h
			realign()
		}
		public function set text(t:String):void{
			field.text = t
		}
		public function get text():String{
			return field.text
		}
		private function realign():void{
			field.y = (componentHeight-field.height)/2
		}
		
		
		
		/*** Private stuff ***/
		private function handleTabRequest(e:Event):void{
			e.preventDefault()
			if(!matches){
				var text:String = field.text
				var scanWord:Object = getCaretWord()
				if(scanWord.text != ""){
					matches = getWordlist(scanWord.text)
					matches.sortOn("weight", Array.NUMERIC | Array.DESCENDING)
					
					before	= text.substring( 0, scanWord.start )
					after	= text.substring( scanWord.end )
				}
			}
			
			if(matches && matches.length > 0){
				var charAfter:String = after.replace(/\W/g, "")
				
				var adder:String = ( charAfter == '' ? ( before == "" ? ': ' + after : ' ' + after ) : after )
				
				if(field.text.indexOf("/") >= 0) adder = " ";	
				
				field.text = before + matches[0].word + adder
				var endIndex:int = matches[0].word.length + before.length + adder.length
				if( matches.length > 1 ){
					field.setSelection( field.selectionBeginIndex , endIndex )
				}else{
					var end:int = endIndex
					field.setSelection( end, end )
				}
				matches.push(matches.shift())
			}
			
		}
		
		private function handleKeyDown(e:KeyboardEvent):void{
			switch( e.keyCode ){
				case 9:{
					//Do nothing
					break;
				}
				case 32:{
					doMatch()
					break;
				}
				default:{
					matches = null
					break;
				}
			}
			
		}
		
		private function doMatch():void{
			if(matches != null && matches.length > 0 && field.selectionBeginIndex != field.selectionEndIndex){
				var text:String = field.text
				field.type = TextFieldType.DYNAMIC
				
				resetText = true;
			}
			matches = null
		}
		
		private function handleKeyUp(e:KeyboardEvent):void{
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			if(resetText){
				field.type = TextFieldType.INPUT
				field.setSelection( field.selectionEndIndex + 1, field.selectionEndIndex + 1)
			}
			resetText = false
		}
		
		private function getWordlist(segment:String):Array{
			var retArr:Array = []
			for( var word:String in checkWords){
				if(word.toLowerCase().indexOf(segment.toLowerCase()) == 0) retArr.push({
					word:word,
					weight:checkWords[word]
				})
			}
			
			for( var command:String in defaultCheckWords){
				if(command.toLowerCase().indexOf(segment.toLowerCase()) == 0) retArr.push({
					word:command,
					weight:checkWords[command]
				})
			}
			
			
			
			
			return retArr
		}
		
		private function getCaretWord():Object{
			var text:String	= field.text
			var start:int	= field.caretIndex
			var end:int		= field.caretIndex
			
			var breakChars:Object = {}
			breakChars[" "] = true
			breakChars["\n"] = true
			breakChars["\t"] = true
			breakChars[String.fromCharCode(13)] = true
			
			while(start-1 >= 0 && !breakChars[text.charAt(start-1)] ) start --
			while(end < text.length && !breakChars[text.charAt(end)] ) end ++
			
			return {end:end, start:start, text:text.substring(start,end)}
		}
	}
}