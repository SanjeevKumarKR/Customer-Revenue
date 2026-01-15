Create or Replace database SLEEKMART_OMS
Create or Replace Schema SLEEKMART_OMS.L1_Landing

Create or replace STORAGE INTEGRATION my_integration
TYPE= External_stage
storage_provider=s3
Enabled=True
Storage_AWS_ROLE_ARN='arn:aws:iam::145805629089:role/custrevnrole'
STORAGE_ALLOWED_LOCATIONS = ('s3://projectcustrevenue/sourcedata/product/');

--"AWS": "STORAGE_AWS_IAM_USER_ARN_FROM_SNOWFLAKE"  
--"sts:ExternalId": "STORAGE_AWS_EXTERNAL_ID_FROM_SNOWFLAKE"

DESC INTEGRATION my_integration;

CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV' 
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

  show FILE FORMATS;

CREATE OR REPLACE STAGE snowstage
  URL = 's3://projectcustrevenue/sourcedata/product/'
  STORAGE_INTEGRATION = my_integration
  FILE_FORMAT = csv_format;

LIST @snowstage

-- PRODUCTS table
CREATE TABLE IF NOT EXISTS L1_LANDING.product_catalog_ext (
    PRODUCT_ID INTEGER,
    PRODUCT_NAME VARCHAR(100),
    CATEGORY_ID VARCHAR(50),
    CATEGORY_NAME VARCHAR(50),
    SUBCATEGORY_ID VARCHAR(50),
    SUBCATEGORY_NAME VARCHAR(50),
);

COPY INTO product_catalog_ext
FROM @snowstage/product
FILE_FORMAT = csv_format

select * from product


  