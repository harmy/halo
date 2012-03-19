package com.cokecode.halo.terrain.layers
{
	
	/**
	 * 排序层 - 角色、物件、魔法和特效，位于此层，这层对象需要根据Y轴进行排序
	 */
	public class SortLayer extends Layer
	{
		public function SortLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
		}
	
		override protected function step(elapsed:Number):void {
			super.step(elapsed);
			
			// 进行排序
			children.sort( super.compare );
		}
		
	}
}