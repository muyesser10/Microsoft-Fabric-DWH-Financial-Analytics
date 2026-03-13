INSERT INTO staging.exim_authorizations_staging
SELECT
fiscal_year,
unique_identifier,
deal_number,
decision,
decision_date,
effective_date,
expiration_date,
brokered,
deal_cancelled,
country,
program,
policy_type,
decision_authority,
primary_export_product_code,
product_description,
term,
primary_applicant,
primary_lender,
primary_exporter,
primary_exporter_city,
primary_exporter_state_code,
primary_exporter_state_name,
primary_borrower,
primary_source_of_repayment,
working_capital_delegated_authority,

TRY_CAST(approved_declined_amount AS FLOAT),
TRY_CAST(disbursed_shipped_amount AS FLOAT),
TRY_CAST(undisbursed_exposure_amount AS FLOAT),
TRY_CAST(outstanding_exposure_amount AS FLOAT),

TRY_CAST(small_business_authorized_amount AS FLOAT),
TRY_CAST(woman_owned_authorized_amount AS FLOAT),
TRY_CAST(minority_owned_authorized_amount AS FLOAT),

TRY_CAST(loan_interest_rate AS FLOAT),

multiyear_working_capital_extension

FROM exim_lakehouse.dbo.clean_exim_data;