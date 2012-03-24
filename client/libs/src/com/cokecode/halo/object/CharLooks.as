package com.cokecode.halo.object
{
	public class CharLooks
	{
		static public const HUMAN:uint	=	0;	// 玩家
		static public const NPC:uint 		=	1;	// npc
		static public const MONSTER:uint	=	2;	// 怪物
		static public const PET:uint		=	3;	// 宠物
		
		public var mType:uint;			//类型		人类，NPC，怪物, 宠物
		public var mBody:uint;			// 0 服装		如果是怪物的话为怪物ID
		public var mHelmet:uint;		// 1 头发类型	
		public var mColor:uint;		// 2 衣服颜色
		public var mWeapon:uint;		// 3 武器ID
		public var mWings:uint			// 4-7 翅膀
		
		public function CharLooks()
		{
		}
		
		public function IsMonster():Boolean
		{
			return mType==MONSTER;
		}
		
		public function IsHuman():Boolean
		{
			return mType==HUMAN;
		}
		
		public function IsNpc():Boolean
		{
			return mType==NPC;
		}

	}
}