package com.cokecode.halo.anim
{
	import flash.utils.Dictionary;

	/**
	 * 动作数据配置
	 */
	public class ActionParam
	{
		/**
		 * 存储每个动作的帧数
		 */
		protected var mActionFrameDic:Dictionary = new Dictionary;
		
		/**
		 * name -> id
		 */
		protected var mActionIdDic:Dictionary = new Dictionary;
		
		/**
		 * id -> name
		 */
		protected var mActionNameDic:Dictionary = new Dictionary;
		
		/**
		 * 记录每个动作的下标(只适用于多个动作集合在一张贴图)
		 */
		protected var mActionIndexDic:Dictionary = new Dictionary;
		protected var mFrameCount:uint;
		
		
		public function ActionParam():void
		{
			iniDefault();
		}
		
		/**
		 * 初始化系统默认动作
		 */
		protected function iniDefault():void
		{
			// 添加顺序必须要按照贴图集合中的顺序
			addAction("stand", 	1,		2,		8);
			addAction("death", 	2, 		2,		8);
			addAction("attack",	3, 		6,		8);
			addAction("walk", 		4, 		8,		8);
			addAction("run", 		5, 		8,		8);
			addAction("magic", 	6, 		4,		8);
		}
		
		/**
		 * 清除所有动作
		 */
		public function clear():void
		{
			mActionFrameDic = new Dictionary;
			mActionIdDic = new Dictionary;
			mActionNameDic = new Dictionary;
			mActionIndexDic = new Dictionary;
			mFrameCount = 0;
		}
		
		/**
		 * 添加动作
		 * @param name	动作名称
		 * @param id	动作id
		 * @param frames	 动作的帧数
		 * @param dirs	这个动作的方向数目
		 */
		public function addAction(name:String, id:uint, frames:uint, dirs:uint = 8):void
		{
			mActionFrameDic[name] = frames;
			mActionIdDic[name] = id;
			mActionNameDic[id] = name;
			mActionIndexDic[name] = mFrameCount; 
			mFrameCount += frames * dirs;
		}
		
		/**
		 * 动作名称转为ID
		 */
		public function nameToId(name:String):uint
		{
			return mActionIdDic[name];
		}
		
		/**
		 * 动作ID转为名称
		 */
		public function idToName(actId:uint):String
		{
			return mActionNameDic[actId];	
		}
		
		/**
		 * 获得动作的贴图下标起始位置
		 */
		public function getActionIndex(name:String):uint
		{
			return mActionIndexDic[name];
		}
		
		
	}
	
}