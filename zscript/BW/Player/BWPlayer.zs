Class BWPlayer : PlayerPawn//zmoveplayer//PlayerPawn
{
	double StillRangeMulti, slideAngle;
	double 	ssup;
	vector2 finalbob;

	override void tick()
	{
		super.tick();
	}

	override void CheckWeaponChange ()
    {
        let player = self.player;

        let bwwp = BaseBWWeapon(player.readyweapon);
        if(bwwp && bwwp.BW_IsReloading())
        {
            player.weaponstate |= WF_WEAPONSWITCHOK;
        }
        super.CheckWeaponChange();
    }

	override void playerthink()
	{
		super.playerthink();
		bool wasOnGround = player.onGround;
		//stick player to the frond when going downstairs
		if (wasOnGround && !player.onGround && pos.z - GetZAt() < maxDropOffHeight && vel.z <= 0)
         {
 			ssup = max(0,(pos.z-floorz));
 			SetOrigin(Vec2OffsetZ(0,0,floorz),true);
            player.onGround = true;
			player.viewz += ssup;
 			ssup = max(0,(ssup*0.7)-0.25);
         }

	}
	
	override Vector2 BobWeapon(double ticFrac)
	{
		vector2 offset = super.BobWeapon(ticFrac);
		if(vel.xy.length() > 0)
		{
			stillrangemulti = 0;
			return offset;
		}
		//this comes from zmovement :D
		StillRangeMulti = min(StillRangeMulti + 0.001, 1);
		offset.Y = StillRangeMulti * sin(Level.maptime / 120. * 360.) + StillRangeMulti;
		
		return (offset);
	}
	
	action bool PressingCrouch()
	{
		return player.cmd.buttons & BT_CROUCH;
	}
	
	action bool JustReleased(int which)
    {
        return !(player.cmd.buttons & which) && player.oldbuttons & which;
    }
		
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		//[Pop] because FUCK leaky floors, even by WW2 standards
		PlayerInfo plyr = Self.Player;
		if(!plyr || plyr.mo != Self) return 0;
		/*if(plyr.mo.CountInv("MO_PowerInvul") == 1)
		{
			A_StartSound("powerup/invul_damage",3);
		}*/
		int dam = super.DamageMobj(inflictor, source, damage, mod, flags, angle);
		player.damagecount = Clamp(player.damagecount, 0, 5);	//reduced red flash
		return dam;
	}
	
	Default
	{
		Player.StartItem "BW_Luger", 1;
		Player.StartItem "BW_PistolAmmo", 8;
		Player.startItem "BW_Fists";
		
		//Player.StartItem "QuickKick", 1;
		
		Player.AttackZOffset 18;//10;
		Player.ViewBobSpeed 15;
		Player.ViewHeight 40;
		Scale 0.8;
		Player.SoundClass "BWPlayer";
		Player.Face "STF";
		Player.DisplayName "William J. Blazkowicz";
		height 48; //to avoid getting stuck in random stairs
	}

	override void PlayerLandedMakeGruntSound(Actor onmobj)
	{
		
		if(onmobj || waterlevel > 1)
		{
			if(onmobj && onmobj.bismonster && onmobj.health > 0)
			{
				name dmgt = (abs(vel.z) > 9) ? 'stomp' : 'kick';
				onmobj.DamagemObj(self,self,abs(vel.z) * 2,dmgt,DMG_USEANGLE,angle);
			}
			super.PlayerLandedMakeGruntSound(onmobj);	//ummmh
			return;
		}

		name landtex = BW_StaticHandler.getmaterialname(texman.getname(floorpic));
		sound landsnd = sound("land/concrete");
		bool spawnsplash;
		switch(landtex)
		{
			case 'carpet':
			case 'Wood':	landsnd = sound("land/wood");		break;
			case 'Stone':	landsnd = sound("land/concrete");	break;
			case 'Marble':	landsnd = sound("land/tile");		break;

			case 'grass':	case 'gravel':
			case 'Dirt':	landsnd = sound("land/dirt");		break;
			
			case 'slime': case 'purplewater': case 'blood':	case 'lava':
			case 'Water': case 'Acid':	spawnsplash = true;
				landsnd = sound("land/water");		break;
			case 'Metal':	landsnd = sound("land/metal");		break;
			case 'sky':		landsnd = sound("step/none");		break;
		}
		A_Startsound(landsnd,10,CHANF_OVERLAP,pitch:frandom[landng](0.9,1.1));
		
		if(spawnsplash)
			BW_StepActor.spawnfootstepFx(self,pos,landtex,true);

	}
	
	States
	{
		Spawn3:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Spawn2");
			BLAS ABACA 10;
		Spawn:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Spawn2");
			BLAS A 5;
			TNT1 A 0 A_Jump(32, "Spawn3");
			Loop;	
		Spawn2:
			TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 0, "Spawn");
			BLAZ E 10;
			Loop;
		See:
			BLAZ ABCD 3;
			Loop;
		Missile:
			BLAZ E 6;
			Goto Spawn;
		Melee:
			BLAZ F 4 BRIGHT;
			Goto Missile;
		Pain:
			BLAZ G 2 A_Pain;
			Goto Spawn;
		Death:
		XDeath:
			BLAZ H 2;
			BLAZ I 2 A_PlayerScream;
			BLAZ J 2 A_NoBlocking;
			BLAZ KL 2;
			BLAZ L -1;
			Stop;
		
		//[Pop] This will be unused for now, but its here for when its needed
		
		KickCheckTakeToken:
			TNT1 A 0;
			TNT1 A 1 A_TakeInventory("Kicking",1);
			Stop;
		KickCheck:
			TNT1 A 0;
			TNT1 A 1;
		DoKick:
			TNT1 A 0;
			TNT1 A 0 A_OverlayFlags(-10, PSPF_ADDWEAPON, false);
			TNT1 A 0 A_OverlayOffset(-10, 0, 32);
			TNT1 A 0 A_JumpIf(PressingCrouch() && momx != 0 && momy != 0, "Slide");
			TNT1 A 0
			{
				A_PlaySound("KICK",69);
			}
			K1CK ABCDE 1;
			K1CK F 2
			{	
				if (CountInv("PowerStrength") == 1)
				{
					//A_FireCustomMissile("SuperKickAttack", 0, 0, 5, -7);
					return;
				}			
				//A_FireCustomMissile("KickAttack", 0, 0, 0, -7);
				return;
			}
			K1CK EDCBA 1;
			TNT1 A 0;
			Goto KickCheckTakeToken;
		Slide:
			TNT1 A 0
			{
				A_QuakeEx(1, 1, 1, 15, 0, 500, "", 0, 0, 0, 0, 0, 0, 0.25);
				A_StartSound("SLIDE", CHAN_WEAPON, CHAN_OVERLAP);
			}
			SLDK ABCD 1;
		SlideLoop:
			SLDK F 2
			{
				A_QuakeEx(1, 1, 1, 15, 0, 500, "", 0, 0, 0, 0, 0, 0, 0.25);
				//A_CustomPunch(5, FALSE, 0, 0, 64);
				A_Recoil(-24);
			}
			TNT1 A 0 A_JumpIf(!PressingCrouch() || JustReleased(BT_CROUCH), "SlideEnd");
			SLDK E 3
			{
				A_QuakeEx(1, 1, 1, 15, 0, 500, "", 0, 0, 0, 0, 0, 0, 0.25);
				//A_CustomPunch(5, FALSE, 0, 0, 64);
				A_Recoil(-8);
			}
			TNT1 A 0 A_JumpIf(!PressingCrouch() || JustReleased(BT_CROUCH), "SlideEnd");
			SLDK F 2
			{
				A_QuakeEx(1, 1, 1, 15, 0, 500, "", 0, 0, 0, 0, 0, 0, 0.25);
				//A_CustomPunch(5, FALSE, 0, 0, 64);
				A_Recoil(-8);
			}
			TNT1 A 0 A_JumpIf(!PressingCrouch() || JustReleased(BT_CROUCH), "SlideEnd");
			SLDK G 3
			{
				A_QuakeEx(1, 1, 1, 15, 0, 500, "", 0, 0, 0, 0, 0, 0, 0.25);
				//A_CustomPunch(5, FALSE, 0, 0, 64);
				A_Recoil(-8);
			}
			TNT1 A 0 A_JumpIf(!PressingCrouch() || JustReleased(BT_CROUCH), "SlideEnd");
			SLDK F 2
			{
				A_QuakeEx(1, 1, 1, 15, 0, 500, "", 0, 0, 0, 0, 0, 0, 0.25);
				//A_CustomPunch(5, FALSE, 0, 0, 64);
				A_Recoil(-6);
			}
			TNT1 A 0 A_JumpIf(!PressingCrouch() || JustReleased(BT_CROUCH), "SlideEnd");
			TNT1 A 0; //A_JumpIf(BW_SlideLoopSlope(), "SlideLoop")
		SlideEnd:
			SLDK HIJK 1;
			Goto KickCheckTakeToken;
	}
}

//custominventory nomore
class Z_NashMove : inventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
	}

	// How much to reduce the slippery movement.
	// Lower number = less slippery.
	const DECEL_MULT = 0.8; //0.8

	//===========================================================================
	//
	//
	//
	//===========================================================================

	bool bIsOnFloor(void)
	{
		return (Owner.Pos.Z == Owner.FloorZ) || (Owner.bOnMObj);
	}

	bool bIsInPain(void)
	{
		State PainState = Owner.FindState('Pain');
		if (PainState != NULL && Owner.InStateSequence(Owner.CurState, PainState))
		{
			return true;
		}
		return false;
	}

	double GetVelocity (void)
	{
		return Owner.Vel.Length();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void DoEffect()
	{
		Super.DoEffect();
		if (Owner && Owner is "PlayerPawn")
		{
			if (bIsOnFloor())
			{
				
				// bump up the player's speed to compensate for the deceleration
				// TO DO: math here is shit and wrong, please fix
				double s = 0.7 + (1.1 - DECEL_MULT); //1.0
				double mod = 1;
				
				//[Pop] Initialize the base value
				s *= 2;
				
				//[Pop] Handle movement boosts here at some point if needed. IE Stims, holsters gun, etc.
				
				//[Pop] This is the main magic with handling how fast players can move with weapons.
				//If not a BaseBWWeapon, is ignored.
				if(Owner.Player.ReadyWeapon)
				{
					let wpn = BaseBWWeapon(Owner.Player.ReadyWeapon);
					if(wpn)
					{
						//mod = wpn.GunSpeedMod;
					}
				}
				
				//Owner.A_SetSpeed(s * mod);
				Owner.A_SetSpeed(s);
				
				Owner.vel.x *= DECEL_MULT;
				Owner.vel.y *= DECEL_MULT;
				// make the view bobbing match the player's movement
				PlayerPawn(Owner).ViewBob = GetVelocity() / 16;//DECEL_MULT / 2;
			}
		}
		
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================
}

class Kicking : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}