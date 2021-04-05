*****************************
* Years of Schooling         ///// For merger  - FINAL VARKEY WITH THE SCHOOL AGE DATA
* Started October, 2018      /////
******************************
/// cd "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Main/From Dolton and Friend/RE__ROSLA_LOSSA/My edit"
**Use the Teacher Data
/// local filepath "C:/Users/supersnake0426/Desktop/Varkey"
local filepath "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Main/From Dolton and Friend/RE__ROSLA_LOSSA/My edit"
use "`filepath'/edit_Varkey_final_data.dta", clear


*****Decide if use the General Public data
//keep if SampleRespType==1

****Setting up the directory
set more off 
/// set more off, which is the default, tells Stata not to pause or display a more message. set more on tells Stata to wait until you press a key before continuing when a more message is displayed.///
/// global Varkey_main = "D:/Varkey/"  // set up the main directory /// 
global Varkey_main = "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Main/From Dolton and Friend/RE__ROSLA_LOSSA/My edit"
/// cd ${Varkey_main} /// do this manually using file - 'change working directory' ///
cd "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Main/From Dolton and Friend/RE__ROSLA_LOSSA/My edit"
capture: mkdir edit_output /// "capture executes command, suppressing all its output (including error messages, if any) and issuing a return code of zero..." 
/// "mkdir creates a new directory (folder)" 



***Merge the data of the leaving age, starting age, and the year of policy change...etc. (from school_age.dta)
capture: drop _merge /// All _merge variables are "matched (3)" whatever that means


merge 1:m market region01 region02 region03 region04 region05 region06 region07 region08 region09 region10 region11 region12 region13 region14 region15 region16 region17 region18 region19 region20 region21 region22 region23 region24 region25 region26 region27 region28 region29 region30 region31 region32 region33 region34 region35 using edit_school_age.dta /// market = which country /// PROBLEM - merge worked 2nd time when I skipped lines up to 24 (Should be fine now)
drop _merge



******keep the variable that we are interested in order to obtain the clear idea***************
//keep market  QCDOB S5 AgeInYears SSA* SSSA*  S7* Uni* S12 S10 SLA*
/// s7 are the additional teaching questionS. 
*******create the variable of year of birth, month of birth******* 
gen yob = year( QCDOB )
gen mob = month( QCDOB )
label variable yob "year of birth"
label variable mob "month of birth"

****Label the variables
label variable SLA_old "the old school-leaving-age of compulsory education "
label variable SLA_new "the new school-leaving-age of compulsory education "
label variable SLA_yopc "the year when the school leaving age of compulsory education was changed " 
label variable Uni_dur "How many years to obtain the University Degree"
/// label variable SLA_new "the leaving age after police change" /// This is named twice: L43


*************Adjust variable for the country that have multiple reform (ROSLA) **********************
/*Most Countries only have one ROSLA or LOSLA*/ /// LOSSA?
***Set up the variable of monthly time series in order to identify  whether the participant were affected by the reform
gen mofbirth = ym(yob, mob)  /// mofbirth = BIRTH COHORT affected by policy change
format mofbirth %tm  
///**************************************************************************** MAJOR EDIT HERE
******************************************************************************* Netherlands (market ==22)
/* The process of adjustment for multiple ROSLA is as following:
1. Find out the period that the latest ROSLA affects people:    [2014 (year of reform occurred)-17(the SLA)-1] =1996./// EDIT (SLA_yopc-SLA_old) i.e (2014-17) therefore birth cohort affect = 9/1997-8/1998
	People who born after 1996m9 are directly or indirectly affected by the latest reform in 2014m9.
2. If people born before the month when latest ROSLA actively affect them (1996m9) , then the values for these people will be re-adjusted. 
	The reason is that these people are actually directly or indirectly affected by the previous reform (in 2008 m9), so we need to re-define the relative values.
3. Follow the same logic: People who born after 1991m9 are directly or indirectly affected by the previous reform in 2008m9.
*******************************************************************************************************************************************************/
/// Both yopc_22_1 and mofbirth are measured in the same fashion therefore the higher the year the closer it is to today 
**************************************************************************************************************************Netherlands (market ==22)
/// There are 2 changes. SLA1:2018: 16 to 17 SLA2:1975:15 to 16 Therefore only the need for 1 adjustment of code
/// BC1: 2018-16=2002


///**************************************************************************** NEW STARTING POINT SINCE ALL BEFORE HERE IS SAVED (Be mindful that this may not work since cd and all that may have to be done again)




****Re-define the values for people born before the month then latest ROSLA (2014) actively affect them 
local yopc_22_1=tm(2002m9) 
replace SLA_old=15 if market==22 & (mofbirth < `yopc_22_1')  
replace SLA_new=16 if market==22 & (mofbirth < `yopc_22_1')  
replace SLA_yopc= 1975 if market==22 & (mofbirth < `yopc_22_1')  


///*****************************************************************************Argentina (market==1)
/// Argentina only has 1 SLA change and 1 SSSA change therefore no adjustments need to be made
///*****************************************************************************Brazil (market==2)
/// Brazil has SSA_old:7 SSA_new:6 SSA_yopc:2013 SSSA_old:11 SSSA_new:11 SSSA_yopc:. SLA_old:17 SLA_new:18 SLA_yopc:2018	
/// Only 1 SSA change therefore no need for adjustment there. No SSSA adjustment therefore no need for adjustment. There are 2 SLA changes...
/// Latest SLA change: 2018: 17 to 18 
/// Second SLA change: 2010: 14 to 17
*** Re-define the values for people born before the month then latest ROSLA acivtely affect them. The Latest ROSLA affects those born 2018-SLA_old=2018-17=2001
local yopc_02_1=tm(2001m9)
replace SLA_old=14 if market==2 & (mofbirth < `yopc_02_1')
replace SLA_new=17 if market==2 & (mofbirth < `yopc_02_1')
replace SLA_yopc=2010 if market==2 & (mofbirth < `yopc_02_1')

///*****************************************************************************Canada (market==3)
/// ALberta has at most 1 change for SLA and SSA & 0 changes for SSSA --- Therefore no need for additional code
/// British Columbia SSA has no changes, SSSA has no changes, SLA has 1 changes --- Therefore no need for code
/// Manitoba has 0 SSA changes, 0 SSSA changes and on,ly 1 SLA change, therefore no need for additional code
/// New Brunswick has 0 SSA changes, 0 SSSA changes and only 1 SLA change, therefore no need for additional code
/// Newfoundland and Labrador has 1 SSA change, 0 SSSA changes and 1 SLA change,therefore no need for additional code
/// Nova Scotia has no changes to any of its relevant school age variables,therefore no need for additional code
/// Ontario has no changes to any of its relevant school age variables,therefore no need for additional code
/// Prince Edward Island doesn't have anymore than 1 change to any of it's relevant school age variables, therefore no need for additional code

/// Quebec has 0 changes to SSA and SSSA however it has 2 changes to SLA: 15 to 16 in 1988 and 14 to 15 in 1961, therefore more code is required for those born prior to the birth cohort for the latest SLA change
/// The latest change in 1988 affects those born in (yopc-SLA_old=1988-15=1973), therefore anyone born prior to 1973m9 must have their code adjusted to the 1961 ROSLA
local yopc_03_09_1=tm(1973m9) 
replace SLA_old=14 if market==3 & region03==9 & (mofbirth < `yopc_03_09_1')
replace SLA_new=15 if market==3 & region03==9 & (mofbirth < `yopc_03_09_1')
replace SLA_yopc=2010 if market==3 & region03==9 & (mofbirth < `yopc_03_09_1')
/// Saskatchewan doesn't have anymore than 1 change to any of it's relevant school age variables, therefore no need for additional code


/// GOOD UP TO HERE -- SAVED


///*****************************************************************************Chile (market==4)	COME BACK TO CHILE
/// Chile has no change to the SSA or SLA but it has 2 changes to the SSSA. 
/// The latest change, that is already in the data, is from 14 to 12 in 1998. The previous change is from 12 to 14 in 1997. 
/// The respective birth cohort affected for the latest reform are those born yopc-SSSA_old= 1998-14=1984. Therefore all those born from 1998m9-1999m9 are affected directly by the 1998 reform.
/// The respecive birth cohort affected by the previous reform are those born yopc-SSSA_old= 1997-12=1985.

local yopc_4_1=tm(1986m9)
replace SSSA_old=12 if market==4 & (mofbirth<`yopc_4_1')
replace SSSA_new=14 if market==4 & (mofbirth<`yopc_4_1')
replace SSSA_yopc=1997 if market==4 & (mofbirth<`yopc_4_1') 			/// I forgot to do Chile before doing dur_prim but I have done it now

///*****************************************************************************China (market==5)
/// Doesn't have anymore than 1 change to any of it's relevant school age variables, therefore no need for additional code
///*****************************************************************************Colombia (market==6) 
/// Doesn't have anymore than 1 change to any of it's relevant school age variables, therefore no need for additional code
///*****************************************************************************Czech Republic (market==7) 
/// Doesn't have anymore than 1 change to any of it's relevant school age variables, therefore no need for additional code
///*****************************************************************************Egypt (market==8) 
/// Egypt has 2 SSSA changes. The latest change, already inputed into our data is 2005 11 to 12. 
/// The previous change that must be considered is 1990 from 12 to 11.


local yopc_8_1=tm(1994m9)
replace SSSA_old=12 if market==8 & (mofbirth<`yopc_8_1')
replace SSSA_new=11 if market==8 & (mofbirth<`yopc_8_1')
replace SSSA_yopc=1990 if market==8 & (mofbirth<`yopc_8_1') 			/// I forgot to do Egypt before doing dur_prim but I have done it now

///***************************************************************************** Finland (market==9)
/// South has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// South West has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// South East has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// West has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// East has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// North has no more than 1 change to any of it's relevant school age variables therefore no need for additional code

///***************************************************************************** France (market==10)
/// France has no more than 1 change to any of it's relevant school age variables therefore no need for additional code

///***************************************************************************** Germany (market==11)
/// Schleswig-Holstein, Hamburg, Niedersach: has 3 SLA changes. However only the latest two count for those born after 1954 which are all those in our dataset. 
/// Therefore the oldest SLA change in 1962 from 14 to 15 can be ignored. Therefore there are only 2 SLA changes to be considered. 
/// The latest SLA change is from 18 to 19 in 2018 that is already inputed in the data. The older SLA change is from 15 to 18 in 2003. 
/// The latest SLA affects those born (yopc-SLA_old=2018-18=2000m9) whereas the older SLA affects those born (yopc-SLA_old=2003-15=1988m9) 
local yopc_11_01_1=tm(2000m9)
replace SLA_old=15 if market==11 & region11==1 & (mofbirth<`yopc_11_01_1')
replace SLA_new=18 if market==11 & region11==1 & (mofbirth<`yopc_11_01_1')
replace SLA_yopc=2003 if market==11 & region11==1 & (mofbirth<`yopc_11_01_1')

/// Nordrhein-Westfalen has 3 SLA changes. However only the latest two count for those born after 1954 since the oldest one is too far back in our dataset. 
/// Therefore the relevant SLA changes are the latest one in 2018 from 18to19 and the previous one of 15to18 in 2003
/// The latest SLA change in 2018 is already inputed into the data. The older SLA change must be inputed for those born before the latest change would have affected them
/// The birth cohort for the latest SLA change is (yopc-SLA_old=2018-18=2000m9)
local yopc_11_02_1=tm(2000m9) 
replace SLA_old=15 if market==11 & region11==2 & (mofbirth<`yopc_11_02_1')
replace SLA_new=18 if market==11 & region11==2 & (mofbirth<`yopc_11_02_1')
replace SLA_yopc=2003 if market==11 & region11==2 & (mofbirth<`yopc_11_02_1')

/// Hessen, Rheinland-Pfalz, Saarland has 3 SLA changes. The one from 1967 affects those born in 1953 who are too old for our dataset so that SLA change will be ignored.
/// The remaining important SLA changes are... SLA1:2018: 18to19. SLA2: 2003:15to18
///												BC1: 2000m9
local yopc_11_03_1=tm(2000m9) 
replace SLA_old=15 if market==11 & region11==3 & (mofbirth<`yopc_11_03_1')
replace SLA_new=18 if market==11 & region11==3 & (mofbirth<`yopc_11_03_1')
replace SLA_yopc=2003 if market==11 & region11==3 & (mofbirth<`yopc_11_03_1')

/// Baden-Württemberg has 3 SLA changes. The one from 1967 affects those born in 1953 who are too old for our dataset so that SLA change will be ignored.
/// SLA1:2018:18to19 and SLA2:2003:15to18
/// BC1: 2000
local yopc_11_04_1=tm(2000m9) 
replace SLA_old=15 if market==11 & region11==4 & (mofbirth<`yopc_11_04_1')
replace SLA_new=18 if market==11 & region11==4 & (mofbirth<`yopc_11_04_1')
replace SLA_yopc=2003 if market==11 & region11==4 & (mofbirth<`yopc_11_04_1')


/// Bayern is the only region with 3 SLA changes that are effective so far, for all members in the data.
/// The SLA changes numbered 1 to 3 with 1 being the most recent are...
/// SLA1:2018: 18to19, SLA2:2003: 15to18, SLA3:1969: 14to15
/// BC1: 2000m9, 1988, 1955. However the final birth cohort only concerns us insofar that it is after 1954. 
local yopc_11_05_1=tm(2000m9) ///  This as the 'Upper Bound'
replace SLA_old=15 if market==11 & region11==5 & (mofbirth<`yopc_11_05_1')
replace SLA_new=18 if market==11 & region11==5 & (mofbirth<`yopc_11_05_1')
replace SLA_yopc=2003 if market==11 & region11==5 & (mofbirth<`yopc_11_05_1')

local yopc_11_05_2=tm(1988m9) 
replace SLA_old=14 if market==11 & region11==5 & (mofbirth<`yopc_11_05_2')
replace SLA_new=15 if market==11 & region11==5 & (mofbirth<`yopc_11_05_2')
replace SLA_yopc=1969 if market==11 & region11==5 & (mofbirth<`yopc_11_05_2')

/// Berlin is the 2nd region, like Bayern to have 3 effective SLA changes. 
/// SLA change 1: 2018: 18 to 19, SLA change 2: 2003: 15to18, SLA change 3: 1969: 14to15
/// The respective birth cohorts are: 1: 2000m9, 1988m9, 1955m9. However the final birth cohort only concerns us insofar that it is after 1954. 
local yopc_11_06_1=tm(2000m9) 
replace SLA_old=15 if market==11 & region11==6 & (mofbirth<`yopc_11_06_1')
replace SLA_new=18 if market==11 & region11==6 & (mofbirth<`yopc_11_06_1')
replace SLA_yopc=2003 if market==11 & region11==6 & (mofbirth<`yopc_11_06_1')

local yopc_11_06_2=tm(1988m9) 
replace SLA_old=14 if market==11 & region11==6 & (mofbirth<`yopc_11_06_2')
replace SLA_new=15 if market==11 & region11==6 & (mofbirth<`yopc_11_06_2')
replace SLA_yopc=1969 if market==11 & region11==6 & (mofbirth<`yopc_11_06_2')

/// Note - All saved here, however I have not double checked all of the values between here and the last save, but certainly most of them. All have been checked up until Germany.

/// Mecklenburg-Vorpommern, Brandenburg, Sa: 3 SLA's overall but only 2 effective SLA's
/// (Most recent) SLA 1:2018: 18to19. SLA2:2003:16to18
/// Respecive Birth Cohorts: 2000m9, 1987m9
local yopc_11_07_1=tm(2000m9) 
replace SLA_old=16 if market==11 & region11==7 & (mofbirth<`yopc_11_07_1')
replace SLA_new=18 if market==11 & region11==7 & (mofbirth<`yopc_11_07_1')
replace SLA_yopc=2003 if market==11 & region11==7 & (mofbirth<`yopc_11_07_1')

/// For all those in market 11 in region 7, if they're born before 2000m9 they're not affected by the latest reform... 
/// ...therefore its not relevant so input the values of the previous reform

/// Sachsen, Thüringen: 3 SLA's overall but only 2 effective SLA's
/// (Most recent) SLA1:2018: 18to19. SLA2:2003: 16to18
/// Respecive Birth Cohorts: 2000m9, 1987m9
local yopc_11_08_1=tm(2000m9) 
replace SLA_old=16 if market==11 & region11==8 & (mofbirth<`yopc_11_08_1')
replace SLA_new=18 if market==11 & region11==8 & (mofbirth<`yopc_11_08_1')
replace SLA_yopc=2003 if market==11 & region11==8 & (mofbirth<`yopc_11_08_1')

///***************************************************************************** Ghana (market==12)
/// Ghana has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Greece (market==13)
/// Greece has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Hungary (market==14)
/// Hungary has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** India (market==15)
/// India has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Indonesia (market==16)
/// Indonesia has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Israel (market==17)
/// Israel has 2 SLA changes and as such requires 1 adjustments to the code for those old enough to not be affected by SLA1.
/// SLA1:2018: 17to18. SLA2:2012: 15to17
/// Birth Cohort for 1: 2018-17=2001m9. BC2: 2012-15=1997
local yopc_17_1=tm(2001m9) 
replace SLA_old=15 if market==17 & (mofbirth<`yopc_17_1')
replace SLA_new=17 if market==17 & (mofbirth<`yopc_17_1')
replace SLA_yopc=2012 if market==17 & (mofbirth<`yopc_17_1')

///***************************************************************************** Italy (market==18)
/// Italy has 3 SLA changes but only 2 ones that are effective for those born on or after 1954. 
/// As such only 1 correction is needed for those born far away enough to not be affected by the latest ROSLA change.
/// SLA change 1: 2018: 16 to 18. SLA2: 1999: 14 to 16
/// BC1: 2002m9 BC2:1985m9
local yopc_18_1=tm(2002m9) 
replace SLA_old=14 if market==18 & (mofbirth<`yopc_18_1')
replace SLA_new=16 if market==18 & (mofbirth<`yopc_18_1')
replace SLA_yopc=1999 if market==18 & (mofbirth<`yopc_18_1')
///***************************************************************************** Japan (market==19)
/// Japan has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Korea (market==20)
/// Korea has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Malaysia (market==21)
/// Malaysia has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Netherlands (market==22)
/// Already done above
///***************************************************************************** New Zealand (market==23)
/// NZ has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Panama (market==24)
/// Panama has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Peru (market==25)
/// Although Peru has 2 SSA changes, the latest one doesn't count as it's in 2018 and as such doesn't affect any of my participants
///***************************************************************************** Portugal (market==26)			
/// There are 3 SLA changes but only 2 effective SLA changes as we can ignore the SLA change of 1964.
/// There are 2 effective SSA changes

/// Therefore we need 1 adjustment for SLA and 1 adjustment for SSA. Start with SLA since it's easier. 

/// SLA1:2014:16to18	SLA2:1973:14to16	(SLA3:1964:13to14 =Ineffective)
/// BC1:1998m9			BC2:1959			(IneffectiveBC3:1951)

local yopc_26_SLA1=tm(1998m9)
replace SLA_old=14 if market==26 & (mofbirth<`yopc_26_SLA1')
replace SLA_new=16 if market==26 & (mofbirth<`yopc_26_SLA1')
replace SLA_yopc=1973 if market==26 & (mofbirth<`yopc_26_SLA1')

/// SSA adjustments
/// SSA1:1971:7to6	SSA2:1970:8to7
/// BC1: 1965m9		BC2:1963m9
/// For all those born too far away to be affected by the 1971 SSA1 change.

local yopc_26_SSA1=tm(1965m9)
replace SSA_old=8 if market==26 & (mofbirth<`yopc_26_SSA1')
replace SSA_new=7 if market==26 & (mofbirth<`yopc_26_SSA1')
replace SSA_yopc=1970 if market==26 & (mofbirth<`yopc_26_SSA1')

///***************************************************************************** Russia (market==27)
/// Russia has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Singapore (market==28)
/// Singapore has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Spain (market==29)
/// Spain has 2 SLA changes and as such needs the data adjusted once only for all those observations too young for the most recent ROSLA
/// SLA1:1990:14to16	SLA2:1970:12to14
/// BC1: 1976m9			BC2:1958 (not relevant only that it is after 1954 is relevant)

local yopc_29_1=tm(1976m9) /// Upper Boundary
replace SLA_old=12 if market==29 & (mofbirth<`yopc_29_1')
replace SLA_new=14 if market==29 & (mofbirth<`yopc_29_1')
replace SLA_yopc=1970 if market==29 & (mofbirth<`yopc_29_1')

///***************************************************************************** Switzerland (market==30)
/// Although Switzerland has 2 SSA changes, it only has 0 effective ones. Switzerland requires no adjustment code
///***************************************************************************** Taiwan (market==31)
/// Taiwan has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** Turkey (market==32) 
/// Only SLA's need readjustment code for Turkey
/// There are 3 SLA changes all of which are effective for the participants in our data
/// SLA1: 2012:15 to 18. SLA2:2005:14 to 15. SLA3: 1997:12 to 14
/// BC1: 1997m9 BC2: 1991m9 BC3: 1985m9 (This one doesn't matter only insofar that it is larger than 1954)
local yopc_32_1=tm(1997m9) /// Upper Boundary
replace SLA_old=14 if market==32 & (mofbirth<`yopc_32_1')
replace SLA_new=15 if market==32 & (mofbirth<`yopc_32_1')
replace SLA_yopc=2005 if market==32 & (mofbirth<`yopc_32_1')

local yopc_32_2=tm(1991m9) /// Lower Upper Boundary
replace SLA_old=12 if market==32 & (mofbirth<`yopc_32_2')
replace SLA_new=14 if market==32 & (mofbirth<`yopc_32_2')
replace SLA_yopc=1997 if market==32 & (mofbirth<`yopc_32_2')

/// **********************************************************************ALL DOUBLE CHECKED UP TO HERE (Triple Checked up to Germany) **********************************************************************///


///***************************************************************************** Uganda (market==33) 
/// Uganda has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
///***************************************************************************** UK (market==34) Apply the same code to multiple regions since all regions within England will require the same code
/// The UK data can thought of as 4 categories
/// Category 1: Scotland 
/// Category 2: North East, North West, Yorkshire and the Humber, East Midlands, West Midlands, East of England, Greater London, South East, South West
/// Category 3: Wales
/// Category 4: Northern Ireland

/// The code will be the same for all regions within the same category. 

/// Scotland has no more than 1 change to any of it's relevant school age variables therefore no need for additional code

/// Category 2. All regions within category 2 have 3 SLA's all of which are effective. Therefore 2 corrections are needed as code already outlines SLA1. 
/// SLA1: 2015:17 to 18. SLA2: 2013:16 to 17. SLA3: 1973:15 to 16. 
/// BC1: 1998m9 BC2: 1997m9 BC3: 1958m9 (this only matters insofar that it is above 1954)
/// THIS SECTION IS MOSTLY CHECKED AND ALL GOOD
local yopc_34_c2_1=tm(1998m9) /// Upper Boundary
replace SLA_old=16 if market==34 & region34!=1 & region34!=7 & region34!=12 &(mofbirth<`yopc_34_c2_1')
replace SLA_new=17 if market==34 & region34!=1 & region34!=7 & region34!=12 &(mofbirth<`yopc_34_c2_1')
replace SLA_yopc=2013 if market==34 & region34!=1 & region34!=7 & region34!=12 &(mofbirth<`yopc_34_c2_1')

local yopc_34_c2_2=tm(1997m9) /// Upper Boundary
replace SLA_old=15 if market==34 & region34!=1 & region34!=7 & region34!=12 &(mofbirth<`yopc_34_c2_2')
replace SLA_new=16 if market==34 & region34!=1 & region34!=7 & region34!=12 &(mofbirth<`yopc_34_c2_2')
replace SLA_yopc=1973 if market==34 & region34!=1 & region34!=7 & region34!=12 &(mofbirth<`yopc_34_c2_2')

/// Category 3: Wales has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// Category 4: Northern Ireland
/// While there are 2 SLA's only 1 is effectective as the SLA change in 1957 doesn't count for anyone born in our dataset


/// ALL SAVED /// 

///***************************************************************************** United States (market==35) 
/// region35==1 for Maine. Therefore United States is not in alphabetical order.

/// 1 Maine has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 2 New Hampshire has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 3 Massachusetts has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 4 Rhode Island has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 5 Connecticut has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 6 Vermont has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 7 New York has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 8 New Jersey has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 9 Pennsylvania has no more than 1 change to any of it's relevant school age variables therefore no need for additional code
/// 10 Wisconsin has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 11 Michigan has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 12 Ohio has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 13 Indiana has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 14 Illinois has 2 SLA's both of which are effective, therefore one adjustment is needed for all those born far away enough to not be effected by SLA1.
/// SLA1: 2018:17 to 18 SLA2:2013:16 to 17
/// BC1: 2001m9 BC2:1997m9 (This is only useful insofar that it is above 1954)

local yopc_35_14_1=tm(2001m9) /// Upper Boundary
replace SLA_old=16 if market==35 & region35==14 &(mofbirth<`yopc_35_14_1')
replace SLA_new=17 if market==35 & region35==14 &(mofbirth<`yopc_35_14_1')
replace SLA_yopc=2013 if market==35 & region35==14 &(mofbirth<`yopc_35_14_1')

/// 15 North Dakota has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 16 Minnesota has 2 SLA changes and thus requires 1 adjustment. NEGATIVE ROSLA - Code for deletion complete. 
/// SLA1:2018:16 to 18. SLA2:2002:18 to 16
/// BC1: 2002m9 BC2: 1986m8
/// DIFFERENT PLAN DUE TO NEGATIVE ROSLA
/// Therefore delete all observations for people who are old enough to be affected by negative ROSLA
/// BE CAREFUL CHECK IT HAS WORKED ON BROWSE! (Browse with mofbirth or AgeInYears to check)

local yopc_16_Negative1=tm(1986m9)
drop if region35==16 & (mofbirth<`yopc_16_Negative1')

/// CHECKED ALL GOOD AND SAVED 
/// 17 South Dakota has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 18 Nebraska has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 19 Iowa has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 20 Missouri has 2 SLA changes therefore it requires 1 adjustment for those born away enough to not be affected by the latest reform
/// SLA1:2018:17 to 18. SLA2:2013:16 to 17
/// BC1: 2001m9

local yopc_35_20_1=tm(2001m9) /// Upper Boundary
replace SLA_old=16 if market==35 & region35==20 &(mofbirth<`yopc_35_20_1')
replace SLA_new=17 if market==35 & region35==20 &(mofbirth<`yopc_35_20_1')
replace SLA_yopc=2013 if market==35 & region35==20 &(mofbirth<`yopc_35_20_1')

/// SAVED CHECKED

/// 21 Kansas has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 22 Virginia has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 23 Deleware has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 24 Maryland has 2 SLA changes both of which are effective, therefore 1 adjustment to the code is rquired. 
/// SLA1: 2018:17 to 18. SLA2: 2015:16 to 17
/// BC1: 2001m9

local yopc_35_24_1=tm(2001m9) /// Upper Boundary
replace SLA_old=16 if market==35 & region35==24 &(mofbirth<`yopc_35_24_1')
replace SLA_new=17 if market==35 & region35==24 &(mofbirth<`yopc_35_24_1')
replace SLA_yopc=2015 if market==35 & region35==24 &(mofbirth<`yopc_35_24_1')

/// 25 North Carolina has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 26 South Carolina has 2 SLA changes therefore requires 1 adjustment.
/// SLA1: 2018:17 to 18. SLA2: 2006:16 to 17
/// BC1: 2001m9

local yopc_35_26_1=tm(2001m9)
replace SLA_old=16 if market==35 & region35==26 &(mofbirth<`yopc_35_26_1')
replace SLA_new=17 if market==35 & region35==26 &(mofbirth<`yopc_35_26_1')
replace SLA_yopc=2006 if market==35 & region35==26 &(mofbirth<`yopc_35_26_1')

/// 27 Georgia has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 28 Florida has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 29 West Virginia has 2 SLA changes therefore requires 1 adjustment code
/// SLA1: 2018: 17 to 18. 2013:16 to 17
/// BC1: 2001m9

local yopc_35_29_1=tm(2001m9)
replace SLA_old=16 if market==35 & region35==29 &(mofbirth<`yopc_35_29_1')
replace SLA_new=17 if market==35 & region35==29 &(mofbirth<`yopc_35_29_1')
replace SLA_yopc=2013 if market==35 & region35==29 &(mofbirth<`yopc_35_29_1')

/// 30 Kentucky has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 31 Tennessee has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 32 Alabama has 2 SLA changes therefore requires 1 readjustment of the code
/// SLA1:2018: 17 to 18 SLA2:2013: 16 to 17
/// BC1: 2001m9

local yopc_35_32_1=tm(2001m9)
replace SLA_old=16 if market==35 & region35==32 &(mofbirth<`yopc_35_32_1')
replace SLA_new=17 if market==35 & region35==32 &(mofbirth<`yopc_35_32_1')
replace SLA_yopc=2013 if market==35 & region35==32 &(mofbirth<`yopc_35_32_1')

/// 33 Mississippi has 3 SLA changes therefore it requires 2 sets of readjustment code. It has a negative ROSLA so... CHECK -- ROSLA CODE MIGHT NOT WORK FOR MISSISSIPPI
/// SLA1: 2018:17to18.		SLA2:2007:16to17.		SLA3:2003:17to16
/// BC1: 2001m9				BC2: 1991m8				BC3: 1987m9

local yopc_35_33_1=tm(2001m9)
replace SLA_old=16 if market==35 & region35==33 &(mofbirth<`yopc_35_33_1')
replace SLA_new=17 if market==35 & region35==33 &(mofbirth<`yopc_35_33_1')
replace SLA_yopc=2007 if market==35 & region35==33 &(mofbirth<`yopc_35_33_1')

local yopc_33_Negative1=tm(1987m9)
drop if region35==33 & (mofbirth<`yopc_33_Negative1')

/// 34 Texas has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 35 Oklahoma has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 36 Arkansas has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 37 Louisiana has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 38 Montana has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 39 Idaho has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 40 Wyoming has no more than  1 change to any of it's relevant school age variables therefore no need for additional code -- Negative ROSLA - No problem now. 
/// Wyoming only has 1 observation that was not affected by any changes. The respective SLA/SSA variables have been adapted and there is no need for further code. 


/// 41 Nevada has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 42 Utah has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// SAVED

/// 43 Colorado has 2 SLA changes therefore 1 readjustment is required in order to adjust the values of those born far away enough to not be affected by the latest SLA change (SLA1)
/// SLA1: 2018:17to18. SLA2: 2007:16to17
/// BC1: 2001m9
local yopc_35_43_1=tm(2001m9)
replace SLA_old=16 if market==35 & region35==43 &(mofbirth<`yopc_35_43_1')
replace SLA_new=17 if market==35 & region35==43 &(mofbirth<`yopc_35_43_1')
replace SLA_yopc=2007 if market==35 & region35==43 &(mofbirth<`yopc_35_43_1')

/// 44 New Mexico has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 45 Arizona has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 46 Alaska has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

/// 47 Washington has 2 SLA changes. CHECK SINCE 1 IS A NEGATIVE ROSLA
/// SLA1:2006:16to18. SLA2:2004:17to16. 
/// BC1: 1989m9			BC2: 1988m9

replace SLA_old=16 if market==35 & region35==47 
replace SLA_new=18 if market==35 & region35==47 
replace SLA_yopc=2006 if market==35 & region35==47 

local yopc_35_Negative1=tm(1988m9)
drop if region35==35 & (mofbirth<`yopc_35_Negative1')

/// 48 Oregon has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 49 California has no more than  1 change to any of it's relevant school age variables therefore no need for additional code
/// 50 Hawaii has no more than  1 change to any of it's relevant school age variables therefore no need for additional code

///***************************************************************************** Recode for multiple ROSLA/LOSSA complete ************************************/

/// SAVED


/// I understand all up to here! YAS!
***************School LEAVING AGE (SLA)*******************************
************Example of the ROSLA Definition***************
/* Say ROSLA happened in 9/1972 for raising age from 15 to 16 then
ROSLA =0 for those born on or AFTER 9/1958
ROSLA=1 for those born 9/1957 - 8/1958
ROSLA=. For those born BEFORE 9/1957
*/

gen ROSLA_S=.
//ROSLA =0 , the case that people born in 1957, and after September ///EDIT: IN 9/1958 
replace ROSLA_S =0 if (yob == SLA_yopc-SLA_old+1) & mob >=9 /// Lowest Boundary
//ROSLA =0 , the case that people born after 1957. ///EDIT: AFTER 9/1958 
replace ROSLA_S =0 if (yob > SLA_yopc-SLA_old+1) /// Slightly higher lower boundary


//ROSLA =1 , the case that people born in 1957, and before August ///EDIT: ...people born in 1958, and before August
replace ROSLA_S =1 if (yob == SLA_yopc-SLA_old+1) & mob < 9 /// Upper Boundary
//ROSLA =1 , the case that people born one year before 1957, and after August  ///EDIT: ...people born one year before 1958, and after August
replace ROSLA_S =1 if (yob == SLA_yopc-SLA_old)  & mob >8 /// Lower Boundary

/// All else is . since it is so by default due to the variable being created that way to begin with

**********************School STARTING AGE (SSA)*******************************
/*Say LOSSA happened in 9/1960 for lowering Starting age from 6 to 5 then
LOSSA =0 for those born on or AFTER 9/1956
LOSSA=1 for those born 9/1955 - 8/1956
LOSSA=. For those born BEFORE 9/1955
*/


// Create the variable that lower year of school starting age.
gen LOSSA_P=.
//LOSSA =0 , the case that people born on 1956, and after September  /// Lowest limit
replace LOSSA_P =0 if (yob == SSA_yopc-SSA_new+1) & mob >=9 
//LOSSA =0 , the case that people born after 1956 /// Lower limit that is slightly higher
replace LOSSA_P =0 if (yob > SSA_yopc- SSA_new+1)  

//LOSSA =1 , the case that people born on 1956, and before September  /// Upper Limit
replace LOSSA_P =1 if (yob == SSA_yopc-SSA_new+1)  & mob <9 
//LOSSA =1 , the case that people born on one year before 1956, and after September /// Lower limit
replace LOSSA_P =1 if (yob == SSA_yopc-SSA_new) & mob >=9

/// SAVED - With some checks made too and everything was fine
	 
**********Counterfactual Years of schooling************
/*how many years less or more schooling would they have had if they had been affected by the reform(s) 
when they weren’t OR had not been affected by the reform and they were. */

gen CFYRS_R=.
gen CFYRS_L=.

label variable CFYRS_R "CFYRS for ROSLA "
label variable CFYRS_L "CFYRS for LOSSA "


// if people were directly affected by the ROSLA,  then ///EDIT: I have swapped SLA-new and SLA old as explained in the email to Powen
replace CFYRS_R = SLA_old-SLA_new if ROSLA_S==1 
// if people were indirectly affected by the ROSLA,  then
replace CFYRS_R = SLA_old-SLA_new if ROSLA_S==0 
// if people were not affected by the ROSLA,  then
replace CFYRS_R = SLA_new-SLA_old if ROSLA_S==.

// if people were directly affected by the LOSSA,  then /// EDIT: I have also swapped one of the SSA_new/old 
replace CFYRS_L = (SSA_new-SSA_old) if LOSSA_P==1
// if people were indirectly affected by the LOSSA,  then 
replace CFYRS_L = (SSA_new-SSA_old) if LOSSA_P==0
// if people were not affected by the LOSSA,  then 
replace CFYRS_L = (SSA_old-SSA_new) if LOSSA_P==.

/// All good up to here
***YRSAWAY – How many completes years older (+) or younger (-) they would have had to be in or ROSLA or LOSSA.
///****************************************************************************** MAYBE JUST SKIP LINES 543-575 ///
  

/// Pretty Sure CFYRS is all good so --- SAVED (NOTE: I have saved another file up at this point in a separate folder called 'BFR YRSAWAY' or something like that just incase stuff gets messed up from here onwards


gen YRSAWAY_R=.
gen YRSAWAY_L=.

label variable  YRSAWAY_R "YRSAWAY for ROSLA"
label variable  YRSAWAY_L "YRSAWAY for LOSSA"

// If people born on the year that ROSLA affects them but month of birth is later than September, then people have to wait one year to be enrolled. 
replace YRSAWAY_R=yob-(SLA_yopc-SLA_old)+1 if ROSLA_S==0 & (SLA_yopc-SLA_old==yob) & mob>=9 
// If people born after the year that ROSLA affects them but month of birth is later than September, then people have to wait one year to be enrolled. 
replace YRSAWAY_R= yob-(SLA_yopc-SLA_old)+1 if ROSLA_S==0 & (yob>SLA_yopc-SLA_old) & mob>=9 
// If people born after the year that ROSLA affects them but month of birth is earlier than September, then people don't need to wait one year to be enrolled. 
replace YRSAWAY_R= yob-(SLA_yopc-SLA_old) if ROSLA_S==0 & (yob>SLA_yopc-SLA_old) & mob<9 
//If people are directly affected by ROSLA, then YRSAWAY==0
replace YRSAWAY_R=0 if ROSLA_S==1 
//If people are not affected by ROSLA, then 
replace YRSAWAY_R=yob-(SLA_yopc-SLA_old)  if ROSLA_S==. & (yob==SLA_yopc-SLA_old-1) & mob<9
replace YRSAWAY_R=yob-(SLA_yopc-SLA_old)  if ROSLA_S==. & (yob<SLA_yopc-SLA_old-1) & mob<9
replace YRSAWAY_R=yob-(SLA_yopc-SLA_old)+1  if ROSLA_S==. & (yob<SLA_yopc-SLA_old-1) & mob>=9

// If people born on the year that LOSSA affects them but month of birth is later than September, then people have to wait one year to be enrolled. 
replace YRSAWAY_L= yob-(SSA_yopc-SSA_old)+1 if LOSSA_P==0 &  (yob>SSA_yopc-SSA_old) & mob>=9 
// If people born after the year that LOSSA affects them but month of birth is later than September, then people have to wait one year to be enrolled. 
replace YRSAWAY_L= yob-(SSA_yopc-SSA_old) if LOSSA_P==0 &  (yob>SSA_yopc-SSA_old) & mob<9 
// If people born after the year that LOSSA affects them but month of birth is later than September, then people have to wait one year to be enrolled. 
replace YRSAWAY_L= yob-(SSA_yopc-SSA_old)+1 if LOSSA_P==0 &  (SSA_yopc-SSA_old==yob) & mob>=9
//If people are directly affected by LOSSA, then YRSAWAY==0
replace YRSAWAY_L=0 if LOSSA_P==1 
//If people are not affected by LOSSA, then 
replace YRSAWAY_L=yob-(SSA_yopc-SSA_old) if LOSSA_P==.  & (yob==SSA_yopc-SSA_old-1) & mob<9
replace YRSAWAY_L=yob-(SSA_yopc-SSA_old) if LOSSA_P==.  & (yob<SSA_yopc-SSA_old-1) & mob<9
replace YRSAWAY_L=yob-(SSA_yopc-SSA_old)+1 if LOSSA_P==.  & (yob<SSA_yopc-SSA_old-1) & mob>=9

///****************************************************************************** RESUME HERE ///

****Years of Schooling for the compulsory school /// This whole section is fine and makes perfect sense
gen SCH=.
replace SCH=SLA_new-SSA_new if ROSLA_S==1 & LOSSA_P==0  // the year of schooling is affected by ROSLA and LOSSA 
replace SCH=SLA_new-SSA_new if ROSLA_S==1 & LOSSA_P==1  // the year of schooling is affected by ROSLA and LOSSA
replace SCH=SLA_new-SSA_old if ROSLA_S==1 & LOSSA_P==.   // the year of schooling is affected by ROSLA 

replace SCH=SLA_new-SSA_new if ROSLA_S==0 & LOSSA_P==0 // the year of schooling is affected by ROSLA and LOSSA
replace SCH=SLA_new-SSA_new if ROSLA_S==0 & LOSSA_P==1 // the year of schooling is affected by ROSLA and LOSSA
replace SCH=SLA_new-SSA_old if ROSLA_S==0 & LOSSA_P==. // the year of schooling is affected by ROSLA 

replace SCH=SLA_old-SSA_new if ROSLA_S==. & LOSSA_P==0 // the year of schooling is affected by  LOSSA
replace SCH=SLA_old-SSA_new if ROSLA_S==. & LOSSA_P==1 // the year of schooling is affected by LOSSA
replace SCH=SLA_old-SSA_old if ROSLA_S==. & LOSSA_P==.  // the year of schooling is not affected by ROSLA and LOSSA

/// SAVED

*****************************Calculate the total schooling year****************************************
***********Duration of Primary school***************
******create the duration (schooling years) of primary school*******
gen dur_prim=.
label variable dur_prim "the schooling years in primary school"
*****Logic of derive this variable****
/*
There are two time points in the data: 1970 (old) and 2017 (new). 
If individual's school-starting-age passes the year of policy change, then we use the new starting age to calculate the duration.
If individual's school-starting-age DOESN'T pass the year of policy change, then we use the OLD starting age to calculate the duration. 
We use SSSA (Secondary school starting age) to represent the primary school leaving age in order to obtain the duration of primary school.
The definition of duration of primary school is the secondary school starting-school age minus the primary school starting-school age
*/
/// DON'T FULLY UNDERSTAND WHAT IS BELOW, MAYBE IT WILL MAKE SENSE IN CONTEXT WITH THE NEXT SECTION @ line:219
***Set up the variable of monthly time series for the reform in order to identify  whether the participant were affected 
// Policy change for the primary school starting age:  people are affected if their birthday are later than the calculated time as following 
/// EDIT: '-SSA_old-1' if replaced with '-SSA_new'
/// Note, this below is the birth cohort beginning point affected when LOSSA=1
gen mofpc_SSA=ym(SSA_yopc-SSA_new, 9)  
// Policy change for the secondary school starting age (represent the primary school-leaving-age) :  people are affected if their birthday are later than the calculated time  as following
gen mofpc_SSSA=ym(SSSA_yopc-SSSA_new, 9) 

// Duration of primary school for people who were not affected by the reform of secondary school starting age, but affected by the reform of primary school starting age 
replace dur_prim = SSSA_old-SSA_new if (mofbirth<mofpc_SSSA) & (mofbirth>=mofpc_SSA) 
// Duration of primary school for people who were not affected by the reform of secondary school starting age, and were not affected by the reform of primary school starting age 
replace dur_prim = SSSA_old-SSA_old if (mofbirth<mofpc_SSSA) & (mofbirth<mofpc_SSA)  
// Duration of primary school for people who were affected by the reform of secondary school starting age, and affected by the reform of primary school starting age 
replace dur_prim = SSSA_new-SSA_new if (mofbirth>=mofpc_SSSA) & (mofbirth>=mofpc_SSA) 
// Duration of primary school for people who were affected by after the reform of secondary school starting age, but were not affected by the reform of primary school starting age 
replace dur_prim = SSSA_new-SSA_old if (mofbirth>=mofpc_SSSA) & (mofbirth<mofpc_SSA) 

label variable  SSA_old "Primary School Starting age in 1970"
label variable  SSA_new "Primary School Starting age in 2017"
label variable  SSA_yopc "The year that the policy of Primary School Starting age changed"
label variable  SSSA_old "Secondary School Starting age in 1970"
label variable  SSSA_new "Secondary School Starting age in 2017"
label variable  SSSA_yopc "The year that the policy of Secondary School Starting age changed"
/// Up to here

***********Duration of Secondary school***************
gen dur_sec=.
label variable dur_sec "the schooling years in secondary school"
/*
The definition of duration of secondary school is the leaving age minus the secondary school starting-school age
*/

// Policy change for the primary school starting age:  people are affected if their birthday are later than the calculated time  
gen mofpc_SLA=ym(SLA_yopc-SLA_old-1, 9)  

// Duration of secondary school for people who were NOT affected by the reform of secondary school leaving age, and were NOT affected by the reform of secondary school starting age 
replace dur_sec = SLA_old-SSSA_old if (mofbirth < mofpc_SLA) & (mofbirth<mofpc_SSSA)
// Duration of secondary school for people who were affected by the reform of secondary school leaving age, but were NOT affected by the reform of secondary school starting age 
replace dur_sec = SLA_new-SSSA_old if (mofbirth >= mofpc_SLA) & (mofbirth<mofpc_SSSA)
// Duration of secondary school for people who were not affected by the reform of secondary school leaving age, but were affected by the reform of secondary school starting age 
replace dur_sec = SLA_old-SSSA_new if (mofbirth < mofpc_SLA) & (mofbirth>=mofpc_SSSA)
// Duration of secondary school for people who were affected by the reform of secondary school leaving age, and were affected by the reform of secondary school starting age 
replace dur_sec = SLA_new-SSSA_new if (mofbirth >= mofpc_SLA) & (mofbirth>=mofpc_SSSA)
/****

///**************************************************************************** IMPORTANT: Ignore lines 726-741 as I have my own corrective method

NOTE: The compulsory education of most countries is secondary school.  /// THIS IS A PROBLEM
If the SLA (school leaving age of compulsory education ) is smaller than SSSA(secondary school starting age), 
	then I assume that the compulsory education is up to primary school.
 We need to adjust the dur_sec if the compulsory education is primary school (SLA<SSSA). 
**********Adjust the duration of secondary school  ****/

replace dur_sec= 2 if market== 13 & SLA_new <= SSSA_new // Greece
replace dur_sec= 2 if market== 13 & SLA_old <= SSSA_old // Greece

replace dur_sec= 2 if market== 4 & SLA_new <= SSSA_new // Chile
replace dur_sec= 2 if market== 4 & SLA_old <= SSSA_old // Chile

replace dur_sec= 4 if market== 33 & SLA_new <= SSSA_new // Uganda
replace dur_sec= 4 if market== 33 & SLA_old <= SSSA_old // Uganda



/// SAVED

**********Create the variable of schooling years*************
//Definition: 
1 Primary School 
   2 Secondary school, high school 
    3 University degree 
     4 Higher academic degree - e.g. masters, doctorate, MBA. (L_i-S_i )+4
    5 Formal Professional qualification (e.g. Law, Accountancy, Surveying, Architectur (L_i-S_i )+2
    6 Still in full time education (Age_i- S_i)
    7 Not applicable - I have no formal education  (11-S_i )                      */
/// I have no idea what "L_i-S_i" means	
gen yearofsch=.
replace yearofsch = dur_prim if S5==1
replace yearofsch = dur_prim+dur_sec if S5==2
replace yearofsch = dur_prim+dur_sec+Uni_dur if S5==3
replace yearofsch = dur_prim+dur_sec+Uni_dur+4 if S5==4
replace yearofsch = dur_prim+dur_sec+Uni_dur+2 if S5==5
/* There are some extreme case that they are old but still involve as a "still in full-time education"*/ /// Basically we assume they've been consistently in education since they started with no breaks
replace yearofsch = AgeInYears-SSA_old if S5==6 & AgeInYears<=35 &  (mofbirth<mofpc_SSA) 
replace yearofsch = AgeInYears-SSA_new if S5==6 & AgeInYears<=35 &  (mofbirth>=mofpc_SSA) 
replace yearofsch = dur_prim if S5==7 


******Have brief check and idea about the distribution************
tab market dur_prim
tab market dur_sec 


**********Create  the distribution figure******************
preserve
collapse (count) freqs=AgeInYears, by(market yearofsch)  // the variable AgeInYears is just a proxy, this command count the frequency of valid values.
label variable freqs "Counts"
twoway (bar freqs yearofsch) , by(market) ylabel(, angle(0)) xtitle("years of schooling") ytitle("frequency")
  gr export years_schooling_dist.png, replace width(1280) height(1024)
save output/freq_years_schooling.dta, replace
restore

*********
preserve
collapse (count) freqs=AgeInYears, by(yearofsch)  // the variable AgeInYears is just a proxy, this command count the frequency of valid values.
label variable freqs "Counts"
twoway (bar freqs yearofsch) , ylabel(, angle(0)) xtitle("years of schooling") ytitle("frequency")
  gr export years_schooling_dist_all.png, replace width(1280) height(1024)
save output/freq_years_schooling_all.dta, replace
restore

tab S10

************************************ GRAPHS

graph bar (mean) derivedpppincgross, over(market, label(angle(90) labsize(small))) graphregion(color(white)) ylabel(0 (20000) 80000) ///
ytitle("mean of annual personal income (PPP $)", size(small))     
	  gr export output/income_dist_fullsample.png, replace width(1280) height(1024)

	  
/// Everyone but teachers graph	  
graph bar (mean) derivedpppincgross if SampleRespType==1, over(market, label(angle(90) labsize(small))) graphregion(color(white)) ///
ytitle("mean of annual personal income (PPP $)", size(small))  ylabel(0 (20000) 80000)   
	  gr export output/income_dist_GP.png, replace width(1280) height(1024)

/// Teachers only graph	  
graph bar (mean) derivedpppincgross if SampleRespType==2, over(market, label(angle(90) labsize(small))) graphregion(color(white)) ///
ytitle("mean of annual personal income (PPP $)", size(small))  ylabel(0 (20000) 80000)
	  gr export output/income_dist_ET.png, replace width(1280) height(1024)
 

**********************Section 3--Print relevant tables******************
********************Create the variable list*******
*****Labelling the variables
label variable mofbirth "month of birth (time series)" 
label variable ROSLA_S "Raise school leaving age (secondary school)"
label variable  LOSSA_P "Lower school starting age (primary school)" 
label variable SCH " schooling years(compulsory education)" 
label variable mofpc_SSA "month of the reform for changing school starting age (primary school, time series)"
label variable mofpc_SSSA "month of the reform for changing school starting age (secondary school, time series)" 
label variable mofpc_SLA "month of the reform for changing school leaving age (secondary school, time series)" 
label variable  yearofsch "schooling years according to the level of individual education "
label variable derivedpppincgross_adj "adjusted individual gross income (annual, PPP)"
label variable derivedpppstartgross_adj "adjusted perceived teacher's salary (annual, PPP)"
label variable derivedpppfairgross_adj "adjusted  teacher's fair salary (annual, PPP)"
label variable derivedpppmin "Reservation wage for non-teachers to become teachers, PPP"
label variable derivedpppmin_ter "The leaving reservation wage for teachers to be induced into a different job, PPP"
label variable derivedpppspen_p "Government spending on primary school (annual PPP)"
label variable derivedpppspen_s "Government spending on secondary school (annual PPP)"



*********Create the list of variable we are interested*********
preserve
local keep_vars ROSLA_S LOSSA_P CFYRS_R CFYRS_L YRSAWAY_R YRSAWAY_L /// 
SCH dur_prim dur_sec Uni_dur yearofsch  ///
derivedpppincgross_adj derivedpppstartgross_adj derivedpppfairgross_adj derivedpppmin derivedpppmin_ter ///
derivedpppspen_p derivedpppspen_s ///
SLA_yopc mofpc_SSA mofpc_SSSA mofpc_SLA ///
SSA_old SSA_new SSA_yopc SSSA_old SSSA_new SSSA_yopc SLA_old SLA_new  yob mob mofbirth /// 

descsave `keep_vars', saving(var_list.dta, replace)

use var_list, clear
keep name varlab
rename name variable
rename varlab label_variable
 export excel * using "var_list.xlsx", sheet("var_list")  firstrow(variables) replace

restore
graph close

//keep `keep_vars' market QCDOB AgeInYear
compress /// compress attempts to reduce the amount of memory used by your data /// 
save Varkey_schooling.dta, replace
