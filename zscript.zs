Version 4.3

#include "zscript/BW/Materials.zs"
#include "zscript/BW/Weapons/WeaponBase.zs"
#include "zscript/BW/Weapons/BWProjectiles.zs"
#include "zscript/BW/Monsters/MonsterBase.zs"
#include "zscript/BW/Monsters/AIBase.zs"
#include "zscript/BW/Effects/Effects.zs"
#include "zscript/BW/Hud/BWHud.zs"
#include "zscript/BW/Player/BWPlayer.zs"

//Weapons
#include "zscript/BW/Weapons/Slot1/Fists.zs"
#include "zscript/BW/Weapons/Slot2/Luger.zs"
#include "zscript/BW/Weapons/Slot3/MP40.zs"
#include "zscript/BW/Weapons/Slot4/Trenchgun.zs"
#include "zscript/BW/Weapons/Throwables/grenades.zs"

//Monsters
#include "zscript/BW/Monsters/BrownGuard/Pistol.zs"
#include "zscript/BW/Monsters/BlueGuard/MP40.zs"
#include "zscript/BW/Monsters/BlueGuard/Shotgun.zs"
#include "zscript/BW/Monsters/Dogs/Doggie.zs"

#include "zscript/BW/Monsters/Spawners.zs"


//Map props
#include "zscript/BW/Maps/DecorationsBase.zs"

//Items
#include "zscript/BW/Items/Treasures.zs"

//NashGore
#include "zscript/NashGore/NashGoreMath.zc"
#include "zscript/NashGore/NashGorePlugin.zc"
#include "zscript/NashGore/NashGoreGameplayStatics.zc"
#include "zscript/NashGore/NashGoreFloaterDetector.zc"
#include "zscript/NashGore/NashGoreHandler.zc"
#include "zscript/NashGore/NashGoreBlood.zc"
#include "zscript/NashGore/NashGoreBloodPlane.zc"
#include "zscript/NashGore/NashGoreGibs.zc"
#include "zscript/NashGore/NashGoreRealGibs.zc"
#include "zscript/NashGore/NashGoreCrushedGibs.zc"
#include "zscript/NashGore/NashGoreSquishyGibs.zc"
#include "zscript/NashGore/NashGoreIceChunk.zc"
#include "zscript/NashGore/NashGoreLiquidBlood.zc"
#include "zscript/NashGore/NashGoreActor.zc"
#include "zscript/NashGore/NashGoreCorpseHitbox.zc"
#include "zscript/NashGore/NashGoreTestMonster.zc"
#include "zscript/NashGore/NashGoreOptionMenu.zc"

#include "zscript/BW/Gore/BWGibs.zs"
#include "zscript/BW/Gore/BWHitBox.zs"

// global constants
const STAT_NashGore_Gore = Thinker.STAT_USER + 1;
const STAT_CASING = thinker.STAT_USER + 2;
const STAT_FLATDECAL = thinker.STAT_USER + 3;
const SLAUGHTERMAP_DIST = 1000.0;
const MAP_EPSILON = 1 / 65536.;


// fuck 
Class CustomInventoryBW2 : CustomInventory
{

	Action void A_CheckGrenade()
	{
		player.SetPSprite(PSP_WEAPON,player.ReadyWeapon.FindState('GrenadeFlash'));
	}

	Action void A_SlideCheck() 
	{
		player.SetPSprite(PSP_WEAPON,player.ReadyWeapon.FindState('SlideFlash'));
	}

	Action void A_CheckKnife()
	{
		player.SetPSprite(PSP_WEAPON,player.ReadyWeapon.FindState('KnifeFlash'));
	}

	Action void A_CheckAxe()
	{
		player.SetPSprite(PSP_WEAPON,player.ReadyWeapon.FindState('AxeFlash'));
	}
	
	action void KickDoors(int dist = 70)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz, data: t);
		if(t.hitline)
			t.hitline.Activate(player.mo,t.lineside,SPAC_USE);
	}
	
	const SlideSpeed = 17;
	double slideAngle;
	
	action void BW_SlideThrust(double force = 2)
	{
		velfromangle(force,invoker.slideAngle);
	}
	
	action void BW_SlideDirSet(bool reset = false)
	{
		if(reset)
			invoker.slideAngle = 0.0;
		else
			invoker.slideAngle = Angle - VectorAngle(player.cmd.forwardmove, player.cmd.sidemove);
	}
	
}

