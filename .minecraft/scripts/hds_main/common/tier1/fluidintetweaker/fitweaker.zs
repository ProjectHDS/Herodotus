#priority -1

import mods.fluidintetweaker.FITweaker;
import crafttweaker.block.IBlockState;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

for matName in crtlib.baseMetals {
    FITweaker.addRecipe(game.getLiquid(matName.toLowerCase() ~ "_soften_glass"), true, <liquid:water>, false, IBlockState.getBlockState("contenttweaker:glass_particulated_" ~ matName.toLowerCase(), [""]));
}
}
