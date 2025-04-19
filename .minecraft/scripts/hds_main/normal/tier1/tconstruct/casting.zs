#packmode normal
#priority -1

import mods.tconstruct.Casting;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.liquid.ILiquidStack;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){
for matName in crtlib.baseMetals {
    Casting.addTableRecipe(oreDict.get("paperAmorphousPrecipitated" ~ matName).firstItem, <minecraft:paper>, game.getLiquid(matName.toLowerCase() ~ "_amorphous_suspension"), 2000, true, 20*5);
}
}
