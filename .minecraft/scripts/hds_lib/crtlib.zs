#loader crafttweaker multiblocked gregtech contenttweaker
#priority 2001

import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.oredict.IOreDictEntry;

static maxInt as int = 2147483647;

static baseMetals as string[]= ["Iron", "Copper", "Lead", "Tin"];

// For extra added blocks, DO NOT use unless under special conditions, use getDecoBlocks() instead.
static decoBlocks as IItemStack[] = [
    <item:minecraft:dirt>,
    <item:minecraft:stone>
];

function getDecoBlocks() as IItemStack[] {
    var toReturn as IItemStack[] = [];
    for chiselItem in loadedMods["chisel"].items {
        if (chiselItem.isItemBlock) {
            toReturn += chiselItem;
        }
    }
    for decoBlock in decoBlocks {
        toReturn += decoBlock;
    }
    return toReturn;
}
