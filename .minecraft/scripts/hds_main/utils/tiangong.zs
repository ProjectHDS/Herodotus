#priority 30000

import crafttweaker.item.IItemStack;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.grassUtils.RecipeUtils;
import scripts.hds_lib.crtlib.getDecoBlocks;


if (!isInvalid) {

for deco in getDecoBlocks() as IItemStack {
    recipes.addShaped("tiangong." ~ deco.name, deco*64, RecipeUtils.createSurround(<contenttweaker:tiangong>.reuse(), deco));
}

}
