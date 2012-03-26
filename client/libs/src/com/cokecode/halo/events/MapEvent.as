package com.cokecode.halo.events
{
	import flash.events.Event;
	
	public class MapEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		private var mId:uint;
		private var mWidth:uint;
		private var mHeight:uint;
				
		public function MapEvent(type:String, id:uint, width:uint, height:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			mId = id;
			mWidth = width;
			mHeight = height;
		}
		
		
		public function get height():uint
		{
			return mHeight;
		}

		public function set height(value:uint):void
		{
			mHeight = value;
		}

		public function get width():uint
		{
			return mWidth;
		}

		public function set width(value:uint):void
		{
			mWidth = value;
		}

		public function get id():uint
		{
			return mId;
		}

		public function set id(value:uint):void
		{
			mId = value;
		}

	}
}