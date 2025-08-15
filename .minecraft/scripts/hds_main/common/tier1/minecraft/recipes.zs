#priority -1

import scripts.hds_lib.crtlib;
import scripts.hds_main.utils.modloader.isInvalid;

if(!isInvalid){

for matName in crtlib.baseMetals {
    val dustTinyGlass = oreDict.get("dustTinyGlass" ~ matName);
    recipes.addShapeless(oreDict.get("dustGlass" ~ matName).firstItem, [
        dustTinyGlass, dustTinyGlass, dustTinyGlass, dustTinyGlass,
        dustTinyGlass, dustTinyGlass, dustTinyGlass, dustTinyGlass,dustTinyGlass
    ]);
}

}
