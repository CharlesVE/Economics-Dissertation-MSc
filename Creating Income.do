/// This has to be done before the tax_rate do file /// #

*****************************
* Varkey  Data (Statistics by Country)
*The purpose of this code is to create a Stata Dataset containing the interested variables by countries
* Started May, 2018 
******************************

**Use the Teacher Data
/// use "C:\Users\supersnake0426\Desktop\Varkey\Varkey_Teachers.dta", clear

use "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Main/Dissertation MAIN/DATA/Varkey/Varkey_Teachers.dta"
keep if SampleRespType==1

/// SampleRespType is separated into two types a) NAT REP b) Teachers only sample 
/// ...a) since we don't want a teachers only sample ///

****Setting up the directory
set more off
/// "tells Stata not to pause or display a more message" ///
/// global Varkey_main = "D:/Varkey/"  // set up the main directory


global Varkey_main = "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Dissertation Teacher/Dissertation MAIN/DATA/Varkey/"
cd ${Varkey_main} 
capture: mkdir output
///  Capture is a modifier so that the mkdir command does not produce an output/// mkdir = make directory, it creates a new folder, it's 'output' hence why output is put after mkdir

/**Rename the market Label**/
label define market 34 "UK", modify /// it was previously 'the UK'
label values market market

**Recode the rank of Occupational status 
lookfor Q1grid_ Q2grid_
 local recode_vars `r(varlist)'
foreach re_var of local recode_vars {
gen `re_var'_r=`re_var'-14
recode `re_var'_r (-13=14) (-12=13) (-11=12) (-10=11) (-9=10) (-8=9) (-7=8) (-6=7) (-5=6) (-4=5) (-3=4) (-2=3) (-1=2) (0=1)

}

***Generate the string variable for each market
gen market_str =""
replace market_str = "Argentina"  if market ==1
replace market_str = "Brazil"  if market ==2
replace market_str = "Canada"  if market ==3
replace market_str = "Chile"  if market ==4
replace market_str = "China"  if market ==5
replace market_str = "Colombia"  if market ==6
replace market_str = "Czech Republic"  if market ==7
replace market_str = "Egypt"  if market ==8
replace market_str = "Finland"  if market ==9
replace market_str = "France"  if market ==10
replace market_str = "Germany"  if market ==11
replace market_str = "Ghana"  if market ==12
replace market_str = "Greece"  if market ==13
replace market_str = "Hungary"  if market ==14
replace market_str = "India"  if market ==15
replace market_str = "Indonesia"  if market ==16
replace market_str = "Israel"  if market ==17
replace market_str = "Italy"  if market ==18
replace market_str = "Japan"  if market ==19
replace market_str = "Korea"  if market ==20
replace market_str = "Malaysia"  if market ==21
replace market_str = "Netherlands"  if market ==22
replace market_str = "New Zealand"  if market ==23
replace market_str = "Panama"  if market ==24
replace market_str = "Peru"  if market ==25
replace market_str = "Portugal"  if market ==26
replace market_str = "Russia"  if market ==27
replace market_str = "Singapore"  if market ==28
replace market_str = "Spain"  if market ==29
replace market_str = "Switzerland"  if market ==30
replace market_str = "Taiwan"  if market ==31
replace market_str = "Turkey"  if market ==32
replace market_str = "Uganda"  if market ==33
replace market_str = "UK"  if market ==34
replace market_str = "United States"  if market ==35

/// The above lines create a new variable called market_str which is basically the same as the market variable only a string version ///

gen market_abb =""
replace market_abb = "AR"  if market ==1
replace market_abb = "BR"  if market ==2
replace market_abb = "CA"  if market ==3
replace market_abb = "CL"  if market ==4
replace market_abb = "CN"  if market ==5
replace market_abb = "CO"  if market ==6
replace market_abb = "CZ"  if market ==7
replace market_abb = "EG"  if market ==8
replace market_abb = "FI"  if market ==9
replace market_abb = "FR"  if market ==10
replace market_abb = "DE"  if market ==11
replace market_abb = "GH"  if market ==12
replace market_abb = "GR"  if market ==13
replace market_abb = "HU"  if market ==14
replace market_abb = "IN"  if market ==15
replace market_abb = "ID"  if market ==16
replace market_abb = "IL"  if market ==17
replace market_abb = "IT"  if market ==18
replace market_abb = "JP"  if market ==19
replace market_abb = "KR"  if market ==20
replace market_abb = "MY"  if market ==21
replace market_abb = "NL"  if market ==22
replace market_abb = "NZ"  if market ==23
replace market_abb = "PA"  if market ==24
replace market_abb = "PE"  if market ==25
replace market_abb = "PT"  if market ==26
replace market_abb = "RU"  if market ==27
replace market_abb = "SG"  if market ==28
replace market_abb = "ES"  if market ==29
replace market_abb = "CH"  if market ==30
replace market_abb = "TW"  if market ==31
replace market_abb = "TR"  if market ==32
replace market_abb = "UG"  if market ==33
replace market_abb = "UK"  if market ==34
replace market_abb = "US"  if market ==35

/// This does the same thing as the previous list of commands only with the abbreviations for countries rather than the actual names themselves, 
/// it is used to merge the datasets as they need a variable that is constant between the 2 datasets, that is why this do file must be done first///
/// Since the second one is used for merges ///


***********************The following code is to create the statistics for each market/country.****************************************

/// Necessary for later merge ///

***********************************Figure 3 : Average status ranking of primary school teachers, "



preserve
 collapse (firstnm) market_abb market_str (mean) mean_rank_p=Q1grid_C_Q1_r mean_rank_s=Q1grid_D_Q1_r mean_rank_h=Q1grid_E_Q1_r  (count) count_Primary=Q1grid_C_Q1_r count_Second=Q1grid_D_Q1_r count_Head=Q1grid_E_Q1_r (mean) mean_be_teacher=Q11  mean_respect_country=Q17grid_D_Q17  mean_respect_school=Q17grid_E_Q17 , by(market) 

/// collapse converts the dataset in memory into a dataset of means, sums, medians, etc. clist refers to numeric variables exclusively. ///
 
**create a variable to sort the the country in the figure
egen sort_r_head=rank( mean_rank_h ), unique
 
labmask sort_r_head, values(market_str )
sort sort_r_head

save data_bycountry, replace
/// "(note: file data_bycountry.dta not found) file data_bycountry.dta saved" ---- No longer a problem ///

restore

****************************Figure 4:  Would you encourage your child to become a teacher?
preserve 
/// The restore comes after figure 5 /// 

contract market Q11  market_str market_abb

bys market (Q11) : gen sum_freq = sum(_freq)
bys market (Q11) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100


gen Q11_percent21=.
gen Q11_percent22=.
gen Q11_percent23=.
gen Q11_percent24=.
gen Q11_percent25=.
bys market : replace Q11_percent21 = _percent2[1]  
bys market : replace Q11_percent22 = _percent2[2]  
bys market : replace Q11_percent23 = _percent2[3]  
bys market : replace Q11_percent24 = _percent2[4]  
bys market : replace Q11_percent25 = _percent2[5]

label variable Q11_percent21 "Q11 percentage value 1"
label variable Q11_percent22 "Q11 percentage value 2"
label variable Q11_percent23 "Q11 percentage value 3"
label variable Q11_percent24 "Q11 percentage value 4"
label variable Q11_percent25 "Q11 percentage value 5"  
drop Q11 _percent _percent2 _freq sum_freq
bys market: keep if _n==1

bysort market:  gen Q11_sort_var= Q11_percent21+Q11_percent22

 egen Q11_rank_var=rank(Q11_sort_var)
labmask Q11_rank_var, value(market_str)
 
 
 ***********************Figure 5 Positive encouragement for children to become teachers correlated against average teacher respect ranking compared to other professions
 gen _percent_enc2= Q11_percent21+Q11_percent22
 
               /// WARNING! /// 
/// ignore the "//" and just do the command without it ///

merge 1:1 market using data_bycountry 
drop _merge

save data_bycountry, replace

	  restore


************************ Figure 6: Teachers’ social status compared to doctors, librarians, social workers, nurses and local government  managers as a percentage of professions considered most similar
preserve

contract market Q3 market_str market_abb

bys market (Q3) : gen sum_freq = sum(_freq)
bys market (Q3) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100


gen Q3_percent21=.
gen Q3_percent27=.
gen Q3_percent210=.
gen Q3_percent29=.
gen Q3_percent25=.
bys market : replace Q3_percent21 = _percent2[1]
bys market : replace Q3_percent27 = _percent2[7]  
bys market : replace Q3_percent210 = _percent2[10]  
bys market : replace Q3_percent29 = _percent2[9]  
bys market : replace Q3_percent25 = _percent2[5]

drop Q3 _percent _percent2 _freq sum_freq
bys market: keep if _n==1

merge 1:1 market using data_bycountry
drop _merge

save data_bycountry, replace
 restore
 
 
***************************************************** Figure 7  Pupils respect teachers*********
*****Pupils respect teachers in my COUNTRY

/// WARNING ///
/// BEFORE doing this, make sure not to put in the '//' in the command ///

preserve
contract market Q17grid_D_Q17 market_str 

bys market (Q17grid_D_Q17) : gen sum_freq = sum(_freq)
bys market (Q17grid_D_Q17) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100

gen Q17D_percent21=.
gen Q17D_percent22=.
gen Q17D_percent23=.
gen Q17D_percent24=.
gen Q17D_percent25=.
bys market : replace Q17D_percent21 = _percent2[1]  
bys market : replace Q17D_percent22 = _percent2[2]  
bys market : replace Q17D_percent23 = _percent2[3]  
bys market : replace Q17D_percent24 = _percent2[4]  
bys market : replace Q17D_percent25 = _percent2[5]

label variable Q17D_percent21 "Q17D percentage value 1"
label variable Q17D_percent22 "Q17D percentage value 2"
label variable Q17D_percent23 "Q17D percentage value 3"
label variable Q17D_percent24 "Q17D percentage value 4"
label variable Q17D_percent25 "Q17D percentage value 5"  
drop Q17grid_D_Q17 _percent _percent2 _freq sum_freq
bys market: keep if _n==1

gen Q17D_sort_var= Q17D_percent21+Q17D_percent22
egen Q17D_rank_var=rank(Q17D_sort_var)
labmask Q17D_rank_var, value(market_str)

merge 1:1 market using data_bycountry 
drop _merge

save data_bycountry, replace

 restore
 
 ***********************************************************Pupils respect teachers in my SCHOOL**************************************************************
 /// WARNING /// 
 /// Ignore '//' ///
 preserve
contract market Q17grid_E_Q17 market_str , nomiss 


bys market (Q17grid_E_Q17) : gen sum_freq = sum(_freq)
bys market (Q17grid_E_Q17) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100

gen Q17E_percent21=.
gen Q17E_percent22=.
gen Q17E_percent23=.
gen Q17E_percent24=.
gen Q17E_percent25=.
bys market : replace Q17E_percent21 = _percent2[1]  
bys market : replace Q17E_percent22 = _percent2[2]  
bys market : replace Q17E_percent23 = _percent2[3]  
bys market : replace Q17E_percent24 = _percent2[4]  
bys market : replace Q17E_percent25 = _percent2[5]

label variable Q17E_percent21 "Q17E percentage value 1"
label variable Q17E_percent22 "Q17E percentage value 2"
label variable Q17E_percent23 "Q17E percentage value 3"
label variable Q17E_percent24 "Q17E percentage value 4"
label variable Q17E_percent25 "Q17E percentage value 5"  
drop Q17grid_E_Q17 _percent _percent2 _freq sum_freq
bys market: keep if _n==1

gen Q17E_sort_var= Q17E_percent21+Q17E_percent22
egen Q17E_rank_var=rank(Q17E_sort_var)
labmask Q17E_rank_var, value(market_str)


merge 1:1 market using data_bycountry 
drop _merge
save data_bycountry, replace

restore	  
	
	
****************************************************Figure 12.1  Should teachers be rewarded in pay according to their pupils’ results?*********************
preserve
contract market Q17grid_G_Q17 market_str 

bys market (Q17grid_G_Q17) : gen sum_freq = sum(_freq)
bys market (Q17grid_G_Q17) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100


gen Q17G_percent21=.
gen Q17G_percent22=.
gen Q17G_percent23=.
gen Q17G_percent24=.
gen Q17G_percent25=.
bys market : replace Q17G_percent21 = _percent2[1]  
bys market : replace Q17G_percent22 = _percent2[2]  
bys market : replace Q17G_percent23 = _percent2[3]  
bys market : replace Q17G_percent24 = _percent2[4]  
bys market : replace Q17G_percent25 = _percent2[5]

label variable Q17G_percent21 "Q17G percentage value 1"
label variable Q17G_percent22 "Q17G percentage value 2"
label variable Q17G_percent23 "Q17G percentage value 3"
label variable Q17G_percent24 "Q17G percentage value 4"
label variable Q17G_percent25 "Q17G percentage value 5"  
drop Q17grid_G_Q17 _percent _percent2 _freq sum_freq
bys market: keep if _n==1


gen Q17G_sort_var= Q17G_percent21+Q17G_percent22
egen Q17G_rank_var=rank(Q17G_sort_var)
labmask Q17G_rank_var, value(market_str)


merge 1:1 market using data_bycountry 
drop _merge

save data_bycountry, replace

restore	  


****************************************************************************Figure 12.2  Should teachers be rewarded in pay according to effort?*************************
preserve
contract market Q17grid_H_Q17 market_str 

bys market (Q17grid_H_Q17) : gen sum_freq = sum(_freq)
bys market (Q17grid_H_Q17) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100

gen Q17H_percent21=.
gen Q17H_percent22=.
gen Q17H_percent23=.
gen Q17H_percent24=.
gen Q17H_percent25=.
bys market : replace Q17H_percent21 = _percent2[1]  
bys market : replace Q17H_percent22 = _percent2[2]  
bys market : replace Q17H_percent23 = _percent2[3]  
bys market : replace Q17H_percent24 = _percent2[4]  
bys market : replace Q17H_percent25 = _percent2[5]

label variable Q17H_percent21 "Q17H percentage value 1"
label variable Q17H_percent22 "Q17H percentage value 2"
label variable Q17H_percent23 "Q17H percentage value 3"
label variable Q17H_percent24 "Q17H percentage value 4"
label variable Q17H_percent25 "Q17H percentage value 5"  
drop Q17grid_H_Q17 _percent _percent2 _freq sum_freq
bys market: keep if _n==1


gen Q17H_sort_var= Q17H_percent21+Q17H_percent22
egen Q17H_rank_var=rank(Q17H_sort_var)
labmask Q17H_rank_var, value(market_str)

merge 1:1 market using data_bycountry 
drop _merge
save data_bycountry, replace
	 restore
	 
	
*******************************************************************************Figure 14  How good is the education system?**********************



preserve
collapse (mean) mean_edu_good=Q14Grid_1_Q14 (count) count_edu_count=Q14Grid_1_Q14, by(market) 

merge 1:1 market using PISA2015.dta, keepusing(_all)
drop _merge

drop if market>35

egen market_r_good=rank( mean_edu_good )
replace market_str="Egypt" if market== 8
replace market_str="Ghana" if market== 12 
replace market_str="India" if market== 15
replace market_str="Malaysia" if market== 21
replace market_str="Panama" if market== 24
replace market_str="Uganda" if market== 33

labmask market_r_good, values(market_str )



	merge 1:1 market using data_bycountry 
drop _merge
save data_bycountry, replace
restore


******************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************
*****************************************************The following code is related to financial variable and tax rate****
**********************************************************************************************************************************************************************************************
*****************************************************Run the "tax_rate_varkey.do" to create the STATA dataset "tax_rate_varkey" 
******************************************************************************************************************************************************************************


/// WARNING!! ///
/// Preserve is for preserving data, make sure to do it BEFORE running the tax rate do file ///

preserve




















// run "C:\Users\supersnake0426\Desktop\Varkey\tax_rate_varkey.do"


/// START HERE AFTER 'tax_rate_varkey.do ///

///  run "\Users\charlesvalenciaevans\Documents\Sussex University\Dissertation\Dissertation Teacher\Dissertation MAIN\DATA\Varkey\tax_rate_varkey.do" ///
restore
**Then merge the information of tax rate into the original dataset.
/**The following section is to merge the variables of tax rate with the Varkey 2018 dataset**/

merge m:1 market using tax_rate_varkey.dta, keepusing(_all) 

/// '(note: variable market_str was str14, now str79 to accommodate using data's values)' /// 


/**After merging the tax rate, we are able to convert the net salary to gross salary. 

First of all, we create the variable of gross salary and net salary**/
gen derivedincgross=.
replace derivedincgross=S10_5 if S10_5!=. & S11==1 /// S11==1 is the question confirming that the income is gross salary
/// in otherwords, replace derivedincgross to be equal to INCOME for those that answered 5 next to their income (since 5 gives the S10_5 value of being annual) if S10_5 is not null (.) and if S11 confirms it is gross salary ///
replace derivedincgross=S10_4*12 if S10_4!=. & S11==1
/// replace derivedincgross with 12 times the monthly value if the respective boxes aren't null (.) and it is in fact gross salary (S11==1)
replace derivedincgross=S10_3*48 if S10_3!=. & S11==1

replace derivedincgross=S10_2*240 if S10_2!=. & S11==1
replace derivedincgross=S10_1*1960 if S10_1!=. & S11==1

/// Then we create the variable of net salary ///
gen derivedincnet=.
replace derivedincnet=S10_5 if S10_5!=. & S11==2 /// S11==2 is question confirming that the income is net salary
/// make derived net income equal to S10_5 (All those who answered 5 will give their income annually) if the box is not empty and if it is definitely net salary individuals ///
replace derivedincnet=S10_4*12 if S10_4!=. & S11==2
replace derivedincnet=S10_3*48 if S10_3!=. & S11==2
replace derivedincnet=S10_2*240 if S10_2!=. & S11==2
replace derivedincnet=S10_1*1960 if S10_1!=. & S11==2



***Calculating the gross salary given net salary
gen gross_s=.
gen net_s =derivedincnet 




*******************
**the order of the following is very important
****Reconstruct the structure of tax: Reset the personal allowance as the first band/bracket 
/**Since the OECD taxation dataset separate the personal allowance as a variable, I re-construct the personal allowance as the first threshold. 
This setting helps the calculation in the later of the code **/
replace th_12=th_11 if p_allowance!=0 
replace mr_12=mr_11 if p_allowance!=0
replace th_11=th_10 if p_allowance!=0
replace mr_11=mr_10 if p_allowance!=0
replace th_10=th_09 if p_allowance!=0
replace mr_10=mr_09 if p_allowance!=0
forvalues i=9(-1)2 {
local i_1=`i'-1
replace th_0`i'=th_0`i_1' if p_allowance!=0
replace mr_0`i'=mr_0`i_1' if p_allowance!=0
}
replace th_01=p_allowance if p_allowance!=0
replace mr_01=0 if p_allowance!=0

replace p_allowance=0

/// every section has been moved down a section, hence forvalues acting as an algorithm instead...
/// ... of writing the whole thing our manually. This is because, starting from the bottom, the lowest tax bracket becomes the personal allowance, therefore... 
/// ... the tax bracket above (below th_02 must now become th_01 since it is now the first threshold)
********************
/**Create the marginal tax rate and threshold for NET salary, given the marginal tax rate and threshold of Gross salary.
Please see the excel file "Net_vs_Gross_tax_rate_example" for the detail of calculation. **/
gen net_th_01=th_01-p_allowance
gen net_th_02= th_02-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_02
gen net_mr_01=(1/(1-mr_01))-1
gen net_mr_02=(1/(1-mr_02))-1
/** Create the variable of the difference between consecutive bracket: column I in the excel file "Net_vs_Gross_tax_rate_example".
This is an important proxy to convert gross to net salary.  
**/
gen net_dif_mr_01=net_mr_02-net_mr_01

forvalues i=3(1)12 {
local i_1=`i'-1
if `i'<= 9{
local temp_term "`temp_term' -(th_0`i'-th_0`i_1')*mr_0`i' "
display "th_0`i'-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_01 `temp_term'"
gen net_th_0`i'= th_0`i'-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_02 `temp_term'
gen net_mr_0`i'=(1/(1-mr_0`i'))-1
gen net_dif_mr_0`i_1'=net_mr_0`i'-net_mr_0`i_1'
}
else if `i'==10{
local temp_term "`temp_term' -(th_`i'-th_0`i_1')*mr_`i' "
display "th_`i'-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_02 `temp_term'"
gen net_th_`i'= th_`i'-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_02 `temp_term'
gen net_mr_`i'=(1/(1-mr_`i'))-1
gen net_dif_mr_`i_1'=net_mr_`i'-net_mr_0`i_1'
}

else if `i'>10{
local temp_term "`temp_term' -(th_`i'-th_`i_1')*mr_`i' "
display "th_`i'-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_02 `temp_term'"
gen net_th_`i'= th_`i'-(th_01-p_allowance)*mr_01-(th_02-th_01)*mr_02 `temp_term'
gen net_mr_`i'=(1/(1-mr_`i'))-1
gen net_dif_mr_`i_1'=net_mr_`i'-net_mr_`i_1'
}

}



/**I create a variable "detect" to detect the bracket that the respondant's salary is located **/
gen detect=0 
/*detect which bracket that respondant's salary located*/
forvalues i=11(-1)1 {
*display "`i'"
if `i'>=10 {
replace detect=detect+1 if net_s>net_th_`i'
}
else {
replace detect=detect+1 if net_s>net_th_0`i'
}
}


**Salary Located in Tax band 1
replace gross_s=net_s if detect ==0
replace gross_s=net_s+(net_s-net_th_01)*net_dif_mr_01 if detect ==1
**Salary located in Tax band 2
forvalues i=1(1)2 {
local net_temp  " `net_temp'  +(net_s-net_th_0`i')*net_dif_mr_0`i' "
}
display "`net_temp'"
replace gross_s=net_s `net_temp' if detect==2
**Salary located in Tax band 3-9


rename net_dif_mr_9 net_dif_mr_09

forvalues ii=3(1)9 {
local net_temp 
forvalues i=1(1)`ii' {
local net_temp  " `net_temp'  +(net_s-net_th_0`i')*net_dif_mr_0`i' "
}
replace gross_s=net_s `net_temp' if detect==`ii'
}
display "`net_temp'"



**Salary located in Tax band 10
local net_temp
forvalues i=1(1)9 {
local net_temp  " `net_temp'  +(net_s-net_th_0`i')*net_dif_mr_0`i' "
}
forvalues ii=10 (1)10 {
local net_temp  " `net_temp'  +(net_s-net_th_`ii')*net_dif_mr_`ii' "
}
display "`net_temp'"
replace gross_s=net_s `net_temp' if detect==10
**Salary located in  Tax band 11
local net_temp
forvalues i=1(1)9 {
local net_temp  " `net_temp'  +(net_s-net_th_0`i')*net_dif_mr_0`i' "
}
forvalues ii=10(1)11 {
local net_temp  " `net_temp'  +(net_s-net_th_`ii')*net_dif_mr_`ii' "
}
replace gross_s=net_s `net_temp' if detect==11



/**Now, consider the tax credit. I create the variable of  payable tax (Gross-Net salary), and compare the payable tax with tax credit.
Gross = Net + Payable tax -tax_credit (if payable tax > tax credit)
Gross = Net + Payable tax (If payable tax < tax credit) 
gross_s_tc is the gross salary that adjusted from net salary (_tc means that this variable is adjusted with tax credit as well)
**/
gen tax=gross_s-net_s
replace tax_credit=0 if tax_credit==.
gen dif_tax_credit=tax-tax_credit

replace dif_tax_credit=max(dif_tax_credit, 0)
gen gross_s_tc=net_s+dif_tax_credit 
/*considering the tax credit*/


						 
/**Replace the gross salary with the information of net salary  **/
 sum derivedincgross
replace derivedincgross= gross_s_tc if derivedincgross==. & gross_s_tc!=.

 sum derivedincgross
 


 
 /**Create the dummy "bonus" for 13th or 14th monthly payment (bonus payment)
No bonus payment = 0 
13 th monthly payment =1 
14 th monthly payment =2 ,
Then adjust the derived salary with the bonus payment **/
gen bonus=0

replace bonus =1 if market_str =="Argentina"
replace bonus =2 if market_str =="Brazil"
replace bonus =1 if market_str =="Chile"
replace bonus =1 if market_str =="China"
replace bonus =1 if market_str =="Colombia"
replace bonus =1 if market_str =="Finland"
replace bonus =1 if market_str =="France"
replace bonus =1 if market_str =="Germany"
replace bonus =2 if market_str =="Greece"
replace bonus =1 if market_str =="India"
replace bonus =1 if market_str =="Indonesia"
replace bonus =1 if market_str =="Italy"
replace bonus =2 if market_str =="Japan"
replace bonus =1 if market_str =="Malaysia"
replace bonus =1 if market_str =="Netherlands"
replace bonus =1 if market_str =="Panama"
replace bonus =2 if market_str =="Peru"
replace bonus =1 if market_str =="Portugal"
replace bonus =1 if market_str =="Singapore"
replace bonus =2 if market_str =="Spain"
replace bonus =1 if market_str =="Switzerland"
replace bonus =1 if market_str =="Taiwan"

/// Of the 20 countries cited above, those with bonus =1 have a bonus month's salary while those with bonus = 2 have 2 months bonus salary

replace derivedincgross = derivedincgross* 13/12 if bonus ==1
replace derivedincgross = derivedincgross* 14/12 if bonus ==2

**Gross 
gen derivedpppincgross=.
/// creating ppp from non ppp
replace derivedpppincgross=derivedincgross / 11.341 if market==1
replace derivedpppincgross=derivedincgross / 2.052 if market==2
replace derivedpppincgross=derivedincgross / 1.208 if market==3
replace derivedpppincgross=derivedincgross / 385.357 if market==4
replace derivedpppincgross=derivedincgross / 3.509 if market==5
replace derivedpppincgross=derivedincgross / 1292.842 if market==6
replace derivedpppincgross=derivedincgross / 13.405 if market==7
replace derivedpppincgross=derivedincgross / 2.896 if market==8
replace derivedpppincgross=derivedincgross / 0.92 if market==9
replace derivedpppincgross=derivedincgross / 0.808 if market==10
replace derivedpppincgross=derivedincgross / 0.78 if market==11
replace derivedpppincgross=derivedincgross / 1.554 if market==12
replace derivedpppincgross=derivedincgross / 0.605 if market==13
replace derivedpppincgross=derivedincgross / 130.189 if market==14
replace derivedpppincgross=derivedincgross / 17.697 if market==15
replace derivedpppincgross=derivedincgross / 4164.36 if market==16
replace derivedpppincgross=derivedincgross / 4 if market==17
replace derivedpppincgross=derivedincgross / 0.738 if market==18
replace derivedpppincgross=derivedincgross / 100.675 if market==19
replace derivedpppincgross=derivedincgross / 858.084 if market==20
replace derivedpppincgross=derivedincgross / 1.449 if market==21
replace derivedpppincgross=derivedincgross / 0.799 if market==22
replace derivedpppincgross=derivedincgross / 1.497 if market==23
replace derivedpppincgross=derivedincgross / 0.594 if market==24
replace derivedpppincgross=derivedincgross / 1.667 if market==25
replace derivedpppincgross=derivedincgross / 0.622 if market==26
replace derivedpppincgross=derivedincgross / 25.327 if market==27
replace derivedpppincgross=derivedincgross / 0.827 if market==28
replace derivedpppincgross=derivedincgross / 0.655 if market==29
replace derivedpppincgross=derivedincgross / 1.291 if market==30
replace derivedpppincgross=derivedincgross / 14.885 if market==31
replace derivedpppincgross=derivedincgross / 1.421 if market==32
replace derivedpppincgross=derivedincgross / 1078.125 if market==33
replace derivedpppincgross=derivedincgross / 0.696 if market==34
replace derivedpppincgross=derivedincgross / 1 if market==35




/**Create the variable of the mean Minimum Wage across our countries, then eliminate/remove the observations below the mean minimum wages   **/

gen derivedsalarygross=.
replace derivedsalarygross=Q5AGrid_2_Q5A  if Q5AGrid_2_Q5A!=. & Q5BGrid_2_Q5B ==1


gen derivedsalarynet=.
replace derivedsalarynet=Q5AGrid_2_Q5A  if Q5AGrid_2_Q5A!=. & Q5BGrid_2_Q5B ==2

gen derivedsalarygrossfair=.
replace derivedsalarygrossfair=Q6AGrid_2_Q6A if Q6AGrid_2_Q6A!=. & Q6BGrid_2_Q6B ==1


gen derivedsalarynetfair=.
replace derivedsalarynetfair=Q6AGrid_2_Q6A if Q6AGrid_2_Q6A!=. & Q6BGrid_2_Q6B ==2


*************************************************************************************************
******Code Below is to generate the gross variables in terms of net variables***********************************
************************************************************************************************

/** Generate the gross salary in terms of net salary. In order to save space, I use the code mentioned above, 
and set up a "local" function to convert the net variable that we are interested **/


local vars_gross derivedsalarynet derivedsalarynetfair
foreach var_gross of local vars_gross {

gen gross_`var_gross'=.

/**I create an variable "detect" to detect the bracket that the respondant's salary is located **/
gen detect_`var_gross'=0 
/*detect which bracket that respondant's salary located*/
forvalues i=11(-1)1 {
*display "`i'"
if `i'>=10 {
replace detect_`var_gross'=detect_`var_gross'+1 if `var_gross'>net_th_`i'
}
else {
replace detect_`var_gross'=detect_`var_gross'+1 if `var_gross'>net_th_0`i'
}
}

**Salary Located in Tax band 1
replace gross_`var_gross'=`var_gross' if detect_`var_gross' ==0
replace gross_`var_gross'=`var_gross'+(`var_gross'-net_th_01)*net_dif_mr_01 if detect_`var_gross' ==1
**Salary located in Tax band 2
forvalues i=1(1)2 {
local net_temp  " `net_temp'  +(`var_gross'-net_th_0`i')*net_dif_mr_0`i' "
}
display "`net_temp'"
replace gross_`var_gross'=`var_gross' `net_temp' if detect_`var_gross'==2
**Salary located in Tax band 3-9
forvalues ii=3(1)9 {
local net_temp 
forvalues i=1(1)`ii' {
local net_temp  " `net_temp'  +(`var_gross'-net_th_0`i')*net_dif_mr_0`i' "
}
replace gross_`var_gross'=`var_gross' `net_temp' if detect_`var_gross'==`ii'
}
display "`net_temp'"

**Salary located in Tax band 10
local net_temp
forvalues i=1(1)9 {
local net_temp  " `net_temp'  +(`var_gross'-net_th_0`i')*net_dif_mr_0`i' "
}
forvalues ii=10 (1)10 {
local net_temp  " `net_temp'  +(`var_gross'-net_th_`ii')*net_dif_mr_`ii' "
}
display "`net_temp'"
replace gross_`var_gross'=`var_gross' `net_temp' if detect_`var_gross'==10
**Salary located in  Tax band 11
local net_temp
forvalues i=1(1)9 {
local net_temp  " `net_temp'  +(`var_gross'-net_th_0`i')*net_dif_mr_0`i' "
}
forvalues ii=10(1)11 {
local net_temp  " `net_temp'  +(`var_gross'-net_th_`ii')*net_dif_mr_`ii' "
}
replace gross_`var_gross'=`var_gross' `net_temp' if detect_`var_gross'==11


/**Now, consider the tax credit. I create the variable of  payable tax (Gross-Net salary), and compare the payable tax with tax credit.
Gross = Net + Payable tax -tax_credit (if payable tax > tax credit)
Gross = Net + Payable tax (If payable tax < tax credit) 
gross_s_tc is the gross salary that adjusted from net salary (_tc means that this variable is adjusted with tax credit as well)
**/
gen tax_`var_gross'=gross_`var_gross'-`var_gross'
replace tax_credit=0 if tax_credit==.
gen dif_tc_`var_gross'=tax_`var_gross'-tax_credit

replace dif_tc_`var_gross'=max(dif_tc_`var_gross', 0)
gen gross_`var_gross'_tc=`var_gross'+dif_tc_`var_gross' 
/*considering the tax credit*/


}



replace derivedsalarygross= gross_derivedsalarynet_tc if derivedsalarygross==. & gross_derivedsalarynet_tc!=. 


replace derivedsalarygrossfair= gross_derivedsalarynetfair_tc if derivedsalarygrossfair==. & gross_derivedsalarynetfair_tc!=.

*************************************************************************************************
******Code above is to generate the gross variable in terms of net variables***********************************
***************************************************************************************************
/*Consider and adjust the starting and fair salary with the bonus payment*/
replace derivedsalarygross = derivedsalarygross* 13/12 if bonus ==1
replace derivedsalarygross = derivedsalarygross* 14/12 if bonus ==2


replace derivedsalarygrossfair = derivedsalarygrossfair* 13/12 if bonus ==1
replace derivedsalarygrossfair = derivedsalarygrossfair* 14/12 if bonus ==2


/**Derive PPP starting gross salary (including the converted sample from net salary) **/
**Starting Salary (Perceived)
gen derivedpppstartgross=.

replace derivedpppstartgross=derivedsalarygross / 11.341 if market==1
replace derivedpppstartgross=derivedsalarygross / 2.052 if market==2
replace derivedpppstartgross=derivedsalarygross / 1.208 if market==3
replace derivedpppstartgross=derivedsalarygross / 385.357 if market==4
replace derivedpppstartgross=derivedsalarygross / 3.509 if market==5
replace derivedpppstartgross=derivedsalarygross / 1292.842 if market==6
replace derivedpppstartgross=derivedsalarygross / 13.405 if market==7
replace derivedpppstartgross=derivedsalarygross / 2.896 if market==8
replace derivedpppstartgross=derivedsalarygross / 0.92 if market==9
replace derivedpppstartgross=derivedsalarygross / 0.808 if market==10
replace derivedpppstartgross=derivedsalarygross / 0.78 if market==11
replace derivedpppstartgross=derivedsalarygross / 1.554 if market==12
replace derivedpppstartgross=derivedsalarygross / 0.605 if market==13
replace derivedpppstartgross=derivedsalarygross / 130.189 if market==14
replace derivedpppstartgross=derivedsalarygross / 17.697 if market==15
replace derivedpppstartgross=derivedsalarygross / 4164.36 if market==16
replace derivedpppstartgross=derivedsalarygross / 4 if market==17
replace derivedpppstartgross=derivedsalarygross / 0.738 if market==18
replace derivedpppstartgross=derivedsalarygross / 100.675 if market==19
replace derivedpppstartgross=derivedsalarygross / 858.084 if market==20
replace derivedpppstartgross=derivedsalarygross / 1.449 if market==21
replace derivedpppstartgross=derivedsalarygross / 0.799 if market==22
replace derivedpppstartgross=derivedsalarygross / 1.497 if market==23
replace derivedpppstartgross=derivedsalarygross / 0.594 if market==24
replace derivedpppstartgross=derivedsalarygross / 1.667 if market==25
replace derivedpppstartgross=derivedsalarygross / 0.622 if market==26
replace derivedpppstartgross=derivedsalarygross / 25.327 if market==27
replace derivedpppstartgross=derivedsalarygross / 0.827 if market==28
replace derivedpppstartgross=derivedsalarygross / 0.655 if market==29
replace derivedpppstartgross=derivedsalarygross / 1.291 if market==30
replace derivedpppstartgross=derivedsalarygross / 14.885 if market==31
replace derivedpppstartgross=derivedsalarygross / 1.421 if market==32
replace derivedpppstartgross=derivedsalarygross / 1078.125 if market==33
replace derivedpppstartgross=derivedsalarygross / 0.696 if market==34
replace derivedpppstartgross=derivedsalarygross / 1 if market==35

**Teacher's fair salary
gen derivedpppfairgross=.
replace derivedpppfairgross=derivedsalarygrossfair / 11.341 if market==1
replace derivedpppfairgross=derivedsalarygrossfair / 2.052 if market==2
replace derivedpppfairgross=derivedsalarygrossfair / 1.208 if market==3
replace derivedpppfairgross=derivedsalarygrossfair / 385.357 if market==4
replace derivedpppfairgross=derivedsalarygrossfair / 3.509 if market==5
replace derivedpppfairgross=derivedsalarygrossfair / 1292.842 if market==6
replace derivedpppfairgross=derivedsalarygrossfair / 13.405 if market==7
replace derivedpppfairgross=derivedsalarygrossfair / 2.896 if market==8
replace derivedpppfairgross=derivedsalarygrossfair / 0.92 if market==9
replace derivedpppfairgross=derivedsalarygrossfair / 0.808 if market==10
replace derivedpppfairgross=derivedsalarygrossfair / 0.78 if market==11
replace derivedpppfairgross=derivedsalarygrossfair / 1.554 if market==12
replace derivedpppfairgross=derivedsalarygrossfair / 0.605 if market==13
replace derivedpppfairgross=derivedsalarygrossfair / 130.189 if market==14
replace derivedpppfairgross=derivedsalarygrossfair / 17.697 if market==15
replace derivedpppfairgross=derivedsalarygrossfair / 4164.36 if market==16
replace derivedpppfairgross=derivedsalarygrossfair / 4 if market==17
replace derivedpppfairgross=derivedsalarygrossfair / 0.738 if market==18
replace derivedpppfairgross=derivedsalarygrossfair / 100.675 if market==19
replace derivedpppfairgross=derivedsalarygrossfair / 858.084 if market==20
replace derivedpppfairgross=derivedsalarygrossfair / 1.449 if market==21
replace derivedpppfairgross=derivedsalarygrossfair / 0.799 if market==22
replace derivedpppfairgross=derivedsalarygrossfair / 1.497 if market==23
replace derivedpppfairgross=derivedsalarygrossfair / 0.594 if market==24
replace derivedpppfairgross=derivedsalarygrossfair / 1.667 if market==25
replace derivedpppfairgross=derivedsalarygrossfair / 0.622 if market==26
replace derivedpppfairgross=derivedsalarygrossfair / 25.327 if market==27
replace derivedpppfairgross=derivedsalarygrossfair / 0.827 if market==28
replace derivedpppfairgross=derivedsalarygrossfair / 0.655 if market==29
replace derivedpppfairgross=derivedsalarygrossfair / 1.291 if market==30
replace derivedpppfairgross=derivedsalarygrossfair / 14.885 if market==31
replace derivedpppfairgross=derivedsalarygrossfair / 1.421 if market==32
replace derivedpppfairgross=derivedsalarygrossfair / 1078.125 if market==33
replace derivedpppfairgross=derivedsalarygrossfair / 0.696 if market==34
replace derivedpppfairgross=derivedsalarygrossfair / 1 if market==35



/**Input the minimum wage for each country in terms of the document provided
There are a few countries that have no regulation of minimum wages.**/
gen pppminwage=.


replace pppminwage =13254 if market_str =="Argentina"
replace pppminwage =5562 if market_str =="Brazil"
replace pppminwage =16762 if market_str =="Canada"
replace pppminwage =7278 if market_str =="Chile"
replace pppminwage =3117 if market_str =="China"
replace pppminwage =6835 if market_str =="Colombia"
replace pppminwage =10662 if market_str =="Czech Republic"
replace pppminwage =0.01 if market_str =="Egypt"
replace pppminwage =0.01 if market_str =="Finland"
replace pppminwage =20669 if market_str =="France"
replace pppminwage =22430 if market_str =="Germany"
replace pppminwage =1760 if market_str =="Ghana"
replace pppminwage =12066 if market_str =="Greece"
replace pppminwage =11085 if market_str =="Hungary"
replace pppminwage =2498 if market_str =="India"
replace pppminwage =3500 if market_str =="Indonesia"
replace pppminwage =14389 if market_str =="Israel"
replace pppminwage =0.01 if market_str =="Italy"
replace pppminwage =14307 if market_str =="Japan"
replace pppminwage =15604 if market_str =="Korea"
replace pppminwage =5789 if market_str =="Malaysia"
replace pppminwage =21276 if market_str =="Netherlands"
replace pppminwage =21941 if market_str =="New Zealand"
replace pppminwage =6473 if market_str =="Panama"
replace pppminwage =5862 if market_str =="Peru"
replace pppminwage =10235 if market_str =="Portugal"
replace pppminwage =2992 if market_str =="Russia"
replace pppminwage =0.01 if market_str =="Singapore"
replace pppminwage =13922 if market_str =="Spain"
replace pppminwage =24598 if market_str =="Switzerland"
replace pppminwage =18272 if market_str =="Taiwan"
replace pppminwage =15221 if market_str =="Turkey"
replace pppminwage =60 if market_str =="Uganda"
replace pppminwage =21268 if market_str =="UK"
replace pppminwage =15080 if market_str =="United States"


/** Set up the upper bound that identify the unreasonable values.
I use the seccap which is the upper bound we originally set (three times the actual teacher's payment ) as the maximum.
The following code is to create the variable of upper bound. 
**/
decode seccap, gen(maxsec)
destring maxsec, replace
gen pppmaxsec=.
replace pppmaxsec=maxsec / 11.341 if market==1
replace pppmaxsec=maxsec / 2.052 if market==2
replace pppmaxsec=maxsec / 1.208 if market==3
replace pppmaxsec=maxsec / 385.357 if market==4
replace pppmaxsec=maxsec / 3.509 if market==5
replace pppmaxsec=maxsec / 1292.842 if market==6
replace pppmaxsec=maxsec / 13.405 if market==7
replace pppmaxsec=maxsec / 2.896 if market==8
replace pppmaxsec=maxsec / 0.92 if market==9
replace pppmaxsec=maxsec / 0.808 if market==10
replace pppmaxsec=maxsec / 0.78 if market==11
replace pppmaxsec=maxsec / 1.554 if market==12
replace pppmaxsec=maxsec / 0.605 if market==13
replace pppmaxsec=maxsec / 130.189 if market==14
replace pppmaxsec=maxsec / 17.697 if market==15
replace pppmaxsec=maxsec / 4164.36 if market==16
replace pppmaxsec=maxsec / 4 if market==17
replace pppmaxsec=maxsec / 0.738 if market==18
replace pppmaxsec=maxsec / 100.675 if market==19
replace pppmaxsec=maxsec / 858.084 if market==20
replace pppmaxsec=maxsec / 1.449 if market==21
replace pppmaxsec=maxsec / 0.799 if market==22
replace pppmaxsec=maxsec / 1.497 if market==23
replace pppmaxsec=maxsec / 0.594 if market==24
replace pppmaxsec=maxsec / 1.667 if market==25
replace pppmaxsec=maxsec / 0.622 if market==26
replace pppmaxsec=maxsec / 25.327 if market==27
replace pppmaxsec=maxsec / 0.827 if market==28
replace pppmaxsec=maxsec / 0.655 if market==29
replace pppmaxsec=maxsec / 1.291 if market==30
replace pppmaxsec=maxsec / 14.885 if market==31
replace pppmaxsec=maxsec / 1.421 if market==32
replace pppmaxsec=maxsec / 1078.125 if market==33
replace pppmaxsec=maxsec / 0.696 if market==34
replace pppmaxsec=maxsec / 1 if market==35


display pppminwage 
display pppmaxsec 
sum derivedpppstartgross



/** Now , try to detect the observations that are outside of the tolerance range (between country's minimum wage and maximum value)  **/
*************Start Salary*********************************
gen ident_start= . 
/*Dummy to indicate the outlier, missing value means observation is higher than minimum wage, 0 is adjusted observation, 1 is lower than minimum, 2 is higher than maximum*/
gen outlier_start=. 
/**The value of outlier**/
gen adju_start=. 
/*corrected value */

/*Set up an adjustment factor (a proportion of country's minimum wage). By changing the value of  this factor, we can adjust the tolerance range */
local mfactor =1

replace ident_start = 2 if derivedsalarygross > maxsec

replace ident_start=1 if  derivedpppstartgross<(pppminwage)*`mfactor'
count if ident_start==1
tab market ident_start

scalar o_start = r(N)
local o_s = o_start


replace outlier_start= derivedpppstartgross if ident_start ==1

replace adju_start= derivedpppstartgross * 1960 if derivedpppstartgross<(pppminwage)*`mfactor' & S10==1
replace adju_start= derivedpppstartgross * 240 if derivedpppstartgross<(pppminwage)*`mfactor' & S10==2
replace adju_start= derivedpppstartgross * 48 if derivedpppstartgross<(pppminwage)*`mfactor' & S10==3
replace adju_start= derivedpppstartgross * 12 if derivedpppstartgross<(pppminwage)*`mfactor' & S10==4

/*Remove those adjusted observation from the list of unreasonable observation*/
replace ident_start =0 if adju_start<pppmaxsec & adju_start > (pppminwage)*`mfactor'
count if ident_start==1

scalar c_start = o_start - r(N)


/**Replace the unreasonable values with adjusted values**/
gen derivedpppstartgross_adj= derivedpppstartgross
replace derivedpppstartgross_adj= adju_start if ident_start ==0 & adju_start !=. 
replace derivedpppstartgross_adj= . if ident_start==1 | ident_start==2


label define ident_start 0 "Rescued" 1 "Unresonable" 2 "Higher than upper bound"
label values ident_start ident_start 
label variable ident_start ident_start


tab market ident_start

*************Fair Salary*********************************
gen ident_fair= . 
/*Dummy to indicate the outlier*/
gen outlier_fair=. 
/**The value of outlier**/
gen adju_fair=. 
/*corrected value */

/*Set up an adjustment factor (a proportion of country's minimum wage). By changing the value of  this factor, we can adjust the tolerance range */
replace ident_fair = 2 if derivedpppfairgross > maxsec
replace ident_fair=1 if  derivedpppfairgross<(pppminwage)*`mfactor'
count if ident_fair==1
scalar o_fair = r(N)
*tab market ident_fair

replace outlier_fair= derivedpppfairgross if ident_fair ==1

replace adju_fair= derivedpppfairgross * 1960 if derivedpppfairgross<(pppminwage)*`mfactor' & S10==1
replace adju_fair= derivedpppfairgross * 240 if derivedpppfairgross<(pppminwage)*`mfactor' & S10==2
replace adju_fair= derivedpppfairgross * 48 if derivedpppfairgross<(pppminwage)*`mfactor' & S10==3
replace adju_fair= derivedpppfairgross * 12 if derivedpppfairgross<(pppminwage)*`mfactor' & S10==4

/*Remove those adjusted observation from the list of unreasonable observation*/
replace ident_fair =0 if adju_fair<pppmaxsec & adju_fair > (pppminwage)*`mfactor'
count if ident_fair==1
scalar c_fair = o_fair - r(N)
/**Replace the unreasonable values with adjusted values**/

gen derivedpppfairgross_adj= derivedpppfairgross
replace derivedpppfairgross_adj= adju_fair if ident_fair ==0 & adju_fair !=. 
replace derivedpppfairgross_adj= . if ident_fair==1 | ident_fair==2



*tab market ident_fair

display "Outlier_start:  " o_start "  Corrected_start: " c_start
display "Outlier_fair:  " o_fair "  Corrected_fair: " c_fair

*************Personal Income *********************************
gen ident_inc= . 
/*Dummy to indicate the outlier, missing value means observation is higher than minimum wage, 0 is adjusted observation, 1 is lower than minimum, 2 is higher than maximum*/
gen outlier_inc=. 
/**The value of outlier**/
gen adju_inc=. 
/*corrected value */

/*Set up an adjustment factor (a proportion of country's minimum wage). By changing the value of  this factor, we can adjust the tolerance range */
local mfactor =1

replace ident_inc = 2 if derivedsalarygross > maxsec

replace ident_inc=1 if  derivedpppincgross<(pppminwage)*`mfactor'
count if ident_inc==1
tab market ident_inc

scalar o_inc = r(N)
local o_s = o_inc


replace outlier_inc= derivedpppincgross if ident_inc ==1

replace adju_inc= derivedpppincgross * 1960 if derivedpppincgross<(pppminwage)*`mfactor' & S10==1
replace adju_inc= derivedpppincgross * 240 if derivedpppincgross<(pppminwage)*`mfactor' & S10==2
replace adju_inc= derivedpppincgross * 48 if derivedpppincgross<(pppminwage)*`mfactor' & S10==3
replace adju_inc= derivedpppincgross * 12 if derivedpppincgross<(pppminwage)*`mfactor' & S10==4

/*Remove those adjusted observation from the list of unreasonable observation*/
replace ident_inc =0 if adju_inc<pppmaxsec & adju_inc > (pppminwage)*`mfactor'
count if ident_inc==1

scalar c_inc = o_inc - r(N)


/**Replace the unreasonable values with adjusted values**/
gen derivedpppincgross_adj= derivedpppincgross
replace derivedpppincgross_adj= adju_inc if ident_inc ==0 & adju_inc !=. 
replace derivedpppincgross_adj= . if ident_inc==1 | ident_inc==2


label define ident_inc 0 "Rescued" 1 "Unresonable" 2 "Higher than upper bound"
label values ident_inc ident_inc 
label variable ident_inc ident_inc


tab market ident_inc

*******************************************************
  
gen pppactualgross =.
replace pppactualgross=10370.51 if market ==1
replace pppactualgross=12993.03 if market ==2
replace pppactualgross=43714.85 if market ==3
replace pppactualgross=20890.06 if market ==4
replace pppactualgross=12209.51 if market ==5
replace pppactualgross=18805.73 if market ==6
replace pppactualgross=18859.09 if market ==7
replace pppactualgross=6592.47 if market ==8
replace pppactualgross=40491.1 if market ==9
replace pppactualgross=33675.49 if market ==10
replace pppactualgross=65396.25 if market ==11
replace pppactualgross=7249.04 if market ==12
replace pppactualgross=21480.69 if market ==13
replace pppactualgross=16240.75 if market ==14
replace pppactualgross=21607.63 if market ==15
replace pppactualgross=14407.98 if market ==16
replace pppactualgross=22175.36 if market ==17
replace pppactualgross=33629.78 if market ==18
replace pppactualgross=31460.65 if market ==19
replace pppactualgross=33141.46 if market ==20
replace pppactualgross=18120.08 if market ==21
replace pppactualgross=43742.59 if market ==22
replace pppactualgross=33098.75 if market ==23
replace pppactualgross=16000 if market ==24
replace pppactualgross=12478.13 if market ==25
replace pppactualgross=35519.24 if market ==26
replace pppactualgross=5922.53 if market ==27
replace pppactualgross=50249.38 if market ==28
replace pppactualgross=47864.09 if market ==29
replace pppactualgross=77490.6 if market ==30
replace pppactualgross=40821.16 if market ==31
replace pppactualgross=30302.8 if market ==32
replace pppactualgross=4204.87 if market ==33
replace pppactualgross=31845.26 if market ==34
replace pppactualgross=44228.73 if market ==35


gen pppactualgross_adj= pppactualgross
replace pppactualgross_adj = pppactualgross* 13/12 if bonus ==1
replace pppactualgross_adj = pppactualgross* 14/12 if bonus ==2
************************************************************************
*****************************************************************************************************************
****For Primary School Teachers
gen pppactualgross_p =.
replace pppactualgross_p=10370.51 if market ==1
replace pppactualgross_p=12993.03 if market ==2
replace pppactualgross_p=43714.85 if market ==3
replace pppactualgross_p=20386.59 if market ==4
replace pppactualgross_p=10465.3 if market ==5
replace pppactualgross_p=18805.73 if market ==6
replace pppactualgross_p=18859.09 if market ==7
replace pppactualgross_p=6592.47 if market ==8
replace pppactualgross_p=35355.79 if market ==9
replace pppactualgross_p=30495.16 if market ==10
replace pppactualgross_p=57790.68 if market ==11
replace pppactualgross_p=7249.04 if market ==12
replace pppactualgross_p=21480.69 if market ==13
replace pppactualgross_p=14822.39 if market ==14
replace pppactualgross_p=15924.48 if market ==15
replace pppactualgross_p=14407.98 if market ==16
replace pppactualgross_p=21367 if market ==17
replace pppactualgross_p=31195.5 if market ==18
replace pppactualgross_p=31460.65 if market ==19
replace pppactualgross_p=33918.08 if market ==20
replace pppactualgross_p=18120.08 if market ==21
replace pppactualgross_p=40882.5 if market ==22
replace pppactualgross_p=30973.08 if market ==23
replace pppactualgross_p=12000 if market ==24
replace pppactualgross_p=12478.13 if market ==25
replace pppactualgross_p=35519.24 if market ==26
replace pppactualgross_p=5922.53 if market ==27
replace pppactualgross_p=50249.38 if market ==28
replace pppactualgross_p=42858.74 if market ==29
replace pppactualgross_p=60967.73 if market ==30
replace pppactualgross_p=40821.16 if market ==31
replace pppactualgross_p=30302.8 if market ==32
replace pppactualgross_p=4204.87 if market ==33
replace pppactualgross_p=31845.26 if market ==34
replace pppactualgross_p=43100.3 if market ==35



gen pppactualgross_p_adj= pppactualgross_p
replace pppactualgross_p_adj = pppactualgross_p* 13/12 if bonus ==1
replace pppactualgross_p_adj = pppactualgross_p* 14/12 if bonus ==2

*******************************************************

  * Define teacher dummy
gen teacher=0
replace teacher=1 if S9A==1


/**What wages would induce in the general public to become teachers.**/

gen derivedpppmin =.

replace derivedpppmin=Q10A / 11.341 if market==1
replace derivedpppmin=Q10A / 2.052 if market==2
replace derivedpppmin=Q10A / 1.208 if market==3
replace derivedpppmin=Q10A / 385.357 if market==4
replace derivedpppmin=Q10A / 3.509 if market==5
replace derivedpppmin=Q10A / 1292.842 if market==6
replace derivedpppmin=Q10A / 13.405 if market==7
replace derivedpppmin=Q10A / 2.896 if market==8
replace derivedpppmin=Q10A / 0.92 if market==9
replace derivedpppmin=Q10A / 0.808 if market==10
replace derivedpppmin=Q10A / 0.78 if market==11
replace derivedpppmin=Q10A / 1.554 if market==12
replace derivedpppmin=Q10A / 0.605 if market==13
replace derivedpppmin=Q10A / 130.189 if market==14
replace derivedpppmin=Q10A / 17.697 if market==15
replace derivedpppmin=Q10A / 4164.36 if market==16
replace derivedpppmin=Q10A / 4 if market==17
replace derivedpppmin=Q10A / 0.738 if market==18
replace derivedpppmin=Q10A / 100.675 if market==19
replace derivedpppmin=Q10A / 858.084 if market==20
replace derivedpppmin=Q10A / 1.449 if market==21
replace derivedpppmin=Q10A / 0.799 if market==22
replace derivedpppmin=Q10A / 1.497 if market==23
replace derivedpppmin=Q10A / 0.594 if market==24
replace derivedpppmin=Q10A / 1.667 if market==25
replace derivedpppmin=Q10A / 0.622 if market==26
replace derivedpppmin=Q10A / 25.327 if market==27
replace derivedpppmin=Q10A / 0.827 if market==28
replace derivedpppmin=Q10A / 0.655 if market==29
replace derivedpppmin=Q10A / 1.291 if market==30
replace derivedpppmin=Q10A / 14.885 if market==31
replace derivedpppmin=Q10A / 1.421 if market==32
replace derivedpppmin=Q10A / 1078.125 if market==33
replace derivedpppmin=Q10A / 0.696 if market==34
replace derivedpppmin=Q10A / 1 if market==35


bysort market : sum derivedpppmin
replace derivedpppmin =. if derivedpppmin> 500000
replace derivedpppmin =. if derivedpppmin ==0




************************************************************
/**Create ppp minimum wages for teachers to leave teaching**/

gen derivedpppmin_ter=.

replace derivedpppmin_ter=Q10B / 11.341 if market==1
replace derivedpppmin_ter=Q10B / 2.052 if market==2
replace derivedpppmin_ter=Q10B / 1.208 if market==3
replace derivedpppmin_ter=Q10B / 385.357 if market==4
replace derivedpppmin_ter=Q10B / 3.509 if market==5
replace derivedpppmin_ter=Q10B / 1292.842 if market==6
replace derivedpppmin_ter=Q10B / 13.405 if market==7
replace derivedpppmin_ter=Q10B / 2.896 if market==8
replace derivedpppmin_ter=Q10B / 0.92 if market==9
replace derivedpppmin_ter=Q10B / 0.808 if market==10
replace derivedpppmin_ter=Q10B / 0.78 if market==11
replace derivedpppmin_ter=Q10B / 1.554 if market==12
replace derivedpppmin_ter=Q10B / 0.605 if market==13
replace derivedpppmin_ter=Q10B / 130.189 if market==14
replace derivedpppmin_ter=Q10B / 17.697 if market==15
replace derivedpppmin_ter=Q10B / 4164.36 if market==16
replace derivedpppmin_ter=Q10B / 4 if market==17
replace derivedpppmin_ter=Q10B / 0.738 if market==18
replace derivedpppmin_ter=Q10B / 100.675 if market==19
replace derivedpppmin_ter=Q10B / 858.084 if market==20
replace derivedpppmin_ter=Q10B / 1.449 if market==21
replace derivedpppmin_ter=Q10B / 0.799 if market==22
replace derivedpppmin_ter=Q10B / 1.497 if market==23
replace derivedpppmin_ter=Q10B / 0.594 if market==24
replace derivedpppmin_ter=Q10B / 1.667 if market==25
replace derivedpppmin_ter=Q10B / 0.622 if market==26
replace derivedpppmin_ter=Q10B / 25.327 if market==27
replace derivedpppmin_ter=Q10B / 0.827 if market==28
replace derivedpppmin_ter=Q10B / 0.655 if market==29
replace derivedpppmin_ter=Q10B / 1.291 if market==30
replace derivedpppmin_ter=Q10B / 14.885 if market==31
replace derivedpppmin_ter=Q10B / 1.421 if market==32
replace derivedpppmin_ter=Q10B / 1078.125 if market==33
replace derivedpppmin_ter=Q10B / 0.696 if market==34
replace derivedpppmin_ter=Q10B / 1 if market==35


bysort market : sum derivedpppmin_ter
replace derivedpppmin_ter =. if derivedpppmin_ter> 500000
replace derivedpppmin_ter =. if derivedpppmin_ter ==0

*****************************************************


***Educational Spending that people thought

decode secspendcap, gen(maxsecspend)
destring maxsecspend, replace

decode primspendcap, gen(maxprimspend)
destring maxprimspend, replace


gen Q21=.
replace Q21= (Q21a1_1_Q21a*maxprimspend)/100 if Q21a1_1_Q21a !=.
replace Q21= (Q21b1_1_Q21b*maxprimspend)/100 if Q21b1_1_Q21b !=. 

gen Q22=.
replace Q22= (Q22a1_1_Q22a*maxsecspend)/100 if Q22a1_1_Q22a !=.
replace Q22= (Q22b1_1_Q22b*maxsecspend)/100 if Q22b1_1_Q22b !=. 



gen derivedpppspen_p =.
replace derivedpppspen_p=Q21 / 11.341 if market==1
replace derivedpppspen_p=Q21 / 2.052 if market==2
replace derivedpppspen_p=Q21 / 1.208 if market==3
replace derivedpppspen_p=Q21 / 385.357 if market==4
replace derivedpppspen_p=Q21 / 3.509 if market==5
replace derivedpppspen_p=Q21 / 1292.842 if market==6
replace derivedpppspen_p=Q21 / 13.405 if market==7
replace derivedpppspen_p=Q21 / 2.896 if market==8
replace derivedpppspen_p=Q21 / 0.92 if market==9
replace derivedpppspen_p=Q21 / 0.808 if market==10
replace derivedpppspen_p=Q21 / 0.78 if market==11
replace derivedpppspen_p=Q21 / 1.554 if market==12
replace derivedpppspen_p=Q21 / 0.605 if market==13
replace derivedpppspen_p=Q21 / 130.189 if market==14
replace derivedpppspen_p=Q21 / 17.697 if market==15
replace derivedpppspen_p=Q21 / 4164.36 if market==16
replace derivedpppspen_p=Q21 / 4 if market==17
replace derivedpppspen_p=Q21 / 0.738 if market==18
replace derivedpppspen_p=Q21 / 100.675 if market==19
replace derivedpppspen_p=Q21 / 858.084 if market==20
replace derivedpppspen_p=Q21 / 1.449 if market==21
replace derivedpppspen_p=Q21 / 0.799 if market==22
replace derivedpppspen_p=Q21 / 1.497 if market==23
replace derivedpppspen_p=Q21 / 0.594 if market==24
replace derivedpppspen_p=Q21 / 1.667 if market==25
replace derivedpppspen_p=Q21 / 0.622 if market==26
replace derivedpppspen_p=Q21 / 25.327 if market==27
replace derivedpppspen_p=Q21 / 0.827 if market==28
replace derivedpppspen_p=Q21 / 0.655 if market==29
replace derivedpppspen_p=Q21 / 1.291 if market==30
replace derivedpppspen_p=Q21 / 14.885 if market==31
replace derivedpppspen_p=Q21 / 1.421 if market==32
replace derivedpppspen_p=Q21 / 1078.125 if market==33
replace derivedpppspen_p=Q21 / 0.696 if market==34
replace derivedpppspen_p=Q21 / 1 if market==35


gen derivedpppspen_s =.

replace derivedpppspen_s=Q22 / 11.341 if market==1
replace derivedpppspen_s=Q22 / 2.052 if market==2
replace derivedpppspen_s=Q22 / 1.208 if market==3
replace derivedpppspen_s=Q22 / 385.357 if market==4
replace derivedpppspen_s=Q22 / 3.509 if market==5
replace derivedpppspen_s=Q22 / 1292.842 if market==6
replace derivedpppspen_s=Q22 / 13.405 if market==7
replace derivedpppspen_s=Q22 / 2.896 if market==8
replace derivedpppspen_s=Q22 / 0.92 if market==9
replace derivedpppspen_s=Q22 / 0.808 if market==10
replace derivedpppspen_s=Q22 / 0.78 if market==11
replace derivedpppspen_s=Q22 / 1.554 if market==12
replace derivedpppspen_s=Q22 / 0.605 if market==13
replace derivedpppspen_s=Q22 / 130.189 if market==14
replace derivedpppspen_s=Q22 / 17.697 if market==15
replace derivedpppspen_s=Q22 / 4164.36 if market==16
replace derivedpppspen_s=Q22 / 4 if market==17
replace derivedpppspen_s=Q22 / 0.738 if market==18
replace derivedpppspen_s=Q22 / 100.675 if market==19
replace derivedpppspen_s=Q22 / 858.084 if market==20
replace derivedpppspen_s=Q22 / 1.449 if market==21
replace derivedpppspen_s=Q22 / 0.799 if market==22
replace derivedpppspen_s=Q22 / 1.497 if market==23
replace derivedpppspen_s=Q22 / 0.594 if market==24
replace derivedpppspen_s=Q22 / 1.667 if market==25
replace derivedpppspen_s=Q22 / 0.622 if market==26
replace derivedpppspen_s=Q22 / 25.327 if market==27
replace derivedpppspen_s=Q22 / 0.827 if market==28
replace derivedpppspen_s=Q22 / 0.655 if market==29
replace derivedpppspen_s=Q22 / 1.291 if market==30
replace derivedpppspen_s=Q22 / 14.885 if market==31
replace derivedpppspen_s=Q22 / 1.421 if market==32
replace derivedpppspen_s=Q22 / 1078.125 if market==33
replace derivedpppspen_s=Q22 / 0.696 if market==34
replace derivedpppspen_s=Q22 / 1 if market==35



******************************************************

/// WARNING!!! --- Remove '///' first before proceeding! ///

preserve

  collapse  (mean) derivedpppstartgross_adj derivedpppfairgross_adj derivedpppspen_p derivedpppspen_s,  by(market)
merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace

restore


preserve
  collapse  (mean) derivedpppstartgross_adj_ter=derivedpppstartgross_adj derivedpppfairgross_adj_ter=derivedpppfairgross_adj Q16_1_ter=Q16grid_1_Q16  Q16_2_ter=Q16grid_2_Q16 derivedpppmin_ter derivedpppincgross_adj_ter=derivedpppincgross_adj if teacher==1,  by(market)
merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace

restore


 
***************************************************************************************************

**CRT Score
gen CRT_score =0

replace CRT_score=CRT_score+1 if Q27==1
replace CRT_score=CRT_score+1 if Q28==2
replace CRT_score=CRT_score+1 if Q29==2


gen CRT_score_teacher=.
replace CRT_score_teacher = CRT_score if teacher ==1

* Define Left-Rright Wing
gen wing_score=.
recode Q24 (5=1) (4=2) (3=3) (2=4) (1=5), gen(Q24_r)
drop Q24

recode Q25 (5=1) (4=2) (3=3) (2=4) (1=5), gen(Q25_r)
drop Q25

recode Q26 (5=1) (4=2) (3=3) (2=4) (1=5), gen(Q26_r)
drop Q26

replace wing_score= Q24_r+Q25_r+Q26_r



*********************************PCA ****************
*****************************Robert's Code*********************************************

/*_____PCA: EXPLICIT MEASURES - OLD METHOD & OLD COUNTRIES_____*/
//reverse coding respect rank of primary school (PS) and secondary school (SS) teachers
gen rankrespPSinv=15-Q1grid_C_Q1
gen rankrespSSinv=15-Q1grid_D_Q1


//generating (by country) modal answer to most similar profession to teacher
bys market:egen modalprof=mode(Q3), maxmode


//generating status var = reverse coded rank of most similar profession
gen statusrank=.
replace statusrank=15-Q1grid_A_Q1 if modalprof==1
replace statusrank=15-Q1grid_B_Q1 if modalprof==2
replace statusrank=15-Q1grid_F_Q1 if modalprof==3
replace statusrank=15-Q1grid_G_Q1 if modalprof==4
replace statusrank=15-Q1grid_H_Q1 if modalprof==5
replace statusrank=15-Q1grid_I_Q1 if modalprof==6
replace statusrank=15-Q1grid_J_Q1 if modalprof==7
replace statusrank=15-Q1grid_K_Q1 if modalprof==8
replace statusrank=15-Q1grid_L_Q1 if modalprof==9
replace statusrank=15-Q1grid_M_Q1 if modalprof==10
replace statusrank=15-Q1grid_N_Q1 if modalprof==11
//setting status rank as 6.5 where modal profession is 'none of these' (Japan and Ghana)
replace statusrank=6.5 if modalprof==12 

//generating (by country) prop. of Rs who agree/strongly agree that pupils respect teachers in country
gen puprespect=0
replace puprespect=1 if inrange(Q17grid_D_Q17,1,2)

//Conducting PCA on country level data and merging 1st PC back into original data    [[pweight=Weight]
preserve

collapse rankrespPS rankrespSS statusrank puprespect , by(market)
 
gen oldGEM=0
replace oldGEM=1 if inlist(market,2,5,7,8,9,10,11,13,17,18,19,20,22,23,26,28,29,30,32,34,35)
keep if oldGEM==1

pca rankrespPS rankrespSS statusrank puprespect, comp(3)
predict c1

save temp, replace

restore

merge m:m market using temp, keepusing(c1 oldGEM) nogen
 
rename c1 omocPCA
label var omocPCA "PCA score (old method, old countries)"

/*_____PCA: EXPLICIT MEASURES - OLD METHOD & OLD COUNTRIES_____*/
//NOTE: need to run lines 9-33 first

//Conducting PCA on country level data and merging 1st PC back into original data
preserve

collapse rankrespPS rankrespSS statusrank puprespect, by(market)
 
pca rankrespPS rankrespSS statusrank puprespect, comp(3)
predict c1

save temp, replace

restore

merge m:m market using temp, keepusing(c1) nogen
rename c1 omncPCA
label var omncPCA "PCA score (old method, new countries)"
 
/*_____FACTOR ANALYSIS: IMPLICIT MEASURES______*/
//recoding implicit vars to 0/1 (1 is the positive - e.g. trusted, well paid etc.)
local k=1
while `k'<=10 {
gen Imp_Sel`k'_bin=0 if Imp_Sel`k'==2
replace Imp_Sel`k'_bin=1 if Imp_Sel`k'==1
local k=`k'+1
}

//computing the correlation matrix
tetrachoric Imp_Sel*_bin, posdef

//saving the N
global N=r(N)

//saving the matrix
matrix fa=r(Rho)

//running the factor analysis to identify the number of factors
factormat fa, ipf n($N) mineigen(1)

//running analysis restricted to two factors, with varimax rotation
factormat fa, ipf n($N) factors(2)
rotate, varimax normalize
 
//generating factor variables
predict f1 f2

rename f1 imp_quality
rename f2 imp_status

label var imp_quality "Implicit perception of teacher quality"
label var imp_status "Implicit perception of teacher status"

/*_____PCA: EXPLICIT MEASURES PLUS QUALITY SCORE______*/

//Conducting PCA on country level data and merging 1st PC back into original data
preserve

collapse rankrespPS rankrespSS statusrank puprespect imp_quality, by(market)

pca rankrespPS rankrespSS statusrank puprespect imp_quality, comp(2)
predict c1

save temp, replace

restore

***
preserve
*****

merge m:m market using temp, keepusing(c1) nogen
rename c1 pqualPCA
label var pqualPCA "PCA score (including implicit quality)"

/*_____Erasing temporary dataset____*/
erase temp.dta

/*________PRODUCING COUNTRY LEVEL OUTPUT________*/

//collapsing to country level data
collapse *PCA* imp*, by(market)

//generating country ranking vars
foreach var in omocPCA omncPCA imp_quality imp_status pqualPCA {
egen `var'_rank=rank(`var'), field
}

sort market


/*_____SCATTER PLOTS_____*/
//Explicit status (old countries) (x) vs. explicit status (new countries) (x)
scatter omncPCA omocPCA, m(none) mlabel(market) mlabp(0) ytitle("New countries") xtitle("Old countries")
corr omncPCA omocPCA

//Explicit status (new countries) (x) vs. implicit status (y)
scatter imp_status omncPCA, m(none) mlabel(market) mlabp(0) ytitle("Implicit status") xtitle("Explicit status")
corr imp_status omncPCA

//Explicit status (new countries) (x) vs. implicit quality (y)
scatter imp_quality omncPCA, m(none) mlabel(market) mlabp(0) ytitle("Implicit quality") xtitle("Explicit status")
corr imp_quality omncPCA

//Explicit status (new countries) (x) vs. explicit status plus quality (y)
scatter pqualPCA omncPCA, m(none) mlabel(market) mlabp(0) ytitle("Explicit status plus quality") xtitle("Explicit status")
corr pqualPCA omncPCA


save Robert_PCA.dta, replace
restore
**************************************************************************************



*****************Teacher's perception of Status***********************************************


/*_____PCA: EXPLICIT MEASURES - OLD METHOD & OLD COUNTRIES_____*/
//NOTE: need to run lines 9-33 first

//Conducting PCA on country level data and merging 1st PC back into original data
preserve

collapse rankrespPS rankrespSS statusrank puprespect if teacher == 1, by(market)

pca rankrespPS rankrespSS statusrank puprespect, comp(3)
predict c1

save temp_ter, replace

restore

merge m:m market using temp_ter, keepusing(c1) nogen
rename c1 omncPCA_ter
label var omncPCA_ter "PCA score (old method, new countries) Sample: Teacher"



//computing the correlation matrix
tetrachoric Imp_Sel*_bin if teacher ==1, posdef

//saving the N
global N=r(N)

//saving the matrix
matrix fa_ter=r(Rho)

//running the factor analysis to identify the number of factors
factormat fa_ter, ipf n($N) mineigen(1)

//running analysis restricted to two factors, with varimax rotation
factormat fa_ter, ipf n($N) factors(2)
rotate, varimax normalize
 
//generating factor variables
predict f1 f2

rename f1 imp_quality_ter
rename f2 imp_status_ter

label var imp_quality_ter "Implicit perception of teacher quality Sample:Teacher"
label var imp_status_ter "Implicit perception of teacher status Sample:Teacher"

/*_____PCA: EXPLICIT MEASURES PLUS QUALITY SCORE______*/


//Conducting PCA on country level data and merging 1st PC back into original data
preserve

collapse rankrespPS rankrespSS statusrank puprespect imp_quality if teacher ==1, by(market)

pca rankrespPS rankrespSS statusrank puprespect imp_quality, comp(2)
predict c1

save temp_ter, replace

restore

***
preserve
*****

merge m:m market using temp_ter, keepusing(c1) nogen
rename c1 pqualPCA_ter
label var pqualPCA_ter "PCA score (including implicit quality) Sample: Teacher"

/*_____Erasing temporary dataset____*/
erase temp_ter.dta

/*________PRODUCING COUNTRY LEVEL OUTPUT________*/  	/// WHat is country level output? ///

//collapsing to country level data
collapse *PCA* imp*, by(market)

//generating country ranking vars
foreach var in omncPCA_ter imp_quality_ter imp_status_ter pqualPCA_ter {
egen `var'_rank=rank(`var'), field
}

sort market

*br			/// What is br?? ///

/*_____SCATTER PLOTS_____*/

//Explicit status (new countries) (x) vs. implicit status (y)
scatter imp_status_ter omncPCA_ter, m(none) mlabel(market) mlabp(0) ytitle("Implicit status") xtitle("Explicit status")
corr imp_status_ter omncPCA_ter

//Explicit status (new countries) (x) vs. implicit quality (y)
scatter imp_quality_ter omncPCA_ter, m(none) mlabel(market) mlabp(0) ytitle("Implicit quality") xtitle("Explicit status")
corr imp_quality_ter omncPCA_ter

//Explicit status (new countries) (x) vs. explicit status plus quality (y)
scatter pqualPCA_ter omncPCA_ter, m(none) mlabel(market) mlabp(0) ytitle("Explicit status plus quality") xtitle("Explicit status")
corr pqualPCA_ter omncPCA_ter


save Robert_PCA_ter.dta, replace
restore
**************************************************************************************

**************TEACHER STATUS INDEX*************************************
**Figure 1

preserve 
collapse (mean) Q1grid_C_Q1_r Q1grid_D_Q1_r Q3 Q17grid_E_Q17 pppactualgross_adj pppactualgross pppactualgross_p_adj, by(market)


/*Assume  a score(baseline) that can convert to Teacher Status==1 ,
Formula:
(Min-baseline)/(Max-baseline) = 0.01, and find the value of baseline

local baseline=(0.01*`r(max)'-`r(min)')/(-0.99)
*/

merge 1:1 market using Robert_PCA
drop _merge
summ omncPCA
local baseline=(0.01*`r(max)'-`r(min)')/(-0.99)
gen tsagg_index=100*(omncPCA-`baseline')/(`r(max)'-`baseline')


merge 1:1 market using data_bycountry.dta
capture drop _merge

*****Export the information into a excel file***********************
sort tsagg_index
 export excel market_str tsagg_index pppactualgross pppactualgross_adj mean_score_rank using "Fig1.xls", firstrow(variables) replace


save data_bycountry.dta, replace



/**The Teacher Status Index (Sample: Teacher)**/
	  merge 1:1 market using Robert_PCA_ter
drop _merge
summ omncPCA_ter
local baseline_ter=(0.01*`r(max)'-`r(min)')/(-0.99)
gen tsagg_index_ter=100*(omncPCA_ter-`baseline_ter')/(`r(max)'-`baseline_ter')

merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace


**Create a variable to sort the countries in the figure
egen market_r_TSI=rank( tsagg_index ), unique
replace market_str="Egypt" if market== 8
replace market_str="Ghana" if market== 12 
replace market_str="India" if market== 15
replace market_str="Malaysia" if market== 21
replace market_str="Panama" if market== 24
replace market_str="Uganda" if market== 33

/// labmask only ever comes after egen, but egen can appear without labmask /// 
labmask market_r_TSI, values(market_str )
	  
merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace


restore

preserve
*****************Teacher's perception of status***************************
**********Sample: Teacher*********************************

/// WARNING --- Remove /// first! ///
 collapse (firstnm) market_abb market_str (mean) mean_rank_p_ter=Q1grid_C_Q1_r mean_rank_s_ter=Q1grid_D_Q1_r mean_rank_h_ter=Q1grid_E_Q1_r  if teacher==1 , by(market) 

**Create a variable to sort the countries in the figure		 
egen sort_r_head_ter=rank( mean_rank_h_ter ), unique
labmask sort_r_head_ter, values(market_str )

merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace


restore

*************Figure 8: Estimated teacher wages, perceived fair teacher wages and actual teacher wages*****************************
******Install the package of radar if it is not installed yet*************************
**ssc install radar

/// WARNING remove GREEN /// 

 preserve
  collapse (firstnm) market_abb market_str (mean) derivedpppstartgross derivedpppfairgross Q10A Q10B Q19z_1_Q19 Q20z_1_Q20  Q21a1_1_Q21a Q21b1_1_Q21b S12 S12T derivedpppmin MD_Score1 MD_Score2 MD_Score3 MD_Score4 MD_Score5 MD_Score6 MD_Score7 MD_Score8 MD_Score9 Q16grid_1_Q16  Q16grid_2_Q16 pppactualgross pppactualgross_adj CRT_score CRT_score_teacher wing_score,  by(market)
  
replace market_str="Egypt" if market== 8
replace market_str="Ghana" if market== 12 
replace market_str="India" if market== 15
replace market_str="Malaysia" if market== 21
replace market_str="Panama" if market== 24
replace market_str="Uganda" if market== 33
replace market_str="Czech" if market== 7

	 drop if market>35
  
merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace

restore

************** Implicit Response ********************************
********pre-set the label of figures

local IR11 "Trust"
local IR21 "Well_Paid"
local IR31 "Influential"
local IR41 "Inspiring"
local IR51 "Respected"
local IR61 "High_Status"
local IR71 "Hard_Working"
local IR81 "Caring"
local IR91 "High_flyer"
local IR101 "Intelligent"

local IR10 "Untrust"
local IR20 "Pooly_Paid"
local IR30 "Not_influential"
local IR40 "Uninspiring"
local IR50 "Not_Respected"
local IR60 "Low_Status"
local IR70 "Lazy"
local IR80 "Uncaring"
local IR90 "Mediocre"
local IR100 "Unintelligent"

capture graph drop IR*

forvalues i=1/10 {
preserve
contract market Imp_Sel`i'_bin 
drop if Imp_Sel`i'_bin ==.
********Create the proportion of the answer************** 
bys market (Imp_Sel`i'_bin) : gen sum_freq = sum(_freq)
bys market (Imp_Sel`i'_bin) : gen _percent = sum_freq/ sum_freq[_N]*100
bys market  : gen _percent2 = _freq/ sum_freq[_N]*100

gen IR`i'_percent20=.
gen IR`i'_percent21=.

bys market : replace IR`i'_percent20 = _percent2[1]  
bys market : replace IR`i'_percent21 = _percent2[2]  

label variable IR`i'_percent20 "Imp_Sel`i'_bin percentage value 0"
label variable IR`i'_percent21 "Imp_Sel`i'_bin percentage value 1"

drop Imp_Sel`i'_bin _percent _percent2 _freq sum_freq
bys market: keep if _n==1

  save tempp_`i'.dta, replace
  capture drop _merge
	 merge 1:1 market using data_bycountry.dta
capture drop _merge
save data_bycountry.dta, replace
    restore
	preserve
  collapse (mean) Imp_RT* [pweight=Weight] , by(market) 
  merge 1:1 market using tempp_`i'.dta 
  
gen base= 0
gen top = 100

capture drop _merge
	 merge 1:1 market using data_bycountry.dta
capture drop _merge

save data_bycountry.dta, replace
  restore


erase tempp_`i'.dta 

}

   
*********************For all countries/samples*************************************
  preserve
* use "C:\Users\supersnake0426\Desktop\Varkey\Varkey_Teachers.dta", clear

  collapse  (mean)  MD_Score1 MD_Score2 MD_Score3 MD_Score4 MD_Score5 MD_Score6 MD_Score7 MD_Score8 MD_Score9 

 label var MD_Score1 "Reducing Class size in Primary School" 
 label var MD_Score2 "Reducing Class size in Secondary School" 
label var MD_Score3  "Employing more teacher " 
label var MD_Score4  " Higher salaries for existing teacher" 
label var MD_Score5  "Better training and professional for teacher" 
label var MD_Score6  "Improving school buildings and computer" 
label var MD_Score7  "Employing more non-teaching staff" 
label var MD_Score8  "Do not spend it on education but something else" 
label var MD_Score9  "Do not spend any extra money and keep taxes same"  
  
  	  graph bar    MD_Score9  MD_Score7 MD_Score8 MD_Score2 MD_Score1 MD_Score4 MD_Score3 MD_Score6 MD_Score5 ,  ti("Figure :  MaxDiff analysis of educational expenditure (All Country)", size(small))  
bar( 1  , color(blue) ) /// 
bar( 2,  color(dkgreen) )  ///
bar( 3  , color(gold) ) /// 
bar( 4,  color(orange)  )  ///
bar( 5  , color(black) ) /// 
bar( 6,  color(pink)  )  ///
bar( 7,  color(purple) )  ///
bar( 8  , color(maroon) ) /// 
bar( 9,  color(red) )  ///
  ylabel( 0  (50) 270, labsize(vsmall) ) exclude0 ///ysc(r(-0.5 .))
legend(label(1 "`:variable label MD_Score9'") /// 
	  label(2 "`:variable label MD_Score7'") /// 
	  label(3 "`:variable label MD_Score8'") /// 
	  label(4 "`:variable label MD_Score2'") /// 
	  label(5 "`:variable label MD_Score1'") /// 
	  label(6 "`:variable label MD_Score4'") /// 
	  label(7 "`:variable label MD_Score3'") /// 
	  label(8 "`:variable label MD_Score6'") /// 
	  label(9 "`:variable label MD_Score5'") /// 
	  textwidth(*4.5) size(*.5) rowgap(*.5)  colgap(*5)   forcesize rows(7)  symysize(*.5) symxsize(*.5)  region(lcolor(white))   ) ///
 graphregion(color(white)) ///
  ytitle("MaxDiff Scores", size(small))     //
   gr export output/MaxDiff_all.png, replace width(1600) height(1200)
   restore
   
