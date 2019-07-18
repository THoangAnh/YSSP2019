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

*set R region /
*$include txt_file_beaver/set-region.txt
*/;

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

set YP(Y,P) year plant relation /
$include txt_file_beaver/set-year-plant-relation.txt
/;

set SRM(Y,S,RM) year supply raw material relation /
$include txt_file_beaver/set-year-supply-raw-material-relation.txt
/;

* ------------------------------------------------------------------------------
*                                - PARAMETERS -
* ------------------------------------------------------------------------------

*** POWER PLANTS ******

parameter initialStatus(P,Tech)/
$include txt_file_beaver/parameter-initial-status.txt
/;

parameter EffCoal(P)/
$include txt_file_beaver/parameter-efficiency-coal_plant.txt
/;

****** COAL ******

parameter Capacity(P) /
$include txt_file_beaver/parameter-power-capacity.txt
/;

parameter Generation(Y,P) /
$include txt_file_beaver/parameter-power-generation.txt
/;
* unit_Generation_GWh

parameter coalPrice(Y,P) /
$include txt_file_beaver/parameter-coal-price.txt
/;
* unit coalPrice_$/GWh (GWh is converted from J of coal_energy)

parameter InvestmentCoal(Y,P) /
$include txt_file_beaver/parameter-investment-coal-plant.txt
/;
* unit InvestmentCoal_$/GWh (GWh is electricity generation)

parameter CostIOMCoal(Y,P) /
$include txt_file_beaver/parameter-cost-IOM-coal.txt
/;
*unit CostIOMCoal_$/GWh (GWh is electricity generation)

****** BIOMASS ******

parameter BiomassPotential(Y,S,RM)/
$include txt_file_beaver/parameter-potential-biomass.txt
/;

parameter BiomPrice(Y,S,RM)/
$include txt_file_beaver/parameter-biomass_price.txt
/;
* unit BiomPrice_$/PJ

****** CO_FIRING ******

parameter CRFCofir(P) /
$include txt_file_beaver/parameter-CRF-cofiring.txt
/;

parameter SpecificCostCofir(Y,P,Tech) /
$include txt_file_beaver/parameter-specific-cost-cofiring.txt
/;
* unit SpecificCostCofir_$/MWelec

parameter FixOMCostCofir(Y,P,Tech) /
$include txt_file_beaver/parameter-fix-OM-cost-cofiring.txt
/;

parameter VarOMCostCofir(Y,P,Tech) /
$include txt_file_beaver/parameter-var-OM-cost-cofiring.txt
/;

parameter UrateHigh(Tech)/
$include txt_file_beaver/parameter-utilization-rate-high.txt
/;

parameter UrateLow(Tech)/
$include txt_file_beaver/parameter-utilization-rate-low.txt
/;

parameter EffCof(Tech)/
$include txt_file_beaver/parameter-efficiency-cofiring.txt
/;

****** TRANSPORT ******

parameter transDistSupplyPlant(S,P,T) /
$include txt_file_beaver/parameter-distance-supply-plant.txt
/;
* unit transDistSupplyPlant_km

parameter tranBiofix(Y,RM,T) /
$include txt_file_beaver/parameter-transport-fix-cost.txt
/;
* unit tranBiofix_$/PJ/km (PJ is expressed by biomass raw energy)

parameter tranBiovar(Y,RM,T)/
$include txt_file_beaver/parameter-transport-var-cost.txt
/;
* unit tranBiovar_$/PJ/km (PJ is expressed by biomass raw energy)

****** EMISSIONS ******

parameter transEmissionBiomass(RM,T)/
$include txt_file_beaver/parameter-trans-emission.txt
/;

parameter EmFoscoal(Y,P)/
$include txt_file_beaver/parameter-emission-basecase.txt
/;

parameter carbonprice(Y,P,Tech) /
$include txt_file_beaver/parameter-price-carbon.txt
/;


* ------------------------------------------------------------------------------
*                                - VARIALBLES -
* ------------------------------------------------------------------------------

binary variable
UP(Y,P,Tech)

positive variables
BSP(Y,S,RM,P,Tech)                       Amount of biomass used in the coal plant (unit_PJ)

CoalProductionCost(Y,P)                  Production cost of electricity from coal power plant
CofirProductionCost(Y,P,Tech)            Production cost of electricity from co-firing power plant

AvailableBiomass(Y,S,RM)                 Biomass available to be used for each year

CostBMTransport(Y,P,S,RM,T,Tech)         Cost of transporting the biomass
CostBio(Y,P,RM,Tech)                     Cost of biomass
CostFossil(Y,P)                          Cost related to coal for electricity production (unit_$)

EmissionBMTransport(Y,P,S,T,Tech)        Emissions from transport of biomass
EmissionProduction(Y,P,Tech)             Emission from production

ElBio(Y,P,Tech)                          Electricity from biomass in co-firing configuration (unit_GWh)

variable
COMBINEEQUATIONS
TOTCOST(Y)
TOTEMISSIONS(Y)
TOTEMISSIONSCOST(Y)

equations

****** ELECTRICITY PRODUCTIONS ******
ElectricityBiomass(Y,P,Tech)          Electricity produced from biomass

****** COSTS ******
FossilCost(Y,P)
BiomassCost(Y,P,RM,Tech)
biomassTransportSPCost(Y,P,S,RM,T,Tech)
ProductionCostCoal(Y,P)
ProductionCostCoFir(Y,P,Tech)
TotalCosteq(Y)

****** EMISSIONS ******
transportBMEmission(Y,P,S,T,Tech)      Emissions from transport
ProductionEmission(Y,P,Tech)           Emissions generated from production
totalEmissions(Y)
totalEmissionsCost(Y)
combine

****** CONSTRAINTS ******
availabilityBM(Y,S,RM)
supplyBiomass(Y,S,RM)
*constraintsBSP(Y,S,RM,P,Tech)
plantStatus(Y,P,Tech)
plantTypeRestriction(Y,P)
ElBioMaxConstraint(Y,P,Tech)
ElBioMinConstraint(Y,P,Tech)

;
*-------------------------------------------------------------------------------
*-----------------------   COSTS    --------------------------------------------
*-------------------------------------------------------------------------------

****** COAL COST FOR NORMAL COAL OR CO-FIRING CONFIGURATION ******

FossilCost(Y,P)..
         CostFossil(Y,P) =E= SUM((Tech) $(YP(Y,P)),coalPrice(Y,P)*(Generation(Y,P)-ElBio(Y,P,Tech))/EffCoal(P));
*recheck efficiency

****** BIOMASS COST FOR CO-FIRING CONFIGURATION ******

BiomassCost(Y,P,RM,Tech)..
         CostBio(Y,P,RM,Tech) =E= SUM((S,T)$(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),BiomPrice(Y,S,RM)*BSP(Y,S,RM,P,Tech));


****** BIOMASS TRANSPORT COST TO PLANTS ******

biomassTransportSPCost(Y,P,S,RM,T,Tech)..
         CostBMTransport(Y,P,S,RM,T,Tech) =E= ((transDistSupplyPlant(S,P,T)*tranBiovar(Y,RM,T) + tranBiofix(Y,RM,T))*BSP(Y,S,RM,P,Tech)) $(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM));


****** PRODUCTION COST ******

******------- PRODUCTION COST = INVESTMENT + FIX O&M + VAR O&M ------******

******------- PRODUCTION COST FOR NORMAL COAL CONFIGURATION ------******

ProductionCostCoal(Y,P)  $(YP(Y,P))..
         CoalProductionCost(Y,P) =E= CostIOMCoal(Y,P)*Generation(Y,P)*(SUM(Tech,(1-UP(Y,P,Tech))));


******------- PRODUCTION COST FOR CO-FIRING CONFIGURATION ------******

ProductionCostCoFir(Y,P,Tech)..
         CofirProductionCost(Y,P,Tech) =E= ((InvestmentCoal(Y,P)*Generation(Y,P)*UP(Y,P,Tech)+ SpecificCostCofir(Y,P,Tech)*ElBio(Y,P,Tech)/Generation(Y,P)*Capacity(P))*CRFCofir(P)
                                           + FixOMCostCofir(Y,P,Tech)*Capacity(P)*UP(Y,P,Tech)
                                           + VarOMCostCofir(Y,P,Tech)*Generation(Y,P)*UP(Y,P,Tech)) $(YP(Y,P));

*ProductionCostCoFir(Y,P,Tech)..
*CofirProductionCost(Y,P,Tech) =E= ((InvestmentCoal(Y,P)*(Generation(Y,P)-ElBio(Y,P,Tech))+ SpecificCostCofir(Y,P,Tech)*ElBio(Y,P,Tech)/Generation(Y,P)*Capacity(P))*CRFCofir(P)
*+ FixOMCostCofir(Y,P,Tech)*Capacity(P)
*+ VarOMCostCofir(Y,P,Tech)*Generation(Y,P))*(UP(Y,P,Tech));

***************** TOTAL COST ******************

TotalCosteq(Y)..
         TOTCOST(Y) =E=
*   coal cost
           SUM((P),CostFossil(Y,P))
*   biomass cost
         + SUM((P,RM,Tech),CostBio(Y,P,RM,Tech))
*   biomass transport cost
         + SUM((P,S,RM,T,Tech),CostBMTransport(Y,P,S,RM,T,Tech))
*   production cost
         + SUM((P,Tech),CoalProductionCost(Y,P))
*   production cost co_firing
         + SUM((P,Tech),CofirProductionCost(Y,P,Tech));


*-------------------------------------------------------------------------------
*-----------------------   EMISSIONS    ----------------------------------------
*-------------------------------------------------------------------------------

****** BIOMASS TRANSPORT EMISSIONS ******

transportBMEmission(Y,P,S,T,Tech)..
         EmissionBMTransport(Y,P,S,T,Tech) =E=
         SUM(RM $(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),
         (transEmissionBiomass(RM,T)*transDistSupplyPlant(S,P,T)*BSP(Y,S,RM,P,Tech)));


****** PRODUCTION EMISSIONS FROM COAL ******

ProductionEmission(Y,P,Tech)..
         EmissionProduction(Y,P,Tech) =E=
         SUM((RM),EmFoscoal(Y,P)*(Generation(Y,P)-ElBio(Y,P,Tech))) $(YP(Y,P));
** Check if emission from coal is expressed by coal heat energy or electricity. If by coal energy, should add Eff_coal


totalEmissions(Y)..
         TOTEMISSIONS(Y) =E=
* biomass transport
         SUM((P,S,T,Tech),EmissionBMTransport(Y,P,S,T,Tech))
* coal combustion
         + SUM((P,Tech),EmissionProduction(Y,P,Tech));

totalEmissionsCost(Y)..
         TOTEMISSIONSCOST(Y) =E= SUM((P,Tech),TOTEMISSIONS(Y)*carbonprice(Y,P,Tech));

*-------------------------------------------------------------------------------
*-----------------------   OBJECTIVE FUNCTION    -------------------------------
*-------------------------------------------------------------------------------

combine..
         COMBINEEQUATIONS =E= sum(Y,TOTCOST(Y)+ TOTEMISSIONSCOST(Y));

*-------------------------------------------------------------------------------
*------------------------------   CONSTRAINTS    -------------------------------
*-------------------------------------------------------------------------------

****** BIOMASS ******

******------ BIOMASS AVAILIBILITY ------******

availabilityBM(Y,S,RM) $(SRM(Y,S,RM))..
AvailableBiomass(Y,S,RM) =E=  (BiomassPotential(Y,S,RM)$(ORD(Y) eq 1) + BiomassPotential(Y,S,RM)$(ORD(Y) gt 1) - SUM((P,Tech,T)$(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P)),BSP(Y-1,S,RM,P,Tech))$(ORD(Y) gt 1));


******------ BIOMASS USED FOR POWER PLANTS ------******

supplyBiomass(Y,S,RM)..
         SUM((P,Tech,T)$(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),BSP(Y,S,RM,P,Tech))
         =L= AvailableBiomass(Y,S,RM);

******------ ELCTRICITY PRODUCED FROM BIOMASS  ------******

ElectricityBiomass(Y,P,Tech)..
         SUM((S,RM,T)$(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),EffCof(Tech)*BSP(Y,S,RM,P,Tech))
         =E= ElBio(Y,P,Tech);

******------ TECHNOLOGIES ------******

* Time constraint, When a plant is built, it stays the year after
plantStatus(Y,P,Tech) $(YP(Y,P))..
        UP(Y,P,Tech) =G= initialStatus(P,Tech)$(ORD(Y) eq 1) + UP(Y-1,P,Tech)$(ORD(Y) gt 1);

* Constraints when no co-firing, BSP = 0
*constraintsBSP(Y,S,RM,P,Tech)..BSP(Y,S,RM,P,Tech) =E= 0 $(1-UP(Y,P,Tech));

* Plant type restriction
plantTypeRestriction(Y,P) $(YP(Y,P))..
         SUM(Tech,UP(Y,P,Tech)) =L= 1;

* Contraints on max and min biomass

ElBioMaxConstraint(Y,P,Tech)..
          SUM((S,RM,T)$(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),ElBio(Y,P,Tech)) =L= UrateHigh(Tech)*Generation(Y,P)*UP(Y,P,Tech);

ElBioMinConstraint(Y,P,Tech)..
         SUM((S,RM,T)$(transDistSupplyPlant(S,P,T) and RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),ElBio(Y,P,Tech)) =G= UrateLow(tech)*Generation(Y,P)*UP(Y,P,Tech);


* ------------------------------------------------------------------------------
*
FILE cplexOpt/ cplex.opt /;
PUT cplexOpt;
PUT "PARALLELMODE = 1"/;
*PUT "epint=0.1"/;
PUT "threads=2"/;
PUTCLOSE cplexOpt;
*
************************************
MODEL facilityLocation  /ALL/;
facilityLocation.ITERLIM   = 1000000;
facilityLocation.RESLIM    =  100000;
facilityLocation.NODLIM    = 1000000;
facilityLocation.OPTCA     =  0;
facilityLocation.OPTCR     =  0;
facilityLocation.CHEAT     =  0;
facilityLocation.CUTOFF    =  1E+20;
facilityLocation.TRYINT    =  .01;
facilityLocation.OPTFILE   = 1;
facilityLocation.PRIOROPT  = 0;
facilityLocation.workspace = 16000;
*-----------------------
facilityLocation.SCALEOPT = 1;
*-----------------
*

************************************
*option MIP=gamschk;
SOLVE facilityLocation USING MIP MINIMIZING COMBINEEQUATIONS;
************************************
*
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*

$ontext
FILE resultFile/
*$include txt_file_beaver/file-solution.txt
//;

PUT resultFile;
PUT "%---- Resolution ------"/;
*
PUT "MODELSTAT = "
PUT facilityLocation.MODELSTAT:6:0
PUT ";"/;
*
PUT "SOLVESTAT = "
PUT facilityLocation.SOLVESTAT:6:0
PUT ";"/;
*
PUT "RESUSD = "
PUT facilityLocation.RESUSD:6:0
PUT ";"/;
*
PUT "%---- Main numbers ----"/;
*

PUT "np.Plants = ["/
LOOP((Y,Tech), PUT "[" ORD(Y):6:0"," PUT ORD(Tech):6:0"," SUM(P,UP.L(Y,P,Tech)):15:1"],"/)
PUT "]"/;

PUT "np.Total_Generation_per_year = [..."/
LOOP ((Y), PUT SUM((P),Generation(Y,P)):15:1/)
PUT "];"/;

PUT "TotalBiomassused = [..."/;
LOOP((Y),PUT SUM((P,S,RM,Tech,T)$transDistSupplyPlant(S,P,T), BSP.L(Y,S,RM,P,Tech)):20:6/)
PUT "];"/;


PUT "TOTCOST = [..."/;
*LOOP((R), PUT ORD(R):6:0  TOTCOST.L(R):20:6/)
PUT ORD(Y):6:0  TOTCOST.L(Y):20:6/)
PUT "];"/;

PUT "#MaxBiomass = [..."/;
PUT SUM((S,RM),availableBiomass(S,RM)):15:1/
PUT "];"/;


PUT "EmissionReduction = [..."/
PUT (sum(P,EmFoscoal(P)*Demand(P))-sum(R,TOTEMISSIONS.L(R))) :20:6/
PUT "];"/;

PUT "TotalEmissioneq = [..."/
PUT  Sum(R,TOTEMISSIONS.L(R)):20:6/
PUT "];"/;
*
PUT "BIOMASSEmissioneq = [..."/
PUT sum((P,Tech),EmissionBMTransport.l(P,Tech)):20:6/
PUT "];"/

PUT "Emissiontech = [..."/
PUT  Sum(P,TechEmission.l(P)):20:6/
PUT "];"/;
*
PUT "EmissionCoal = [..."/
PUT  Sum(P,CoalEmission.l(P)):20:6/
PUT "];"/;
*
PUT "BaselineEmissionoftheSystem = [..."/
PUT sum(P,EmFoscoal(P)*Demand(P)):20:6/
PUT "];"/;
*
PUT "ElBio = [..."/
LOOP(Tech,  PUT ORD(Tech):6:0 PUT sum(P,ElBio.l(P,Tech)):20:6/)
PUT "];"/;
*
PUT "ElecGenCostCofire = [..."/;
LOOP((Tech), PUT ORD(Tech):6:0 SUM(P,LCOE.l(P)):20:6/)
PUT "];"/;

PUT "COSTBIOMASS = [..."/
LOOP(Tech,  PUT ORD(Tech):6:0 SUM((P,RM), CostBio.l(P,RM,Tech)):20:6/)
PUT "];"/;

PUT "COSTBIOMASStrans = [..."/
LOOP(Tech,  PUT ORD(Tech):6:0 SUM((P,RM), CostBMTransport.l(P,RM,Tech)):20:6/)
PUT "];"/;


PUT "ElecGenCostCoal = [..."/;
LOOP((Tech), PUT ORD(Tech):6:0 (SUM((P,R),UP.L(P,Tech)*LCOEcoal(P)*Demand(P))):20:6/)
PUT "];"/;

PUT "EmissionPLANT = [..."/
LOOP((P), PUT ORD(P):6:0 (TechEmission.l(P)+ CoalEmission.L(P)+ SUM(TECH,EmissionBMTransport.l(P,Tech))) :20:6/)
PUT "];"/;

PUT "EMISSIONSFROMcOALeq = [..."/
LOOP((P), PUT ORD(P):6:0 CoalEmission.L(P):20:6/)
PUT "];"/;

PUT "Biomassused = [..."/;
LOOP((S,RM), PUT ORD(S):6:0 PUT ORD(RM):6:0 SUM((P,Tech), BSP.L(S,RM,P,Tech)):20:6/)
PUT "];"/;



PUT "Biomassusedfor direct co-feed cofiring = [..."/;
PUT  SUM((P,S,RM,Tech)$(transDistSupplyPlant(S,P)and ord (tech) eq 1 ), BSP.L(S,RM,P,'Tech1')):20:6/
PUT "];"/;

PUT "Biomassusedfor direct separate feed cofiring = [..."/;
PUT SUM((P,S,RM,Tech)$(transDistSupplyPlant(S,P)and ord (tech) eq 2 ),BSP.L(S,RM,P,'Tech2')):20:6/
PUT "];"/;

PUT "Biomassusedfor indirect cofiring = [..."/;
PUT SUM((P,S,RM,Tech)$(transDistSupplyPlant(S,P)and ord (tech) eq 3 ),BSP.L(S,RM,P,'Tech3')):20:6/
PUT "];"/;

PUT "Biomassusedfor parallel cofiring = [..."/;
PUT SUM((P,S,RM,Tech)$(transDistSupplyPlant(S,P)and ord (tech) eq 4 ),BSP.L(S,RM,P,'Tech4')):20:6/
PUT "];"/;

PUT "Biomassused for plant = [..."/;
LOOP((P, RM), PUT ORD(P):6:0 PUT ORD(RM):6:0 SUM((S,Tech)$transDistSupplyPlant(S,P), BSP.L(S,RM,P,Tech)):20:6/)
PUT "];"/;

PUT "Biomassratio for plant = [..."/;
LOOP((P, RM), PUT ORD(P):6:0 PUT ORD(RM):6:0 SUM((S,Tech)$transDistSupplyPlant(S,P),  Eff(P)*BSP.L(S,RM,P,Tech)/Demand(P)):20:6/)
PUT "];"/;

PUT "CostBio = [..."/;
PUT SUM((P,Tech,RM),CostBio.L(P,RM,Tech)):15:3/
PUT "];"/;

PUT "CostBMtrans = [..."/;
PUT SUM((P,Tech,RM),CostBMTransport.L(P,RM,Tech)):15:3/
PUT "];"/;

PUT "LCOE = [..."/;
LOOP ((P), PUT ORD (P):6:0  LCOE.L(P):15:1/)
PUT "];"/;

PUT "1st term LCOE ="/;
LOOP ((P), PUT ORD(P):6:0  SUM(TECH, CostIOM(P,Tech)* UP.L(P,Tech)):15:3/)
PUT "];"/;

PUT "2nd term LCOE ="/;
LOOP ((P), PUT ORD(P):6:0  ((SUM(TECH,UP.L(P,Tech)* (Demand(P)/Eff(P))) - SUM((S,RM,TECH)$transDistSupplyPlant(S,P),BSP.L(S,RM,P,Tech)))*coalPrice):15:3/)
PUT "];"/;

PUT "3rd term LCOE ="/;
LOOP ((P), PUT ORD(P):6:0  SUM((S,RM,Tech)$transDistSupplyPlant(S,P), BSP.L(S,RM,P,Tech)*costBm(S,RM)):20:6/)
PUT "];"/;

PUT "CostFossil = [..."/;
LOOP((P), PUT ORD(P):6:0 (Demand(P)*(1-sum(tech,UP.L(P,Tech)))*LCOECoal(P)):15:1/)
PUT "];"/;

PUT "Emission cost = [..."/;
LOOP((R), PUT ORD(R):6:0  (TOTEMISSIONS.L(R)* carbonprice(R)):20:6/)
PUT "];"/;

PUT "Carbon price = [..."/;
LOOP((R), PUT ORD(R):6:0  carbonprice(R):20:6/)
PUT "];"/;


FILE resultBSP/
*$include txt_file_beaver/result-BSP.txt
/;

PUT resultBSP/;
LOOP((S,RM), PUT ORD(S):6:0 PUT ORD(RM):6:0 SUM((P,Tech), BSP.L(S,RM,P,Tech)):20:6/)

FILE resultPlant/
*$include txt_file_beaver/result-plant.txt
/;

PUT resultPlant/;
LOOP((P,Tech), PUT P.tl PUT ORD(P):6:0 PUT ORD(Tech):6:0 UP.L(P,Tech):15:1/)

FILE resultemission/
*$include txt_file_beaver/result-emission.txt
/;

PUT resultemission/
SUM (R,TOTEMISSIONS.L(R)):20:6/

$offtext

