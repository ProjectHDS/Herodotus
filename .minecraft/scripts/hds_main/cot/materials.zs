#priority 2000
#loader contenttweaker

import scripts.grassUtils.CotUtils;
import scripts.grassUtils.classes.MaterialSystemHelper.MaterialSystemHelper;
import scripts.hds_lib.cotlib;

//MSH commander function
function materialBuilder(name as string, partsList as string[], materialsList as int[string]){
    val register as MaterialSystemHelper = CotUtils.getMaterialSystemHelper(name);
    for parts in partsList{
        register.addPart(parts);
    }
    for mat in materialsList{
        register.registerMaterial(mat, materialsList[mat]);
    }
    register.registerAllMaterialParts();
}


//settelment
for key, value in cotlib.allPartsMap {
    materialBuilder(key, value, cotlib.allMaterialMap[key]);
}
