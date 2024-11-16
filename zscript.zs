Version 4.3

#include "zscript/BW/Materials.zs"
#include "zscript/BW/Weapons/WeaponBase.zs"
#include "zscript/BW/Monsters/MonsterBase.zs"
#include "zscript/BW/Effects/Effects.zs"
#include "zscript/BW/Hud/BWHud.zs"
#include "zscript/BW/Player/BWPlayer.zs"

#include "zscript/Nashgore/NashGoreCommon.zc"
#include "zscript/Nashgore/NashGoreStatics.zc"
#include "zscript/Nashgore/NashGoreHandler.zc"
#include "zscript/Nashgore/NashGoreBlood.zc"
#include "zscript/Nashgore/NashGoreBloodPlane.zc"
#include "zscript/Nashgore/NashGoreGibs.zc"
#include "zscript/Nashgore/NashGoreCrushedGibs.zc"
#include "zscript/Nashgore/NashGoreSquishyGibs.zc"
#include "zscript/Nashgore/NashGoreIceChunk.zc"
#include "zscript/Nashgore/NashGoreLiquidBlood.zc"
#include "zscript/Nashgore/NashGoreWallBlood.zc"
#include "zscript/Nashgore/NashGoreActor.zc"
#include "zscript/Nashgore/NashGoreMenu.zc"
//#include "zscript/Nashgore/NashGoreMath.zc"

// global constants
const STAT_NashGore_Gore = Thinker.STAT_USER + 1;
const STAT_CASING = thinker.STAT_USER + 2;
const STAT_FLATDECAL = thinker.STAT_USER + 3;
const SLAUGHTERMAP_DIST = 1000.0;
const MAP_EPSILON = 1 / 65536.;




