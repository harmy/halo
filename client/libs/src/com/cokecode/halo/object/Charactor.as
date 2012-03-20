package com.cokecode.halo.object
{
	import de.nulldesign.nd2d.display.Camera2D;
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
		
		override public function get width():Number
		{
			return mView.width;
		}
		
		override public function get height():Number
		{
			return mView.height;
		}
		
		
		override public function isInViewport(camera:Camera2D):Boolean
		{
			if (x + width < camera.x)
				return false;
			
			if (y + width < camera.y)
				return false;
			
			if ((x - height) > (camera.x + camera.sceneWidth))
				return false;
			
			if ((y - height) > (camera.y + camera.sceneHeight))
				return false;
			
			return true;
		}
		
		
		/**
		 * 更新内部逻辑
		 */
		override protected function step(elapsed:Number):void {
			super.step(elapsed);
			
		}
	}
}

