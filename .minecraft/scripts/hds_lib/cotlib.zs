#priority 2001
#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Block;
import scripts.grassUtils.CotUtils;
import scripts.grassUtils.classes.MaterialSystemHelper.MaterialSystemHelper;

//registerParts
val registerPartsArray as string[] = [
    "dustUnstable", "dustMetastable", "dustGlass", "dustTinyGlass", "paperAmorphousPrecipitated"
];

val register as MaterialSystemHelper = CotUtils.getMaterialSystemHelper("registerPart");
for name in registerPartsArray{
    register.registerNormalPart(name, "item", false);
}

//util functions
function addNormalBlock(name as string){
    VanillaFactory.createBlock(name, <blockmaterial:rock>).register();
}

function createGlassBlock(name as string) as Block {
    val glassBlock as Block = VanillaFactory.createBlock(name, <blockmaterial:glass>);
    glassBlock.setBlockLayer("CUTOUT");
    glassBlock.setFullBlock(false);
    return glassBlock;
}

//partsArrays
static allPartsMap as string[][int] = {
    /*allPartsAsExample
    "nugget", "beam", "dirty_dust", "cluster", "ring",
    "rod", "crystal", "plate", "chipped_gem", "centrifuged_ore",
    "ore_rock", "casing", "missing", "dense_plate",
    "block", "shard", "molten", "flawless_gem", "dust",
    "crushed_ore", "ore", "small_dust", "long_rod", "small_spring",
    "clump", "flawed_gem", "large_spring", "purified_ore", "poor_ore",
    "minecart", "armor", "round", "ore_sample", "dense_ore",
    "bolt", "ingot", "tiny_dust", "gear"
    */
    0 : [// basic metals
        "dustUnstable", "dustMetastable", "paperAmorphousPrecipitated", "dustGlass", "nugget", "dustTinyGlass", "tiny_dust", "small_dust"
    ]
};

static allMaterialMap as int[string][int] = {
    0 : { // basic metals
        "iron" : 0xd8af93,
        "copper" : 0xff4100,
        "lead" : 0x818ebe,
        "tin" : 0xdbdbdb
    }
};

static plainItemIDs as string[] = [];

static plainBlockIDs as string[] = [];
