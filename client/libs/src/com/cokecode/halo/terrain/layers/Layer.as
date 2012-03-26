package com.cokecode.halo.terrain.layers
{
	import com.cokecode.halo.object.GameObject;
	import com.cokecode.halo.object.IClip;
	import com.cokecode.halo.terrain.tmx.TMX;
	import com.cokecode.halo.terrain.tmx.TMXLayer;
	
	import de.nulldesign.nd2d.display.Node2D;
	
	import flash.utils.Dictionary;

	/**
	 * 层的基类
	 */
	public class Layer extends Node2D
	{
		/**
		 * 层的名字
		 */
		protected var mLayerName:String;
		
		protected var mTMX:TMX;
		protected var mTMXLayer:TMXLayer;
		
//		/**
//		 * 层的宽度(格子数)
//		 */
//		protected var mLayerWidth:uint;
//		
//		/**
//		 * 层的高度(格子数)
//		 */
//		protected var mLayerHeight:uint;
		
		/**
		 * 该层包含的属性键值对
		 */
		protected var mProps:Dictionary;
		
		/**
		 * 存储裁剪掉的对象
		 */
		protected var mChildrenClip:Dictionary = new Dictionary;	// Node2D

		
		public function Layer(name:String, width:uint, height:uint)
		{
			mLayerName = name;
//			mLayerWidth = width;
//			mLayerHeight = height;
		}
		
		public function setTMXData(tmx:TMX, tmxLayer:TMXLayer):void
		{
			mTMX = tmx;
			mTMXLayer = tmxLayer;
		}
		
		public function initData():void
		{
			//TODO
		}
		
		// 获得阻挡信息
		public function getBlock(x:int, y:int):int
		{
			if (mTMX == null || mTMXLayer == null) return 0;
			
			var block:int = mTMXLayer.getCell(x, y);
			if (block == 0) return 0;
			
			return mTMX.getImgFrame(block) + 1;
		}
		
		public function get layerName():String
		{
			return mLayerName;
		}
		
//		public function get layerWidth():uint
//		{
//			return mLayerWidth;
//		}
//		
//		public function get layerHeight():uint
//		{
//			return mLayerHeight;
//		}
		
		public function clear():void
		{
			dispose();
			removeAllChildren();
			mChildrenClip = new Dictionary;
		}
		
		override public function removeChild(child:Node2D):void {
			
			// 先删除裁剪掉的对象
			delete mChildrenClip[child];
			
			super.removeChild(child);
		}
		
		override public function removeChildAt(idx:uint):void {
			var child:Node2D = getChildAt(idx);
			if (child == null) return;
			
			// 先删除裁剪掉的对象
			delete mChildrenClip[child];
			
			// 再删除容器内的对象
			super.removeChildAt(idx);
		}

		
		/**
		 * 对象进行裁剪
		 */
		public function clip():void
		{
			var child:IClip;
			
			// 处理裁剪掉的对象
			for each(child in mChildrenClip) {
				if ( child.isInViewport(camera) ) {
					super.addChild(child as Node2D);
					delete mChildrenClip[child];
				}
			}
			
			// 处理容器内的对象
			for (var i:uint=0; i<numChildren; ++i) {
				child = this.getChildAt(i) as IClip;
				if (child == null) continue;
				if ( !child.isInViewport(camera) ) {
					mChildrenClip[child] = child;
					super.removeChildAt(i);
				}
			}
			
			//if (numChildren) trace("对象数： " + numChildren);
		}
		
		override protected function step(elapsed:Number):void 
		{
			// 根据相机位置，进行裁剪
			clip();
		}
		
		/**
		 * 层内对象的默认排序规则
		 * 根据Y轴行进排序
		 */
		protected function compare(paraA:Node2D,paraB:Node2D):int
		{
			var resultA:int = paraA.y
			var resultB:int = paraB.y;
			if(resultA > resultB) return 1;
			if(resultA < resultB) return -1;
			return 0;
		}
	}
}