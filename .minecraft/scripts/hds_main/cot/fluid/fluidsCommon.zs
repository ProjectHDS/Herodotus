#priority 2000
#loader contenttweaker

import scripts.grassUtils.CotUtils;
import scripts.hds_lib.cotlib;
import scripts.hds_lib.crtlib;

//register
//addFluid(name as string, color as int, temperature as int, viscosity as int, density as int, luminosity as int, isLava as bool){
for mat, color in cotlib.allMaterialMap[0] {
    CotUtils.addFluid(mat.toLowerCase() ~ "_soften_glass", color, 1300, 0, crtlib.maxInt, 10, true);
    CotUtils.addFluid(mat.toLowerCase() ~ "_amorphous", color, 300, 1000, 1000, 0, false);
    CotUtils.addFluid(mat.toLowerCase() ~ "_amorphous_suspension", color, 300, 1000, 1000, 0, false);
}
