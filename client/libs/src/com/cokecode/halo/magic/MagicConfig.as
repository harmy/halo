package com.cokecode.halo.magic
{
	/**
	 * 单个魔法配置单元
	 * */
	public final class MagicConfig
	{
		public var mID:uint					= 0;		//唯一id	
		public var mLayer:uint					= 0;		//0人前，1人后
		public var mType:uint					= 0;		//0自身，1飞行，2目标
		public var mEndType:uint				= 0;		//0播放完，1持续一段时间，2手动结束
		public var mOffx:uint					= 0;		//x偏移
		public var mOffy:uint					= 0;		//y偏移
		public var mScale:uint					= 0;		//放大倍数
		public var mBlend:uint					= 0;		//混合方式
		public var mDuration:uint				= 0;		//持续时间
		public var mSound:uint					= 0;		//声音
		public var mAniSpeed:uint				= 0;		//动画速度
		public var mFlySpeed:uint				= 0;		//飞行速度
		public var mOption:uint				= 0;		//其他选项
		public var mChild:MagicConfig						//子节点
		public var mSibling:MagicConfig					//弟兄节点
		
		public function MagicConfig()
		{
		}
	}
}