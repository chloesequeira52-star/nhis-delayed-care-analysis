/* Mock nhis_raw in place of PROC IMPORT of adult24.csv (not shipped in repo).
   race_eth and education classification below is the author's own, verbatim
   (final versions of each recode). */
data nhis_raw;
    input MHTHDLY_A HICOV_A SEX_A HISPALLP_A RACEALLP_A EDUCP_A;
    datalines;
1 1 1 1 1 1
1 2 2 2 1 2
2 1 1 2 2 3
2 1 2 2 3 4
1 2 2 1 2 5
2 1 1 2 1 6
1 1 2 2 2 2
2 2 1 2 4 3
1 1 1 1 5 4
2 1 2 2 1 5
1 2 1 2 6 6
2 1 2 1 3 1
1 1 1 2 2 2
2 2 2 2 1 3
1 1 2 2 7 4
2 1 1 1 1 5
1 2 2 2 2 6
2 1 1 2 8 2
1 1 2 2 9 3
2 2 1 1 1 4
1 1 1 2 2 5
2 1 2 2 3 6
1 2 1 2 1 1
2 1 2 1 2 2
1 1 1 2 4 3
2 2 2 2 1 4
1 1 2 2 2 5
2 1 1 2 5 6
1 2 2 1 1 2
2 1 1 2 2 3
;
run;

data nhis_clean;
    set nhis_raw;
    if MHTHDLY_A = 1 then delayed_care = 1;
    else if MHTHDLY_A = 2 then delayed_care = 0;
    else delayed_care = .;
run;

data nhis_clean2;
    set nhis_clean;

    length race_eth $20;

    /* Hispanic */
    if HISPALLP_A = 1 then race_eth = "Hispanic";

    /* Everyone else = Non-Hispanic -> classify by race */
    else if HISPALLP_A in (2,3,4,5,6,7) then do;

        if RACEALLP_A = 1 then race_eth = "White";
        else if RACEALLP_A = 2 then race_eth = "Black";
        else if RACEALLP_A in (3,4,5,6,7,8,9) then race_eth = "Other";

    end;

run;
proc freq data=nhis_clean2;
    tables race_eth;
run;

data nhis_final;
    set nhis_clean2;

    /* remove missing / unknown education */
    if EDUCP_A in (7,8,9) then delete;

run;
data nhis_final;
    set nhis_final;

    length education $20;

    if EDUCP_A in (1,2) then education = "HS or less";
    else if EDUCP_A in (3,4) then education = "Some college";
    else if EDUCP_A in (5,6) then education = "College+";

run;
proc freq data=nhis_final;
    tables education;
run;
