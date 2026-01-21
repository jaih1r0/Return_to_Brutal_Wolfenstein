Version 4.10

#include "zscript/BW/Handlers/Materials.zs"
#include "zscript/BW/Handlers/BWHandler.zs"
#include "zscript/BW/BW_Statics.zs"
#include "zscript/BW/MathNMixins.zs"

#include "zscript/BW/Spawners/SpawnerBase.zs"

#include "zscript/BW/Weapons/Base/WeaponBase.zs"
#include "zscript/BW/Weapons/Base/WeaponBase_Functions.zs"
#include "zscript/BW/Weapons/Base/WeaponBase_States.zs"
#include "zscript/BW/Weapons/BWProjectiles.zs"
#include "zscript/BW/Weapons/EnemyProjectiles.zs"
#include "zscript/BW/Monsters/MonsterBase.zs"
#include "zscript/BW/Monsters/AIBase.zs"
#include "zscript/BW/Monsters/BossesBase.zs"
#include "zscript/BW/Effects/Effects.zs"
#include "zscript/BW/Effects/Puffs.zs"
#include "zscript/BW/Effects/Footsteps.zs"
#include "zscript/BW/Effects/Debris.zs"
#include "zscript/BW/Effects/Casings.zs"
#include "zscript/BW/Hud/BWHud.zs"
#include "zscript/BW/Hud/BossBar.zs"
#include "zscript/BW/Player/BWPlayer.zs"

//Weapons
#include "zscript/BW/Weapons/Slot1/Fists.zs"

#include "zscript/BW/Weapons/Slot2/Luger.zs"

#include "zscript/BW/Weapons/Slot3/MP40.zs"
#include "zscript/BW/Weapons/Slot3/STG44.zs"
#include "zscript/BW/Weapons/Slot3/M1Thompson.zs"

#include "zscript/BW/Weapons/Slot4/Trenchgun.zs"
#include "zscript/BW/Weapons/Slot4/Kar98K.zs"

#include "zscript/BW/Weapons/Slot5/MG42.zs"

#include "zscript/BW/Weapons/Slot6/Panzerschreck.zs"

#include "zscript/BW/Weapons/Slot7/Tesla.zs"
#include "zscript/BW/Weapons/Slot7/Flammerwerfer.zs"

#include "zscript/BW/Weapons/Slot8/HellSSG.zs"
#include "zscript/BW/Weapons/Slot8/Leichenfaust.zs"

#include "zscript/BW/Weapons/Throwables/grenades.zs"

//Monsters
#include "zscript/BW/Monsters/BrownGuard/Pistol.zs"
#include "zscript/BW/Monsters/BrownGuard/Rifle.zs"
#include "zscript/BW/Monsters/BlueGuard/MP40.zs"
#include "zscript/BW/Monsters/BlueGuard/Shotgun.zs"
#include "zscript/BW/Monsters/BlackGuard/STG44.zs"
#include "zscript/BW/Monsters/Dogs/Doggie.zs"
#include "zscript/BW/Monsters/Mutants/Mutant.zs"

#include "zscript/BW/Monsters/Demons/Demons.zs"
#include "zscript/BW/Monsters/Demons/DoomImp.zs"

//Bosses
#include "zscript/BW/Monsters/Bosses/Hans.zs"

#include "zscript/BW/Monsters/BWSpawners.zs"
#include "zscript/BW/Monsters/DooMSpawners.zs"


//Map props
#include "zscript/BW/Maps/DecorationsBase.zs"

//Items
#include "zscript/BW/Items/Treasures.zs"
#include "zscript/BW/Items/Armor.zs"
#include "zscript/BW/Items/Keys.zs"
#include "zscript/BW/Items/Health.zs"
#include "zscript/BW/Items/Ammo.zs"

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

class BW_Unknown : Actor replaces Unknown
{
	Default
	{
		Radius 32;
		Height 56;
		Scale 0.05;
		+FLOATBOB;
		FloatBobStrength 0.5;
		//FloatBobFactor 0.5; //lzdoom compat
		+NOGRAVITY;
		+NOBLOCKMAP;
		+DONTSPLASH;
		+ROLLSPRITE;
		+ROLLCENTER;
	}
	
	override void Tick()
	{
		Super.Tick();
		//A_SpawnParticle("Black", 0, 100, 4, 0, 0, 0, 10, frandom(-0.2,0.2), frandom(-0.2,0.2), frandom(-0.2,0.2), 0, 0, 0, 0.9, 0.01);
	}
	
	States
	{
		Spawn:
			S0SG A 1
			{
				A_SetRoll(0+random(-10,10), SPF_INTERPOLATE);
			}
			TNT1 A 0
			{
				int chance = random(1,5);
				if(chance == 3)
				{
					A_SpawnItemEx("BW_UnknownEye", 0, 0, 10, frandom(-0.5,0.5), frandom(-0.5,0.5), frandom(-0.5,0.5));
				}
			}
			S0SG A 1
			{
				A_SetRoll(0+random(-10,10), SPF_INTERPOLATE);
			}
			Loop;
	}
}

class BW_UnknownEye : Actor
{
	Default
	{
		Radius 2;
		Height 2;
		Scale 0.05;
		+FLOATBOB;
		FloatBobStrength 0.5;
		//FloatBobFactor 0.5; //lzdoom compat
		+NOGRAVITY;
		+NOBLOCKMAP;
		+DONTSPLASH;
		+ROLLSPRITE;
		+ROLLCENTER;
	}
	
	States
	{
		Spawn:
			S0SG BBBBB random(1,3) A_SetRoll(0+random(-10,10), SPF_INTERPOLATE);
			S0SG BBBBB random(1,3)
			{
				A_FadeOut(0.1);
				A_SetRoll(0+random(-10,10), SPF_INTERPOLATE);
			}
			Wait;
	}
}