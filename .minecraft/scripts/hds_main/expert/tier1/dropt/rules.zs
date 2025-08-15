#packmode expert
#priority -1

import mods.dropt.Dropt;
import scripts.grassUtils.StringHelper;
import crafttweaker.item.IItemStack;
import crafttweaker.oredict.IOreDictEntry;
import scripts.hds_main.utils.modloader.isInvalid;

import scripts.hds_lib.crtlib;

if(!isInvalid){
for matName in crtlib.baseMetals {

    Dropt.list("glass_for_tinydust_" ~ matName.toLowerCase())
        .add(Dropt.rule()
            .matchBlocks(["contenttweaker:glass_" ~ matName.toLowerCase()])
            .replaceStrategy("REPLACE_ITEMS")
            .addDrop(Dropt.drop()
                .items([oreDict.get("dustTiny" ~ matName).firstItem * 18])
            )
    );
}
}
