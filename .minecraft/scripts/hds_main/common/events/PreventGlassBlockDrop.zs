#priority -1

import crafttweaker.events.IEventManager;
import crafttweaker.event.BlockHarvestDropsEvent;
import crafttweaker.player.IPlayer;
import crafttweaker.block.IBlock;
import crafttweaker.oredict.IOreDictEntry;
import scripts.hds_lib.crtlib;
import scripts.hds_main.utils.modloader.isInvalid;

if(!isInvalid){

events.onBlockHarvestDrops(function(event as BlockHarvestDropsEvent) {
    var player as IPlayer = event.player;
    if(!event.isPlayer || event.drops.length == 0 || event.silkTouch) return;
    val block as IBlock = event.block;
    for matName in crtlib.baseMetals {
        val id = oreDict.get("glass" ~ matName).firstItem.definition.id;
        val ids = oreDict.get("glassSoftened" ~ matName).firstItem.definition.id;
        val idp = oreDict.get("glassParticulated" ~ matName).firstItem.definition.id;
        if (block.definition.id == idp || block.definition.id == id || block.definition.id == ids) {
            event.drops = [];
            break;
        }
    }
});

}