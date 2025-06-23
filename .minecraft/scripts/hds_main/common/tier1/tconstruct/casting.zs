#priority -1

import mods.tconstruct.Casting;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.liquid.ILiquidStack;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if (!isInvalid) {

    var baseParts as IItemStack[] = [
        <hdsutils:meta_gear>,
        <hdsutils:meta_gear_small>,
        <hdsutils:meta_plate>,
        <hdsutils:meta_stick>,
        <hdsutils:meta_stick_long>,
        <hdsutils:meta_ring>,
        <hdsutils:meta_ingot>,
        <hdsutils:meta_block_compressed_0>,
        <hdsutils:meta_screw>
    ];

    var woodParts as IIngredient[] = [
        <ore:gearWood>,
        <ore:gearSmallWood>,
        <ore:plateWood>,
        <ore:stickWood>,
        <ore:stickLongWood>,
        <ore:ringWood>,
        <ore:ingotWood>,
        <ore:plankWood>,
        <ore:screwWood>
    ];

    var baseLiquid as ILiquidStack[] = [
        null, // Index 0 (no liquid)
        <liquid:copper>, // Index 1
        <liquid:iron>, // Index 2
        <liquid:tin>, // Index 3
        <liquid:lead> // Index 4
    ];

    for meta in 1 .. 5 {
        for i, part in baseParts {
            val input = woodParts[i];
            val result = part.definition.makeStack(meta);
            val liquid = baseLiquid[meta];

            // Add table casting recipe
            Casting.addTableRecipe(
                result,
                input,
                liquid,
                16,
                true,
                80
            );
        }
    }

}