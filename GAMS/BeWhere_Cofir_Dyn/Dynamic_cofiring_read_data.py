# -*- coding: utf-8 -*-
"""

Dynamic co-firing model for Vietnam
Last updated: Mon Jul  20, 2019

@author: tranh
"""

import pandas as pd
import numpy as np
import glob, os

file_location='P:/beaver/HoangAnh_CofirVN/YSSP2019//GAMS/BeWhere_Cofir_Dyn/Data/Parameters.xlsx'
file_destination='P:/beaver/HoangAnh_CofirVN/YSSP2019/GAMS/BeWhere_Cofir_Dyn/txt_file_beaver/'
file_destination_processing='P:/beaver/HoangAnh_CofirVN/YSSP2019/GAMS/txt_file_beaver_processing/'

# Definitions

def create_parameter_file(file_name,letter,data_frame):
    column = range(data_frame.shape[1])
    row = range(data_frame.shape[0])
    
    f = open(file_name, 'w')
    for rr in row:
        for cc in column:
            if cc<len(letter)-1:
                f.write("%s." %(letter[cc]+str(int(data_frame.values[rr,cc]))))
            if cc==len(letter)-1:
                f.write("%s" %(letter[cc]+str(int(data_frame.values[rr,cc]))))
            if cc==len(letter):
                #f.write(" %.10f" %(data_frame.values[rr,cc]))
                # only take 10 digits in the emission since unit is MtCO2
                f.write(" %.3f" %(data_frame.values[rr,cc]))
                #f.write(" %f" %(data_frame.values[rr,cc]))
        f.write("\n")
    f.close()
    
    
def create_emission_parameter_file(file_name,letter,data_frame):
    column = range(data_frame.shape[1])
    row = range(data_frame.shape[0])
    
    f = open(file_name, 'w')
    for rr in row:
        for cc in column:
            if cc<len(letter)-1:
                f.write("%s." %(letter[cc]+str(int(data_frame.values[rr,cc]))))
            if cc==len(letter)-1:
                f.write("%s" %(letter[cc]+str(int(data_frame.values[rr,cc]))))
            if cc==len(letter):
               # only take 10 digits in the emission since unit is MtCO2
                f.write(" %.10f" %(data_frame.values[rr,cc]))
                
        f.write("\n")
    f.close()

def SelectPoints(df_In, df_Col, ColumnCriteria):   
    column = range(ColumnCriteria.shape[0])
    df_temp=np.concatenate([df_In.values[df_In.values[::,df_Col] == ColumnCriteria.values[cc,0],::] for cc in column])
    return pd.DataFrame(df_temp)

def SelectPointsRow(df_In, df_Row, ColumnCriteria):   
    column = range(ColumnCriteria.shape[0])
    df_temp=np.concatenate([df_In.values[::,df_In.values[df_Row,::] == ColumnCriteria.values[cc,0]] for cc in column],axis=1)
    return pd.DataFrame(df_temp)
    
def create_data_file(data_frame,filename):
    #    np.savetxt(filename, data_frame_out,fmt='{0: <{1}}'.format("%s", 6))
    np.savetxt(filename, data_frame,fmt='%-6s')
    
print('Load coal power plants...')
df_plants = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Coal_Power_Plants', usecols='A')

print('Load power generations...')
df_power_generation = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Coal_Power_Plants', usecols='S:AE')

print('Load power capacity...')
df_power_capacity = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Coal_Power_Plants', usecols='J')

print('Load cofirng technologies...')
df_cofir_technologies = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Tech', usecols='A')

print('Load supply locations...')
df_supply = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Grid', usecols='D')

print('Load RM differents types...')
df_RM = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='RM', usecols='A')

print('Load transport types...')
df_transport_mode = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Transport_biomass', usecols='A')

print('Load years...')
df_year = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Year', usecols='A')

print('Load RM availability 2018...')
df_RM_avail_2018 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='D:I')

print('Load RM availability 2019...')
df_RM_avail_2019 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='J:O')

print('Load RM availability 2020...')
df_RM_avail_2020 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='P:U')

print('Load RM availability 2021...')
df_RM_avail_2021 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='V:AA')

print('Load RM availability 2022...')
df_RM_avail_2022 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='AB:AG')

print('Load RM availability 2023...')
df_RM_avail_2023 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='AH:AM')

print('Load RM availability 2024...')
df_RM_avail_2024 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='AN:AS')

print('Load RM availability 2025...')
df_RM_avail_2025 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='AT:AY')

print('Load RM availability 2026...')
df_RM_avail_2026 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='AZ:BE')

print('Load RM availability 2027...')
df_RM_avail_2027 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='BF:BK')

print('Load RM availability 2028...')
df_RM_avail_2028 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='BL:BQ')

print('Load RM availability 2029...')
df_RM_avail_2029 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='BR:BW')

print('Load RM availability 2030...')
df_RM_avail_2030 = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Feed_avail', usecols='BX:CC')

print('Load initial status...')
df_initial_status = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Initial_status_coal_plants', usecols='B:E')


print('Load efficiency coal power plants...')
df_eff_coal = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Coal_Eff', usecols='C')

print('Load investment coal power plants...')
df_invest_coal = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Invest_cost_coal', usecols='C:O')

print('Load cost IOM coal power plants...')
df_cost_IOM_coal = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Cost_IOM_coal', usecols='C:O')

print('Load coal price...')
df_coal_price = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Coal_price_plants', usecols='C:O')

print('Load biomass price...')
df_biom_price = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Biomass_price', usecols='D:I')

print('Load CRF Cofiring...')
df_CRF_cof = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='CRF_Cofir', usecols='G')

print('Load specific cost cofiring...')
df_specific_cost = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Specific_cost_cofir', usecols='C:BB')

print('Load fix and var OM cost cofiring...')
df_fix_var_OM_cofir_cost = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Constants_biomass', usecols='C')

print('Load U rate...')
df_U_rate = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Tech', usecols='F,G')

print('Load efficiency of cofiring technology...')
df_eff_cofiring = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Tech', usecols='D')

#print('Load distance from supply to plants...')
#df_distance_sypply_plants = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Distance_grid_to_plant', usecols='C:F')

print('Load fix and var transport cost...')
df_fix_var_transport_cost = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Transport_biomass', usecols='D:E')

print('Load emissions from transport biomass...')
df_transport_emission = pd.read_excel(file_location, header=None, skiprows=2, sheet_name='Transport_biomass', usecols='F')

print('Load emissions factor from coal combustion...')
df_emission_coal = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='EF_basecase', usecols='C')

print('Load carbon price...')
df_carbon_price = pd.read_excel(file_location, header=None, skiprows=3, sheet_name='Constants_coal', usecols='C')

print('Load emission target...')
df_emission_target = pd.read_excel(file_location, header=None, skiprows=4, sheet_name='Emission_target', usecols='Q:AC')



print('set-plant...')
create_parameter_file(file_destination+'set-plant.txt',['P'],pd.DataFrame(df_plants.iloc[::,0]))

print('set-technology...')
create_parameter_file(file_destination+'set-technology.txt',['Tech'],pd.DataFrame(df_cofir_technologies.iloc[::,0]))

print('set-supply...')
create_parameter_file(file_destination+'set-supply.txt',['S'],pd.DataFrame(df_supply.iloc[::,0]))

print('set-raw-material...')
create_parameter_file(file_destination+'set-raw-material.txt',['RM'],pd.DataFrame(df_RM.iloc[::,0]))

print('set-transport...')
create_parameter_file(file_destination+'set-transport.txt',['T'],pd.DataFrame(df_transport_mode.iloc[::,0]))

print('set-years...')
create_parameter_file(file_destination+'set-years.txt',['Y'],pd.DataFrame(df_year.iloc[::,0]))

print('set-raw-material-technology...')
create_parameter_file(file_destination+'set-raw-material-technology.txt',['RM','Tech'],pd.DataFrame(np.vstack([[df_RM.iloc[i, 0], df_cofir_technologies.iloc[j, 0]]
                                             for i in range(df_RM.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])])))

print('set-year-plant-relation...')   
create_parameter_file(file_destination+'set-year-plant-relation.txt',['Y','P'],pd.DataFrame(np.vstack([[df_year.iloc[j, 0], df_plants.iloc[i, 0]]
                                             for j in range(df_year.shape[0])
                                             for i in range(df_plants.shape[0])
                                             if df_power_generation.values[i,j] != 0])))    
    
    

##### create set-year-supply-raw-material-relation.txt
    

 
print('parameter-initial-status...')    
create_parameter_file(file_destination+'parameter-initial-status.txt',['P','Tech'],pd.DataFrame(np.vstack([[df_plants.iloc[i,0], df_cofir_technologies.iloc[j,0], df_initial_status.values[i,j]]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])])))
    
    
print('parameter-efficiency-coal_plant...')    
create_parameter_file(file_destination+'parameter-efficiency-coal_plant.txt',['P'],pd.DataFrame(np.vstack([[df_plants.iloc[i,0], df_eff_coal.values[i,0]]
                                             for i in range(df_plants.shape[0])])))
                                              

print('parameter-power-capacity...')    
create_parameter_file(file_destination+'parameter-power-capacity.txt',['P'],pd.DataFrame(np.vstack([[df_plants.iloc[i,0], df_power_capacity.values[i,0]]
                                             for i in range(df_plants.shape[0])])))
    
    
print('parameter-power-generation...')   
create_parameter_file(file_destination+'parameter-power-generation.txt',['Y','P'],pd.DataFrame(np.vstack([[df_year.iloc[j, 0], df_plants.iloc[i, 0], df_power_generation.values[i,j]]
                                             for j in range(df_year.shape[0])
                                             for i in range(df_plants.shape[0])
                                             if df_power_generation.values[i,j] != 0])))   
    
print('parameter-investment-coal-plant...')   
create_parameter_file(file_destination+'parameter-investment-coal-plant.txt',['Y','P'],pd.DataFrame(np.vstack([[df_year.iloc[j, 0], df_plants.iloc[i, 0], df_invest_coal.values[i,j]/1000]
                                             for j in range(df_year.shape[0])
                                             for i in range(df_plants.shape[0])])))
                                              
    
print('parameter-cost-IOM-coal...')   
create_parameter_file(file_destination+'parameter-cost-IOM-coal.txt',['Y','P'],pd.DataFrame(np.vstack([[df_year.iloc[j, 0], df_plants.iloc[i, 0], df_cost_IOM_coal.values[i,j]/1000]
                                             for j in range(df_year.shape[0])
                                             for i in range(df_plants.shape[0])])))
                                            


print('parameter-coal-price...')   
create_parameter_file(file_destination+'parameter-coal-price.txt',['Y','P'],pd.DataFrame(np.vstack([[df_year.iloc[j, 0], df_plants.iloc[i, 0], df_coal_price.values[i,j]/1000]
                                             for j in range(df_year.shape[0])
                                             for i in range(df_plants.shape[0])])))                               
   
    

print('set-year-supply-raw-material-relation-2018...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2018.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[0,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2018.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2018.values[i,j] != 0]))) 
    

print('set-year-supply-raw-material-relation-2019...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2019.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[1,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2019.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2019.values[i,j] != 0]))) 
    
    
print('set-year-supply-raw-material-relation-2020...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2020.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[2,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2020.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2020.values[i,j] != 0]))) 
    
print('set-year-supply-raw-material-relation-2021...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2021.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[3,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2021.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2021.values[i,j] != 0]))) 
    
print('set-year-supply-raw-material-relation-2022...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2022.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[4,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2022.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2022.values[i,j] != 0]))) 
    
print('set-year-supply-raw-material-relation-2023...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2023.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[5,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2023.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2023.values[i,j] != 0]))) 
    
print('set-year-supply-raw-material-relation-2024...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2024.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[6,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2024.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2024.values[i,j] != 0])))
    
print('set-year-supply-raw-material-relation-2025...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2025.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[7,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2025.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2025.values[i,j] != 0])))
    
print('set-year-supply-raw-material-relation-2026...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2026.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[8,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2026.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2026.values[i,j] != 0])))

print('set-year-supply-raw-material-relation-2027...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2027.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[9,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2027.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2027.values[i,j] != 0])))
    
print('set-year-supply-raw-material-relation-2028...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2028.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[10,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2028.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2028.values[i,j] != 0])))
    
print('set-year-supply-raw-material-relation-2029...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2029.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[11,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2029.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2029.values[i,j] != 0])))
    
print('set-year-supply-raw-material-relation-2030...')    
create_parameter_file(file_destination_processing+'set-year-supply-raw-material-relation-2030.txt',['Y','S','RM'],pd.DataFrame(np.vstack([[df_year.iloc[12,0], df_supply.iloc[i,0], df_RM.iloc[j,0], df_RM_avail_2030.values[i,j]]
                                             for i in range(df_supply.shape[0])
                                             for j in range(df_RM.shape[0])
                                             if df_RM_avail_2030.values[i,j] != 0])))
    
#    
##### exceptional 
#   
#  
filenames_1 = [file_destination_processing+'set-year-supply-raw-material-relation-2018.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2019.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2020.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2021.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2022.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2023.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2024.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2025.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2026.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2027.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2028.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2029.txt',
             file_destination_processing+'set-year-supply-raw-material-relation-2030.txt']
#
#output = file_destination+'parameter-potential-biomass.txt'
with open(file_destination+'parameter-potential-biomass.txt', 'w') as outfile:
    for fname in filenames_1:
        with open(fname) as infile:
            for line in infile:
                outfile.write(line)
           
#                
####file = open(output,"r")
####for line in file:
####    split_carac = line.split()
####    after_split_carac = split_carac[0]
####    
####file_new = open(file_destination+'set-year-supply-raw-material-relation.txt', 'w')
####file_new.write(after_split_carac)
####file_new.close
####
###
print('parameter-biomass-price...')    
create_parameter_file(file_destination+'parameter-biomass-price.txt',['Y','RM'],pd.DataFrame(np.vstack([[df_year.iloc[i,0], df_RM.iloc[j,0], df_biom_price.values[i,j]/1000]
                                             for i in range(df_year.shape[0])
                                             for j in range(df_RM.shape[0])]))) 

                                          
print('parameter-CRF-cofiring...')    
create_parameter_file(file_destination+'parameter-CRF-cofiring.txt',['P'],pd.DataFrame(np.vstack([[df_plants.iloc[i,0], df_CRF_cof.values[i,0]]
                                             for i in range(df_plants.shape[0])])))      

print('parameter-specific-cost-cofiring-2018...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2018.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[0,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                            
    

print('parameter-specific-cost-cofiring-2019...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2019.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[1,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+4]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                            
    
    
print('parameter-specific-cost-cofiring-2020...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2020.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[2,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+8]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2021...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2021.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[3,0], df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+12]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                            
    
print('parameter-specific-cost-cofiring-2022...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2022.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[4,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+16]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2023...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2023.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[5,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+20]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2024...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2024.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[6,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+24]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                            
    
print('parameter-specific-cost-cofiring-2025...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2025.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[7,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+28]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2026...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2026.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[8,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+32]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             

print('parameter-specific-cost-cofiring-2027...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2027.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[9,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+36]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2028...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2028.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[10,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+40]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2029...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2029.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[11,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+44]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])]))) 
                                             
    
print('parameter-specific-cost-cofiring-2030...')    
create_parameter_file(file_destination_processing+'parameter-specific-cost-cofiring-2030.txt',['Y','P','Tech'],pd.DataFrame(np.vstack([[df_year.iloc[12,0], 
                                                                                                                                       df_plants.iloc[i,0], 
                                                                                                                                       df_cofir_technologies.iloc[j,0], 
                                                                                                                                       df_specific_cost.values[i,j+48]/1000]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])])))  

filenames_3 = [file_destination_processing+'parameter-specific-cost-cofiring-2018.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2019.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2020.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2021.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2022.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2023.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2024.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2025.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2026.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2027.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2028.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2029.txt',
             file_destination_processing+'parameter-specific-cost-cofiring-2030.txt']


with open(file_destination+'parameter-specific-cost-cofiring.txt', 'w') as outfile:
    for fname in filenames_3:
        with open(fname) as infile:
            for line in infile:
                outfile.write(line)                                


print('parameter-fix-OM-cost-cofiring...')    
create_parameter_file(file_destination+'parameter-fix-OM-cost-cofiring.txt',['Tech'],pd.DataFrame(np.vstack([[df_cofir_technologies.iloc[i,0], df_fix_var_OM_cofir_cost.values[114,0]/1000]
                                             for i in range(df_cofir_technologies.shape[0])])))
    
print('parameter-var-OM-cost-cofiring...')    
create_parameter_file(file_destination+'parameter-var-OM-cost-cofiring.txt',['Tech'],pd.DataFrame(np.vstack([[df_cofir_technologies.iloc[i,0], df_fix_var_OM_cofir_cost.values[115,0]/1000]
                                             for i in range(df_cofir_technologies.shape[0])])))

print('parameter-utilization-rate-high...')    
create_parameter_file(file_destination+'parameter-utilization-rate-high.txt',['Tech'],pd.DataFrame(np.vstack([[df_cofir_technologies.iloc[i,0], df_U_rate.values[i,0]]
                                             for i in range(df_cofir_technologies.shape[0])])))
    
print('parameter-utilization-rate-low...')    
create_parameter_file(file_destination+'parameter-utilization-rate-low.txt',['Tech'],pd.DataFrame(np.vstack([[df_cofir_technologies.iloc[i,0], df_U_rate.values[i,1]]
                                             for i in range(df_cofir_technologies.shape[0])])))
    
print('parameter-efficiency-cofiring...')    
create_parameter_file(file_destination+'parameter-efficiency-cofiring.txt',['P','Tech'],pd.DataFrame(np.vstack([[df_plants.iloc[i,0], df_cofir_technologies.iloc[j,0], df_eff_cofiring.values[j,0]]
                                             for i in range(df_plants.shape[0])
                                             for j in range(df_cofir_technologies.shape[0])])))
                                          

#print('parameter-distance-supply-plant-2018...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2018.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[0,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2019...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2019.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[1,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2020...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2020.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[2,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2021...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2021.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[3,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2022...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2022.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[4,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2023...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2023.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[5,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2024...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2024.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[6,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2025...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2025.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[7,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2026...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2026.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[8,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2027...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2027.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[9,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#print('parameter-distance-supply-plant-2028...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2028.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[10,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#
#print('parameter-distance-supply-plant-2029...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2029.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[11,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))
#    
#
#print('parameter-distance-supply-plant-2030...')    
#create_parameter_file(file_destination_processing+'parameter-distance-supply-plant-2030.txt',['Y','RM','S','P','T'],pd.DataFrame(np.vstack([[df_year.iloc[12,0], df_distance_sypply_plants.iloc[i,3], df_distance_sypply_plants.iloc[i,0], df_distance_sypply_plants.iloc[i,1], df_transport_mode.iloc[j,0], df_distance_sypply_plants.values[i,2]]
#                                             for j in range(df_transport_mode.shape[0])
#                                             for i in range(df_distance_sypply_plants.shape[0])])))  
#    
#
#filenames_4 = [file_destination_processing+'parameter-distance-supply-plant-2018.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2019.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2020.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2021.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2022.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2023.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2024.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2025.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2026.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2027.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2028.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2029.txt',
#             file_destination_processing+'parameter-distance-supply-plant-2030.txt']
#
#
#with open(file_destination+'parameter-distance-supply-plant.txt', 'w') as outfile:
#    for fname in filenames_4:
#        with open(fname) as infile:
#            for line in infile:
#                outfile.write(line)
    
print('parameter-transport-fix-cost...')    
create_parameter_file(file_destination+'parameter-transport-fix-cost.txt',['RM','T'],pd.DataFrame(np.vstack([[df_RM.iloc[i,0], df_transport_mode.iloc[j,0], df_fix_var_transport_cost.values[i,0]/1000]
                                             for i in range(df_RM.shape[0])
                                             for j in range(df_transport_mode.shape[0])])))
    
print('parameter-transport-var-cost...')    
create_parameter_file(file_destination+'parameter-transport-var-cost.txt',['RM','T'],pd.DataFrame(np.vstack([[df_RM.iloc[i,0], df_transport_mode.iloc[j,0], df_fix_var_transport_cost.values[i,1]/1000]
                                             for i in range(df_RM.shape[0])
                                             for j in range(df_transport_mode.shape[0])])))
    
print('parameter-trans-emission...')    
create_emission_parameter_file(file_destination+'parameter-trans-emission.txt',['RM','T'],pd.DataFrame(np.vstack([[df_RM.iloc[i,0], df_transport_mode.iloc[j,0], df_transport_emission.values[0,0]/1000000]
                                             for i in range(df_RM.shape[0])
                                             for j in range(df_transport_mode.shape[0])])))
    
print('parameter-emission-basecase...')    
create_emission_parameter_file(file_destination+'parameter-emission-basecase.txt',['Y'],pd.DataFrame(np.vstack([[df_year.iloc[i,0], df_emission_coal.values[0,0]/1000000]
                                             for i in range(df_year.shape[0])])))
                                            
                                           

print('parameter-price-carbon...')    
create_parameter_file(file_destination+'parameter-price-carbon.txt',['Y'],pd.DataFrame(np.vstack([[df_year.iloc[yy,0], df_carbon_price.values[33,0]*1000]
                                             for yy in range(df_year.shape[0])])))
                   
# Emissions target 2 degree - NDC
#print('parameter_emission_target...')    
#create_parameter_file(file_destination+'parameter_emission_target.txt',['Y'],pd.DataFrame(np.vstack([[df_year.iloc[yy,0], df_emission_target.values[0,yy]]
#                                             for yy in range(df_year.shape[0])])))


# Emission target assumpted - 15% compared to baseline 
print('parameter_emission_target...')    
create_parameter_file(file_destination+'parameter_emission_target.txt',['Y'],pd.DataFrame(np.vstack([[df_year.iloc[yy,0], df_emission_target.values[3,yy]]
                                             for yy in range(df_year.shape[0])])))

