#packmode normal expert
#modloaded bathappymod
#loader contenttweaker
#priority 1000

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Block;
import mods.contenttweaker.BlockMaterial;
import mods.contenttweaker.SoundType;
import mods.contenttweaker.ResourceLocation;


var micq = VanillaFactory.createBlock("mic_quartz", <blockmaterial:stone>);
micq.setLightOpacity(3);
micq.setLightValue(0);
micq.setBlockHardness(5.0);
micq.setBlockResistance(5.0);
micq.setToolClass("pickaxe");
micq.setToolLevel(2);
micq.setBlockSoundType(<soundtype:stone>);
micq.setSlipperiness(0.3);
micq.register();
ResourceLocation.create("contenttweaker:ore_micquartz");