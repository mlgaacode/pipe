package com.pipe.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class AVM1Proxy
	{
		private static var SOUNDPAUSE:String="sound_pause";
		private static var SOUNDPLAY:String="sound_play";
		
		private var _filePath:String="";
		private var file:File;
		private var stream:FileStream;
		
		public function AVM1Proxy(path:String)
		{
			_filePath=path;
			file=new File(_filePath);
			stream=new FileStream();
		}
		/**
		 * 
		 * @param o={method,params}
		 * 
		 */		
		public function sendMethod(o:Object):void{
			var s:String=o.method+":"+o.params;
			writetxt(s);
		}
		
		private function readtxt():String
		{
			stream.open(file,FileMode.READ);
			var ba:ByteArray=new ByteArray();
			stream.readBytes(ba,0,file.size);
			stream.close();
			ba.position=0;
			return ba.readMultiByte(ba.length,"");
		}
		
		private function writetxt(s:String):void
		{
			var ba:ByteArray=new ByteArray();
			ba.writeMultiByte(s,"");
			stream.open(file,FileMode.WRITE);
			stream.writeBytes(ba,0,ba.length);
			stream.close();
		}
	}
}