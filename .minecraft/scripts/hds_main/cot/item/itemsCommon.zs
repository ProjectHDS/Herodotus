#priority 2000
#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Item;
import scripts.hds_lib.cotlib.plainItemIDs;
import scripts.grassUtils.CotUtils;

var tg = VanillaFactory.createExpandItem("tiangong");
tg.rarity = "EPIC";
tg.maxStackSize = 1;
tg.register();

for id in plainItemIDs {
    CotUtils.addNormalItem(id);
}
