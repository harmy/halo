package com.cokecode.halo.object
{
	import com.cokecode.halo.anim.AnmPlayer;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.filters.GlowFilter;

	public class Charactor extends GameObject
	{
		static private var count:uint = 1;
		
		//protected var mAnmPlayer:AnmPlayer;	// 角色动画播放
		protected var mLooks:CharLooks;		// 外观数据
		protected var mView:Sprite2D;			// 以后要去掉
		
		
		public function Charactor(looks:CharLooks)
		{
			mLooks = looks;
			
			mId = count++;
			
			setNameText("我是玩家");
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
//			if (x + width < camera.x)
//				return false;
//			
//			if (y + width < camera.y)
//				return false;
//			
//			if ((x - height) > (camera.x + camera.sceneWidth))
//				return false;
//			
//			if ((y - height) > (camera.y + camera.sceneHeight))
//				return false;
			
			var halfW:Number = width * 0.5;
			var halfH:Number = height * 0.5;
			
			if (x + halfW < camera.x)	// 图片移出相机左边
				return false;
			
			if (y + halfH < camera.y)	// 图片移出相机上边
				return false;
			
			if (x - halfW > camera.x + camera.sceneWidth)	// 图片移出相机右边
				return false;
			
			if (y - halfH > camera.y + camera.sceneHeight)	// 图片移出相机下边
				return false;
			
			return true;
		}
		
		
		/**
		 * 更新内部逻辑
		 */
		override protected function step(elapsed:Number):void {
			super.step(elapsed);
		
			//if (mAnmPlayer) mAnmPlayer.Update();
		}
	}
}

