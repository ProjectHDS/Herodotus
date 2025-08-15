#packmode expert
#priority -1

import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){
for matName in crtlib.baseMetals {
    furnace.addRecipe(oreDict.get("glassImpure" ~ matName).firstItem, oreDict.get("paperAmorphousPrecipitated" ~ matName));
}
}