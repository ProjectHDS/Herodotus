#packmode expert
#priority -1

import mods.fallingalchemy.FallingAlchemy;
import mods.fallingalchemy.ConsumedItem;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

for matName in crtlib.baseMetals {
    FallingAlchemy.addConversion(
        <minecraft:sand>, 
        [FallingAlchemy.createConsumedItem(oreDict.get("dustUnstable" ~ matName))],
        1,
        [oreDict.get("dustMetastable" ~ matName).firstItem],
        1,
        0
    ).setSuccessSound("minecraft:block.enchantment_table.use", 0.5, 1.5).register();
}

}