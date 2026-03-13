CREATE TABLE staging.exim_authorizations_staging (
    fiscal_year INT,
    unique_identifier VARCHAR(100),
    deal_number VARCHAR(100),
    decision VARCHAR(50),

    decision_date DATE,
    effective_date DATE,
    expiration_date DATE,

    brokered BIT,
    deal_cancelled BIT,

    country VARCHAR(100),
    program VARCHAR(100),
    policy_type VARCHAR(100),

    decision_authority VARCHAR(100),

    primary_export_product_code VARCHAR(100),
    product_description VARCHAR(500),

    term VARCHAR(50),

    primary_applicant VARCHAR(200),
    primary_lender VARCHAR(200),
    primary_exporter VARCHAR(200),

    primary_exporter_city VARCHAR(100),
    primary_exporter_state_code VARCHAR(10),
    primary_exporter_state_name VARCHAR(100),

    primary_borrower VARCHAR(200),

    primary_source_of_repayment VARCHAR(200),

    working_capital_delegated_authority VARCHAR(50),

    -- Spark: double → Warehouse: float
    approved_declined_amount FLOAT,
    disbursed_shipped_amount FLOAT,
    undisbursed_exposure_amount FLOAT,
    outstanding_exposure_amount FLOAT,

    small_business_authorized_amount FLOAT,
    woman_owned_authorized_amount FLOAT,
    minority_owned_authorized_amount FLOAT,

    loan_interest_rate FLOAT,

    multiyear_working_capital_extension VARCHAR(50)
);