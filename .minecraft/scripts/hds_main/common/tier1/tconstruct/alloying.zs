#priority -1

import mods.tconstruct.Alloy;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.liquid.ILiquidStack;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

for matName in crtlib.baseMetals {
    Alloy.addRecipe(game.getLiquid(matName.toLowerCase() ~ "_amorphous_suspension")*125, [game.getLiquid(matName.toLowerCase() ~ "_amorphous")*18, <liquid:water> * 250]);
}

}
