-- ============================================================
-- ORACLE SQL SEQUENCES - BANKING MANAGEMENT SYSTEM
-- ============================================================
-- EXAMPLE 1: Customer ID Sequence
-- EXAMPLE 2: Bank Account ID Sequence
-- EXAMPLE 3: Transaction ID Sequence
-- EXAMPLE 4: Loan ID Sequence
-- EXAMPLE 5: NEXTVAL and CURRVAL
-- EXAMPLE 6: INCREMENT BY
-- EXAMPLE 7: CACHE and NOCACHE
-- EXAMPLE 8: CYCLE and NOCYCLE
-- EXAMPLE 9: ALTER SEQUENCE
-- EXAMPLE 10: DROP SEQUENCE
-- ============================================================


-- ============================================================
-- STEP 1: CREATE BANK CUSTOMER TABLE
-- ============================================================

CREATE TABLE BANK_CUSTOMERS (

    CUSTOMER_ID NUMBER PRIMARY KEY,       -- Unique customer ID

    CUSTOMER_NAME VARCHAR2(100),          -- Customer full name

    MOBILE_NUMBER VARCHAR2(15),           -- Customer mobile number

    CITY VARCHAR2(50),                    -- Customer city

    CREATED_DATE DATE DEFAULT SYSDATE     -- Customer registration date

);


-- ============================================================
-- EXAMPLE 1: CREATE CUSTOMER ID SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Every new bank customer should receive a unique customer ID.
-- Customer IDs start from 1001 and increase by 1.
-- ============================================================

CREATE SEQUENCE SEQ_CUSTOMER_ID

START WITH 1001        -- First generated customer ID

INCREMENT BY 1         -- Increase ID by 1

MINVALUE 1001          -- Minimum sequence value

MAXVALUE 999999        -- Maximum sequence value

NOCYCLE                -- Do not restart after maximum

NOCACHE;               -- Do not preallocate sequence numbers


-- ============================================================
-- INSERT CUSTOMER RECORDS USING NEXTVAL
-- ============================================================

-- Generate customer ID 1001
INSERT INTO BANK_CUSTOMERS
(CUSTOMER_ID, CUSTOMER_NAME, MOBILE_NUMBER, CITY)
VALUES
(SEQ_CUSTOMER_ID.NEXTVAL, 'Rahul', '9876543210', 'Bangalore');


-- Generate customer ID 1002
INSERT INTO BANK_CUSTOMERS
(CUSTOMER_ID, CUSTOMER_NAME, MOBILE_NUMBER, CITY)
VALUES
(SEQ_CUSTOMER_ID.NEXTVAL, 'Priya', '9876543211', 'Hyderabad');


-- Generate customer ID 1003
INSERT INTO BANK_CUSTOMERS
(CUSTOMER_ID, CUSTOMER_NAME, MOBILE_NUMBER, CITY)
VALUES
(SEQ_CUSTOMER_ID.NEXTVAL, 'Amit', '9876543212', 'Chennai');


-- Save customer records
COMMIT;


-- Display all customers
SELECT * FROM BANK_CUSTOMERS;


-- ============================================================
-- EXPECTED OUTPUT
-- ============================================================
-- CUSTOMER_ID | CUSTOMER_NAME | CITY
-- 1001        | Rahul         | Bangalore
-- 1002        | Priya         | Hyderabad
-- 1003        | Amit          | Chennai
-- ============================================================


-- ============================================================
-- STEP 2: CREATE BANK ACCOUNTS TABLE
-- ============================================================

CREATE TABLE BANK_ACCOUNTS (

    ACCOUNT_ID NUMBER PRIMARY KEY,        -- Unique account ID

    CUSTOMER_ID NUMBER,                   -- Customer owning account

    ACCOUNT_TYPE VARCHAR2(20),            -- SAVINGS or CURRENT

    BALANCE NUMBER(12,2),                 -- Available balance

    STATUS VARCHAR2(20),                  -- Account status

    CONSTRAINT FK_BANK_CUSTOMER
    FOREIGN KEY (CUSTOMER_ID)
    REFERENCES BANK_CUSTOMERS(CUSTOMER_ID)

);


-- ============================================================
-- EXAMPLE 2: BANK ACCOUNT NUMBER SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Automatically generate unique bank account IDs.
-- Account IDs start from 500001.
-- ============================================================

CREATE SEQUENCE SEQ_ACCOUNT_ID

START WITH 500001       -- First account ID

INCREMENT BY 1          -- Increase by 1

MINVALUE 500001         -- Minimum account ID

MAXVALUE 999999999      -- Maximum account ID

NOCYCLE                 -- Never restart automatically

CACHE 20;               -- Preallocate up to 20 sequence values


-- ============================================================
-- INSERT BANK ACCOUNTS
-- ============================================================

-- Create Rahul's savings account
INSERT INTO BANK_ACCOUNTS
(ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE, STATUS)
VALUES
(SEQ_ACCOUNT_ID.NEXTVAL, 1001, 'SAVINGS', 10000, 'ACTIVE');


-- Create Priya's savings account
INSERT INTO BANK_ACCOUNTS
(ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE, STATUS)
VALUES
(SEQ_ACCOUNT_ID.NEXTVAL, 1002, 'SAVINGS', 20000, 'ACTIVE');


-- Create Amit's current account
INSERT INTO BANK_ACCOUNTS
(ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE, STATUS)
VALUES
(SEQ_ACCOUNT_ID.NEXTVAL, 1003, 'CURRENT', 50000, 'ACTIVE');


-- Save account records
COMMIT;


-- Display bank accounts
SELECT * FROM BANK_ACCOUNTS;


-- ============================================================
-- EXPECTED OUTPUT
-- ============================================================
-- ACCOUNT_ID | CUSTOMER_ID | ACCOUNT_TYPE | BALANCE
-- 500001     | 1001        | SAVINGS      | 10000
-- 500002     | 1002        | SAVINGS      | 20000
-- 500003     | 1003        | CURRENT      | 50000
-- ============================================================


-- ============================================================
-- STEP 3: CREATE BANK TRANSACTIONS TABLE
-- ============================================================

CREATE TABLE BANK_TRANSACTIONS (

    TRANSACTION_ID NUMBER PRIMARY KEY,   -- Unique transaction ID

    ACCOUNT_ID NUMBER,                   -- Account involved

    TRANSACTION_TYPE VARCHAR2(20),       -- DEPOSIT or WITHDRAWAL

    AMOUNT NUMBER(12,2),                 -- Transaction amount

    TRANSACTION_DATE DATE DEFAULT SYSDATE,

    CONSTRAINT FK_BANK_TRANSACTION_ACCOUNT
    FOREIGN KEY (ACCOUNT_ID)
    REFERENCES BANK_ACCOUNTS(ACCOUNT_ID)

);


-- ============================================================
-- EXAMPLE 3: TRANSACTION ID SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Each deposit or withdrawal receives a unique transaction ID.
-- IDs start from 900001.
-- ============================================================

CREATE SEQUENCE SEQ_TRANSACTION_ID

START WITH 900001       -- First transaction ID

INCREMENT BY 1          -- Increase by 1

MINVALUE 900001         -- Minimum transaction ID

NOCYCLE                 -- Do not restart sequence

CACHE 50;               -- Preallocate sequence values


-- ============================================================
-- INSERT BANK TRANSACTIONS
-- ============================================================

-- Record Rahul's deposit of 5000
INSERT INTO BANK_TRANSACTIONS
(TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_TYPE, AMOUNT)
VALUES
(SEQ_TRANSACTION_ID.NEXTVAL, 500001, 'DEPOSIT', 5000);


-- Record Priya's withdrawal of 3000
INSERT INTO BANK_TRANSACTIONS
(TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_TYPE, AMOUNT)
VALUES
(SEQ_TRANSACTION_ID.NEXTVAL, 500002, 'WITHDRAWAL', 3000);


-- Record Amit's deposit of 10000
INSERT INTO BANK_TRANSACTIONS
(TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_TYPE, AMOUNT)
VALUES
(SEQ_TRANSACTION_ID.NEXTVAL, 500003, 'DEPOSIT', 10000);


-- Save transaction records
COMMIT;


-- Display transaction history
SELECT * FROM BANK_TRANSACTIONS;


-- ============================================================
-- EXPECTED OUTPUT
-- ============================================================
-- TRANSACTION_ID | ACCOUNT_ID | TYPE       | AMOUNT
-- 900001         | 500001     | DEPOSIT    | 5000
-- 900002         | 500002     | WITHDRAWAL | 3000
-- 900003         | 500003     | DEPOSIT    | 10000
-- ============================================================


-- ============================================================
-- STEP 4: CREATE BANK LOANS TABLE
-- ============================================================

CREATE TABLE BANK_LOANS (

    LOAN_ID NUMBER PRIMARY KEY,           -- Unique loan ID

    CUSTOMER_ID NUMBER,                   -- Borrower customer ID

    LOAN_TYPE VARCHAR2(30),               -- HOME, PERSONAL, VEHICLE

    LOAN_AMOUNT NUMBER(12,2),             -- Approved loan amount

    LOAN_STATUS VARCHAR2(20),             -- APPROVED or PENDING

    CONSTRAINT FK_BANK_LOAN_CUSTOMER
    FOREIGN KEY (CUSTOMER_ID)
    REFERENCES BANK_CUSTOMERS(CUSTOMER_ID)

);


-- ============================================================
-- EXAMPLE 4: LOAN ID SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Generate unique loan IDs for each loan application.
-- IDs start from 70001 and increase by 5.
-- ============================================================

CREATE SEQUENCE SEQ_LOAN_ID

START WITH 70001       -- First loan ID

INCREMENT BY 5         -- Increase by 5

MINVALUE 70001         -- Minimum loan ID

NOCYCLE                -- Do not restart sequence

NOCACHE;               -- No sequence value caching


-- ============================================================
-- INSERT LOAN RECORDS
-- ============================================================

-- Create Rahul's home loan
INSERT INTO BANK_LOANS
(LOAN_ID, CUSTOMER_ID, LOAN_TYPE, LOAN_AMOUNT, LOAN_STATUS)
VALUES
(SEQ_LOAN_ID.NEXTVAL, 1001, 'HOME', 2500000, 'APPROVED');


-- Create Priya's personal loan
INSERT INTO BANK_LOANS
(LOAN_ID, CUSTOMER_ID, LOAN_TYPE, LOAN_AMOUNT, LOAN_STATUS)
VALUES
(SEQ_LOAN_ID.NEXTVAL, 1002, 'PERSONAL', 500000, 'PENDING');


-- Create Amit's vehicle loan
INSERT INTO BANK_LOANS
(LOAN_ID, CUSTOMER_ID, LOAN_TYPE, LOAN_AMOUNT, LOAN_STATUS)
VALUES
(SEQ_LOAN_ID.NEXTVAL, 1003, 'VEHICLE', 800000, 'APPROVED');


-- Save loan records
COMMIT;


-- Display loan records
SELECT * FROM BANK_LOANS;


-- ============================================================
-- EXPECTED OUTPUT
-- ============================================================
-- LOAN_ID | CUSTOMER_ID | LOAN_TYPE | LOAN_AMOUNT
-- 70001   | 1001        | HOME      | 2500000
-- 70006   | 1002        | PERSONAL  | 500000
-- 70011   | 1003        | VEHICLE   | 800000
-- ============================================================


-- ============================================================
-- EXAMPLE 5: NEXTVAL AND CURRVAL
-- ============================================================
-- NEXTVAL generates the next sequence number.
-- CURRVAL returns the most recently generated sequence number
-- in the current database session.
-- ============================================================

-- Generate the next customer ID
SELECT SEQ_CUSTOMER_ID.NEXTVAL
FROM DUAL;


-- Expected result: 1004
-- Assuming no other NEXTVAL call has occurred


-- Display current customer sequence value
SELECT SEQ_CUSTOMER_ID.CURRVAL
FROM DUAL;


-- Expected result: 1004
-- CURRVAL requires NEXTVAL to have been called in this session


-- Generate another customer ID
SELECT SEQ_CUSTOMER_ID.NEXTVAL
FROM DUAL;


-- Expected result: 1005


-- Display current sequence value again
SELECT SEQ_CUSTOMER_ID.CURRVAL
FROM DUAL;


-- Expected result: 1005


-- ============================================================
-- EXAMPLE 6: INCREMENT BY
-- ============================================================
-- BUSINESS SCENARIO:
-- Generate unique branch reference IDs.
-- Increase every generated value by 10.
-- ============================================================

CREATE SEQUENCE SEQ_BRANCH_ID

START WITH 100         -- First branch reference ID

INCREMENT BY 10        -- Increase by 10

MINVALUE 100           -- Minimum value

MAXVALUE 1000          -- Maximum value

NOCYCLE                -- Do not restart

NOCACHE;               -- No caching


-- Generate first branch reference
SELECT SEQ_BRANCH_ID.NEXTVAL FROM DUAL;
-- Expected: 100


-- Generate second branch reference
SELECT SEQ_BRANCH_ID.NEXTVAL FROM DUAL;
-- Expected: 110


-- Generate third branch reference
SELECT SEQ_BRANCH_ID.NEXTVAL FROM DUAL;
-- Expected: 120


-- ============================================================
-- EXAMPLE 7: CACHE AND NOCACHE
-- ============================================================
-- CACHE can improve sequence generation performance.
-- Cached but unused values may be lost after an instance failure.
-- NOCACHE avoids preallocating a group of sequence values.
-- Neither option guarantees gap-free IDs.
-- ============================================================

-- Create a sequence with caching
CREATE SEQUENCE SEQ_ATM_TRANSACTION

START WITH 10001       -- First ATM transaction ID

INCREMENT BY 1         -- Increase by 1

CACHE 20               -- Cache 20 values

NOCYCLE;               -- Do not restart


-- Generate an ATM transaction ID
SELECT SEQ_ATM_TRANSACTION.NEXTVAL FROM DUAL;
-- Expected: 10001


-- Create a sequence without caching
CREATE SEQUENCE SEQ_CHEQUE_REQUEST

START WITH 20001       -- First cheque request ID

INCREMENT BY 1         -- Increase by 1

NOCACHE                -- No cached sequence allocation

NOCYCLE;               -- Do not restart


-- Generate cheque request ID
SELECT SEQ_CHEQUE_REQUEST.NEXTVAL FROM DUAL;
-- Expected: 20001


-- ============================================================
-- EXAMPLE 8: CYCLE SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Generate reusable demonstration counter values.
-- This is NOT suitable for unique banking primary keys.
-- ============================================================

CREATE SEQUENCE SEQ_BANK_TOKEN_DEMO

START WITH 1           -- Start from 1

INCREMENT BY 1         -- Increase by 1

MINVALUE 1             -- Minimum counter value

MAXVALUE 3             -- Maximum counter value

CYCLE                  -- Restart after reaching maximum

NOCACHE;               -- No caching


-- Generate first value
SELECT SEQ_BANK_TOKEN_DEMO.NEXTVAL FROM DUAL;
-- Expected: 1


-- Generate second value
SELECT SEQ_BANK_TOKEN_DEMO.NEXTVAL FROM DUAL;
-- Expected: 2


-- Generate third value
SELECT SEQ_BANK_TOKEN_DEMO.NEXTVAL FROM DUAL;
-- Expected: 3


-- Generate fourth value
SELECT SEQ_BANK_TOKEN_DEMO.NEXTVAL FROM DUAL;
-- Expected: 1 (sequence cycles)


-- Generate fifth value
SELECT SEQ_BANK_TOKEN_DEMO.NEXTVAL FROM DUAL;
-- Expected: 2


-- ============================================================
-- EXAMPLE 9: NOCYCLE SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Generate unique IDs within a fixed range.
-- Stop when the maximum value is reached.
-- ============================================================

CREATE SEQUENCE SEQ_FIXED_REFERENCE

START WITH 1           -- First value

INCREMENT BY 1         -- Increase by 1

MINVALUE 1             -- Minimum value

MAXVALUE 3             -- Maximum value

NOCYCLE                -- Do not restart

NOCACHE;               -- No caching


-- Generate first value
SELECT SEQ_FIXED_REFERENCE.NEXTVAL FROM DUAL;
-- Expected: 1


-- Generate second value
SELECT SEQ_FIXED_REFERENCE.NEXTVAL FROM DUAL;
-- Expected: 2


-- Generate third value
SELECT SEQ_FIXED_REFERENCE.NEXTVAL FROM DUAL;
-- Expected: 3


-- Fourth call exceeds maximum value
-- Expected error: ORA-08004
-- Run separately to observe the error

/*
SELECT SEQ_FIXED_REFERENCE.NEXTVAL FROM DUAL;
*/


-- ============================================================
-- EXAMPLE 10: ALTER SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Change the branch reference sequence increment.
-- Future values should increase by 20 instead of 10.
-- ============================================================

ALTER SEQUENCE SEQ_BRANCH_ID

INCREMENT BY 20;       -- Change increment from 10 to 20


-- Generate next branch reference
SELECT SEQ_BRANCH_ID.NEXTVAL FROM DUAL;
-- Expected: 140
-- Previous generated value was 120


-- ============================================================
-- EXAMPLE 11: VIEW ALL SEQUENCES
-- ============================================================

-- Display sequences owned by the current user
SELECT

    SEQUENCE_NAME,       -- Sequence name

    MIN_VALUE,           -- Minimum value

    MAX_VALUE,           -- Maximum value

    INCREMENT_BY,        -- Increment size

    CYCLE_FLAG,          -- Y if sequence cycles

    CACHE_SIZE,          -- Number of cached values

    LAST_NUMBER          -- Dictionary value, not always next NEXTVAL

FROM USER_SEQUENCES

ORDER BY SEQUENCE_NAME;


-- ============================================================
-- EXAMPLE 12: UPDATE AND DELETE WITH SEQUENCE-GENERATED IDS
-- ============================================================

-- Update Rahul's city
UPDATE BANK_CUSTOMERS

SET CITY = 'Mumbai'

WHERE CUSTOMER_ID = 1001;


-- Update Priya's loan status
UPDATE BANK_LOANS

SET LOAN_STATUS = 'APPROVED'

WHERE LOAN_ID = 70006;


-- Delete one transaction history row (demonstration only)
-- Production banking ledgers should retain transaction history
DELETE FROM BANK_TRANSACTIONS

WHERE TRANSACTION_ID = 900003;


-- Save changes
COMMIT;


-- Check customer data
SELECT * FROM BANK_CUSTOMERS;


-- Check loan data
SELECT * FROM BANK_LOANS;


-- Check transaction data
SELECT * FROM BANK_TRANSACTIONS;


-- ============================================================
-- EXAMPLE 13: DROP SEQUENCE
-- ============================================================
-- BUSINESS SCENARIO:
-- Remove a demonstration sequence that is no longer required.
-- Dropping a sequence does not delete previously generated IDs.
-- ============================================================

-- Delete demonstration token sequence
DROP SEQUENCE SEQ_BANK_TOKEN_DEMO;


-- Delete fixed reference sequence
DROP SEQUENCE SEQ_FIXED_REFERENCE;


-- Verify remaining sequences
SELECT SEQUENCE_NAME
FROM USER_SEQUENCES
ORDER BY SEQUENCE_NAME;


-- ============================================================
-- END OF BANKING SEQUENCE EXAMPLES
-- ============================================================