CREATE TABLE Attendance(
    EmpId INT,
    Month VARCHAR(10),
    TotalPresent INT
);

INSERT INTO Attendance VALUES
(1,'Jan',20),
(1,'Feb',18),
(1,'Mar',22),
(2,'Jan',19),
(2,'Feb',21),
(2,'Mar',20);

SELECT *
FROM
(
    SELECT EmpId, Month, TotalPresent
    FROM Attendance
) AS SourceTable
PIVOT
(
    SUM(TotalPresent)
    FOR Month IN ([Jan], [Feb], [Mar])
) AS PivotTable;
