#priority 2000
#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Block;
import crafttweaker.block.IBlockState;
import scripts.grassUtils.StringHelperCot;
import scripts.hds_lib.cotlib.createGlassBlock;

for matName in ["copper", "iron", "lead", "tin"] as string[] {
    val g = createGlassBlock("glass_" ~ matName);
    val gp = createGlassBlock("glass_particulated_" ~ matName);
    val gi = createGlassBlock("glass_impure_" ~ matName);
    g.register();
    gp.register();
    gi.register();

    val glassSoftened = createGlassBlock("glass_softened_" ~ matName);
    glassSoftened.onRandomTick = function(world, blockPos, blockState) {
        if ((world.getWorldTime() % 20) == 0) {
		    if (world.getRandom().nextInt(3) < 1) {
                world.setBlockState(itemUtils.getItem("contenttweaker:glass_" ~ matName).asBlock().definition.getStateFromMeta(0), blockPos);
            } else {
                world.setBlockState(itemUtils.getItem("contenttweaker:glass_particulated_" ~ matName).asBlock().definition.getStateFromMeta(0), blockPos);
            }
	    }
    };
    glassSoftened.register();

    oreDict.get("glassSoftened" ~ StringHelperCot.toUpperCamelCase(matName)).add(itemUtils.getItem("contenttweaker:glass_softened_" ~ matName));
    oreDict.get("glass" ~ StringHelperCot.toUpperCamelCase(matName)).add(itemUtils.getItem("contenttweaker:glass_" ~ matName));
    oreDict.get("glassParticulated" ~ StringHelperCot.toUpperCamelCase(matName)).add(itemUtils.getItem("contenttweaker:glass_particulated_" ~ matName));
    oreDict.get("glassImpure" ~ StringHelperCot.toUpperCamelCase(matName)).add(itemUtils.getItem("contenttweaker:glass_impure_" ~ matName));
}
