#priority -1

import crafttweaker.event.BlockNeighborNotifyEvent;
import crafttweaker.block.IBlockState;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IFacing;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_main.utils.debug.debug;

if(!isInvalid){
events.onBlockNeighborNotify(
    function (event as BlockNeighborNotifyEvent) {
        if (event.block.definition.id == "minecraft:piston_extension") {
            var facing = IFacing.fromString(event.blockState.getPropertyValue("facing").toUpperCase());
            var backFacing= facing.opposite();
            // 当活塞动作时，检查动作活塞朝向的反方向 1 格处是什么方块
            var originalPos = event.position;
            var offsetPos = originalPos.getOffset(backFacing, 1);
            
            var world = event.world;
            var offsetPosBlockState = world.getBlockState(offsetPos);
            var originalPosBlockState = world.getBlockState(originalPos);
            // 打印调试信息
            if (debug) printDebugInfo(offsetPosBlockState, originalPosBlockState);
            // 这里不确定能不能直接检测“是活塞拉”，所以暂时先写成“不是活塞推”
            if (!isPistonPush(offsetPosBlockState, originalPosBlockState)) {
                var targetBlockPos = originalPos.getOffset(facing, 2);
                var genBlockPos = originalPos.getOffset(facing, 1);
                // 活塞拉回时，活塞面上一格（即方块的生成位置）必定被活塞头占据
                if (world.getBlockState(targetBlockPos).block.definition.id == "hdsutils:dimcrystal_lead" && 
                    world.getBlockState(genBlockPos).block.definition.id == "minecraft:piston_head"
                ) {
                    world.setBlockState(<blockstate:hdsutils:unstable_lead_dim_fragment>, genBlockPos);
                }
            }
        }
    }
);
}
function printDebugInfo(offsetPosBlockState as IBlockState, originalPosBlockState as IBlockState) as void {
    print("Debug Info Displayed");
    print("------------------------");
    print("offsetPos Block is extended piston: " ~ isPiston(offsetPosBlockState));
    if (isPiston(offsetPosBlockState)) {
        print("offsetPosBlockState properties:");
        for property in offsetPosBlockState.getProperties() {
            print(property ~ ": " ~ offsetPosBlockState.getPropertyValue(property));
        }
    }
    print("originalPos Block is extended piston: " ~ isPiston(originalPosBlockState));
    if (isPiston(originalPosBlockState)) {
        print("originalPosBlockState properties:");
        for property in originalPosBlockState.getProperties() {
            print(property ~ ": " ~ originalPosBlockState.getPropertyValue(property));
        }
    }
    print("isPush: " ~ isPistonPush(offsetPosBlockState, originalPosBlockState));
}

function isPistonPush(offsetPosBlockState as IBlockState, originalPosBlockState as IBlockState) as bool {
    return (
        isPiston(offsetPosBlockState) &&
        (offsetPosBlockState.getPropertyValue("extended") == "false")
    ) && (
        isPiston(originalPosBlockState) &&
        (originalPosBlockState.block.definition.id == "minecraft:piston_extension")
    );
}

function isPiston(blockState as IBlockState) as bool {
    return (
        blockState.block.definition.id == "minecraft:piston" ||
        blockState.block.definition.id == "minecraft:sticky_piston" ||
        blockState.block.definition.id == "minecraft:piston_extension" 
    );
}
