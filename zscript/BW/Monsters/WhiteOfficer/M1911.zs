Class BW_WhiteOfficer_M1911 : BW_WhiteOfficer_Pistol //replaces Zombieman //[Pop] replace is temporary until spawners are implemented. Do we want to do spawner injection?
{
	Default
	{
		DropItem "BW_USAPistolAmmo", 255, 8;
		DropItem "BW_M1911", 100, 1;
	}
	void FireProjBullets()
	{
		A_Light(2);
		//A_SpawnProjectile("BW_LugerBullets", 32, 0, (frandom(3,-3)), CMF_AIMDIRECTION, self.pitch + (frandom(3,-3)));
		BW_FireMonsterBullet("BW_EnemyM1911Bullets");
		BW_MiscEffect.SpawnFireFlashFx(self,30,0,40);
		A_StartSound("M1911/Fire", CHAN_AUTO, CHANF_OVERLAP);
		A_StartSound("M1911/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		AmmoInMag--;
	}
	
	override void BeginPlay()
	{
		super.BeginPlay();
		AmmoInMag = random(4,7); //M1911
	}	
	States
	{
	Reload:
		WTGA E 6;
		WTGR A 6;
		WTGR B 6 A_StartSound("M1911/MagOut", 8, CHANF_OVERLAP, attenuation: 2);
		WTGR C 6;
		WTGR B 6;
		WTGR A 6 A_StartSound("M1911/MagIn", 8, CHANF_OVERLAP, attenuation: 2);
		WTGR C 2;
		TNT1 A 0
		{
			A_StartSound("M1911/Charge", 8, CHANF_OVERLAP, attenuation: 1.5);
			AmmoInMag = 8;
		}
		WTGR A 4;
		Goto See;
	}
}