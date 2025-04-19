#priority 2000
#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import crafttweaker.item.IItemStack;
import scripts.hds_lib.cotlib;

for id in cotlib.plainBlockIDs {
    cotlib.addNormalBlock(id);
}
