/* Mock nhis_raw in place of PROC IMPORT of adult24.csv (not shipped in repo).
   Columns match exactly those the analysis reads. Recode logic below is the
   author's own, verbatim. */
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
