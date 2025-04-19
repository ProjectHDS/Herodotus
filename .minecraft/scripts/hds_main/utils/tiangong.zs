#priority 2000

import crafttweaker.item.IItemStack;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.grassUtils.RecipeUtils;
import scripts.hds_lib.crtlib.getDecoBlocks;

if (!isInvalid) {

for deco in getDecoBlocks() {
    recipes.addShaped(deco*64, RecipeUtils.createSurround(<contenttweaker:tiangong>.reuse(), deco));
}

}
