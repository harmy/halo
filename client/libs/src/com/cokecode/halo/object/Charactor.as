package com.cokecode.halo.object
{
	import com.cokecode.halo.anim.AnimMgr;
	import com.cokecode.halo.anim.Animation;
	import com.cokecode.halo.anim.AnmPlayer;
	import com.cokecode.halo.anim.Model;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.filters.GlowFilter;

	public class Charactor extends GameObject
	{
		protected var mAnmPlayer:AnmPlayer;	// 角色动画播放
		protected var mLooks:CharLooks;		// 外观数据
		
		
		public function Charactor(looks:CharLooks)
		{
			mLooks = looks;
			
			mAnmPlayer = new AnmPlayer(AnimMgr.sInstance.getAtlasTexMgr());
			addChild(mAnmPlayer);
		}
		
//		public function set charView(value:Sprite2D):void
//		{
//			mView = value;
//			removeChild(value);
//			addChild(value);
//		}
		
		public function getAnmPlayer():AnmPlayer
		{
			return mAnmPlayer;
		}
		
		public function getStr():String
		{
			return mLooks.mType.toString() + mId.toString();
		}
		
		public function get charView():Node2D
		{
			return mAnmPlayer;
		}
		
		override public function get width():Number
		{
			if (mAnmPlayer == null) return 0;
			return mAnmPlayer.width;
		}
		
		override public function get height():Number
		{
			if (mAnmPlayer == null) return 0;
			return mAnmPlayer.height;
		}
		
		
		override public function isInViewport(camera:Camera2D):Boolean
		{
			var nx:Number = x;
			var ny:Number = y - 64;
			var nWidth:Number = 128;
			var nHeight:Number = 128;
			
			if (nx + nWidth < camera.x)	// 图片移出相机左边
				return false;
			
			if (ny + nHeight < camera.y)	// 图片移出相机上边
				return false;
			
			if (nx > camera.x + camera.sceneWidth)	// 图片移出相机右边
				return false;
			
			if (ny > camera.y + camera.sceneHeight)	// 图片移出相机下边
				return false;
			
			return true;
		}
		
		
		/**
		 * 更新内部逻辑
		 */
		override protected function step(elapsed:Number):void {
			super.step(elapsed);
		
			if (mAnmPlayer) {
				mAnmPlayer.setDir(mDir);
				mAnmPlayer.update(elapsed);
			}
		}
	}
}

