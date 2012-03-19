package game.magic
{
	/*
	魔法配置说明 (暂时备注在这里)
	1.魔法层: 人前 人后
	2.释放位置: 自身 飞行 目标
	3.结束判断: 播放完 持续一段时间 持续到收到指令 飞行到目标点 飞行出屏幕
	4.声音
	5.选项：是否跟随飞行 播放到最后一帧时保持 飞行速度 动画速度 offx offy 持续时间 放大倍数 blend
	*/
	
	public final class MagicNode
	{
		private var mID:uint					= 0;		//唯一id	
		private var mLayer:uint				= 0;		//0人前，1人后
		private var mType:uint					= 0;		//0自身，1飞行，2目标
		private var mEndType:uint				= 0;		//0播放完，1持续一段时间，2持续至收到指令，3飞行至目标，4飞出屏幕
		private var mOffx:uint					= 0;		//x偏移
		private var mOffy:uint					= 0;		//y偏移
		private var mScale:uint				= 0;		//放大倍数
		private var mBlend:uint				= 0;		//混合方式
		private var mDuration:uint				= 0;		//持续时间
		private var mSound:uint				= 0;		//声音暂不实现	
		private var mAniSpeed:uint				= 0;		//动画速度
		private var mFlySpeed:uint				= 0;		//飞行速度
		private var mOption:uint				= 0;		//其他选项
		private var mChild:MagicNode						//子节点
		private var mSibling:MagicNode						//弟兄节点
		
		public function MagicNode()
		{
		}
	}
}