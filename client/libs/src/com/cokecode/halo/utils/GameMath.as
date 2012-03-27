package com.cokecode.halo.utils 
{
	import flash.geom.Point;
	/**
	 * 游戏相关的数学计算
	 * @author halo
	 */
	public class GameMath 
	{
		/**
		 * 计算方向
		 * 7 0 1
		 * 6 8 2
		 * 5 4 3
		 * @param	ptStart
		 * @param	ptDest
		 * @return
		 */
		static public function calDir(ptStart:Point, ptDest:Point):uint
		{
			var path:uint;
			
			if(ptStart.x==ptDest.x && ptStart.y==ptDest.y) 		// 不改变方向
				path=8;
			else if(ptStart.x<ptDest.x && ptStart.y<ptDest.y)	// 右下
				path=3;
			else if(ptStart.x<ptDest.x && ptStart.y==ptDest.y)	// 右
				path=2;
			else if(ptStart.x<ptDest.x && ptStart.y>ptDest.y)	// 右上
				path=1;
			else if(ptStart.x==ptDest.x && ptStart.y>ptDest.y)	// 上
				path=0;
			else if(ptStart.x>ptDest.x && ptStart.y>ptDest.y)	// 左上
				path=7;
			else if(ptStart.x>ptDest.x && ptStart.y==ptDest.y)	// 左
				path=6;
			else if(ptStart.x>ptDest.x && ptStart.y<ptDest.y)	// 左下
				path=5;
			else if(ptStart.x==ptDest.x && ptStart.y<ptDest.y)	// 下
				path=4;
			else path=8;
			
			return path;
		}
		
	}

}