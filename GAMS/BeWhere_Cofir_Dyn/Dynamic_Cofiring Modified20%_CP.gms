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

parameter InvestmentCoalAnnualized(Y,P) /
$include txt_file_beaver/parameter-investment-coal-plant-annualized.txt
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

*parameter CRFCofir(P) /
*$include txt_file_beaver/parameter-CRF-cofiring.txt
*/;

parameter SpecificCostCofirAnnualized(Y,Tech) /
$include txt_file_beaver/parameter-specific-cost-cofiring-annualized.txt
/;
* unit SpecificCostCofir_$/MWelec

parameter FixOMCostCofir(Tech) /
$include txt_file_beaver/parameter-fix-OM-cost-cofiring.txt
/;

parameter VarOMCostCofir(Tech) /
$include txt_file_beaver/parameter-var-OM-cost-cofiring.txt
/;

*parameter UrateHigh(Tech)/
*$include txt_file_beaver/parameter-utilization-rate-high.txt
*/;

*parameter UrateLow(Tech)/
*$include txt_file_beaver/parameter-utilization-rate-low.txt
*/;

parameter EffCof(Tech)/
$include txt_file_beaver/parameter-efficiency-cofiring.txt
/;

****** TRANSPORT ******

parameter transDistSupplyPlant(S,P) /
$include txt_file_beaver/parameter-distance-supply-plant.txt
/;
* unit transDistSupplyPlant_km

parameter tranBiofix(RM,T) /
$include txt_file_beaver/parameter-transport-fix-cost.txt
/;
* unit tranBiofix_k$/PJ/km (PJ is expressed by biomass raw energy)

parameter tranBiovar(RM,T)/
$include txt_file_beaver/parameter-transport-var-cost.txt
/;
* unit tranBiovar_k$/PJ/km (PJ is expressed by biomass raw energy)

****** EMISSIONS ******

parameter transEmissionBiomass(RM,T)/
$include txt_file_beaver/parameter-trans-emission.txt
/;

parameter EmFoscoal(Y)/
$include txt_file_beaver/parameter-emission-basecase.txt
/;
* unit EmFoscoal_MtCO2/GWhelec

parameter carbonprice(Y) /
$include txt_file_beaver/parameter-price-carbon.txt
/;

*parameter EmTarget(Y)/
*$include txt_file_beaver/parameter_emission_target.txt
*/;
* unit EmTarget_MtCO2/GWhelec

* ------------------------------------------------------------------------------
*                                - VARIALBLES -
* ------------------------------------------------------------------------------

binary variable
UP(Y,P,Tech)

positive variable
CostFossil(Y,P)
ELbio(Y,P,TECH)
CostCofiring (Y,P,Tech)
CostBio(Y,P,Tech)
CoalProductionCost(Y,P)
CofirProductionCost(Y,P,Tech)
CostBMTransport(Y,P,Tech)
BSP(Y,S,RM,P,Tech)
Urate(Y,P,Tech)
EmissionBMTransport(Y,P,Tech)
EmissionProduction(Y,P)
AvailableBiomass(Y,S,RM)

EmissionCofirplants(Y,P)
TotalCostCofirPlants(Y,P)
ElBiomassPerRM(Y,RM)
EmissionProductionfromCoalPlants(Y,P)
EmissionProductionfromCofiringPlants(Y,P)



variable
COMBINEEQUATIONS
TOTCOST(Y)
TOTEMISSIONS(Y)

equations

ElectricityBiomass(Y,P,Tech)        Electricity produced from biomass compared to BSP
FossilCost(Y,P)
CofiringCost(Y,P,TECH)
BiomassCost(Y,P,Tech)
ProductionCostCoal(Y,P)
ProductionCostCoFir(Y,P,Tech)
TotalCosteq(Y)
transportBMEmission(Y,P,Tech)
ProductionEmission(Y,P)
biomassTransportSPCost(Y,P,Tech)
TotalEmissions(Y)
combine
availabilityBM(Y,S,RM)
supplyBiomass(Y,S,RM)
ElectricityBiomass(Y,P,Tech)
plantStatus(Y,P,Tech)
plantTypeRestriction(Y,P)
*UtiliRate (Y,P,Tech)
ElBioMaxConstraint(Y,P,Tech)
*ElBioMinConstraint(Y,P,Tech)
*EmissionContraint(Y)

EmissionfromCofirplants(Y,P)
TotalCofirPlantsCost(Y,P)
ElBioPerRM(Y,RM)
ProductionEmissionfromCoal(Y,P)
ProductionEmissionfromCofir(Y,P)


;
*-------------------------------------------------------------------------------
*-----------------------   COSTS    --------------------------------------------
*-------------------------------------------------------------------------------

****** COAL COST FOR NORMAL COAL OR CO-FIRING CONFIGURATION ******

FossilCost(Y,P)$(YP(Y,P))..
         CostFossil(Y,P) =E= coalPrice(Y,P)*(Generation(Y,P)/EffCoal(P)*(1-SUM(TECH,UP(Y,P,Tech))));

CofiringCost(Y,P,TECH)$(YP(Y,P))..
 CostCofiring (Y,P,Tech) =E= (Generation(Y,P)/EffCof(Tech)*UP(Y,P,Tech)-
                             SUM((S,RM)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)and transDistSupplyPlant(S,P)),BSP(Y,S,RM,P,Tech)))*coalPrice(Y,P);


****** BIOMASS COST FOR CO-FIRING CONFIGURATION ******

BiomassCost(Y,P,Tech)..
         CostBio(Y,P,Tech) =E= SUM((S,RM)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)and transDistSupplyPlant(S,P)),BiomPrice(Y,RM)*BSP(Y,S,RM,P,Tech));


******------- PRODUCTION COST FOR NORMAL COAL CONFIGURATION ------******

ProductionCostCoal(Y,P)  $(YP(Y,P))..
         CoalProductionCost(Y,P) =E= CostIOMCoal(Y,P)*Generation(Y,P)*(1-SUM(Tech,UP(Y,P,Tech)));

ProductionCostCoFir(Y,P,Tech) $(YP(Y,P))..
         CofirProductionCost(Y,P,Tech) =E= (InvestmentCoalAnnualized(Y,P)*Generation(Y,P)*UP(Y,P,Tech)
                                           + SpecificCostCofirAnnualized(Y,Tech)*0.2*Capacity(P)*UP(Y,P,Tech))
                                           + FixOMCostCofir(Tech)*Capacity(P)*UP(Y,P,Tech)
                                           + VarOMCostCofir(Tech)*Generation(Y,P)*UP(Y,P,Tech);

****** BIOMASS TRANSPORT COST TO PLANTS ******

biomassTransportSPCost(Y,P,Tech)..
         CostBMTransport(Y,P,Tech) =E= SUM((S,RM,T)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM) and transDistSupplyPlant(S,P)),((transDistSupplyPlant(S,P)*tranBiovar(RM,T) + tranBiofix(RM,T))*BSP(Y,S,RM,P,Tech)));


******--------------------------------------------------------------------------

TotalCosteq(Y)..
         TOTCOST(Y) =E=
*   coal cost
           SUM((P)$(YP(Y,P)),CostFossil(Y,P))
         + SUM ((P,TECH)$(YP(Y,P)), CostCofiring(Y,P,TECH))
*   biomass cost
         + SUM((P,Tech)$(YP(Y,P)),CostBio(Y,P,Tech))
*   production cost
         + SUM((P)$(YP(Y,P)),CoalProductionCost(Y,P))
*   production cost co_firing
       + SUM((P,Tech)$(YP(Y,P)),CofirProductionCost(Y,P,Tech))
         + SUM((P,Tech)$(YP(Y,P)),CostBMTransport(Y,P,Tech));


*-------------------------------------------------------------------------------
*-----------------------   EMISSIONS    ----------------------------------------
*-------------------------------------------------------------------------------

transportBMEmission(Y,P,Tech)..
         EmissionBMTransport(Y,P,Tech) =E=
        SUM((S,RM,T)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM) and transDistSupplyPlant(S,P)),
       (transEmissionBiomass(RM,T)*transDistSupplyPlant(S,P)*BSP(Y,S,RM,P,Tech)));


****** PRODUCTION EMISSIONS FROM COAL ******

ProductionEmission(Y,P)$(YP(Y,P))..
         EmissionProduction(Y,P) =E=
         EmFoscoal(Y)*(Generation(Y,P) - SUM(Tech,ElBio(Y,P,Tech)));

******--------------------------------------------------------------------------

TotalEmissions(Y)..
         TOTEMISSIONS(Y) =E=
* biomass transport
         SUM((P,Tech)$(YP(Y,P)),EmissionBMTransport(Y,P,Tech))
* coal combustion
         + SUM((P)$(YP(Y,P)),EmissionProduction(Y,P));

*-------------------------------------------------------------------------------
*-----------------------   OBJECTIVE FUNCTION    -------------------------------
*-------------------------------------------------------------------------------

combine..
         COMBINEEQUATIONS =E= sum(Y,TOTCOST(Y)+(TOTEMISSIONS(Y)*carbonprice(Y)));


*-------------------------------------------------------------------------------
*------------------------------   CONSTRAINTS    -------------------------------
*-------------------------------------------------------------------------------

****** BIOMASS ******

******------ BIOMASS AVAILIBILITY ------******

availabilityBM(Y,S,RM) $(SRM(Y,S,RM))..
AvailableBiomass(Y,S,RM) =E=  (BiomassPotential(Y,S,RM)$(ORD(Y) eq 1) + BiomassPotential(Y,S,RM)$(ORD(Y) gt 1) - SUM((P,Tech)$(SRM(Y,S,RM) and RMTe(RM,Tech) and YP(Y,P)),BSP(Y-1,S,RM,P,Tech))$(ORD(Y) gt 1));


******------ BIOMASS USED FOR POWER PLANTS ------******

supplyBiomass(Y,S,RM)..
         SUM((P,Tech)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM)and transDistSupplyPlant(S,P)),BSP(Y,S,RM,P,Tech))
         =L= AvailableBiomass(Y,S,RM);

******------ ELCTRICITY PRODUCED FROM BIOMASS  ------******

ElectricityBiomass(Y,P,Tech)..
         SUM((S,RM)$(RMTe(RM,Tech) and transDistSupplyPlant(S,P) and YP(Y,P) and SRM(Y,S,RM)),EffCof(Tech)*BSP(Y,S,RM,P,Tech))
         =E= ElBio(Y,P,Tech);

******------ TECHNOLOGIES ------******

* Time constraint, When a plant is built, it stays the year after
plantStatus(Y,P,Tech) $(YP(Y,P))..
        UP(Y,P,Tech) =G= initialStatus(P,Tech)$(ORD(Y) eq 1) + UP(Y-1,P,Tech)$(ORD(Y) gt 1);

* Plant type restriction
plantTypeRestriction(Y,P) $(YP(Y,P))..
         SUM(Tech,UP(Y,P,Tech)) =L= 1;

* Contraints on max and min biomass
*UtiliRate (Y,P,Tech)$(YP(Y,P))..
*         Urate(Y,P,Tech)=E=  ElBio(Y,P,Tech)/Generation(Y,P);
* Contraints on max and min biomass

ElBioMaxConstraint(Y,P,Tech)$(YP(Y,P))..
          ElBio(Y,P,Tech) =E= 0.2*Generation(Y,P)*UP(Y,P,Tech);

*ElBioMinConstraint(Y,P,Tech)..
*         ElBio(Y,P,Tech) =G= UrateLow(Tech)*Generation(Y,P)*UP(Y,P,Tech);

* Constraints on emissions target
*EmissionContraint(Y)..
*      TOTEMISSIONS(Y) =L= EmTarget(Y);

*-------------------------------------------------------------------------------
*------------------------------   PUT RESULTS   --------------------------------
*-------------------------------------------------------------------------------

* Total cost co-firing power plants:
TotalCofirPlantsCost(Y,P) $(YP(Y,P))..
        TotalCostCofirPlants(Y,P) =E= SUM(Tech,CostCofiring (Y,P,Tech))
                                    + SUM(Tech, CostBio(Y,P,Tech))
                                    + SUM(Tech,CofirProductionCost(Y,P,Tech))
                                    + SUM(Tech,CostBMTransport(Y,P,Tech));

* Electricity produced from biomass per RM
ElBioPerRM(Y,RM)..
         ElBiomassPerRM(Y,RM) =E= SUM((S,P,Tech) $(RMTe(RM,Tech) and transDistSupplyPlant(S,P) and YP(Y,P) and SRM(Y,S,RM)), EffCof(Tech)*BSP(Y,S,RM,P,Tech));

* Emissions from cofiring plants:
EmissionfromCofirplants(Y,P)  $(YP(Y,P))..
         EmissionCofirplants(Y,P) =E= SUM(Tech,EmissionBMTransport(Y,P,Tech))+ EmFoscoal(Y)*(Generation(Y,P)*SUM(Tech,UP(Y,P,Tech)) - SUM(Tech,ElBio(Y,P,Tech)));

* Emission from coal combustion in coal and cofiring plants:
ProductionEmissionfromCoal(Y,P)$(YP(Y,P))..
         EmissionProductionfromCoalPlants(Y,P) =E=
         EmFoscoal(Y)*Generation(Y,P)*(1-SUM(TECH,UP(Y,P,Tech)));


ProductionEmissionfromCofir(Y,P)$(YP(Y,P))..
         EmissionProductionfromCofiringplants(Y,P) =E=
         EmFoscoal(Y)*(Generation(Y,P)*SUM(TECH,UP(Y,P,Tech)) - SUM(Tech,ElBio(Y,P,Tech)));

***-----------------------------------------------------------------------------

FILE cplexOpt/ cplex.opt /;
PUT cplexOpt;
PUT "PARALLELMODE = 1"/;
*PUT "epint=0.1"/;
PUT "threads=10"/;
PUTCLOSE cplexOpt;
*
************************************
MODEL facilityLocation  /ALL/;
*facilityLocation.ITERLIM   = 1E+6;
* For emission reduction 15% and CP_80 , should increase nb interation
facilityLocation.ITERLIM   = 1E+7;
facilityLocation.RESLIM    =  100000;
facilityLocation.NODLIM    = 1000000;
*facilityLocation.OPTCA     =  0;
facilityLocation.OPTCR     =  0.03;
*facilityLocation.CHEAT     =  0;
facilityLocation.CUTOFF    =  1E+20;
facilityLocation.TRYINT    =  .01;
facilityLocation.OPTFILE   = 1;
facilityLocation.PRIOROPT  = 0;
facilityLocation.workspace = 160000;
*-----------------------
facilityLocation.SCALEOPT = 1;
*-----------------
*
TOTEMISSIONS.SCALE(Y) = power(10,4);
TOTCOST.SCALE(Y) = power(10,4);


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


FILE resultFile/
$include txt_file_beaver/file-solution.txt
/;

PUT resultFile/;
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
PUT "np.Carbon_price = ["/
LOOP((Y), PUT ORD(Y):6:0 carbonprice(Y):20:6/)
PUT "]"/;

PUT "np.Plants_Cofiring_Per_Year = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((P,Tech),UP.L(Y,P,Tech)):15:2/)
PUT "]"/;

* GENERATION

PUT "np.Total_generation_GWh = ["/
LOOP((Y), PUT ORD(Y):6:0"," (SUM(P,Generation(Y,P))):20:6/)
PUT "]"/;

* Generation from plants

PUT "np.Generation_from_cofiring_plants_GWh = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P),Generation(Y,P)*SUM(Tech,UP.L(Y,P,Tech)))):20:6/)
PUT "]"/;

PUT "np.Generation_from_coal_plants_GWh = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P),Generation(Y,P)*(1-SUM(Tech,UP.L(Y,P,Tech))))):20:6/)
PUT "]"/;

* Generation from fuel

PUT "np.Electricity_produced_from_Biomass_per_year_GWh = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((P,Tech),ElBio.L(Y,P,Tech)):20:6/)
PUT "]"/;

PUT "np.Electricity_produced_from_Coal_per_year_GWh = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P,Generation(Y,P))- SUM((P,Tech),ElBio.L(Y,P,Tech))):20:6/)
PUT "]"/;

* Biomass share

PUT "np.Biomass_share_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P,Tech),ElBio.L(Y,P,Tech))/(SUM(P,Generation(Y,P)))):20:6/)
PUT "]"/;

PUT "np.Electricity_produced_from_Biomass_per_RM_per_year = ["/
LOOP((Y,RM), PUT ORD(Y):6:0 PUT ORD(RM):6:0 ElBiomassPerRM.L(Y,RM):20:6/)
PUT "]"/;

* EMISSIONS

FILE resultFileEmission/
$include txt_file_beaver/result-emission.txt
/;

PUT resultFileEmission/;

PUT "np.Total_emissions_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 TOTEMISSIONS.L(Y):20:6/)
PUT "]"/;

*Emissions from plants

PUT "np.Total_emissions_from_cofiring_plants = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM(P,EmissionCofirplants.L(Y,P)):20:6/)
PUT "]"/;

PUT "np.Total_emissions_from_coal_plants = ["/
LOOP((Y), PUT ORD(Y):6:0 (TOTEMISSIONS.L(Y) - SUM(P,EmissionCofirplants.L(Y,P))):20:6/)
PUT "]"/;

*Emissions from fuel

PUT "np.Total_emissions_from_biomass_transport_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((P,Tech),EmissionBMTransport.L(Y,P,Tech)):20:6/)
PUT "]"/;

PUT "np.Total_emissions_from_coal_combustion_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((P),EmissionProduction.L(Y,P)):20:6/)
PUT "]"/;

* Emission reductions
PUT "np.Total_emissions_reduction_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (EmFoscoal(Y)*SUM(P,(Generation(Y,P)))- TOTEMISSIONS.L(Y)):20:6/)
PUT "]"/;

*COST

FILE resultFileCost/
$include txt_file_beaver/result-cost.txt
/;

PUT resultFileCost/;

PUT "np.Total_cost_per_year_INCLUDE_EMISSION_COST = ["/
LOOP((Y), PUT ORD(Y):6:0  (TOTCOST.L(Y) + TOTEMISSIONS.L(Y)*carbonprice(Y)):20:6/)
PUT "]"/;

PUT "np.Total_cost_EXCLUDE_EMISSION_COST_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0  TOTCOST.L(Y):20:6/)
PUT "]"/;

PUT "np.Total_EMISSION_COST_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (TOTEMISSIONS.L(Y)*carbonprice(Y)):20:6/)
PUT "]"/;

* Cost from plants

PUT "np.Total_cost_from_cofiring_plants_per_year_INCLUDE_EMISSION_COST = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P,TotalCostCofirPlants.L(Y,P)) + SUM(P,EmissionCofirplants.L(Y,P))*carbonprice(Y)):20:6/)
PUT "]"/;

PUT "np.Total_cost_from_coal_plants_per_year_INCLUDE_EMISSION_COST = ["/
LOOP((Y), PUT ORD(Y):6:0 ((TOTCOST.L(Y) + TOTEMISSIONS.L(Y)*carbonprice(Y)) - (SUM(P,TotalCostCofirPlants.L(Y,P)) + SUM(P,EmissionCofirplants.L(Y,P))*carbonprice(Y))):20:6/)
PUT "]"/;

PUT "np.Total_cost_from_cofiring_plants_per_year_EXCLUDE_EMISSION_COST = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P,TotalCostCofirPlants.L(Y,P))):20:6/)
PUT "]"/;

PUT "np.Total_cost_from_coal_plants_per_year_EXCLUDE_EMISSION_COST = ["/
LOOP((Y), PUT ORD(Y):6:0 (TOTCOST.L(Y) - SUM(P,TotalCostCofirPlants.L(Y,P))):20:6/)
PUT "]"/;

* Cost from fuels

PUT "np.Total_coal_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P,CostFossil.L(Y,P))+SUM((P,Tech),CostCofiring.L(Y,P,Tech))):20:6/)
PUT "]"/;

PUT "np.Coal_cost_for_coal_plants_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P,CostFossil.L(Y,P))):20:6/)
PUT "]"/;

PUT "np.Coal_cost_for_cofiring_plants_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P,Tech),CostCofiring.L(Y,P,Tech))):20:6/)
PUT "]"/;

PUT "np.Total_biomass_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((P,Tech),CostBio.L(Y,P,Tech)):20:6/)
PUT "]"/;

PUT "np.Total_electricity_production_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P, CoalProductionCost.L(Y,P)) + SUM((P,Tech), CofirProductionCost.L(Y,P,Tech))):20:6/)
PUT "]"/;

PUT "np.Electricity_production_cost_from_coal_plants_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM(P, CoalProductionCost.L(Y,P))):20:6/)
PUT "]"/;

PUT "np.Electricity_production_cost_from_cofiring_plants_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P,Tech), CofirProductionCost.L(Y,P,Tech))):20:6/)
PUT "]"/;

PUT "np.Total_biomass_transport_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((P,Tech),CostBMTransport.L(Y,P,Tech)):20:6/)
PUT "]"/;

PUT "np.Total_emission_cost_from_biomass_transport_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P,Tech),EmissionBMTransport.L(Y,P,Tech))*carbonprice(Y)):20:6/)
PUT "]"/;

PUT "np.Total_emission_cost_from_coal_combustion_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P),EmissionProduction.L(Y,P))*carbonprice(Y)):20:6/)
PUT "]"/;

PUT "np.Emission_cost_from_coal_combustion_from_coal_plants_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P),EmissionProductionfromCoalPlants.L(Y,P))*carbonprice(Y)):20:6/)
PUT "]"/;

PUT "np.Emission_cost_from_coal_combustion_from_cofiring_plants_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (SUM((P),EmissionProductionfromCofiringPlants.L(Y,P))*carbonprice(Y)):20:6/)
PUT "]"/;

$ontext
* Avoided cost

PUT "np.Avoided_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 ((TOTCOST.L(Y) + TOTEMISSIONS.L(Y)*carbonprice(Y))/(EmFoscoal(Y)*SUM(P $(YP(Y,P)),Generation(Y,P))- TOTEMISSIONS.L(Y))):20:6/)
PUT "]"/;


* LCOE in different cases

PUT "np.LCOE_coal_plants_with_emission_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 ((SUM(P,CostFossil.L(Y,P) + CoalProductionCost.L(Y,P))+(TOTEMISSIONS.L(Y) - SUM(P,EmissionCofirplants.L(Y,P)))*carbonprice(Y))/(SUM((P) $(YP(Y,P)),Generation(Y,P)*(1-SUM(Tech,UP.L(Y,P,Tech)))))):20:6/)
PUT "]"/;

PUT "np.LCOE_cofiring_plants_with_emission_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0  ((SUM(P $(YP(Y,P)),TotalCostCofirPlants.L(Y,P)) + SUM(P $(YP(Y,P)),EmissionCofirplants.L(Y,P))*carbonprice(Y))/(SUM((P) $(YP(Y,P)),Generation(Y,P)*SUM(Tech $(YP(Y,P)),UP.L(Y,P,Tech))))):20:6/)
PUT "]"/;

PUT "np.LCOE_all_plants_with_emission_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 ((TOTCOST.L(Y) + TOTEMISSIONS.L(Y)*carbonprice(Y))/SUM(P $(YP(Y,P)),Generation(Y,P))):20:6/)
PUT "]"/;

PUT "np.LCOE_coal_plants_without_emission_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0  (SUM(P,CostFossil.L(Y,P) + CoalProductionCost.L(Y,P))/(SUM((P),Generation(Y,P)*(1-SUM(Tech,UP.L(Y,P,Tech)))))):20:6/)
PUT "]"/;

PUT "np.LCOE_cofiring_plants_without_emission_cost_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0  ((SUM(P,TotalCostCofirPlants.L(Y,P)))/(SUM((P) $(YP(Y,P)),Generation(Y,P)*SUM(Tech,UP.L(Y,P,Tech))))):20:6/)
PUT "]"/;

PUT "np.LCOE_all_plants_without_emission_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 (TOTCOST.L(Y)/SUM(P,Generation(Y,P))):20:6/)
PUT "]"/;

$offtext

FILE resultFileUP/
$include txt_file_beaver/Plants-UP.txt
/;

PUT resultFileUP/;

PUT "np.Plants_Cofiring_Per_Year = ["/
LOOP((Y,P,Tech), PUT ORD(Y):6:0 PUT ORD(P):6:0 PUT ORD(Tech):6:0 (UP.L(Y,P,Tech)):15:2/)
PUT "]"/;

PUT "np.Plants_Cofiring_Per_Tech = ["/
LOOP((Y,Tech), PUT ORD(Y):6:0 PUT ORD(Tech):6:0 SUM((P),UP.L(Y,P,Tech)):15:2/)
PUT "]"/;


FILE resultFileBSP/
$include txt_file_beaver/BSP.txt
/;

PUT resultFileBSP/;

PUT "np.Transport_variable_cost_TO_CALCULATE_Distance_Supply_Plants_km = ["/
LOOP((Y,RM), PUT ORD(Y):6:0 PUT ORD(RM):6:0 SUM((S,P,Tech,T)$(RMTe(RM,Tech) and YP(Y,P) and SRM(Y,S,RM) and transDistSupplyPlant(S,P)),((transDistSupplyPlant(S,P)*tranBiovar(RM,T))*BSP.L(Y,S,RM,P,Tech))):20:6/)
PUT "];"/;

PUT "np.Biomass_BSP_per_year = ["/
LOOP((Y), PUT ORD(Y):6:0 SUM((S,RM,P,Tech),(BSP.L(Y,S,RM,P,Tech))):20:6/)
PUT "]"/;

PUT "np.Biomass_BSP_per_year_per_RM = ["/
LOOP((Y,RM), PUT ORD(Y):6:0 PUT ORD(RM):6:0 SUM((S,P,Tech),(BSP.L(Y,S,RM,P,Tech))):20:6/)
PUT "]"/;

PUT "np.Biomass_BSP = ["/
LOOP((Y,S,RM,P), PUT ORD(Y):6:0 PUT ORD(S):6:0  PUT ORD(RM):6:0  PUT ORD(P):6:0 SUM(Tech,(BSP.L(Y,S,RM,P,Tech))):20:6/)
PUT "]"/;

