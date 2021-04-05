# Economics-Dissertation
Here I provide all the code required to create my variables for my economics dissertation in Stata. It was sent back and forth between myself and NIESR (National Institute of Economic and Social Research) since we were both doing research in the same field and as such worked together to complete this code. 

Note, that all code provided was intended for only myself to read as it was not part of the marked section of my dissertation. 
As such, not all code will be immediately obvious as to what its purpose is. 
Furthermore, the code is not a true reflection of how legible all future projects of mine shall be to a third party.

My Economics dissertation was regarding the rate of return to an additional year of schooling around the world. 
There were two variables that needed to be created: the years of schooling and the income.

The income was the gross derived purchasing power parity (ppp) income to be precise. 
That is, the incomes were generated all into annual income and then converted into dollars so as to make them comparable. 
They were also converted into gross income so as to make them more comparable so that the different tax rates respective to each country would not bias my results.

The ‘years of schooling’ variable was constructed using a ROSLA and LOSSA method.

All data came from Varkey and upon my dissertation advisor's request I am unable to publish it. 

/*******************************************************************************************

Calculating the Years of Schooling from the SLA and the SSA

Should you require it, here is an excerpt from my dissertation outlining more specifically how to calculate my variables. 
SLA = School Leaving Age
SSA = School Starting Age

After this whole procedure of extracting the SLA and SSA data points across time for each country, we can finally create the years of schooling. The first stage of which is to transform the time series data into another dataset prior to merging it with the Varkey data. After having merged the data, any countries that have a double ROSLA or LOSSA have their data adjusted accordingly. To understand the logic that follows I recommend you ignore the fact that some countries have multiple ROSLA or LOSSA until the end where it will be explained. 

The first set of time series data simply explains for each country what the SLA and SSA laws are for each year. That is, each row is a country in a specific year and shows that country’s laws regarding SLA, SSA and SSSA in that specific year.  We shall call this first dataset the law-year dataset, since it describes the compulsory schooling laws for each country in each year. 

However, let us consider an example. Let us say that in our country x in the year 2000 it states that the SSA and SLA are 6 and 15 respectively, making the compulsory years of schooling 9 years. However, for the birth cohort of those born on that year, we do not know if the SSA will change before they’re 6 or if the SLA will change before they’re 15. Therefore, we are unable to say simply that just because someone is born in the year 2000 that the mandatory schooling laws of that same year will apply to them when they come to be of the relevant ages. As such an algorithm was designed to circumvent this problem. 

In order to begin this algorithm, a second dataset was created that we shall call the ROSLA-LOSSA dataset, or RL dataset for short. This RL dataset contained ten new variables. Those variables were: the new SLA (the school leaving age after reform), the old SLA (the school leaving age before reform), the new SSA (the school starting age after reform), the old SSA (the school starting age before reform), the new SSSA (the secondary school starting age after the reform), the old SSSA (the secondary school starting age before the reform), SLA_YOPC, SSA_YOPC, SSSA_YOPC and the number of years university lasts. Each row represented a different country’s, or region’s, values for each of the variables specified above. This removed the time series element from it since there would now only be one row per country or region and no longer multiple rows to indicate the same country at different points in time. The YOPC variables simply refer to the specific year in which a ‘year of policy change’ occurred. All of these variables vary by country and as such every row for each country, and in some cases regions, were different.

Let us take an example in order to illustrate this problem with improved clarity, since it can easily become convoluted. For the example of China, it had 1 ROSLA and 1 LOSSA. The ROSLA occurred in 2012 shifting the SLA from 14 to 15, whereas the LOSSA occurred in 2004 shifting the SSA from 7 to 6. Therefore, for the 1st dataset, the law-year dataset, we would be able to see across time the shift as each row shows China’s schooling laws in that given year. By contrast, the 2nd dataset, the RL dataset, would simply show one row for china and the variables just specified in the paragraph prior would read: new SLA=15, old SLA=14, SLA_YOPC=2012. The same logic would apply to the SSA. As for the SSSA since it remained the same throughout the dataset so the new and old SSSA would be the same, both reading 12 and the SSSA_YOPC would be blank since there was no year of price change. 

Once the RL dataset was complete it could be merged with the Varkey data. Therefore each row would now represent an individual for a given country, instead of just a country. Each row would show, for a given individual in a given country or region, what the new and old SLA was and the year in which it occurred. The same existed for the SSA and SSSA of course. 

I also calculated for each SLA or SSA change the birth cohort that would have been affected. We shall call this variable BC. Using China as an example, the BC would be calculated by: SLA_YOPC-SLA_old. That would be 2012-14=1998, month 9. The reason being that this would be the first birth cohort to be directly affected by the SLA change. Therefore all those born between 1998, month 9, up to and including 1999, month 8, would be the birth cohort affected. 

At this point I set up the time series variable of monthly and annual time series in order to identify whether the participant were affected by the reform using their date of birth. 
Note that time series was only necessary in order to create my years of schooling variable. Once it was created all data could be considered cross sectional from then on. 

Just prior to the introduction of our ROSLA and LOSSA dummy variables, I readjusted the values of each policy change for those countries affected by multiple ROSLA or LOSSA. By way of illustration I shall use another example, that being of Portugal. In Portugal there were 2 SLA changes, the latest one being in 2014 shifting the SLA from 16 to 18. The SLA change prior was in 1973 shifting the SLA from 14 to 16. From here I would calculate the respective birth cohorts that were BC1: 1998 (2014-16) and BC2: 1959 (1973-14). That is to say that all those born between 1959 and 1997 would have their new SLA value set to 16 and the old SLA value set to 14. Whereas all those born after 1998 would have their old SLA value set to 16 and their new SLA value set to 18.  This adjustment would be made by comparing the birth cohort to the monthly and annual time series of their date of birth mentioned earlier. That is to say, for all those with a date of birth that is later than the latest birth cohort for the latest SLA change would have their SLA new and old set to a different value to those with a date of birth that is lower than the latest SLA birth cohort. 

It is as this point that we introduce the new dummy variables, those being: ROSLA_S (the secondary raising of school leaving age dummy) & LOSSA_P (the lowering of school starting age dummy). It should be noted that for the years of schooling calculation and later for my IV these dummies, due to serving different purposes are set differently. 

In the Portuguese example, for all those born after BC1 would have a ROSLA=0. All those born within the year affected by the SLA change would have a ROSLA=1.  Note that we assumed for all countries that the academic year ran from the 9th month until the 8th month of the subsequent year, an assumption made due to time constraints. All those born between BC1 and BC2 would have a ROSLA=0, however all those born before the earliest birth cohort, BC2, would have a ROSLA that was set to a full stop. The ROSLA set to a full stop was used in aid of calculating the years of schooling. When the ROSLA was used for IV later, all those with a value of a full stop were replaced with a zero. 

The same logic was applied to LOSSA. The only difference being when calculating the BC’s affected by the LOSSA change it would simply be the new SSA subtracted from the YOPC. The logic being that you always want to subtract the smaller age from the YOPC since that will reflect the birth cohort that is first affected by the policy change. 

Two more variables were calculated prior to the calculation of years of schooling, those being: Years Away (YRSAWAY) & Counterfactual years of education (CFYRS). 
The YRSAWAY were calculated simply being subtracting the difference between the year of birth and BC year. 
The CFYRS showed how many less or more years of schooling a person would have had if they had, or had not, been affected by the reform(s) depending on if they were or were not already affected. The YRSAWAY shows how many complete years older (+) or younger (-) a participant would have had to be in or ROSLA or LOSSA birth cohort. The CFYRS were simply calculated by subtracting the old SLA from the new SLA or vice versa depending on what side of the BC a participant laid, the same could be said of the SSA too. 

Prior to calculating the years of schooling we first had to calculate the compulsory years of schooling for each individual, depending on which country and birth cohort they belonged to. When calculating it, it had to be done for all the different groupings of which there were nine. This would depend on whether or not an individual was affected directly, indirectly or not at all by the ROSLA and LOSSA. Through subtracting the SSA new from the SLA new, in the case that they were affected by both the ROSLA and LOSSA, or some different combination of old and new SSA and SLA I was able to calculate the years of schooling for every participant that answered the question in the Varkey questionnaire specifying their highest level of educational attainment. 

Subsequently the years of primary school and the years of secondary school had to be calculated. I took the SSSA as the end point of primary school and utilising the SSSA’s and SSA’s for both new and old was able to calculate the years of primary school depending on what side of reform someone’s birth cohort fell into. This same process was repeated for the duration of secondary school only the SSSA marked the beginning rather than the end of this unit of education of course. 

The Varkey questionnaire, upon asking what someone’s highest level of educational attainment was had seven answers those being: (1) Primary School, (2) Secondary school, (3) High school, (4) University degree, (5) Higher academic degree, (6) Formal Professional qualification, (7) Still in full time education & (8) Not applicable - I have no formal education. The years of education had to be calculated for all cases. The first three were simple, as we would simply sum the units of education that we calculated earlier. Given that the Varkey data came with university education years for each respective country this made our calculations even simpler as I could simply add the duration of university to the other educational unit durations to make up the years of schooling for someone who answered that their highest level of educational attainment was university. 

For answers (5) and (6) some assumptions had to be made. That is, for someone with a higher academic degree I assumed they attended an additional 4 years of education above those of category (3). Of course this will vary between countries however due to the lack of specificity of the answer it would be impossible to calculate regardless since some of those answering (5) will have a master’s degree will others will have a PhD. 
For those who answered (6), again due to the lack of specificity in the answer available I was forced to assume that those who answered it attended an additional 2 years of education on top of category (3). Of course these assumptions shall add measurement error since they are only approximations at best. 

For those who answered (7), still in full time education, I calculated two different answers depending on which BC they fell into with regard to the SSA change. In both cases it was the difference between the respective SSA, depending on which BC they fell into, and their age. 
As for those that specified (8) we have assumed that their level of education is equal to that of group (1), in other words they have at least attended primary school. 
