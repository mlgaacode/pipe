package
{
	import com.pipe.phone.AppConfig;
	import com.pipe.utils.AVM1Proxy;
	
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	
	public class Pipe extends Sprite
	{
		private var swfLoader:Loader;
		private var accelerometer:Accelerometer;
		private var txt_info:TextField;
		private var config:AppConfig;
		private var swfProxy:AVM1Proxy;
		public function Pipe()
		{
			super();			
			if(!stage)
				addEventListener(Event.ADDED_TO_STAGE,initApp);
			else
				initApp();
		}
		 private function initApp(e:Event=null):void
		{
			 // 支持 autoOrient
			 stage.align = StageAlign.TOP_LEFT;
			 stage.scaleMode = StageScaleMode.NO_SCALE;
			 
			 config=new AppConfig(stage);
			 config.orientatioin=StageOrientation.ROTATED_LEFT;
			 swfProxy=new AVM1Proxy(File.applicationDirectory.nativePath+"/data/t");
			swfLoader=new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			var lc:LoaderContext=new LoaderContext();
			lc.allowCodeImport=true;
			swfLoader.load(new URLRequest("swf/pipe.swf"),lc);
			addChild(swfLoader);
			addInfo();
		}
	
		 private function onDeactivateHandler():void
		 {
			swfProxy.sendMethod=AVM1Proxy.SOUNDPAUSE;
		 }
		 private function onActiateHandler():void
		 {

		 }
		 private function onLoaded(e:Event):void
		 {
			 doClearance();
			 config.onActiateHandler=onActiateHandler;
			 config.onDeactivateHandler=onDeactivateHandler;	
			 //accelerometer.addEventListener(AccelerometerEvent.UPDATE,updateHandler);
			 
		 }
		 
		 private function updateHandler(e:AccelerometerEvent):void
		 {	
			 txt_info.text="here:x="+e.accelerationX+"y="+e.accelerationY;
		 }
		 
		 private function doClearance():void {
			 trace("clear");
			 try{
				 new LocalConnection().connect("foo");
				 new LocalConnection().connect("foo");
			 }catch(error : Error){
				 
			 }                       
		 }
		 ////////
		 private function addInfo():void{
			 txt_info=new TextField();
			 txt_info.textColor=0xff0000;
			 addChild(txt_info);
			 txt_info.text="herer";
			 txt_info.addEventListener(MouseEvent.CLICK,onClickTest);
		 }
		 private function onClickTest(e:MouseEvent):void
		 {	
			 swfProxy.sendMethod=AVM1Proxy.SOUNDPAUSE;
		 }

	}
}