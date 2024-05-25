-- Create the sales_data table with partitioning
CREATE TABLE sales_data(
    sale_id INTEGER,
    product_id INTEGER NOT NULL,
    region_id INTEGER NOT NULL,
    salesperson_id INTEGER NOT NULL,
    sale_amount NUMERIC NOT NULL,
    sale_date DATE NOT NULL ,
    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE (sale_date);

-- Create partitions for the past 12 months
CREATE TABLE sales_data_2023_05 PARTITION OF sales_data
    FOR VALUES FROM ('2023-05-01') TO ('2023-06-01');

CREATE TABLE sales_data_2023_06 PARTITION OF sales_data
    FOR VALUES FROM ('2023-06-01') TO ('2023-07-01');

CREATE TABLE sales_data_2023_07 PARTITION OF sales_data
    FOR VALUES FROM ('2023-07-01') TO ('2023-08-01');

CREATE TABLE sales_data_2023_08 PARTITION OF sales_data
    FOR VALUES FROM ('2023-08-01') TO ('2023-09-01');

CREATE TABLE sales_data_2023_09 PARTITION OF sales_data
    FOR VALUES FROM ('2023-09-01') TO ('2023-10-01');

CREATE TABLE sales_data_2023_10 PARTITION OF sales_data
    FOR VALUES FROM ('2023-10-01') TO ('2023-11-01');

CREATE TABLE sales_data_2023_11 PARTITION OF sales_data
    FOR VALUES FROM ('2023-11-01') TO ('2023-12-01');

CREATE TABLE sales_data_2023_12 PARTITION OF sales_data
    FOR VALUES FROM ('2023-12-01') TO ('2024-01-01');

CREATE TABLE sales_data_2024_01 PARTITION OF sales_data
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE sales_data_2024_02 PARTITION OF sales_data
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE sales_data_2024_03 PARTITION OF sales_data
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

CREATE TABLE sales_data_2024_04 PARTITION OF sales_data
    FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');
