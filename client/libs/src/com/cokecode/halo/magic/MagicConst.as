package com.cokecode.halo.magic
{		
	/**
	 * 魔法常量说明
	 * */
	public final class MagicConst
	{
		//魔法播放层
		public static const LAYER_BEFORE_PLAYER:uint			= 1;				//人前
		public static const LAYER_AFTER_PLAYER:uint			= 2;				//人后
		
		//魔法类型
		public static const TYPE_SELF:uint					= 1;				//自身魔法
		public static const TYPE_FLY:uint						= 2;				//飞行魔法
		public static const TYPE_DESTINATION:uint				= 3;				//目标魔法
		
		//魔法结束方式
		public static const END_TYPE_ANIMATION_OVER:uint		= 1;				//动画播放完
		public static const END_TYPE_DURATION:uint			= 2;				//持续一段时间
		public static const END_TYPE_MANUAL:uint				= 3;				//根据逻辑需要手动结束	
		
		//其他魔法选项
		public static const OPT_FOLLOW_TARGET:uint			= 1 << 0;			//表示跟随目标
		public static const OPT_NO_TARGET_END:uint			= 1 << 1;			//没目标时结束魔法播放
		public static const OPT_NO_TARGET_CONTINUE:uint		= 1 << 2;			//没有目标时继续播放		
		
		public static const STR_LAYER_BEFOR:String			= "magic_before"; //人物前魔法层名称
		public static const STR_LAYER_AFTER:String			= "magic_after";	//人物后魔法层名称
		
		public function MagicConst()
		{
			throw new Error("this class can't be instantiated");
		}
	}
}