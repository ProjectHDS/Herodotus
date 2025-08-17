#packmode normal
#loader crafttweaker reloadable

import crafttweaker.events.IEventManager;
import crafttweaker.event.PlayerRightClickItemEvent;
import crafttweaker.item.IItemStack;
import crafttweaker.player.IPlayer;
import crafttweaker.data.IData;
import crafttweaker.oredict.IOreDictEntry;
import crafttweaker.event.PlayerTickEvent;
import mods.ctutils.commands.Commands;

static woodComponents as IOreDictEntry[] = [
    <ore:plankWood>,
    <ore:plateWood>,
    <ore:gearWood>,
    <ore:ingotWood>,
    <ore:gearSmallWood>,
    <ore:ringWood>,
    <ore:stickLongWood>,
    <ore:boltWood>,
    <ore:screwWood>,
    <ore:dustWood>
];

// 获取下一个木制部件
function getNextWoodComponent(currentItem as IItemStack) as IItemStack {
    // gt木板自带前两个矿词，跟着用遍历的会原地tp
    if(<ore:plankWood> has currentItem && <ore:plateWood> has currentItem) {
        return <ore:gearWood>.firstItem;
    }

    if(<ore:dustWood> has currentItem) {
        return null;
    }

    for i in 0 to woodComponents.length {
        if (woodComponents[i] has currentItem) {
            val nextIndex = (i + 1) % woodComponents.length;
            val nextItem = woodComponents[nextIndex].firstItem;
            return nextItem;
        }
    }
    return null;
}

function isWoodComponent(item as IItemStack) as bool {
    for component in woodComponents {
        if (component has item) {
            return true;
        }
    }
    return false;
}

// 创建物品标识符，检测切换物品用
function getItemIdentifier(item as IItemStack) as string {
    if (isNull(item)) {
        return "empty";
    }
    return item.definition.id ~ ":" ~ item.metadata;
}

// 按住右键设置isHolding为true
events.onPlayerRightClickItem(function(event as PlayerRightClickItemEvent) {
    val player = event.player;
    val mainHand = player.mainHandHeldItem;
    val offHand = player.offHandHeldItem;
    if(!player.world.remote) {
        return;
    }

    // 检查主手木制部件，副手锉
    if (!isNull(mainHand) && !isNull(offHand) && 
        isWoodComponent(mainHand) && <ore:toolFile> has offHand) {
        // 记录当前主手物品
        val currentItemIdentifier = getItemIdentifier(mainHand);
        player.update({
            isHolding: true,
            lastMainHandItem: currentItemIdentifier,
            releaseBuffer: 0
        });
    }
});

// 玩家tick事件处理计数和转化
events.onPlayerTick(function(event as PlayerTickEvent) {
    val player = event.player;
    val playerData = player.data;
    val mainHand = player.mainHandHeldItem;
    val offHand = player.offHandHeldItem;
    if(!player.world.remote) {
        return;
    }
    // 获取当前主手物品标识符
    val currentItemIdentifier = getItemIdentifier(mainHand);
    
    // 检查是否记录了上一帧的主手物品
    var lastItemChanged = false;
    if (!isNull(playerData.lastMainHandItem)) {
        val lastItemIdentifier = playerData.lastMainHandItem.asString();
        lastItemChanged = lastItemIdentifier != currentItemIdentifier;
        
        // 物品发生变化，重置计数
        if (lastItemChanged) {
            player.update({holdCounter: 0});
        }
    }
    
    // 更新上一帧的主手物品记录
    player.update({lastMainHandItem: currentItemIdentifier});
    
    // 检查玩家是否处于按住状态
    if (!isNull(player.data.isHolding) && playerData.isHolding.asBool()) {
        // 检查物品是否变化，如果变化则重置
        if (lastItemChanged) {
            player.update({isHolding: false, releaseBuffer: 0});
            return;
        }

        player.sendStatusMessage(game.localize("hds.message.woodcrafting.process") ~ (playerData.holdCounter.asFloat()/10.0)*100.0 ~ "%");
        
        if (!isNull(mainHand) && !isNull(offHand) && 
            isWoodComponent(mainHand) && <ore:toolFile> has offHand) {
            
            var counter = 0;
            if (!isNull(playerData.holdCounter)) {
                counter = playerData.holdCounter.asInt();
            }
            val nextComponent = getNextWoodComponent(mainHand);
            if(isNull(nextComponent)){
                player.sendStatusMessage(game.localize("hds.message.woodcrafting.unable"));
                return;
            }
            counter += 1;
            player.update({holdCounter: counter});
            server.commandManager.executeCommand(server, "/playsound minecraft:block.wood.break block "~ player.name ~ " " ~ player.x ~" "~ player.y ~" "~ player.z ~" 0.5 "~ (playerData.holdCounter.asFloat()/10.0));
            // 5s
            if (counter >= 10) {
                
                mainHand.mutable().shrink(1);
                player.give(nextComponent);

                player.sendStatusMessage(game.localize("hds.message.woodcrafting.done"));
                server.commandManager.executeCommand(server, "/playsound minecraft:block.wood.fall block "~ player.name ~ " " ~ player.x ~" "~ player.y ~" "~ player.z ~" 0.5 1");
                if (offHand.isDamageable) {
                    val damagedTool = offHand.withDamage(offHand.damage + 1);
                    player.replaceItemInInventory(-106, damagedTool);
                }

                player.update({holdCounter: 0});
            }
        }
        player.update({isHolding: false});
    }
    else {
        if(!isNull(playerData.releaseBuffer) && playerData.releaseBuffer.asInt() < 10) {
            // 如果玩家没有按住右键，增加缓冲计数
            player.update({releaseBuffer: playerData.releaseBuffer.asInt() + 1});
        } else {
            // 如果缓冲计数超过10，重置状态
            player.update({releaseBuffer: 0});
            player.update({holdCounter: 0});
            player.update({isHolding: false});
        }
    }
});

events.onPlayerLoggedOut(function(event as crafttweaker.event.PlayerLoggedOutEvent) {
    val player = event.player;
    player.update({isHolding: false, holdCounter: 0, releaseBuffer: 0, lastMainHandItem: null});
});