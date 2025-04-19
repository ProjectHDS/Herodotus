#packmode normal
#priority -1

import scripts.hds_lib.crtlib;
import scripts.hds_main.utils.modloader.isInvalid;

if(!isInvalid){

for matName in crtlib.baseMetals {
    val dustUnstable = oreDict.get("dustUnstable" ~ matName);
    recipes.addShapeless(oreDict.get("dustMetastable" ~ matName).firstItem * 4, [
        dustUnstable, dustUnstable, dustUnstable, dustUnstable,
        <minecraft:sand>, <minecraft:sand>, <minecraft:sand>, <minecraft:sand>
    ]);
}

}
