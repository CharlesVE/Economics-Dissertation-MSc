/// This is done half way through the bycountry.do file, AFTER the preserve command /// 

*****************************
* Varkey  Data (Preliminary Check)
* Started May, 2018 
******************************

/****Import the Variables from Excel, and input the data of various countries******/
/// import excel "C:/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Dissertation Teacher/Dissertation MAIN/Fwd_Varkey GTSI/OECD_tax_rate.xlsx", sheet("OECD.Stat export") firstrow allstring clear

import excel "/Users/charlesvalenciaevans/Documents/Sussex University/Dissertation/Main/Dissertation MAIN/Fwd_Varkey GTSI - TAX/OECD_tax_rate.xlsx", sheet("OECD.Stat export") clear 

/*** When I import the excel file, the data is not clean to use. I have to remove some rows which are not relevant, 
 and rename the variables **/
**Construct the variable
drop if _n<=5 |_n==41
rename A market_str
rename D p_allowance
rename F tax_credit
rename H surtax_rate
rename J mr_01
rename L th_01
rename N mr_02
rename P th_02
rename R mr_03
rename T th_03
rename V mr_04
rename X th_04
rename Z mr_05
rename AB th_05
rename AD mr_06
rename AF th_06
rename AH mr_07
rename AJ th_07
rename AL mr_08
rename AN th_08
rename AP mr_09
rename AR th_09
rename AT mr_10
rename AV th_10
rename AX mr_11
rename AZ th_11
rename BB mr_12
rename BD th_12


label variable mr_01 "Marginal rate"
label variable th_01 "Threshold (upper bound)"
label variable p_allowance "Personal Allowance"
label variable tax_credit "tax_credit"

/**Keep the variables that we are interested in, and convert the string variables to numerical variables **/
keep market_str p_allowance tax_credit th_* mr_* 
destring p_allowance tax_credit th_* mr_* , replace force


/**Manually type in the data of various countries. "mr _" stands for the marginal tax rate.  "th _" stands for the threshold of each band/bracket of tax. **/
** Argentina
       local new = _N + 1
        set obs `new'
replace market_str ="Argentina" in l
replace p_allowance= 0  in l

replace mr_01= 5 in l
replace mr_02= 9 in l
replace mr_03= 12 in l
replace mr_04= 15 in l
replace mr_05= 19 in l
replace mr_06= 23 in l
replace mr_07= 27 in l
replace mr_08= 31 in l
replace mr_09= 35 in l


replace th_01= 25754  in l
replace th_02= 51508  in l
replace th_03= 77262 in l
replace th_04= 103016 in l
replace th_05= 154524 in l
replace th_06= 206032 in l
replace th_07= 309048 in l
replace th_08= 412064 in l


** Brazil
       local new = _N + 1
        set obs `new'
replace market_str ="Brazil" in l

replace p_allowance= 0  in l
replace mr_01= 0 in l
replace mr_02= 7.5 in l
replace mr_03= 15 in l
replace mr_04= 22.5 in l
replace mr_05= 27.5 in l

replace th_01= 1903.98  in l
replace th_02= 2826.65  in l
replace th_03= 3751.05 in l
replace th_04= 4664.67 in l

** Egypt
       local new = _N + 1
        set obs `new'
replace market_str ="Egypt" in l
replace p_allowance= 0  in l
replace mr_01= 0 in l
replace mr_02= 10 in l
replace mr_03= 15 in l
replace mr_04= 20 in l
replace mr_05= 22.5 in l

replace th_01= 7200  in l
replace th_02= 30000  in l
replace th_03= 45000 in l
replace th_04= 200000 in l

** Ghana
       local new = _N + 1
        set obs `new'
replace market_str ="Ghana" in l
replace p_allowance= 0  in l
replace mr_01= 0 in l
replace mr_02= 5 in l
replace mr_03= 10 in l
replace mr_04= 17.5 in l
replace mr_05= 25 in l

replace th_01= 3132  in l
replace th_02= 3972  in l
replace th_03= 5172 in l
replace th_04= 38892 in l

** Peru
       local new = _N + 1
        set obs `new'
replace market_str ="Peru" in l
replace p_allowance= 0   in l
replace mr_01= 8 in l
replace mr_02= 14 in l
replace mr_03= 17 in l
replace mr_04= 20 in l
replace mr_05= 30 in l

replace th_01= 20750  in l
replace th_02= 83000  in l
replace th_03= 145250 in l
replace th_04= 186750 in l

** Malaysia
       local new = _N + 1
        set obs `new'
replace market_str ="Malaysia" in l
replace p_allowance= 0   in l
replace mr_01= 0 in l
replace mr_02= 1 in l
replace mr_03= 5 in l
replace mr_04= 10 in l
replace mr_05= 16 in l
replace mr_06= 21 in l
replace mr_07= 24 in l
replace mr_08= 24.5 in l
replace mr_09= 25 in l
replace mr_10= 26 in l
replace mr_11= 28 in l

replace th_01= 5000  in l
replace th_02= 20000  in l
replace th_03= 35000 in l
replace th_04= 50000 in l
replace th_05= 70000  in l
replace th_06= 100000  in l
replace th_07= 250000 in l
replace th_08= 400000 in l
replace th_09= 600000  in l
replace th_10= 1000000  in l

** Panama
       local new = _N + 1
        set obs `new'
replace market_str ="Panama" in l
replace p_allowance= 0   in l
replace mr_01= 0 in l
replace mr_02= 15 in l
replace mr_03= 25 in l

replace th_01= 11000  in l
replace th_02= 50000  in l

** Russia
       local new = _N + 1
        set obs `new'
replace market_str ="Russia" in l
replace p_allowance= 0   in l
replace mr_01= 13 in l

** Singapore
       local new = _N + 1
        set obs `new'
replace market_str ="Singapore" in l
replace p_allowance= 0   in l
replace mr_01= 0 in l
replace mr_02= 2 in l
replace mr_03= 3.5 in l
replace mr_04= 7 in l
replace mr_05= 11.5 in l
replace mr_06= 15 in l
replace mr_07= 18 in l
replace mr_08= 19 in l
replace mr_09= 19.5 in l
replace mr_10= 20 in l
replace mr_11= 22 in l

replace th_01= 20000  in l
replace th_02= 30000  in l
replace th_03= 40000 in l
replace th_04= 80000 in l
replace th_05= 120000  in l
replace th_06= 160000  in l
replace th_07= 200000 in l
replace th_08= 240000 in l
replace th_09= 280000  in l
replace th_10= 320000  in l

** China
/** The information of China taxation is based on monthly payment, not yearly payment. The monthly tax exception is 3500 yun.
I multiply 3500 with 12 month, which is 42000, in order to fit the structure of this dataset. 
The threshold has been converted into yearly payment as well  **/
       local new = _N + 1
        set obs `new'
replace market_str ="China" in l
replace p_allowance= 0+42000   in l

replace mr_01= 3 in l
replace mr_02= 10 in l
replace mr_03= 20 in l
replace mr_04= 25 in l
replace mr_05= 30 in l
replace mr_06= 35 in l
replace mr_07= 40 in l

replace th_01= 18000+42000  in l 
replace th_02= 54000+42000  in l
replace th_03= 108000+42000 in l
replace th_04= 420000+42000 in l
replace th_05= 660000+42000  in l
replace th_06= 960000+42000  in l

** Colombia
       local new = _N + 1
        set obs `new'
replace market_str ="Colombia" in l
replace p_allowance= 0   in l
 
replace mr_01= 0 in l
replace mr_02= 19 in l
replace mr_03= 28 in l
replace mr_04= 33 in l

replace th_01= 36140040  in l
replace th_02= 56365200  in l
replace th_03= 135939600  in l

** India
       local new = _N + 1
        set obs `new'
replace market_str ="India" in l
replace p_allowance= 0   in l
replace mr_01= 0 in l
replace mr_02= 5 in l
replace mr_03= 20 in l
replace mr_04= 30 in l


replace th_01= 250000  in l
replace th_02= 500000  in l
replace th_03= 1000000  in l

** Indonesia
       local new = _N + 1
        set obs `new'
replace market_str ="Indonesia" in l
replace p_allowance= 0   in l
replace mr_01= 5 in l
replace mr_02= 15 in l
replace mr_03= 25 in l
replace mr_04= 30 in l

replace th_01= 50000000  in l
replace th_02= 250000000  in l
replace th_03= 500000000  in l

** Taiwan
       local new = _N + 1
        set obs `new'
replace market_str ="Taiwan" in l
replace p_allowance= 0+90000   in l
replace mr_01= 5 in l
replace mr_02= 12 in l
replace mr_03= 20 in l
replace mr_04= 30 in l
replace mr_05= 40 in l
replace mr_06= 45 in l

replace th_01= 540000  in l
replace th_02= 1210000  in l
replace th_03= 2420000  in l
replace th_04= 4530000  in l
replace th_05= 10310000 in l

** Uganda
       local new = _N + 1
        set obs `new'
replace market_str ="Uganda" in l
replace p_allowance= 0   in l
replace mr_01= 0 in l
replace mr_02= 10 in l
replace mr_03= 20 in l
replace mr_04= 30 in l
replace mr_05= 40 in l

replace th_01= 2820000  in l
replace th_02= 4020000  in l
replace th_03= 4920000  in l
replace th_04= 120000000  in l



/** The market of "example " is to illustrate the case in the excel file(tax_rate_v4_example)**/
** Example
       local new = _N + 1
        set obs `new'
replace market_str ="Example" in l
replace p_allowance= 0   in l

replace mr_01= 0 in l
replace mr_02= 10 in l
replace mr_03= 12 in l
replace mr_04= 15 in l
replace mr_05= 18 in l
replace mr_06= 20 in l
replace mr_07= 23 in l

replace th_01= 20000  in l
replace th_02= 50000  in l
replace th_03= 70000  in l
replace th_04= 100000  in l
replace th_05= 150000  in l
replace th_06= 400000  in l


/**Generate the variable of market in order to merge this tax rate with the Varkey 2018 dataset********/
replace market_str = market_str + " "
gen market =.
replace market = 1 if market_str =="Argentina "
replace market = 2 if market_str =="Brazil "
replace market = 3 if market_str =="Canada "
replace market = 4 if market_str =="Chile "
replace market = 5 if market_str =="China "
replace market = 6 if market_str =="Colombia "
replace market = 7 if market_str =="Czech Republic "
replace market = 8 if market_str =="Egypt "
replace market = 9 if market_str =="Finland "
replace market = 10 if market_str =="France "
replace market = 11 if market_str =="Germany "
replace market = 12 if market_str =="Ghana "
replace market = 13 if market_str =="Greece "
replace market = 14 if market_str =="Hungary "
replace market = 15 if market_str =="India "
replace market = 16 if market_str =="Indonesia "
replace market = 17 if market_str =="Israel "
replace market = 18 if market_str =="Italy "
replace market = 19 if market_str =="Japan "
replace market = 20 if market_str =="Korea "
replace market = 21 if market_str =="Malaysia "
replace market = 22 if market_str =="Netherlands "
replace market = 23 if market_str =="New Zealand "
replace market = 24 if market_str =="Panama "
replace market = 25 if market_str =="Peru "
replace market = 26 if market_str =="Portugal "
replace market = 27 if market_str =="Russia "
replace market = 28 if market_str =="Singapore "
replace market = 29 if market_str =="Spain "
replace market = 30 if market_str =="Switzerland "
replace market = 31 if market_str =="Taiwan "
replace market = 32 if market_str =="Turkey "
replace market = 33 if market_str =="Uganda "
replace market = 34 if market_str =="United Kingdom "
replace market = 35 if market_str =="United States "

/** Convert the variable of marginal tax rate into % **/
replace mr_01=mr_01/100
replace mr_02=mr_02/100
replace mr_03=mr_03/100
replace mr_04=mr_04/100
replace mr_05=mr_05/100
replace mr_06=mr_06/100
replace mr_07=mr_07/100
replace mr_08=mr_08/100
replace mr_09=mr_09/100
replace mr_10=mr_10/100
replace mr_11=mr_11/100
replace mr_12=mr_12/100


sort market
/**In the OECD data set, the missing value of personal allowance and tax credit means that there is no personal allowance or tax credit**/
replace p_allowance=0 if p_allowance==.
replace tax_credit=0 if tax_credit==.
/*Save the market that we are interested*/


keep if market!=.
save tax_rate_varkey.dta, replace
