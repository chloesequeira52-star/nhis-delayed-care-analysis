proc import datafile="/home/u64136090/sasuser.v94/adult24.csv"
    out=nhis_raw
    dbms=csv
    replace;
    guessingrows=1000;
run;
proc contents data=nhis_raw;
run;
data nhis_clean;
    set nhis_raw;

    /* Outcome: delayed mental health care due to cost */
    if MHTHDLY_A = 1 then delayed_care = 1;
    else if MHTHDLY_A = 2 then delayed_care = 0;
    else delayed_care = .;

    /* Insurance */
    if HICOV_A = 1 then insured = 1;
    else if HICOV_A = 2 then insured = 0;
    else insured = .;

    /* Sex */
    if SEX_A = 1 then sex = "Male";
    else if SEX_A = 2 then sex = "Female";
    else sex = "";

run;
proc freq data=nhis_clean;
    tables delayed_care insured sex;
run;
data nhis_clean2;
    set nhis_clean;

    length race_eth $20;

    /* Hispanic takes priority */
    if HISPALLP_A = 1 then race_eth = "Hispanic";

    else if HISPALLP_A = 2 then do;
        if RACEALLP_A = 1 then race_eth = "White";
        else if RACEALLP_A = 2 then race_eth = "Black";
        else if RACEALLP_A in (3,4,5,6,7) then race_eth = "Other";
        else race_eth = "";
    end;

run;
proc freq data=nhis_clean2;
    tables race_eth;
run;
proc freq data=nhis_raw;
    tables RACEALLP_A;
run;
data nhis_clean2;
    set nhis_clean;

    length race_eth $20;

    /* Hispanic takes priority */
    if HISPALLP_A = 1 then race_eth = "Hispanic";

    else if HISPALLP_A = 2 then do;
        if RACEALLP_A = 1 then race_eth = "White";
        else if RACEALLP_A = 2 then race_eth = "Black";
        else if RACEALLP_A in (3,4,5,6,7,8,9) then race_eth = "Other";
        else race_eth = "";
    end;

run;
proc freq data=nhis_clean2;
    tables race_eth;
run;
proc freq data=nhis_raw;
    tables RACEALLP_A;
run;

proc freq data=nhis_clean;
    tables RACEALLP_A;
run;
proc freq data=nhis_clean;
    tables HISPALLP_A;
run;
data nhis_clean2;
    set nhis_clean;

    length race_eth $20;

    /* Hispanic */
    if HISPALLP_A = 1 then race_eth = "Hispanic";

    /* Everyone else = Non-Hispanic → classify by race */
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

    length education $20;

    if EDUCP_A in (1,2) then education = "HS or less";
    else if EDUCP_A = 3 then education = "Some college";
    else if EDUCP_A in (4,5) then education = "College+";

run;
proc freq data=nhis_final;
    tables education;
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
proc logistic data=nhis_final descending;

    class insured (ref="1")
          race_eth (ref="White")
          education (ref="College+")
          / param=ref;

    model delayed_care =
        insured
        race_eth
        education;

run;
proc freq data=nhis_final;
    tables delayed_care;
run;