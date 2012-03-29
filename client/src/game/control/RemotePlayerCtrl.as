package game.control
{
	import com.cokecode.halo.controller.BasePlayerCtrl;
	import com.cokecode.halo.object.Charactor;
	
	/**
	 * 其他角色的控制
	 * @author halo
	 */
	public class RemotePlayerCtrl extends BasePlayerCtrl 
	{
		protected var mTotalSec:Number = 0;
		
		
		public function RemotePlayerCtrl(char:Charactor) 
		{
			super(char);
			
		}
		
		override protected function step(elapsed:Number):void
		{
			super.step(elapsed);
			
			mTotalSec += elapsed;
			if (mTotalSec >= 0.5) {
				mTotalSec = 0;
				mChar.curHP = mChar.maxHP/2 + int(Math.random() * mChar.maxHP/2);
			}
			
/*			if (!mIsPathing) {
				var tx:Number = 50 + int(Math.random() * 50);
				var ty:Number = 50 + int(Math.random() * 50);
				gotoPosByAutoPath(tx, ty);
			}*/
		}
		
	}

}

