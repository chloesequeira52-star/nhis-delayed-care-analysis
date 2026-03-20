# Healthcare Access Disparities Analysis (NHIS 2024)

## Objective
To examine disparities in delayed medical care among U.S. adults using nationally representative NHIS 2024 data.

## Data Source
National Health Interview Survey (NHIS) 2024 adult dataset (n = 16,773 after cleaning).

## Methods
- Cleaned and recoded raw NHIS data in SAS
- Created key variables:
  - Delayed care (binary outcome)
  - Insurance status
  - Race/ethnicity (Hispanic, White, Black, Other)
  - Education (HS or less, Some college, College+)
- Conducted multivariable logistic regression to assess associations

## Key Findings
- Uninsured individuals had over 3 times higher odds of delayed care (OR ≈ 3.23)
- Education was significantly associated with delayed care
- Race/ethnicity was not statistically significant after adjustment

## Tools Used
- SAS (data cleaning, recoding, logistic regression)

## Files
- analysis.sas: full data cleaning and modeling code
