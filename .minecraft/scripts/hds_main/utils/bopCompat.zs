#norun
#priority 30000

import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.oredict.IOreDictEntry;

import mods.dropt.Dropt;
import mods.dropt.Range;
import mods.dropt.RuleList;
import mods.dropt.Harvester;
import mods.pyrotech.CompostBin;
import mods.pyrotech.CompactingBin;
import mods.inworldcrafting.FluidToItem;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.grassUtils.StringHelper;
import scripts.grassUtils.RecipeUtils;


function cbRecipe(output as IItemStack, input as IIngredient) {
    CompactingBin.addRecipe("bop_compat_"~ output.name, output, input, input.amount, true);
}

static root as RuleList = Dropt.list("bop_compat");

val grassBlocks as IItemStack[][IItemStack] = {
    // block: [dirt clump, grass clump, grass path]
    <biomesoplenty:grass:2>: [<contenttweaker:loamy_dirt_clump>, <contenttweaker:loamy_grass_clump>, <biomesoplenty:grass_path>],
    <biomesoplenty:grass:3>: [<contenttweaker:sandy_dirt_clump>, <contenttweaker:sandy_grass_clump>, <biomesoplenty:grass_path:1>],
    <biomesoplenty:grass:4>: [<contenttweaker:silty_dirt_clump>, <contenttweaker:silty_grass_clump>, <biomesoplenty:grass_path:1>],
    <biomesoplenty:grass:5>: [<pyrotech:rock:4>, <contenttweaker:original_grass_clump>, null],
    <biomesoplenty:grass:7>: [<pyrotech:rock:4>, <contenttweaker:flowering_grass_clump>, null],
};

val dirtBlocks as IItemStack[IItemStack] = {
    <biomesoplenty:dirt:8>: <contenttweaker:coarse_loamy_dirt_clump>,
    <biomesoplenty:dirt>: <contenttweaker:loamy_dirt_clump>,
    <biomesoplenty:dirt:9>: <contenttweaker:coarse_sandy_dirt_clump>,
    <biomesoplenty:dirt:1>: <contenttweaker:sandy_dirt_clump>,
    <biomesoplenty:dirt:10>: <contenttweaker:coarse_silty_dirt_clump>,
    <biomesoplenty:dirt:2>: <contenttweaker:silty_dirt_clump>,

    // sand
    <biomesoplenty:white_sand>: <contenttweaker:white_sand_pile>,
    <biomesoplenty:dried_sand>: <contenttweaker:dried_sand_pile>
};

val farmlandSupport as IItemStack[][IItemStack] = {
    <contenttweaker:loamy_dirt_clump> : [<biomesoplenty:farmland_0:0>, <biomesoplenty:farmland_0:14>, <biomesoplenty:farmland_0:12>, <biomesoplenty:farmland_0:10>, <biomesoplenty:farmland_0:8>, <biomesoplenty:farmland_0:6>, <biomesoplenty:farmland_0:4>, <biomesoplenty:farmland_0:2>],
    <contenttweaker:sandy_dirt_clump> : [<biomesoplenty:farmland_0:1>, <biomesoplenty:farmland_0:15>, <biomesoplenty:farmland_0:13>, <biomesoplenty:farmland_0:11>, <biomesoplenty:farmland_0:9>, <biomesoplenty:farmland_0:7>, <biomesoplenty:farmland_0:5>, <biomesoplenty:farmland_0:3>],
    <contenttweaker:silty_dirt_clump> : [<biomesoplenty:farmland_1:0>, <biomesoplenty:farmland_0:14>, <biomesoplenty:farmland_1:12>, <biomesoplenty:farmland_1:10>, <biomesoplenty:farmland_1:8>, <biomesoplenty:farmland_1:6>, <biomesoplenty:farmland_1:4>, <biomesoplenty:farmland_1:2>]
};

val stoneBlocks as IItemStack[IItemStack] = {
    <biomesoplenty:white_sandstone>: <contenttweaker:white_sandstone_rock>
};

val normalGrasses as IItemStack[] = [
    <biomesoplenty:plant_0>, <biomesoplenty:plant_0:1>, <biomesoplenty:plant_0:7>, <biomesoplenty:plant_0:10>
];

val driedGrasses as IItemStack[] = [
    <biomesoplenty:plant_0:13>, <biomesoplenty:plant_0:14>, <biomesoplenty:plant_1>
];

val wetGrasses as IItemStack[] = [
    <biomesoplenty:plant_0:8>, <biomesoplenty:plant_1:7>
];

if(!isInvalid){
    val explosion as Harvester = Dropt.harvester().type("EXPLOSION");
    val emptyHand as Harvester = Dropt.harvester().type("PLAYER").mainHand("WHITELIST", [null]);
    val notShovel as Harvester = Dropt.harvester().mainHand("BLACKLIST", [], "shovel;0;-1");
    val woodenShovel as Harvester = Dropt.harvester().type("PLAYER").mainHand("BLACKLIST", [], "shovel;1;-1");
    val stoneShovel as Harvester = Dropt.harvester().type("PLAYER").mainHand("BLACKLIST", [], "shovel;2;-1");
    val anyShovel as Harvester = Dropt.harvester().type("PLAYER").mainHand("WHITELIST", [], "shovel;-1;-1");
    val notPickaxe as Harvester = Dropt.harvester().mainHand("BLACKLIST", [], "pickaxe;0;-1");
    val woodenPickaxe as Harvester = Dropt.harvester().type("PLAYER").mainHand("BLACKLIST", [], "pickaxe;1;-1");
    val stonePickaxe as Harvester = Dropt.harvester().type("PLAYER").mainHand("BLACKLIST", [], "pickaxe;2;-1");
    val anyPickaxe as Harvester = Dropt.harvester().type("PLAYER").mainHand("WHITELIST", [], "pickaxe;-1;-1");
    val strangeTuber as IItemStack = <pyrotech:strange_tuber>;
    val plantFibers as IItemStack = <pyrotech:material:12>;
    val plantFibersDried as IItemStack = <pyrotech:material:13>;

    for grass in normalGrasses {
        var matchBlocks as string[] = [StringHelper.getItemName(grass)];
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(emptyHand)
            .replaceStrategy("ADD")
            .addDrop(Dropt.drop().items([plantFibers], Dropt.range(1, 2)).selector(Dropt.weight(35)))
            .addDrop(Dropt.drop().items([plantFibersDried], Dropt.range(1, 2)).selector(Dropt.weight(5)))
            .addDrop(Dropt.drop().items([strangeTuber], Dropt.range(1, 2)).selector(Dropt.weight(2)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(Dropt.harvester().type("PLAYER"))
            .replaceStrategy("ADD")
            .addDrop(Dropt.drop().items([plantFibers], Dropt.range(1, 2)).selector(Dropt.weight(35)))
            .addDrop(Dropt.drop().items([plantFibersDried], Dropt.range(1, 2)).selector(Dropt.weight(5)))
        );
        recipes.addShapeless("bop_compat_"~ StringHelper.getItemNameWithUnderline(grass), plantFibers, [grass]);
        // FluidToItem.transform(<astralsorcery:blockcustomflower> * 4, <liquid:astralsorcery.liquidstarlight>, [grass * 4], true);
        CompostBin.addRecipe(<pyrotech:mulch>, grass);
    }

    for grass in driedGrasses {
        var matchBlocks as string[] = [StringHelper.getItemName(grass)];
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(emptyHand)
            .replaceStrategy("ADD")
            .addDrop(Dropt.drop().selector(Dropt.weight(70)))
            .addDrop(Dropt.drop().items([plantFibersDried], Dropt.range(1, 2)).selector(Dropt.weight(50)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(Dropt.harvester().type("PLAYER"))
            .replaceStrategy("ADD")
            .addDrop(Dropt.drop().selector(Dropt.weight(70)))
            .addDrop(Dropt.drop().items([plantFibersDried], Dropt.range(1, 2)).selector(Dropt.weight(50)))
        );
        recipes.addShapeless("bop_compat_"~ StringHelper.getItemNameWithUnderline(grass), plantFibersDried, [grass]);
    }

    for grass in wetGrasses {
        var matchBlocks as string[] = [StringHelper.getItemName(grass)];
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(emptyHand)
            .replaceStrategy("ADD")
            .addDrop(Dropt.drop().selector(Dropt.weight(70)))
            .addDrop(Dropt.drop().items([plantFibers], Dropt.range(1, 2)).selector(Dropt.weight(50)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(Dropt.harvester().type("PLAYER"))
            .replaceStrategy("ADD")
            .addDrop(Dropt.drop().selector(Dropt.weight(70)))
            .addDrop(Dropt.drop().items([plantFibers], Dropt.range(1, 2)).selector(Dropt.weight(50)))
        );
        recipes.addShapeless("bop_compat_"~ StringHelper.getItemNameWithUnderline(grass), plantFibers, [grass]);
        // FluidToItem.transform(<astralsorcery:blockcustomflower> * 4, <liquid:astralsorcery.liquidstarlight>, [grass * 4], true);
        CompostBin.addRecipe(<pyrotech:mulch>, grass);
    }


    for dirtClump, blocks in farmlandSupport {
        for block in blocks {
            var matchBlocks as string[] = [StringHelper.getItemName(block)];
            root.add(Dropt.rule()
                .matchBlocks(matchBlocks)
                .matchHarvester(explosion)
                .addDrop(Dropt.drop().selector(Dropt.weight(9)))
                .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1)))
            );
            root.add(Dropt.rule()
                .matchBlocks(matchBlocks)
                .matchHarvester(notShovel)
                .dropCount(Dropt.range(1, 2))
                .dropStrategy("UNIQUE")
                .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1, 3)).selector(Dropt.weight(50)))
            );
            root.add(Dropt.rule()
                .matchBlocks(matchBlocks)
                .matchHarvester(woodenShovel)
                .dropStrategy("UNIQUE")
                .dropCount(Dropt.range(1, 2))
                .addDrop(Dropt.drop().items([dirtClump], Dropt.range(2, 4)).selector(Dropt.weight(400)))
            );
            root.add(Dropt.rule()
                .matchBlocks(matchBlocks)
                .matchHarvester(stoneShovel)
                .dropStrategy("UNIQUE")
                .addDrop(Dropt.drop().items([block]).selector(Dropt.weight(100)))
                .addDrop(Dropt.drop().items([dirtClump], Dropt.range(3, 6)).selector(Dropt.weight(300)))
            );
        }
    }

    for block, entry in grassBlocks {
        val dirtClump as IItemStack = entry[0];
        val grassClump as IItemStack = entry[1];
        val grassPath as IItemStack = entry[2];
        var matchBlocks as string[] = [StringHelper.getItemName(block)];
        if (!isNull(grassPath)) {
            matchBlocks += StringHelper.getItemName(grassPath);
        }
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(explosion)
            .addDrop(Dropt.drop().selector(Dropt.weight(9)))
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(emptyHand)
            .dropCount(Dropt.range(1, 2))
            .dropStrategy("UNIQUE")
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1, 3)).selector(Dropt.weight(5)))
            .addDrop(Dropt.drop().items([strangeTuber], Dropt.range(1, 2)).selector(Dropt.weight(2)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(notShovel)
            .dropCount(Dropt.range(1, 2))
            .dropStrategy("UNIQUE")
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1, 3)).selector(Dropt.weight(50)))
            .addDrop(Dropt.drop().items([strangeTuber]).selector(Dropt.weight(1)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(woodenShovel)
            .dropStrategy("UNIQUE")
            .dropCount(Dropt.range(1, 2))
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(2, 4)).selector(Dropt.weight(400)))
            .addDrop(Dropt.drop().items([grassClump]).selector(Dropt.weight(100)))
            .addDrop(Dropt.drop().items([strangeTuber]).selector(Dropt.weight(5)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(stoneShovel)
            .dropStrategy("UNIQUE")
            .dropCount(Dropt.range(2))
            .addDrop(Dropt.drop().items([block]).selector(Dropt.weight(100)))
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1, 3)).selector(Dropt.weight(300)))
            .addDrop(Dropt.drop().items([grassClump], Dropt.range(1, 3)).selector(Dropt.weight(200)))
            .addDrop(Dropt.drop().items([strangeTuber]).selector(Dropt.weight(1)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(anyShovel)
            .replaceStrategy("ADD")
            .dropCount(Dropt.range(0, 1))
            .addDrop(Dropt.drop().items([grassClump], Dropt.range(1, 3)).selector(Dropt.weight(1), "EXCLUDED"))
        );
        cbRecipe(block, grassClump * 8);
        recipes.addShapeless("bop_compat_"~ StringHelper.getItemNameWithUnderline(grassClump), <pyrotech:material:12>, [grassClump]);
    }
    for block, dirtClump in dirtBlocks {
        var matchBlocks as string[] = [StringHelper.getItemName(block)];
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(explosion)
            .addDrop(Dropt.drop().selector(Dropt.weight(9)))
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(notShovel)
            .dropCount(Dropt.range(1, 2))
            .dropStrategy("UNIQUE")
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(1, 3)).selector(Dropt.weight(50)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(woodenShovel)
            .dropStrategy("UNIQUE")
            .dropCount(Dropt.range(1, 2))
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(2, 4)).selector(Dropt.weight(400)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(stoneShovel)
            .dropStrategy("UNIQUE")
            .addDrop(Dropt.drop().items([block]).selector(Dropt.weight(100)))
            .addDrop(Dropt.drop().items([dirtClump], Dropt.range(3, 6)).selector(Dropt.weight(300)))
        );
        cbRecipe(block, dirtClump * 8);
    }
    for block, rock in stoneBlocks {
        var matchBlocks as string[] = [StringHelper.getItemName(block)];
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(explosion)
            .addDrop(Dropt.drop().selector(Dropt.weight(9)))
            .addDrop(Dropt.drop().items([rock], Dropt.range(1)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(Dropt.harvester().type("NON_PLAYER"))
            .addDrop(Dropt.drop().items([rock], Dropt.range(2, 4)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(Dropt.harvester().type("PLAYER").mainHand([<pyrotech:crude_pickaxe:*>]))
            .addDrop(Dropt.drop().items([rock], Dropt.range(2, 4)))
        );
        root.add(Dropt.rule()
            .matchBlocks(matchBlocks)
            .matchHarvester(stonePickaxe)
            .addDrop(Dropt.drop().items([rock], Dropt.range(3, 6)).selector(Dropt.weight(4)))
            .addDrop(Dropt.drop().items([block]))
        );
        recipes.addShaped(StringHelper.getItemNameWithUnderline(block) + "_from_rock", block, RecipeUtils.createSurround(<pyrotech:material:17>, rock));
    }

    for i in 0 .. 6 {
        Dropt.list("bop_compact")
            .add(Dropt.rule()
                .replaceStrategy("ADD")
                .matchBlocks(["biomesoplenty:leaves_" ~ i ~ ":*"])
                .addDrop(Dropt.drop()
                    .selector(Dropt.weight(85))
                    .items([<minecraft:stick>])
                )
                .addDrop(Dropt.drop().selector(Dropt.weight(50)))
            );
    }

}
