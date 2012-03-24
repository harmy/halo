package com.cokecode.halo.utils
{
	import flash.net.SharedObject;

	/**
	 * flash本地存储功能(不同于浏览器的cookie)
	 */
	public class Cookie
	{
		private var mName:String;
		private var mSharedObj:SharedObject;
		
		public function Cookie(name:String = "System")
		{
			this.name = name;
		}
		
		public function get name():String
		{
			return mName;
		}
		
		public function set name(value:String):void
		{
			mName = value;
			mSharedObj = SharedObject.getLocal("zscs/" + mName);
		}
		
		public function write(key:String, value:*, flush:Boolean = true):void
		{
			if (mSharedObj.data.cookie == undefined) {
				var obj:Object = {};
				obj[key] = value;
				mSharedObj.data.cookie = obj;
			} else {
				mSharedObj.data.cookie[key] = value;
			}
			
			try {
				if (flush) {
					mSharedObj.flush();
				}	
			} catch (err:Error) {
				trace(err.message);				
			}
		}
		
		public function read(key:String):*
		{
			return isExist(key) ? mSharedObj.data.cookie[key] : null;
		}
		
		public function isExist(key:String):Boolean
		{
			if (mSharedObj.data.cookie == undefined)
				return false;
			
			if (mSharedObj.data.cookie[key] == undefined)
				return false;
			
			return true;
		}
		
		public function remove(key:String):void
		{
			if (!isExist(key))
				return;
			
			delete mSharedObj.data.cookie[key];
			mSharedObj.flush();
		}
		
		public function clear():void
		{
			mSharedObj.clear();
		}
		
	}
}


