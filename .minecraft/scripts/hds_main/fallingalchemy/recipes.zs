import mods.fallingalchemy.FallingAlchemy;
import mods.fallingalchemy.ConsumedItem;
import scripts.hds_lib.crtlib;
import scripts.hds_main.utils.modloader.isInvalid;

if(!isInvalid){
FallingAlchemy.addConversion(
    <hdsutils:unstable_lead_dim_fragment>,
    [],
    1,
    [<contenttweaker:material_part:26>*1],
    1,
    0,
    1,
    0.01,
    true,
    "minecraft:entity.endermen.teleport", 1.0, 1.2
).register();

FallingAlchemy.addConversion(
    <hdsutils:unstable_lead_dim_fragment>,
    [],
    1,
    [<contenttweaker:material_part:27> * 2],
    1,
    0,
    2,
    1,
    true,
    "minecraft:entity.endermen.teleport", 1.0, 1.2
).register();

FallingAlchemy.addConversion(
    <hdsutils:unstable_lead_dim_fragment>,
    [],
    1,
    [<contenttweaker:material_part:27> * 4],
    1,
    0,
    3,
    2,
    true,
    "minecraft:entity.endermen.teleport", 1.0, 1.2
).register();
}