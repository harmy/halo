package com.cokecode.halo.magic
{
	internal final class MagicConfig
	{
		public var mRootID:uint				= 0;		//技能或特效编号
		public var mTexID:uint					= 0;		//贴图id
		public var mTexDirCount:uint			= 0;		//贴图方向数量
		public var mLayer:uint					= 0;		//参考MagicConst
		public var mType:uint					= 0;		//参考MagicConst
		public var mEndType:uint				= 0;		//参考MagicConst
		public var mOffx:int					= 0;		//x偏移
		public var mOffy:int					= 0;		//y偏移
		public var mScale:uint					= 0;		//放大倍数
		public var mBlend:uint					= 0;		//混合方式
		public var mDuration:uint				= 0;		//持续时间
		public var mSound:uint					= 0;		//声音
		public var mBuff:uint					= 0;		//是否是状态魔法效果，0不是，1代表是
		public var mAniSpeed:uint				= 0;		//动画速度
		public var mFlySpeed:uint				= 0;		//飞行速度
		public var mOption:uint				= 0;		//其他选项
		
		public var mChild:MagicConfig						//子节点
		public var mSibling:MagicConfig					//弟兄节点
		public var mParent:MagicConfig;					//父节点
		
		public function MagicConfig()
		{
		}
	}
}