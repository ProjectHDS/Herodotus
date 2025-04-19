#priority -1

import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){
for matName in crtlib.baseMetals {
    furnace.addRecipe(oreDict.get("glass" ~ matName).firstItem, oreDict.get("paperAmorphousPrecipitated" ~ matName));
    furnace.addRecipe(oreDict.get("glass" ~ matName).firstItem, oreDict.get("dustGlass" ~ matName));
    furnace.addRecipe(oreDict.get("glassImpure" ~ matName).firstItem, oreDict.get("glassParticulated" ~ matName));
}
}