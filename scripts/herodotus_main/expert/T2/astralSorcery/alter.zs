#packmode expert
#modloaded bathappymod
#priority -100

import mods.astralsorcery.Altar;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;


//Remove the default lightwell recipe
mods.astralsorcery.Altar.removeAltarRecipe("astralsorcery:shaped/internal/altar/lightwell");

//Adding
mods.astralsorcery.Altar.addDiscoveryAltarRecipe("hds:shaped/internal/altar/lightwellreborn", 
            <astralsorcery:blockwell>, 200, 200, [
			<astralsorcery:blockmarble:6>, null, <astralsorcery:blockmarble:6>,
			<astralsorcery:blockmarble:4>, <botania:manaresource>, <astralsorcery:blockmarble:4>,
			<ore:gemAquamarine>, <astralsorcery:blockmarble:6>, <ore:gemAquamarine>]
);
mods.astralsorcery.Altar.addDiscoveryAltarRecipe("hds:shaped/internal/altar/manapool", 
            <botania:pool>, 200, 200, [
			null, <botania:specialflower>.withTag({type: "manastar"}), null,
			<astralsorcery:blockmarble:5>, <botania:manaresource:23>, <astralsorcery:blockmarble:5>,
			<minecraft:dye:15>, <botania:pool:2>, <minecraft:dye:15>]
);