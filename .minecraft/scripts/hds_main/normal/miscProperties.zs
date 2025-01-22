#packmode normal
#priority 2

import scripts.hds_main.utils.globalGrinder;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.grassUtils.GrassUtils;
import mods.jei.JEI;


if (!isInvalid) {
    // JEI.hideCategory("THAUMCRAFT_ARCANE_WORKBENCH");
    JEI.hideCategory("pneumaticcraft.amadron_trade");
    JEI.addDescription(<artisanworkstumps:log_basin>, "herodotus.jei.desc.log_basin");
    JEI.addDescription(<artisanworkstumps:stone_basin>, "herodotus.jei.desc.stone_basin");
    JEI.addDescription(<agricraft:agri_seed>.withTag({agri_analyzed: 0 as byte, agri_strength: 1 as byte, agri_gain: 1 as byte, agri_seed: "herodotus_slime_grass", agri_growth: 1 as byte}), "herodotus.jei.desc.slime_grass_seed");
    <minecraft:obsidian>.asBlock().definition.resistance = 8.0f;
    <minecraft:iron_pickaxe>.maxDamage = 300;
    <minecraft:iron_shovel>.maxDamage = 300;
    <minecraft:iron_axe>.maxDamage = 300;
    <minecraft:iron_sword>.maxDamage = 300;
    <minecraft:iron_hoe>.maxDamage = 300;
    // TODO: ProdigyTech is removed
    // <prodigytech:crystal_cutter>.maxDamage = 300;
    <pyrotech:obsidian_pickaxe>.maxDamage = 450;
    <pyrotech:obsidian_shovel>.maxDamage = 450;
    <pyrotech:obsidian_axe>.maxDamage = 450;
    <mekanismtools:ironpaxel>.maxDamage = 1000;
    <mekanismtools:obsidianpaxel>.maxDamage = 1500;
    <thaumcraft:stone_ancient_rock>.hardness = 10.0;
    <thaumcraft:stone_ancient_rock>.asBlock().definition.setHarvestLevel("pickaxe", 2);
    // <astralsorcery:blockcustomore>.asBlock().definition.setHarvestLevel("pickaxe", 1);
    <entity:minecraft:zombie_pigman>.removeDrop(<minecraft:gold_nugget>);
    <entity:minecraft:zombie>.removeDrop(<minecraft:iron_ingot>);
    <entity:minecraft:zombie>.removeDrop(<minecraft:iron_ore>);
    <entity:srparasites:pri_longarms>.addDrop(<contenttweaker:broken_ootheca> % 45);
    <entity:srparasites:pri_bolster>.addDrop(<contenttweaker:broken_ootheca> % 35);
    <entity:srparasites:pri_manducater>.addDrop(<contenttweaker:broken_ootheca> % 25);
    <entity:srparasites:pri_reeker>.addDrop(<contenttweaker:broken_ootheca> % 65);
    <entity:srparasites:pri_yelloweye>.addDrop(<contenttweaker:broken_ootheca> % 100);
    <entity:srparasites:pri_summoner>.addDrop(<contenttweaker:broken_ootheca> % 25);
    <entity:srparasites:pri_arachnida>.addDrop(<contenttweaker:broken_ootheca> % 45);
    vanilla.seeds.removeSeed(<item.teslathingies.tesla_plant_seeds:0>);
    globalGrinder.addGrinderRecipe(<minecraft:coal>, <ore:dustCoal>.materialPart);
    <contenttweaker:tiangong>.addTooltip(GrassUtils.i18n("herodotus.tooltips.tiangong"));
}
