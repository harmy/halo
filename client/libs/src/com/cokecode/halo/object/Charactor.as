package com.cokecode.halo.object
{
	import com.cokecode.halo.anim.AnimMgr;
	import com.cokecode.halo.anim.Animation;
	import com.cokecode.halo.anim.AnmPlayer;
	import com.cokecode.halo.anim.Model;

	import com.cokecode.halo.display.LifeBar;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.utils.GameMath;
	import de.nulldesign.nd2d.display.Quad2D;
	import de.nulldesign.nd2d.display.TextureRenderer;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.cokecode.halo.magic.MagicMgr;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.utils.GameMath;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Charactor extends GameObject
	{
		protected var mAnmPlayer:AnmPlayer;					// 角色动画播放
		protected var mLooks:CharLooks;						// 外观数据
		protected var mMoveSpeed:Number = 320;				// 走一格的时间
		protected var mLifeBar:LifeBar;			// 生命条
		protected var mCurHP:uint = 10000;
		protected var mMaxHP:uint = 10000;
		private var mMagicDic:Dictionary = new Dictionary; //释放的魔法管理器		
		
		public function Charactor(looks:CharLooks)
		{
			mLooks = looks;
			
			mAnmPlayer = new AnmPlayer(AnimMgr.instance.getAtlasTexMgr());
			addChild(mAnmPlayer);
			
			mLifeBar = new LifeBar;
			addChild(mLifeBar);
			mLifeBar.x = 30;
			mLifeBar.y = -95;
			
			refreshHP();
		}
		
		protected function refreshHP():void
		{
			if (mLifeBar) mLifeBar.setValue(mCurHP, mMaxHP);
		}
		
		public function get curHP():uint
		{
			return mCurHP;
		}
		
		public function set curHP(value:uint):void
		{
			if (mCurHP != value) {
				mCurHP = value;
				refreshHP();
			}
		}
		
		public function get maxHP():uint
		{
			return mMaxHP;
		}
		
		public function set moveSpeed(value:Number):void
		{
			mMoveSpeed = value;
		}
		
		/**
		 * 移动一步需要的时间(毫秒)
		 */
		public function get moveSpeed():Number
		{
			return mMoveSpeed;
		}
		
		public function playAnim(aniName:String = null):void
		{
			if (mAnmPlayer) mAnmPlayer.playAnim(aniName);
		}
		
		public function get anmPlayer():AnmPlayer
		{
			return mAnmPlayer;
		}
		
		public function getStr():String
		{
			return mLooks.mType.toString() + mId.toString();
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
		
		public function delMagic(id:uint):void
		{
			var arr:Array = mMagicDic[id];
			
			if(arr == null)
			{
				return;
			}
			
			for each(var id:uint in arr)
			{
				MagicMgr.instance.delMagic(id);
			}
			
			delete mMagicDic[id];
		}
		
		public function addMagic(rootID:uint, id:uint):void
		{
			var arr:Array = mMagicDic[rootID];
			
			if(arr == null)
			{
				arr = new Array;				
			}
			
			arr.push(id);
			mMagicDic[rootID] = arr;			
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
		 * 设置当前方向
		 * @param	tx	目标X(世界逻辑格坐标)
		 * @param	ty	目标Y(世界逻辑格坐标)
		 */
		public function setDir(tx:Number, ty:Number):void
		{
			var gridX:Number = x / Map.sTileWidth;
			var gridY:Number = y / Map.sTileHeight;
			var nDir:uint = GameMath.calDir(new Point(gridX, gridY), new Point(tx, ty));
			if (nDir != 8) {
				this.dir = nDir;	
			}
		}
		
		/**
		 * 更新内部逻辑
		 */
		override protected function step(elapsed:Number):void {
			super.step(elapsed);
		
			if (mAnmPlayer) {
				mAnmPlayer.dir = mDir;
				mAnmPlayer.update(elapsed);
			}
		}
	}
}

