package com.pipe.phone
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	
	public class AppConfig
	{
		private var _orientatioin:String;
		private var _stage:Stage;
		public var onActiateHandler:Function;
		public var onDeactivateHandler:Function;
		private var _deviceWidth:int,_deviceHeight:int;
		private var _realWidth:int,_realHeight:int;
		private var _deviceName:String;
		public function AppConfig(stage:Stage)
		{
			_stage=stage;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, _onActiateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, _onDeactivateHandler);
			_deviceWidth=Capabilities.screenResolutionX;
			_deviceHeight=Capabilities.screenResolutionY;
			_realWidth=_deviceWidth;
			_realHeight=_stage.stageHeight;
			setDeviceName();
		}
		private function _onActiateHandler(e:Event):void
		{
			if(onActiateHandler)onActiateHandler.call();
		}
		private function _onDeactivateHandler(e:Event):void
		{
			if(onDeactivateHandler)onDeactivateHandler.call();
		}
		private function setDeviceName():void
		{
			if(_deviceWidth>1024){
				_deviceWidth=640;
				_deviceHeight=960;
				_realWidth=640;
				_realHeight=920;
				_deviceName="iphone4";
				return;
			}
			if(getOS()=="IOS"){
				if(_deviceWidth==320){
					_deviceWidth=320;
					_deviceHeight=480;
					_realWidth=320;
					_realHeight=460;
					_deviceName="iphone3GS";
					return;
				}else{
					_deviceWidth=640;
					_deviceHeight=960;
					_realWidth=640;
					_realHeight=920;
					_deviceName="iphone4";
					return;
				}
			}else{
				_deviceWidth = 480;
				_deviceHeight = 854;				
				_realWidth = 480;
				_realHeight = 816;
				_deviceName="android";
			}
		}
		public function getOS():String{
			return Capabilities.version.split(" ")[0];
		}
		public function getVersion():String
		{
			return Capabilities.version.split(" ")[1];
		}
		public function get deviceName():String
		{
			return _deviceName;
		}
		
		public function set orientatioin(ori:String):void{
			_orientatioin=ori;
			_stage.setOrientation(_orientatioin);
			_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, stage_orientationChangeHandler);
			_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, stage_orientationChagningHandler);
		}
		private function stage_orientationChangeHandler(e:StageOrientationEvent):void
		{
			_stage.setOrientation(_orientatioin);
		}
		private function stage_orientationChagningHandler(e:StageOrientationEvent):void
		{
			_stage.setOrientation(_orientatioin);
		}
	}
}