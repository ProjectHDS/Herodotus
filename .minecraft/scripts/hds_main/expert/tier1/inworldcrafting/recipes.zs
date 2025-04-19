#packmode expert
#priority -1

import crafttweaker.liquid.ILiquidStack;
import mods.inworldcrafting.FluidToItem;
import mods.inworldcrafting.FluidToFluid;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

for matName in crtlib.baseMetals {
    FluidToItem.transform(oreDict.get("paperAmorphousPrecipitated" ~ matName).firstItem, game.getLiquid(matName.toLowerCase() ~ "_amorphous_suspension"), [<minecraft:paper>], true);
}
}
