package com.cokecode.halo.controller
{
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.object.GameObject;
	import com.cokecode.halo.pathfinder.PathFinder;
	import com.cokecode.halo.terrain.Map;
	import flash.geom.Point;
	
	public class BasePlayerCtrl extends Controller
	{
		public static const DEFAULT_MOVE_SPEED:Number = 320; //默认的移动速度
		
		private var mChar:Charactor;
		private var mMoveTargetPos:Point = new Point;
		private var mPathNodes:Array; // Point Array
		
		// 自动寻路相关变量
		protected var mIsPathing:Boolean = false;			// 是否正在寻路中
		protected var mIsMoving:Boolean = false;
		protected var mMoveSpeed:Number = 320;				// 走一格的时间
		protected var mMoveTimePassed:Number = 0;			// 走动已用的时间
		protected var mMoveTimeNeed:Number = 0;				// 走到目标总共需要的时间
		protected var mStartPixel:Point = new Point;		// 开始移动时的像素坐标
		protected var mDestPixel:Point = new Point;			// 目标像素坐标
		
		public function BasePlayerCtrl(char:Charactor)
		{
			super();
			
			mChar = char;
		}
		
		/**
		 * 移动的目标点
		 */
		public function set moveTargetPos(value:Point):void
		{
			mMoveTargetPos = value;
		}
		
		public function get moveTargetPos():Point
		{
			return mMoveTargetPos;
		}
		
		/**
		 * 自动寻路返回的路径点数组
		 */
		public function set pathNodes(value:Array):void
		{
			mPathNodes = value;
		}
		
		public function get pathNodes():Array
		{
			return mPathNodes;
		}
		
		/**
		 * 自动寻路到目标点
		 * @param	tx	目标X(世界逻辑格X)
		 * @param	ty	目标Y(世界逻辑格Y)
		 * @param	mapid	目标地图
		 * @param	target	目标id
		 * @param	action	达到后的动作
		 */
		public function gotoPosByAutoPath(tx:int, ty:int, mapid:uint=0, target:uint=0, action:uint=0):Boolean
		{
			if (mChar == null) return false;
			
			var charX:Number = mChar.x / Map.sTileWidth;
			var charY:Number = mChar.y / Map.sTileHeight;
			
			if (charX == tx && charY == ty)
				return false;
			
			mPathNodes = PathFinder.instance.find(charX, charY, tx, ty);
			if (mPathNodes != null && mPathNodes.length > 1) {
				mPathNodes.shift();
			}
			
			return true;
		}
		
		/**
		 * 移动一个格子
		 * @param	tx
		 * @param	ty
		 */
		protected function moveOneGrid(tx:int, ty:int):Boolean
		{
			if (mChar == null) return false;
			
			var charX:Number = mChar.x / Map.sTileWidth;
			var charY:Number = mChar.y / Map.sTileHeight;
			
			if (charX == tx && charY == ty)
				return false;
				
			mStartPixel.x = mChar.x;
			mStartPixel.y = mChar.y;
			mDestPixel.x = tx * Map.sTileWidth;
			mDestPixel.y = ty * Map.sTileHeight;
			
			var gridNumX:int = Math.abs(tx - charX);
			var gridNumY:int = Math.abs(ty - charY);
			var gridNum:int = Math.max(gridNumX,gridNumY);
			mMoveTimeNeed = mMoveSpeed * gridNum;
			mMoveTimePassed = 0;
			
			mIsMoving = true;
			
			mChar.setDir(tx, ty);
			
			mChar.playAnim("run");
			
			return true;
		}
		
		/**
		 * 处理自动寻路
		 * @param	deltaTime	单位秒
		 */
		protected function movingHandler(elapsed:Number):void
		{
			if (mPathNodes == null) return;
			
			// 转换到毫秒
			elapsed = elapsed * 1000;
			
			// 累计时间流逝(秒转为毫秒)
			mMoveTimePassed += elapsed;
			
			// 根据移动速度调整跑步动作的帧速
			var rate:Number = mMoveSpeed / DEFAULT_MOVE_SPEED;
			//aniBody.setDuration("Run", DEF_DURATION * rate);
			
			// 计算移动位置
			var time:Number = mMoveTimePassed / mMoveTimeNeed;
			if (time > 1) time = 1;
			var pixelX2:Number = time * mDestPixel.x + (1 - time) * mStartPixel.x;
			var pixelY2:Number = time * mDestPixel.y + (1 - time) * mStartPixel.y;
			mChar.x = Math.round(pixelX2);
			mChar.y = Math.round(pixelY2);
			trace("charPos: " + mChar.x + "," + mChar.y);
			if (mChar.x == mDestPixel.x && mChar.y == mDestPixel.y) {
				
				//if (m_gridChangeCB != null) {
					//m_gridChangeCB();
				//}
				
				// 到达目标
				mPathNodes.shift();
				mIsMoving = false;
				//Output.Trace("走满1格");
				if (mPathNodes.length == 0) {
					// 整个寻路完成时再切换到待机动作
					mIsPathing = false;
					mChar.playAnim("stand");
					
					//mIsMoving = false;
					
					//this.model.playAction(ActionConst.ACT_STAND);
					//idle();	
				}
				/*
				if (isWillAttack)
				{
					// 清除寻路路径
					//this._pathArr = null;
					//isWillAttack = false;	// 清除攻击状态
					//attack();
				}
				else if (this._pathArr.length == 0) 
				{
					// 整个寻路完成时再切换到待机动作
					//idle();	
				}
				*/
			}
		}
		
		override protected function step(elapsed:Number):void
		{
			if(mPathNodes != null && mPathNodes.length > 0 && !mIsMoving) {
				var tgPt:Point = new Point();
				tgPt.x = mPathNodes[0].x;
				tgPt.y = mPathNodes[0].y;
				//Output.Trace("开始移动");
				if (!moveOneGrid(tgPt.x, tgPt.y)) {
					mPathNodes.shift();
				}
			}
			
			if (mPathNodes != null && mIsMoving) {
				movingHandler(elapsed);
			}
		}
	
	}
}