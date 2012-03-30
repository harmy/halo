package com.cokecode.halo.magic
{
	import com.cokecode.halo.object.GameObject;
	
	import de.nulldesign.nd2d.geom.Face;
	
	import flash.geom.Point;
	
	/**
	 * 飞行类魔法
	 * */
	internal class MagicFly extends MagicBase
	{
		private var lastAngle:Number		= 0;			//表示失去目标时的飞行角度
		private var lastTargetX:Number		= 0;
		private var lastTargetY:Number		= 0;
		private var lastSign:Point			= new Point;
		
		protected override function doInit():void
		{
			x = mSrcX + mConfig.mOffx;
			y = mSrcY + mConfig.mOffy;
		}
		
		private function isInValidRange():Boolean
		{			
			var cameraCenterX:int = camera.x + camera.sceneWidth / 2;
			var cameraCenterY:int = camera.y + camera.sceneHeight / 2;
			
			return Math.abs(cameraCenterX - x) < MagicConst.VALID_RANGE && 
				Math.abs(cameraCenterY - y) < MagicConst.VALID_RANGE;
			
		}
		
		protected override function isEnd():Boolean
		{
			if(!isInValidRange())
			{
				return true;
			}
			
			var targetObjExist:Boolean = true;
			var targetObjX:int = mTargetX + mConfig.mOffx;
			var targetObjY:int = mTargetY + mConfig.mOffy;
			
			if((mConfig.mOption & MagicConst.OPT_FOLLOW_TARGET) > 0) //跟随目标
			{
				//目标不存在
				if(!targetObjExist)
				{
					if((mConfig.mOption & MagicConst.OPT_NO_TARGET_END) > 0)
					{
						return true;
					}
					
					return false;
				}
				
				return Math.abs(x - targetObjX) <= MagicConst.DIS_TOLERANCE && Math.abs(y - targetObjY) <= MagicConst.DIS_TOLERANCE;
			}			
			
			return Math.abs(x - targetObjX) <= MagicConst.DIS_TOLERANCE && Math.abs(y - targetObjY) <= MagicConst.DIS_TOLERANCE;
		}
		
		private function getDisSign(srcX:Number, srcY:Number, destX:Number, destY:Number):Point
		{
			var pt:Point = new Point;
			
			if(srcX > destX)
			{
				pt.x = -1;
			}
			else
			{
				pt.x = 1;
			}
			
			if(srcY > destY)
			{
				pt.y = -1;
			}
			else
			{
				pt.y = 1;
			}
			
			return pt;
		}
		
		protected override function update(elapsed:Number):void
		{	
			var targetObjExist:Boolean = true;
			var targetObjX:int = mTargetX + mConfig.mOffx;
			var targetObjY:int = mTargetY + mConfig.mOffy;
			var targetX:int = mTargetX + mConfig.mOffx;
			var targetY:int = mTargetY + mConfig.mOffy;
			var dis:Number = elapsed * mConfig.mFlySpeed;
			var xDis:Number = 0;
			var yDis:Number = 0;
			
			if((mConfig.mOption & MagicConst.OPT_FOLLOW_TARGET) > 0) //跟随目标
			{
				//目标不存在
				if(!targetObjExist)
				{		
					if((mConfig.mOption & MagicConst.OPT_NO_TARGET_END) > 0)
					{
						return;
					}
					
					xDis = Math.cos(lastAngle) * dis;
					yDis = Math.sin(lastAngle) * dis;
					xDis = Math.abs(xDis);
					yDis = Math.abs(yDis);
					xDis *= lastSign.x;
					yDis *= lastSign.y;
					x += xDis;
					y += yDis;
					
					return;
				}
				
				lastAngle = Math.atan2(targetObjY - y, targetObjX - x);
				lastTargetX = targetObjX;
				lastTargetY = targetObjY;
			} 	
			else
			{
				lastAngle = Math.atan2(targetY - y, targetX - x);
				lastTargetX = targetX;
				lastTargetY = targetY;				
			}
			
			xDis = Math.cos(lastAngle) * dis;
			yDis = Math.sin(lastAngle) * dis;
			xDis = Math.abs(xDis);
			yDis = Math.abs(yDis);
			lastSign = getDisSign(x, y, lastTargetX, lastTargetY);
			xDis *= lastSign.x;
			yDis *= lastSign.y;
			x += xDis;
			y += yDis;
		}
	}
}







