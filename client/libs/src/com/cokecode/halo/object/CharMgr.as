package com.cokecode.halo.object
{
	import com.cokecode.halo.utils.sprintf;
	
	import flash.utils.Dictionary;

	public class CharMgr
	{
		private static var sInstance:CharMgr = new CharMgr;
		
		protected var mCharDic:Dictionary = new Dictionary;
		protected var mHero:Charactor;
		
		public function CharMgr()
		{
			
		}
		
		public static function get instance():CharMgr
		{
			return sInstance;
		}

		public function clear():void
		{
			mCharDic = new Dictionary;
		}
		
		/**
		 * 添加一个角色到角色到管理器
		 * @char - 角色对象
		 * @type - 角色类型  exp. CharLooks.HUMAN, CharLooks.MONSTER
		 */
		public function addChar(char:Charactor, type:uint):Boolean
		{
			var strID:String = type.toString() + char.id.toString();
			if (mCharDic[strID] != null) {
				trace( sprintf("角色已存在, id=%d, type=%d", char.id, type) );
					return false;
			}
			mCharDic[strID] = char;
			return true;
		}
		
		/**
		 * 从管理器里获得一个角色的引用
		 * id - 角色id
		 * type - 角色类型
		 */
		public function getChar(id:uint, type:uint):Charactor
		{
			var strID:String = type.toString() + id.toString();
			return mCharDic[strID];
		}
		
		public function getCharByStr(str:String):Charactor
		{
			return mCharDic[str];
		}
		
		/**
		 * 主角对象
		 */
		public function set hero(value:Charactor):void
		{
			mHero = value;
		}
		
		/**
		 * 主角对象
		 */
		public function get hero():Charactor
		{
			return mHero;	
		}
		
	}
}