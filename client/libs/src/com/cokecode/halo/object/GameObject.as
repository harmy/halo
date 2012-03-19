package com.cokecode.halo.object
{
	import com.cokecode.halo.controller.Controller;
	
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.TextField2D;
	

	/**
	 * 游戏对象： 玩家、NPC、怪物、宠物、等等
	 */
	public class GameObject extends Node2D
	{
		/**
		 * 唯一ID
		 */
		protected var mId:uint;
		
		/**
		 * 逻辑控制单元
		 */
		protected var mController:Controller;
		
		/**
		 * 方向
		 */
		protected var mDir:uint;
		
		/**
		 * 是否显示名字
		 */
		protected var mIsShowName:Boolean = true;
		
		/**
		 * 显示的名字
		 */
		protected var mTFName:TextField2D = new TextField2D;
		
		/**
		 * 高度
		 */
		protected var mHeight:uint = 0;
		

		
		public function GameObject()
		{
			mTFName.x = -mTFName.width / 2 - mTFName.textWidth / 2;
			mTFName.y = -90;
			mTFName.textColor = 0xFFFFFF;
			//mTFName.filter = [CoreConst.GLOW_FILTER1];
			mTFName.text = "我的名字";


			addChild(mTFName);
		}
		
		
		public function set id(value:uint):void
		{
			mId = value;
		}
		
		public function get id():uint
		{
			return mId;
		}

		public function set controller(ctrl:Controller):void
		{
			mController = ctrl;
		}
		
		public function get controller():Controller
		{
			return mController;
		}
		
		public function updateController():void
		{
			if (mController) mController.update()
		}
		
		public function set dir(value:uint):void
		{
			mDir = value;
		}
		
		public function get dir():uint
		{
			return mDir;
		}
		
		/**
		 * 更新内部逻辑
		 */
		override protected function step(elapsed:Number):void {
			
		}
		
//		/**
//		 * 判断物体是否在摄像机的可是范围内
//		 */
//		public function inViewport(camera:Camera):Boolean
//		{
//			return false;
//		}
	}
}