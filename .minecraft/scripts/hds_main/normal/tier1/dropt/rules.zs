#packmode normal
#priority -1

import mods.dropt.Dropt;
import scripts.grassUtils.StringHelper;
import crafttweaker.item.IItemStack;
import crafttweaker.oredict.IOreDictEntry;
import scripts.hds_main.utils.modloader.isInvalid;

import scripts.hds_lib.crtlib;

if(!isInvalid){
for matName in crtlib.baseMetals {

    Dropt.list("glass_break_" ~ matName.toLowerCase())
        .add(Dropt.rule()
            .matchBlocks(["contenttweaker:glass_" ~ matName.toLowerCase()])
            .replaceStrategy("REPLACE_ITEMS")
            .addDrop(Dropt.drop()
                .items([oreDict.get("dustGlass" ~ matName).firstItem * 2])
            )
    );

    Dropt.list("glass_for_nugget_" ~ matName.toLowerCase())
        .add(Dropt.rule()
            .matchBlocks(["contenttweaker:glass_particulated_" ~ matName.toLowerCase()])
            .replaceStrategy("REPLACE_ITEMS")
            .addDrop(Dropt.drop()
                .items([oreDict.get("nugget" ~ matName).firstItem], Dropt.range(4, 5))
            )
    );
}
}
