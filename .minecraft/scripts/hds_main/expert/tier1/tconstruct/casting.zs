#packmode expert
#priority -1

import mods.tconstruct.Casting;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.liquid.ILiquidStack;
import crafttweaker.oredict.IOreDictEntry;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if (!isInvalid) {
for mat in crtlib.baseMetals {
    Casting.addBasinRecipe(
        oreDict.get("glassSoftened" ~ mat).firstItem,
        null,
        game.getLiquid(mat.toLowerCase() ~ "_soften_glass") * 1296,
        100,
        false
    );
}

}