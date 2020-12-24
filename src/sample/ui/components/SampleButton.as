﻿package sample.ui.components{	import flash.display.DisplayObject;	import flash.display.SimpleButton;	import flash.events.Event;	import flash.events.MouseEvent;

	public class SampleButton extends SimpleButton{		protected var _width:Number		protected var _height:Number		protected var _clickHandler:Function		function SampleButton(clickHandler:Function = null){						_clickHandler = function():void{if(clickHandler!=null) clickHandler()}			if(_clickHandler != null){				addEventListener(Event.ADDED_TO_STAGE,handleAttach)				addEventListener(Event.REMOVED_FROM_STAGE,handleDetatch)			}						addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{				var cache:DisplayObject = overState;				overState = downState;				stage.addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void{					overState = cache;					stage.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee);				})			})									redraw()		}				public function handleAttach(e:Event):void{			addEventListener(MouseEvent.CLICK, _clickHandler)		}				public function handleDetatch(e:Event):void{			removeEventListener(MouseEvent.CLICK, _clickHandler)		}				public override function set width(w:Number):void{			_width = w;			redraw();		}				public override function set height(h:Number):void{			_height = h;			redraw();		}								protected function redraw():void{			if(this.upState){				this.upState.width = _width				this.upState.height = _height			}						if(this.downState){				this.downState.width = _width				this.downState.height = _height			}			if(this.overState){				this.overState.width = _width				this.overState.height = _height			}			if(this.hitTestState){				this.hitTestState.width = _width				this.hitTestState.height = _height					}		}	}	}