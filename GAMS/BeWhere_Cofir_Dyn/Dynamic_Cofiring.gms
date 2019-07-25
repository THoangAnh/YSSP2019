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

parameter Capacity(P) /
$include txt_file_beaver/parameter-power-capacity.txt
/;
* unit_Capacity_MW

parameter Generation(Y,P) /
$include txt_file_beaver/parameter-power-generation.txt
/;
* unit_Generation_GWh

parameter InvestmentCoal(Y,P) /
$include txt_file_beaver/parameter-investment-coal-plant.txt
/;
* unit InvestmentCoal_$/GWh (GWh of electricity generation)

parameter CostIOMCoal(Y,P) /
$include txt_file_beaver/parameter-cost-IOM-coal.txt
/;
*unit CostIOMCoal_$/GWh (GWh of electricity generation)


****** COAL ******

parameter coalPrice(Y,P) /
$include txt_file_beaver/parameter-coal-price.txt
/;
* unit coalPrice_$/GWh (GWh is converted from J of coal_energy)


****** BIOMASS ******

parameter BiomassPotential(Y,S,RM)/
$include txt_file_beaver/parameter-potential-biomass.txt
/;

parameter BiomPrice(Y,RM)/
$include txt_file_beaver/parameter-biomass-price.txt
/;
* unit BiomPrice_$/GWh (GWh is converted from J of biomass heat)

****** CO_FIRING ******

parameter CRFCofir(P) /
$include txt_file_beaver/parameter-CRF-cofiring.txt
/;

parameter SpecificCostCofir(Y,P,Tech) /
$include txt_file_beaver/parameter-specific-cost-cofiring.txt
/;
* unit SpecificCostCofir_$/MWelec

parameter FixOMCostCofir(Tech) /
$include txt_file_beaver/parameter-fix-OM-cost-cofiring.txt
/;

parameter VarOMCostCofir(Tech) /
$include txt_file_beaver/parameter-var-OM-cost-cofiring.txt
/;

parameter UrateHigh(Tech)/
$include txt_file_beaver/parameter-utilization-rate-high.txt
/;

parameter UrateLow(Tech)/
$include txt_file_beaver/parameter-utilization-rate-low.txt
/;

parameter EffCof(P,Tech)/
$include txt_file_beaver/parameter-efficiency-cofiring.txt
/;

****** TRANSPORT ******

parameter transDistSupplyPlant(S,P,T) /
$include txt_file_beaver/parameter-distance-supply-plant.txt
/;
* unit transDistSupplyPlant_km

parameter tranBiofix(RM,T) /
$include txt_file_beaver/parameter-transport-fix-cost.txt
/;
* unit tranBiofix_$/PJ/km (PJ is expressed by biomass raw energy)

parameter tranBiovar(RM,T)/
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
* unit EmFoscoal_tCO2/GWhelec

parameter carbonprice(Y) /
$include txt_file_beaver/parameter-price-carbon.txt
/;

parameter EmTarget(Y)/
$include txt_file_beaver/parameter_emission_target.txt
/;
* unit EmFoscoal_tCO2/GWhelec

* ------------------------------------------------------------------------------
*                                - VARIALBLES -
* ------------------------------------------------------------------------------

binary variable
UP(Y,P,Tech)

positive variables
BSP(Y,S,RM,P,Tech)                       Amount of biomass used in the coal plant (unit_GWh heat)
Urate(Y,S,RM,P,Tech)                     Share of biomass (compared to generation)

CoalProductionCost(Y,P)                  Production cost of electricity from coal power plant
CofirProductionCost(Y,P,Tech)            Production cost of electricity from co-firing power plant

AvailableBiomass(Y,S,RM)                 Biomass available to be used for each year

CostBMTransport(Y,P,S,RM,T,Tech)         Cost of transporting the biomass
CostBio(Y,P,RM,Tech)                     Cost of biomass
CostFossil(Y,P)                          Cost related to coal for electricity production (unit_$)

EmissionBMTransport(Y,P,S,T,Tech)        Emissions from transport of biomass
EmissionProduction(Y,P,Tech)             Emission from production

ElBio(Y,S,RM,P,Tech)                          Electricity from biomass in co-firing configuration (unit_GWh)

variable
COMBINEEQUATIONS
TOTCOST(Y)
TOTEMISSIONS(Y)
TOTEMISSIONSCOST(Y)

equations

****** ELECTRICITY PRODUCTIONS ******
ElectricityBiomass(Y,S,RM,P,Tech)          Electricity produced from biomass

****** BIOMASS SHARE ******
BiomShare(Y,S,RM,P,Tech)              Share of biomass

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
EmissionContraint(Y)
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
         CostFossil(Y,P) =E= SUM((Tech,S,RM) $(YP(Y,P)),coalPrice(Y,P)*(Generation(Y,P)/EffCoal(P)*(1-UP(Y,P,Tech)) + Generation(Y,P)/EffCof(P,Tech)*UP(Y,P,Tech) - ElBio(Y,S,RM,P,Tech)/EffCoal(P)));


****** BIOMASS COST FOR CO-FIRING CONFIGURATION ******

BiomassCost(Y,P,RM,Tech)..
         CostBio(Y,P,RM,Tech) =E= SUM((S)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),BiomPrice(Y,RM)*BSP(Y,S,RM,P,Tech));


****** BIOMASS TRANSPORT COST TO PLANTS ******

biomassTransportSPCost(Y,P,S,RM,T,Tech)..
         CostBMTransport(Y,P,S,RM,T,Tech) =E= ((transDistSupplyPlant(S,P,T)*tranBiovar(RM,T) + tranBiofix(RM,T))*BSP(Y,S,RM,P,Tech)) $(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM));


****** PRODUCTION COST ******

******------- PRODUCTION COST = INVESTMENT + FIX O&M + VAR O&M ------******

******------- PRODUCTION COST FOR NORMAL COAL CONFIGURATION ------******

ProductionCostCoal(Y,P)  $(YP(Y,P))..
         CoalProductionCost(Y,P) =E= CostIOMCoal(Y,P)*Generation(Y,P)*(SUM(Tech,(1-UP(Y,P,Tech))));


******------- PRODUCTION COST FOR CO-FIRING CONFIGURATION ------******

ProductionCostCoFir(Y,P,Tech)..
         CofirProductionCost(Y,P,Tech) =E= SUM((S,RM) $(YP(Y,P) and SRM(Y,S,RM)),((InvestmentCoal(Y,P)*Generation(Y,P)*UP(Y,P,Tech)+ SpecificCostCofir(Y,P,Tech)*Urate(Y,S,RM,P,Tech)*Capacity(P))*CRFCofir(P)
                                           + FixOMCostCofir(Tech)*Capacity(P)*UP(Y,P,Tech)
                                           + VarOMCostCofir(Tech)*Generation(Y,P)*UP(Y,P,Tech)));

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
         SUM(RM $(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),
         (transEmissionBiomass(RM,T)*transDistSupplyPlant(S,P,T)*BSP(Y,S,RM,P,Tech)));


****** PRODUCTION EMISSIONS FROM COAL ******

ProductionEmission(Y,P,Tech)..
         EmissionProduction(Y,P,Tech) =E=
         SUM((S,RM),EmFoscoal(Y,P)*(Generation(Y,P) - ElBio(Y,S,RM,P,Tech))) $(YP(Y,P));


totalEmissions(Y)..
         TOTEMISSIONS(Y) =E=
* biomass transport
         SUM((P,S,T,Tech),EmissionBMTransport(Y,P,S,T,Tech))
* coal combustion
         + SUM((P,Tech),EmissionProduction(Y,P,Tech));

totalEmissionsCost(Y)..
         TOTEMISSIONSCOST(Y) =E= SUM((P,Tech),TOTEMISSIONS(Y)*carbonprice(Y));

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
AvailableBiomass(Y,S,RM) =E=  (BiomassPotential(Y,S,RM)$(ORD(Y) eq 1) + BiomassPotential(Y,S,RM)$(ORD(Y) gt 1) - SUM((P,Tech,T)$(SRM(Y,S,RM) and RMTe(RM,Tech) and YP(Y,P)),BSP(Y-1,S,RM,P,Tech))$(ORD(Y) gt 1));


******------ BIOMASS USED FOR POWER PLANTS ------******

supplyBiomass(Y,S,RM)..
         SUM((P,Tech,T)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),BSP(Y,S,RM,P,Tech))
         =L= AvailableBiomass(Y,S,RM);

******------ ELCTRICITY PRODUCED FROM BIOMASS  ------******

ElectricityBiomass(Y,S,RM,P,Tech)..
         SUM((T)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),EffCof(P,Tech)*BSP(Y,S,RM,P,Tech))
         =E= ElBio(Y,S,RM,P,Tech);

******------ BIOMASS SHARE ------******

BiomShare(Y,S,RM,P,Tech)..
         Urate(Y,S,RM,P,Tech) =E= (ElBio(Y,S,RM,P,Tech)/Generation(Y,P)) $(YP(Y,P) and SRM(Y,S,RM));

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
          SUM((S,RM)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),ElBio(Y,S,RM,P,Tech)) =L= UrateHigh(Tech)*Generation(Y,P)*UP(Y,P,Tech);

ElBioMinConstraint(Y,P,Tech)..
         SUM((S,RM)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)),ElBio(Y,S,RM,P,Tech)) =G= UrateLow(Tech)*Generation(Y,P)*UP(Y,P,Tech);

EmissionContraint(Y)..
         TOTEMISSIONS(Y) =L= EmTarget(Y);
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
facilityLocation.ITERLIM   = 5E+5;
facilityLocation.RESLIM    =  100000;
facilityLocation.NODLIM    = 1000000;
*facilityLocation.OPTCA     =  0;
facilityLocation.OPTCR     =  0.03;
*facilityLocation.CHEAT     =  0;
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
SOLVE facilityLocation USING RMIP MINIMIZING COMBINEEQUATIONS;
************************************
*
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*




FILE resultFile/
$include txt_file_beaver/file-solution.txt
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
LOOP((Y,P), PUT "[" ORD(Y):6:0"," PUT ORD(P):6:0"," SUM(Tech,UP.L(Y,P,Tech)):15:1"],"/)
PUT "]"/;

PUT "np.BSP_GWh_heat = ["/
LOOP((Y,P), PUT "[" ORD(Y):6:0"," PUT ORD(P):6:0"," SUM((RM,S,Tech),BSP.L(Y,S,RM,P,Tech)):15:6"],"/)
PUT "]"/;

PUT "np.ElBio_GWh_elec = ["/
LOOP((Y,P), PUT "[" ORD(Y):6:0"," PUT ORD(P):6:0"," SUM((RM,S,Tech),ElBio.L(Y,S,RM,P,Tech)):15:6"],"/)
PUT "]"/;

PUT "np.Urate = ["/
LOOP((Y,P), PUT "[" ORD(Y):6:0"," PUT ORD(P):6:0"," SUM((RM,S,Tech),Urate.L(Y,S,RM,P,Tech)):15:6"],"/)
PUT "]"/;

PUT "np.TOTCOST_$ = ["/;
LOOP((Y), PUT "[" ORD(Y):6:0"," TOTCOST.L(Y):20:6"],"/)
PUT "]"/;

PUT "np.TOTEMISSIONS_tCO2 = ["/;
LOOP((Y), PUT "[" ORD(Y):6:0"," TOTEMISSIONS.L(Y):20:6"],"/)
PUT "]"/;

PUT "np.TOTEMISSIONSCOST_$ = ["/;
LOOP((Y), PUT "[" ORD(Y):6:0"," TOTEMISSIONSCOST.L(Y):20:6"],"/)
PUT "]"/;

PUT "np.Emission_coal_combustion _tCO2 = ["/
LOOP((Y,P), PUT "[" ORD(Y):6:0"," PUT ORD(P):6:0"," SUM((Tech),EmissionProduction.L(Y,P,Tech)):15:6"],"/)
PUT "]"/;

PUT "np.EmissionBMTransport_tCO2 = ["/
LOOP((Y,P), PUT "[" ORD(Y):6:0"," PUT ORD(P):6:0"," SUM((S,T,Tech),EmissionBMTransport.L(Y,P,S,T,Tech)):15:6"],"/)
PUT "]"/;




