#loader crafttweaker multiblocked
#packmode normal
#priority 2001

import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.oredict.IOreDictEntry;

import thaumcraft.aspect.CTAspect;
import thaumcraft.aspect.CTAspectStack;

//parts and colors
static colors as string[] = ["red", "yellow", "blue"];
static shapes as string[] = ["rhombus", "spherical", "square"];
static latinColors as string[] = ["rubrum", "flavum", "caeruleum"];
static latinShapes as string[] = ["rhombus", "sphaericus", "quadrata"];
static colorsMap as string[string] = {
    "red" : "rubrum",
    "yellow" : "flavum",
    "blue" : "caeruleum"
};
static shapesMap as string[string] = {
    "rhombus" : "rhombus",
    "spherical" : "sphaericus",
    "square" : "quadrata"
};

static maxInt as int = 2147483647;

static allMetals as [string] = [
    "Bronze", "Iron", "Lithium", "Copper",
    "Lead", "Tin", "Nickel", "Silver", "Lapis",
    "Tungsten", "Sodium", "Aluminum", "Gold",
    "Chromium", "Silicon", "Cobalt", "Titanium",
    "Potassium", "Iridium", "Osmium"
];

static allGems as [string] = [
    "Diamond", "Glimmerite"
];

static allAspectsString as string[] = [
    "humanus", "herba", "invidia", "infernum", "permutatio", "vitreus",
    "motus", "draco", "ira", "desidia", "infernus", "cognitio", "ignis",
    "vacuos", "gelum", "tenebrae", "perditio", "victus", "aer", "machina",
    "gula", "auram", "visum", "sensus", "exitium", "fluctus", "aqua", "fabrico",
    "terra", "ordo", "sonus", "alkimia", "metallum", "potentia", "volatus",
    "revelatio", "vinculum", "lux", "bestia", "praecantatio", "spiritus",
    "caeles", "praemunio", "mortuus", "imperium", "luxuria", "alienis", "desiderium",
    "instrumentum", "exanimis", "superbia", "vitium", "ventus", "aversio"
];

static allAspectCTAspectStack as CTAspectStack[] = [
    <aspect:humanus>, <aspect:herba>, <aspect:invidia>, <aspect:infernum>, <aspect:permutatio>,
    <aspect:vitreus>, <aspect:motus>, <aspect:draco>, <aspect:ira>, <aspect:desidia>,
    <aspect:infernus>, <aspect:cognitio>, <aspect:ignis>, <aspect:vacuos>, <aspect:gelum>,
    <aspect:tenebrae>, <aspect:perditio>, <aspect:victus>, <aspect:aer>, <aspect:machina>,
    <aspect:gula>, <aspect:auram>, <aspect:visum>, <aspect:sensus>, <aspect:exitium>,
    <aspect:fluctus>, <aspect:aqua>, <aspect:fabrico>, <aspect:terra>, <aspect:ordo>,
    <aspect:sonus>, <aspect:alkimia>, <aspect:metallum>, <aspect:potentia>, <aspect:volatus>,
    <aspect:revelatio>, <aspect:vinculum>, <aspect:lux>, <aspect:bestia>, <aspect:praecantatio>,
    <aspect:spiritus>, <aspect:caeles>, <aspect:praemunio>, <aspect:mortuus>, <aspect:imperium>,
    <aspect:luxuria>, <aspect:alienis>, <aspect:desiderium>, <aspect:instrumentum>,
    <aspect:exanimis>, <aspect:superbia>, <aspect:vitium>, <aspect:ventus>, <aspect:aversio>
];

static basicAspects as CTAspectStack[] = [
    <aspect:aer>, <aspect:terra>, <aspect:ignis>, <aspect:aqua>,
    <aspect:ordo>, <aspect:perditio>, <aspect:vitium>
];

static toRemoveArcaneRecipes as [IItemStack] = [
    <thaumcraft:tube>,
    <thaumicaugmentation:glass_tube>,
    <thaumcraft:tube_restrict>,
    <thaumcraft:tube_oneway>,
    <thaumcraft:tube_filter>,
    <thaumcraft:tube_valve>,
    <thaumcraft:filter>*2,
    <thaumcraft:condenser_lattice>,
    <thaumcraft:thaumometer>,
    <thaumcraft:resonator>,
    <thaumcraft:condenser>,
    <thaumcraft:morphic_resonator>,
    <thaumcraft:metal_alchemical>,
    <thaumcraft:centrifuge>,
    <thaumcraft:mechanism_simple>,
    <thaumcraft:essentia_output>,
    <thaumcraft:essentia_input>,
    <thaumcraft:jar_normal>,
    <thaumcraft:sanity_checker>,
    <thaumcraft:smelter_void>,
    <thaumcraft:seal>,
    <thaumcraft:goggles>,
    <thaumicaugmentation:void_recharge_pedestal>,
    <thaumicaugmentation:impetus_diffuser>,
    <thaumicaugmentation:impetus_drainer>,
    <thaumicaugmentation:impetus_gate>,
    <thaumicaugmentation:impetus_linker>,
    <thaumicaugmentation:impetus_relay>,
    <thaumicaugmentation:impulse_cannon_augment:1>,
    <thaumicaugmentation:impulse_cannon_augment>,
    <thaumicaugmentation:material:1>,
    <thaumcraft:metal_alchemical_advanced>,
    <thaumicwonders:dimensional_ripper>,
    <thaumicwonders:portal_anchor>,
    <thaumicwonders:flux_distiller>,
    <thaumicwonders:primordial_accelerator_tunnel>,
    <thaumicwonders:primordial_accelerator_terminus>,
    <thaumadditions:jar_eldritch>,
    <thaumcraft:smelter_basic>,
    <thaumcraft:smelter_thaumium>,
    <thaumcraft:smelter_void>,
    <thaumadditions:mithrillium_smelter>,
    <thaumadditions:adaminite_smelter>,
    <thaumadditions:mithminite_smelter>,
    <thaumadditions:jar_brass>,
    <thaumadditions:jar_thaumium>
];

// For extra added blocks, DO NOT use unless under special conditions, use getDecoBlocks() instead.
static decoBlocks as IItemStack[] = [
    <minecraft:dirt>,
    <minecraft:stone>
];

function getDecoBlocks() as IItemStack[] {
    var toReturn as IItemStack[] = [];
    for chiselItem in loadedMods["chisel"].items as IItemStack {
        if chiselItem.isItemBlock {toReturn += chiselItem};
    }
    toReturn += decoBlocks;
    return toReturn;
}

function getAllBasicAspects(amount as int) as CTAspectStack[] {
    return [
        <aspect:aer> * amount,
        <aspect:terra> * amount,
        <aspect:ignis> * amount,
        <aspect:aqua> * amount,
        <aspect:ordo> * amount,
        <aspect:perditio> * amount
    ];
}

function tcSaltGetter(aspect as string, amountnum as int = 1) as IItemStack {
    return <thaumadditions:salt_essence>.withTag({Aspects: [{amount: amountnum, key: aspect}]});
}

function tcPhialGetter(aspect as string, amountnum as int = 10) as IItemStack {
    return <thaumcraft:phial:1>.withTag({Aspects: [{amount: amountnum, key: aspect}]});
}

function tcCrystalGetter(aspect as string, amountnum as int = 1) as IItemStack {
    return <thaumcraft:crystal_essence>.withTag({Aspects: [{amount: amountnum, key: aspect}]});
}

function tcSSGetter(aspect as string) as IItemStack {
    return <thaumadditions:seal_symbol>.withTag({Aspect: aspect});
}

function tcPodGetter(aspect as string) as IItemStack {
    return <thaumadditions:vis_pod>.withTag({Aspect: aspect});
}

function tcSeedGetter(aspect as string) as IItemStack {
    return itemUtils.getItem("thaumadditions:vis_seeds/" ~ aspect);
}

function tcVisBlockGetter(aspect as string) as IItemStack {
    return <thaumadditions:crystal_block>.withTag({Aspect: aspect});
}

function tconPartGetter(basic as IItemStack, material as string) as IItemStack {
    return basic.withTag({Material: material});
}

function refinedBottleGetter(fluidName as string, amount as int = 1000) as IItemStack {
    return <hdsutils:refined_bottle>.withTag({Fluid: {FluidName: fluidName, Amount: amount}});
}

// function asRockCrystalGetter(collectiveCapability as int = 0, size as int = 0, fract as int = 0, purity as int = 0, sizeOverride as int = 0) as IItemStack {
//     return <astralsorcery:itemrockcrystalsimple>.withTag({astralsorcery: {crystalProperties: {collectiveCapability: 0, size: 0, fract: 0, purity: 0, sizeOverride: 0}}});
// }
