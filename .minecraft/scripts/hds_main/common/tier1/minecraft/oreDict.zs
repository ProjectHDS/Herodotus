#priority 1500

import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.oredict.IOreDictEntry;
import scripts.hds_main.utils.modloader.isInvalid;

if(!isInvalid){

val oreDictMap as IItemStack[][IOreDictEntry] = {
    <ore:glassLead>: [<contenttweaker:glass_lead>],
    <ore:glassCopper>: [<contenttweaker:glass_copper>],
    <ore:glassTin>: [<contenttweaker:glass_tin>],
    <ore:glassIron>: [<contenttweaker:glass_iron>],
    <ore:glassImpureTin>: [<contenttweaker:glass_impure_tin>],
    <ore:glassImpureCopper>: [<contenttweaker:glass_impure_copper>],
    <ore:glassImpureLead>: [<contenttweaker:glass_impure_lead>],
    <ore:glassImpureIron>: [<contenttweaker:glass_impure_iron>],
    <ore:glassSoftenedCopper>: [<contenttweaker:glass_softened_copper>],
    <ore:glassSoftenedTin>: [<contenttweaker:glass_softened_tin>],
    <ore:glassSoftenedLead>: [<contenttweaker:glass_softened_lead>],
    <ore:glassSoftenedIron>: [<contenttweaker:glass_softened_iron>],
    <ore:glassParticulatedCopper>: [<contenttweaker:glass_particulated_copper>],
    <ore:glassParticulatedTin>: [<contenttweaker:glass_particulated_tin>],
    <ore:glassParticulatedLead>: [<contenttweaker:glass_particulated_lead>],
    <ore:glassParticulatedIron>: [<contenttweaker:glass_particulated_iron>]
};

for oda, item in oreDictMap{
    oda.add(item);
}
}
