/**
 * thanks for http://nsdevaraj.wordpress.com/2008/10/16/avm1movie-controller-in-flex/ 
 * and http://troyworks.com/blog/2007/09/17/avm2loader-converting-avm1-to-avm2/
 * 
 * AVM1MovieProxy
 * 
 * modified by sban 2009/2/21
 * http://blog.sban.com.cn/
 */

package com.pipe.utils
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	
	[Event(name="enterFrame", type="flash.events.Event")]
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	public class AVM1MvoieProxy extends Sprite
	{
		public function AVM1MvoieProxy()
		{
			this.addChild(_loader);
		}		
		
		private var _urlLoader : URLLoader;
		private var _loader:Loader = new Loader();
		private var _isReady : Boolean = false;
		private var _movieClip : MovieClip;
		
		public var url : String;
		public var autoPlay : Boolean = false;
		
		public function get currentFrame() : int
		{
			return isReady ? _movieClip.currentFrame : 0;
		}
		
		public function get totalFrames() : int
		{
			return isReady ? _movieClip.totalFrames : 0;
		}
		
		public function get isReady() : Boolean
		{
			return _isReady;
		}
		
		public function nextFrame() : void
		{
			if(isReady) _movieClip.nextFrame();
		}
		
		public function prevFrame() : void
		{
			if(isReady) _movieClip.prevFrame();
		}
		
		public function nextScene() : void
		{
			if(isReady) _movieClip.nextScene();
		}
		
		public function prevScene() : void
		{
			if(isReady) _movieClip.prevScene();
		}
		
		public function stop() : void
		{
			if(isReady) _movieClip.stop();
		}
		
		public function play() : void
		{
			if(isReady) _movieClip.play();
		}
		
		public function gotoAndStop(frame : Object, scene : String = null) : void
		{
			if(isReady) _movieClip.gotoAndStop(frame, scene);
		}
		
		public function gotoAndPlay(frame : Object, scene : String = null) : void
		{
			if(isReady) _movieClip.gotoAndPlay(frame, scene);
		}
		
		
		public function load(url : String = null):void
		{
			var path : String = url ? url : this.url;
			
			if(!path) return;
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			_urlLoader.load( new URLRequest(path));
		}		
		
		private function completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, completeHandler);
			
			var inputBytes:ByteArray = ByteArray(_urlLoader.data);
			inputBytes.endian = Endian.LITTLE_ENDIAN;
			
			if (isCompressed(inputBytes)) {
				uncompress(inputBytes);
			}			
			var version:uint = uint(inputBytes[3]); 
			if (version <= 10) { 
				if (version == 8 || version == 9 || version == 10){
					flagSWF9Bit(inputBytes);
				}
				else if (version <= 7) {
					insertFileAttributesTag(inputBytes);
				}
				updateVersion(inputBytes, 9);
			}
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			var lc : LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			_loader.loadBytes(inputBytes,lc);
		}
		
		private function loadCompleteHandler(event : Event) : void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			
			_movieClip = _loader.content as MovieClip;
			_isReady = true;
			dispatchEvent(new Event(Event.COMPLETE));
			
			if(!autoPlay) stop();
			
			_movieClip.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event : Event) : void
		{
			dispatchEvent(event);
		}
		
		/**
		 *  
		 * @param bytes
		 * @return 
		 * 
		 */		
		private function isCompressed(bytes:ByteArray):Boolean
		{
			//trace(bytes.toString());
			return bytes[0] == 0x43;
		}		
		
		private function uncompress(bytes:ByteArray):void
		{
			var cBytes:ByteArray = new ByteArray();
			cBytes.writeBytes(bytes, 8);
			bytes.length = 8;
			bytes.position = 8;
			cBytes.uncompress();
			bytes.writeBytes(cBytes);
			bytes[0] = 0x46;
			cBytes.length = 0;
		}		
		
		private function getBodyPosition(bytes:ByteArray):uint
		{
			var result:uint = 0;			
			result += 3; // FWS/CWS
			result += 1; // version(byte)
			result += 4; // length(32bit-uint)			
			var rectNBits:uint = bytes[result] >>> 3;
			result += (5 + rectNBits * 4) / 8; // stage(rect)			
			result += 2;			
			result += 1; // frameRate(byte)
			result += 2; // totalFrames(16bit-uint)			
			return result;
		}		
		
		private function findFileAttributesPosition(offset:uint, bytes:ByteArray):uint
		{
			bytes.position = offset;			
			try {
				for (;;) {
					var byte:uint = bytes.readShort();
					var tag:uint = byte >>> 6;
					if (tag == 69) {
						return bytes.position - 2;
					}
					var length:uint = byte & 0x3f;
					if (length == 0x3f) {
						length = bytes.readInt();
					}
					bytes.position += length;
				}
			}
			catch (e:EOFError) {
			}			
			return NaN;
		}
		
		private function flagSWF9Bit(bytes:ByteArray):void
		{
			var pos:uint = findFileAttributesPosition(getBodyPosition(bytes), bytes);
			if (!isNaN(pos)) {
				bytes[pos + 2] |= 0x08;
			}
		}
		private function insertFileAttributesTag(bytes:ByteArray):void
		{
			var pos:uint = getBodyPosition(bytes);
			var afterBytes:ByteArray = new ByteArray();
			afterBytes.writeBytes(bytes, pos);
			bytes.length = pos;
			bytes.position = pos;
			bytes.writeByte(0x44);
			bytes.writeByte(0x11);
			bytes.writeByte(0x08);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeBytes(afterBytes);
			afterBytes.length = 0;
		}
		private function updateVersion(bytes:ByteArray, version:uint):void
		{
			bytes[3] = version;
		}
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
		}
	}
	
}