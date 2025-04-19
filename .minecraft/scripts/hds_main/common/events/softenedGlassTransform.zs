#priority -1

import mods.fluidintetweaker.IEventManager;
import mods.fluidintetweaker.event.CustomFluidInteractionEvent;
import scripts.hds_main.utils.modloader.isInvalid;
import scripts.hds_lib.crtlib;

if(!isInvalid){

events.onCustomFluidInteraction(function(event as CustomFluidInteractionEvent) {
    if (!event.world.remote) {
        print(event.liquidInteractionRecipeKey);
    }
});
}