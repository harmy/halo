package com.cokecode.halo.object
{
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.filters.GlowFilter;

	public class Charactor extends GameObject
	{
		static private var count:uint = 1;
		
		protected var mLooks:CharLooks;
		protected var mView:Sprite2D;
		
		
		public function Charactor(looks:CharLooks)
		{
			mLooks = looks;
			
			mId = count++;
		}
		
		public function set charView(value:Sprite2D):void
		{
			mView = value;
			removeChild(value);
			addChild(value);
		}
		
		public function get charView():Sprite2D
		{
			return mView;
		}
		
//		override public function get width():Number
//		{
//			return mView.frameWidth;
//		}
//		
//		override public function get height():Number
//		{
//			return mView.frameHeight;
//		}
		
		/*
		override public function inViewport(camera:Camera):Boolean
		{
//			if (camera.x > x + 128)
//				return false;
//			
//			if (camera.y > y + 128)
//				return false;
//			
//			if (camera.right < (x - 128))
//				return false;
//			
//			if (camera.bottom < (y - 128))
//				return false;
			
			if (camera.x > x + width/2)
				return false;
			
			if (camera.y > y + height)
				return false;
			
			if (camera.right < (x - width/2))
				return false;
			
			if (camera.bottom < (y - height))
				return false;
			
			return true;
		}
		*/
		
		/**
		 * 更新内部逻辑
		 */
		override protected function step(elapsed:Number):void {
			super.step(elapsed);
			
		}
	}
}

