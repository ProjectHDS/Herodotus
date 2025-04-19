#priority -1

import mods.tconstruct.Melting;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.liquid.ILiquidStack;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

for matName in crtlib.baseMetals {
    Melting.addRecipe(game.getLiquid(matName.toLowerCase() ~ "_amorphous") * 288, oreDict.get("dustMetastable" ~ matName));
    Melting.addRecipe(game.getLiquid(matName.toLowerCase() ~ "_soften_glass") * 500, oreDict.get("glassSoftened" ~ matName));
    Melting.addRecipe(game.getLiquid(matName.toLowerCase() ~ "_soften_glass") * 1000, oreDict.get("dustGlass" ~ matName));
}

}
