package com.pipe.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class AVM1Proxy
	{
		public static var SOUNDPAUSE:String="sound_pause";
		public static var SOUNDPLAY:String="sound_play";
		
		private var _filePath:String="";
		private var files:Vector.<File>;
		private var _curr:int=0;
		private var stream:FileStream;
		private var _method:String="";
		
		public function AVM1Proxy(path:String)
		{
			_filePath=path;
			files=new Vector.<File>();
			files[0]=new File(_filePath);
			files[1]=new File(_filePath+"2");
			stream=new FileStream();
		}
		private function get curr():int{
			_curr=_curr==0?1:0;
			return _curr;
		}
		/**
		 * 
		 * @param o={method,params}
		 * 
		 */		
		public function set sendMethod(method:String):void{
			_method=method;
			writetxt();
		}
		
		private function readtxt():String
		{
			stream.open(files[_curr],FileMode.READ);
			var ba:ByteArray=new ByteArray();
			stream.position=0;
			stream.readBytes(ba,0,files[_curr].size);
			stream.close();
			ba.position=0;
			return ba.readMultiByte(ba.length,"");
		}
		
		private function writetxt():void
		{			
			var ba:ByteArray=new ByteArray();
			switch(_method)
			{
				case SOUNDPLAY:
				{
					ba.writeMultiByte(SOUNDPLAY,"");
					break;
				}
				case SOUNDPAUSE:
				{
					ba.writeMultiByte(SOUNDPAUSE,"");
					break;
				}
			}
			ba.position=0;
			stream.open(files[_curr],FileMode.WRITE);
			stream.position=0;
			stream.writeBytes(ba,0,ba.length);
			stream.close();
			stream.open(files[curr],FileMode.WRITE);
			stream.writeUTF("");
			stream.close();
		}
	}
}