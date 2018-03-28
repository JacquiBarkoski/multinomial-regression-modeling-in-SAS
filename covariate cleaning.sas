
/* frequency of covariates*/
proc freq data=demog;
tables
prepregBMI
prepregBMIcat
homeown
childraceeth
momedu_detail
dadedu_detail
run;


data demog;
set demog;
MaxEdu = MAX(MomEdu_detail, DadEdu_detail);
if MomEdu_detail =. or DadEdu_detail =. then MaxEdu=.; run;

*
0 = No formal education
1 = 8th grade or less
2 = 9th through 12th grade – no diploma
3 = High school diploma or GED
4 = Some college credit – no degree
5 = Associate’s, Tech, or Vocational degree
6 = Bachelor’s degree
7 = Master’s degree
8 = Doctorate or Professional degree;


/* creating 5 level max education*/
data demog;
set demog;
if Maxedu =. then maxedu5 =.;
if maxedu in (0 1 2) then maxedu5 =1;/*less than HS*/
if maxedu =3 then maxedu5 =2; /*HS/GED*/
if maxedu in (4 5) then maxedu5 =3; /* some college or associates degree */
if maxedu =6 then maxedu5 =4; /* BS*/
if maxedu in (7 8) then maxedu5 =5; /* grad/prof*/
proc freq data=demog;
tables MaxEdu*maxedu5/missing;
run;

/* creating 3 level max education*/
data demog;
set demog;
if Maxedu =. then maxedu3 =.;
if maxedu in(2 3 4 5) then maxedu3 =1;/*less than HS, HS/GED, some college or associates deegree - label as some college or less*/
if maxedu =6 then maxedu3 =2; /*BS (college degree)*/
if maxedu in (7 8) then maxedu3 =3; run; /* graduate/professional degree*/
proc freq data=demog;
tables MaxEdu*maxedu3 dx_alg*maxedu3 dx_alg*maxedu5 MaxEdu maxedu3 maxedu5 /missing;
run;

data demog;
set demog;
if prepregBMIcat = . then prepregBMIcat2=.;
if prepregBMIcat = 1 or prepregBMIcat=2 then prepregBMIcat2=0 ;
if prepregBMIcat = 3 then prepregBMIcat2=1 ;
if prepregBMIcat = 4 then prepregBMIcat2=2 ; run; 
/* checking new varibles and missing*/
proc freq data=demog;
tables prepregBMIcat2*prepregBMIcat / missing;
run;


data demog;
set demog;
if month_conception >=5 and month_conception <= 10 then season2_conception = 1; /*WARM*/
if month_conception >=11 then  season2_conception = 0;
if month_conception >=1 and month_conception <= 4 then season2_conception=0; /* COLD*/
if month_conception >=11 then season3_conception = 0; /*winter*/
if month_conception <= 2 then season3_conception = 0; /*winter*/
if month_conception >=3 and month_conception <=6 then  season3_conception = 1; /*spring*/
if month_conception >=7 and month_conception <= 10 then season3_conception=2; run;/* summer*/

/* checking new varibles and missing*/
proc freq data=demog;
tables month_conception*season2_conception  month_conception*season3_conception/ missing;
run;

1='US - CA' 
2='US - other' 
3='US - unspecified'
4='Outside US - Mexico' 
5='Outside US - other' 
6='Outside US - unspecified';

data demog;
set demog;
if mombirthplace = . then mombirth2 =. and mombirth3= .;
if mombirthplace in(1 2 3) then mombirth2 =0; 
if mombirthplace in(4 5 6) then mombirth2 =1; 
if mombirthplace in(2 3) then mombirth3 =0; 
if mombirthplace =1 then mombirth3 =1; 
if mombirthplace in(4 5 6) then mombirth3 =2; 
run;

/* checking new varibles and missing*/
proc freq data=demog;
tables mombirthplace*mombirth3 mombirthplace*mombirth2 / missing;
run;

/* export file new variables into an excel file */
data education_vars;
set demog (KEEP=  coi_ID momedu_detail dadedu_detail EQ1P02Q14fthedulev EQ1P02Q07mthedulev MaxEdu );
run;

proc export data=education_vars
    outfile="R:\folder name \newdata.csv"
    dbms=csv
    replace;
run;







