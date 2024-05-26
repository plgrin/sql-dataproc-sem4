ALTER TABLE DimEmployees
ADD COLUMN EmployeeSurrogateID SERIAL PRIMARY KEY,
ADD COLUMN EffectiveDate DATE NOT NULL DEFAULT CURRENT_DATE,
ADD COLUMN EndDate DATE,
ADD COLUMN IsCurrent BOOLEAN NOT NULL DEFAULT TRUE;

CREATE OR REPLACE FUNCTION handle_employee_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Mark the old record as historical
    UPDATE DimEmployees
    SET EndDate = CURRENT_DATE, IsCurrent = FALSE
    WHERE EmployeeSurrogateID = OLD.EmployeeSurrogateID;

    -- Insert a new record with updated details and new surrogate ID
    INSERT INTO DimEmployees (
        EmployeeID, LastName, FirstName, Title, TitleOfCourtesy,
        BirthDate, HireDate, Address, City, Region, PostalCode, Country, Phone,
        Extension, Photo, Notes, ReportsTo, PhotoPath, EffectiveDate, IsCurrent
    ) VALUES (
        OLD.EmployeeID, OLD.LastName, OLD.FirstName, NEW.Title, OLD.TitleOfCourtesy,
        OLD.BirthDate, OLD.HireDate, NEW.Address, OLD.City, OLD.Region, OLD.PostalCode, OLD.Country, OLD.Phone,
        OLD.Extension, OLD.Photo, OLD.Notes, OLD.ReportsTo, OLD.PhotoPath, CURRENT_DATE, TRUE
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
