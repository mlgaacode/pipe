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
		private var _deviceName:String;
		public function AppConfig(stage:Stage)
		{
			_stage=stage;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActiateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivateHandler);
			_deviceWidth=Capabilities.screenResolutionX;
			_deviceHeight=Capabilities.screenResolutionY;
			setDeviceName();	
		}
		private function setDeviceName():void
		{
			if(_deviceWidth	
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