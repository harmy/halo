package com.cokecode.halo.object
{
	import com.cokecode.halo.controller.Controller;
	import com.cokecode.halo.data.CoreConst;
	import com.cokecode.halo.display.TextField;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.utils.GameMath;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.display.TextureRenderer;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	

	/**
	 * 游戏对象： 玩家、NPC、怪物、宠物、等等
	 */
	public class GameObject extends Node2D implements IClip
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
		protected var mTFName:TextField = new TextField;
		
		/**
		 * 高度
		 */
		protected var mHeight:uint = 0;
		
		
		public function GameObject()
		{
			// 名字
			addChild(mTFName);
			
			// 初始化名字的参数
			mTFName.pivot.x = -32;
			mTFName.pivot.y = 16;
			mTFName.y = -63;
			mTFName.textColor = 0xFFFFFF;
			mTFName.filter = [CoreConst.GLOW_FILTER1];
		}
		
		public function setNameText(name:String):void
		{
			mTFName.text = name;
		}
		
		public function setNameColor(color:uint):void
		{
			mTFName.textColor = color;
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
		
		/**
		 * 判断物体是否在摄像机的可是范围内
		 */
		public function isInViewport(camera:Camera2D):Boolean
		{
			return false;
		}
	}
}