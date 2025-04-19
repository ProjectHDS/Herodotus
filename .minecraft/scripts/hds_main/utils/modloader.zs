#loader crafttweaker multiblocked gregtech
#priority 1145141

static isInvalid as bool = false;
static invalidMods as string[] = [
    "torcherino",
    "xijun",
    "calculator",
    "bacteria",
    "decomp_table",
    "deconstrcution_table",
    "decon_table",
    "decontable",
    "decon",
    "uncraftingtable",
    "cyclic",
    "deconstruction",
    "grimpack",
    "avaritia",
    "xray",
    "oreping",
    "reinforcedtools",
    "scenter",
    "extrabotany",
    "oresniffer",
    "eplus",
    "stm",
    "ISM"
];

for i in invalidMods{
    if(loadedMods in i){
        isInvalid = true;
        print("[ModLoader] Found invalid mods, no gameplay scripts will be loaded anymore.");
        break;
    }
}

//calling
//import scripts.hds_main.utils.modloader.isInvalid;
if(!isInvalid){
    print("[ModLoader] The check for invalid mods has been completed, and all scripts will now be loaded.");
}