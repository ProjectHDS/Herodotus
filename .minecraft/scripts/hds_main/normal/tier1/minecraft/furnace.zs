#packmode normal
#priority -1

import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){
for matName in crtlib.baseMetals {
    furnace.addRecipe(oreDict.get("glassSoftened" ~ matName).firstItem, oreDict.get("paperAmorphousPrecipitated" ~ matName));
    furnace.addRecipe(oreDict.get("glassSoftened" ~ matName).firstItem, oreDict.get("dustGlass" ~ matName));
}
}