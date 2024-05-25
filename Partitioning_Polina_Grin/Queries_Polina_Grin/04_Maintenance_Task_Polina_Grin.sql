CREATE OR REPLACE FUNCTION manage_partitions()
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    current_date DATE := CURRENT_DATE;
    new_partition_start DATE;
    new_partition_end DATE;
    old_partition_date DATE;
BEGIN
    -- Calculate start and end dates for the new partition
    new_partition_start := DATE_TRUNC('month', current_date) + INTERVAL '1 month';
    new_partition_end := DATE_TRUNC('month', new_partition_start) + INTERVAL '1 month';

    -- Drop partitions older than 12 months
    FOR old_partition_date IN
        SELECT sale_date
        FROM sales_data
        WHERE sale_date < current_date - INTERVAL '12 months'
    LOOP
        EXECUTE format('DROP TABLE IF EXISTS sales_data_%s', TO_CHAR(old_partition_date, 'YYYY_MM'));
    END LOOP;

    -- Create new partition for the next month
    EXECUTE format('CREATE TABLE sales_data_%s PARTITION OF sales_data FOR VALUES FROM (%L) TO (%L)',
                   TO_CHAR(new_partition_start, 'YYYY_MM'),
                   new_partition_start,
                   new_partition_end);
END;
$$;
