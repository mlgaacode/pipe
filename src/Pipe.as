package
{
	import com.pipe.utils.AVM1MvoieProxy;
	
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.LocalConnection;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.text.TextField;
	
	import flashx.textLayout.elements.BreakElement;
	
	public class Pipe extends Sprite
	{
		//private var mc_content:AVM1MvoieProxy;
		private var swfLoader:Loader;
		private var accelerometer:Accelerometer;
		private var txt_info:TextField;
		private var file:File;
		private var stream:FileStream;
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
			 
			 stage.setOrientation(StageOrientation.ROTATED_LEFT);
			 stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE,stageOrientationHandler);
			 stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING,stageOrientationHandler);	
			 	 
			swfLoader=new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, onLoaded, false, 0, true);
			var lc:LoaderContext=new LoaderContext();
			lc.allowCodeImport=true;
			swfLoader.load(new URLRequest("swf/pipe.swf"),lc);
			addChild(swfLoader);
			txt_info=new TextField();
			txt_info.textColor=0xff0000;
			addChild(txt_info);
			txt_info.text="0";
			txt_info.addEventListener(MouseEvent.CLICK,onClickTest);
			file=new File(File.applicationDirectory.nativePath+"/data/t.txt");
			stream=new FileStream();
			
		}
	
		 private function onClickTest(e:MouseEvent):void
		 {		
			 stream.open(file,FileMode.WRITE);
			 var t:int=int(txt_info.text);
			 t++;
			 stream.writeByte(t);
			 
			 stream.close();
			 stream.open(file,FileMode.READ);
			 t=stream.readByte();
			 txt_info.text=""+t;
			 trace("here:"+t);
			 stream.close();
		 }

		 private function onDeactivateHandler(e:Event):void
		 {
			 //mc_content.stop();
		 }
		 private function onActiateHandler(e:Event):void
		 {
			 //mc_content.play();
		 }
		 private function stageOrientationHandler(e:StageOrientationEvent):void
		 {
			 stage.setOrientation(StageOrientation.ROTATED_LEFT);
		 }
		 private function onLoaded(e:Event):void
		 {
			 trace("loaded");				
			 //doClearance();
			
			 NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,onActiateHandler);
			 NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,onDeactivateHandler);	
			// accelerometer.addEventListener(AccelerometerEvent.UPDATE,updateHandler);
			 
		 }
		 
		 private function updateHandler(e:AccelerometerEvent):void
		 {	
			 txt_info.text="here:x="+e.accelerationX+"y="+e.accelerationY;
		 }
		 public function test():void{
		 	trace("test");
		 }
		 private function doClearance():void {
			 trace("clear");
			 try{
				 new LocalConnection().connect("foo");
				 new LocalConnection().connect("foo");
			 }catch(error : Error){
				 
			 }                       
		 }
	}
}