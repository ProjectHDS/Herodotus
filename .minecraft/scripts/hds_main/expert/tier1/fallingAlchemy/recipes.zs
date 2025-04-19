#packmode expert
#priority -1

import mods.fallingalchemy.FallingAlchemy;
import mods.fallingalchemy.ConsumedItem;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

for matName in crtlib.baseMetals {
    FallingAlchemy.addConversion(<minecraft:sand>, [
        FallingAlchemy.createConsumedItem(oreDict.get("dustUnstable" ~ matName), 1d, [oreDict.get("dustMetastable" ~ matName).firstItem]
    ]).register();
}

}