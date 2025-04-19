#priority 1500

import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.oredict.IOreDictEntry;
import scripts.hds_main.utils.modloader.isInvalid;

if(!isInvalid){

val oreDictAddMap as IItemStack[][IOreDictEntry] = {};

val oreDictRemoveMap as IItemStack[][IOreDictEntry] = {};

//st
for oda, item in oreDictAddMap{
    oda.add(item);
}

for odr, items in oreDictRemoveMap{
    odr.removeItems(items);
}
}
