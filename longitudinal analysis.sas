/* creating a natural log transformed variable for 3PBA for pregnacy average concentrations for each trimester */
data biomarkerdata;
set biomarkerdata;
Ln_pest= log(pest);
run;

/* mean, median, and percentile's of pesticide concentrations overall and by trimester*/
proc univariate data=biomarkerdata;
var pest pest_T2 pest_T3;
run;

/*correlation between pesticide concentrations from the 2nd and 3rd pregnancy trimesters*/
proc corr data=biomarkerdata;
var Ln_pest_T2 Ln_pest_T3  ;
run;

/* scatter plot for pesticide concentration from specimens collected in the 2nd and 3rd trimesters of pregnacy*/
SYMBOL1 V=circle C=blue I=r;
TITLE 'Scatterplot - With Regression Line ';
PROC GPLOT DATA=biomarkerdata;
     PLOT Ln_pest_T2*Ln_pest_T3;
RUN;
QUIT; 

/*box plot of pesticide concentrations in each diagnosis group*/
proc boxplot data = biomarkerdata;
  plot ln_pest*dx3/ boxstyle = schematic 
clipsymbol  = dot
clipfactor =2
height=3
;
run;

/* geometric means for pesticide metabolite*/
proc surveymeans data=biomarkerdata ALLGEO ;
var pest ;
run;

/* weighted crude linear regression analyses for association between homeownership and pesticide concentrations*/
proc surveyreg data=biomarkerdata order=freq;
class gender ;
	model ln_pest = homeown /  solution  CLPARM;
	weight weight_var;
	run;
	quit;
    
 /* weighted crude logisict model with analytical weights to test association between 2 level diagnosis and pesticide biomarker concentrations*/
proc surveylogistic data=biomarkerdata;
class dx2 (ref='0')/PARAM=REF ;
model dx2=ln_pest ;
weight weight_var;
run;

/* conditional logistic weighted adjusted for SES and gender*/
proc surveylogistic data =biomarkerdata ;
class dx3 (ref='0') /param = reference  ;
  model dx3 = ln_pest year SES gender / RSQ EXPB;
  strata year;
	weight weight_var;
run;

	/* multinomial regression adjusted for SES and gender with analytica weights*/
proc surveylogistic data=biomarkerdata; 
class dx3 (ref='0') SES gender/param = reference ;
	model dx3 = ln_pest year SES gender /RSQ EXPB  link =glogit COVB ;
	weight weight_var;
	run;
quit;
