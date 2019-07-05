* GAMS code
* ------------------------------------------------------------------------------
*
* The Beaver BeWhere Co-firing Dynamic Model for Vietnam
*
*                        2019.07.03
* ------------------------------------------------------------------------------
*
OPTION MIP=CPLEX;
*
* ------------------------------------------------------------------------------
*                                - SETS -
* ------------------------------------------------------------------------------

set P plants /
$include txt_file_beaver/set-plant.txt
/;

set Tech technologies /
$include txt_file_beaver/set-technology.txt
/;

set S supply /
$include txt_file_beaver/set-supply.txt
/;

set RM raw material /
$include txt_file_beaver/set-raw-material.txt
/;

set T transportmode /
$include txt_file_beaver/set-transport.txt
/;

set Y years /
$include txt_file_beaver/set-years.txt
/;

set RMTe(RM,Tech) raw meterial technology relation /
$include txt_file_beaver/set-raw-material-technology.txt
/;

* ------------------------------------------------------------------------------
*                                - PARAMETERS -
* ------------------------------------------------------------------------------
****** COAL ******

parameter Generation(Y,P) /
$include txt_file_beaver/parameter-power-generation.txt
/;

parameter coalPrice(Y,P) /
$include txt_file_beaver/parameter-coal-price.txt
/;

parameter LCOECoalPlant(Y,P) /
$include txt_file_beaver/LCOE-coal-plant.txt
/;

****** BIOMASS ******

parameter BiomassPotential(Y,S,RM)/
$include txt_file_beaver/parameter-available-biomass.txt
/;

parameter BiomPrice(Y,S,RM)/
$include txt_file_beaver/parameter-biomass_price.txt
/;

****** CO_FIRING ******

parameter CostIOMCofir(Y,P,Tech) /
$include txt_file_beaver/parameter-cost-IOM-cofiring.txt
/;

parameter UrateHigh(Tech)/
$include txt_file_beaver/parameter-utilization-rate.txt
/;

parameter UrateLow(Tech)/
$include txt_file_beaver/parameter-utilization-rate-low.txt
/;

parameter EffCof(P)/
$include txt_file_beaver/parameter-efficiency-cofiring.txt
/;

****** TRANSPORT ******

parameter transDistSupplyPlant(S,P,T) /
$include txt_file_beaver/parameter-distance-supply-plant.txt
/;

parameter tranBiofix(Y,RM,T) /
$include txt_file_beaver/parameter-transport-fix-cost.txt
/;

parameter tranBiovar(Y,RM,T)/
$include txt_file_beaver/parameter-transport-var-cost.txt
/;

****** EMISSIONS ******

parameter transEmissionBiomass(RM,T)/
$include txt_file_beaver/parameter-trans-emission.txt
/;

parameter EmFactorCoal(P,Tech)/
$include txt_file_beaver/parameter-emission-factor.txt
/;

parameter carbonprice(Y,P,Tech) /
$include txt_file_beaver/parameter-price-carbon.txt
/;


* ------------------------------------------------------------------------------
*                                - VARIALBLES -
* ------------------------------------------------------------------------------

binary variable
UP(y,P,Tech)

positive variables
BSP(Y,S,RM,P,Tech)                       Amount of biomass used in the coal plant (unit)
LCOE(Y,P)                                Levelized cost of electricity ??????

AvailableBiomass(Y,S,RM)                 Biomass available to be used for each year

CostBMTransport(Y,P,RM,T,Tech)           Cost of transporting the biomass
CostBio(Y,P,RM,Tech)                     Cost of biomass
CostFossil(Y,P)                          Cost related to coal for electricity production

EmissionBMTransport(Y,P,T,Tech)          Emissions from transport of biomass
TechEmission(Y,P,tech)                   Emission from production
CoalEmission(Y,P)                        Emission from existing coal plants

ElBio(Y,P,Tech)                          Electricity from biomass in co-firing configuration

variable
COMBINEEQUATIONS
TOTEMISSIONS(Y)
TOTCOST(Y)

equations
biomassCost(Y,P,RM,Tech)
biomassTransportSPCost(Y,P,RM,Tech)
ProductionCost(P)
FossilCost(P,R)
TotalCosteq(R)


*-------------------------------------------------------------------------------
*-----------------------   COSTS    --------------------------------------------
*-------------------------------------------------------------------------------

****** BIOMASS COST ******
biomassCost(Y,P,RM,Tech)..
         CostBio(Y,P,RM,Tech) =E= SUM((S,tECH,T)$(transDistSupplyPlant(S,P,T)and RMTe(RM,Tech) and (Ord(Tech) eq 3 or Ord(Tech) eq 4)),costBm(Y,S,RM)*BSP(Y,S,RM,P,Tech));

biomassCost(Y,P,RM,Tech)$ RMTe(RM,Tech)..
         CostBio(y,P,RM,Tech) =E= SUM((S)$transDistSupplyPlant(S,P),costBm(S,RM)*BSP(y,S,RM,P,Tech));
 ************************jkll*************