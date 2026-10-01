-- Create Database 
create database Hospital;

-- Create Table
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    department VARCHAR(50),
    doctor_name VARCHAR(100),
    lead_time_days INT,         -- days between booking and appointment
    appointment_date DATE,
    status VARCHAR(20),         -- 'Completed', 'No-Show', 'Cancelled'
    fee DECIMAL(8, 2)
);

-- Values Inserts:
INSERT INTO appointments VALUES
(1, 'Rahul Sharma', 45, 'Male', 'Cardiology', 'Dr. Mehta', 2, '2026-03-01', 'Completed', 150.00),
(2, 'Anita Verma', 32, 'Female', 'Dermatology', 'Dr. Iyer', 7, '2026-03-01', 'No-Show', 100.00),
(3, 'David Clark', 58, 'Male', 'Orthopedics', 'Dr. Evans', 1, '2026-03-02', 'Completed', 200.00),
(4, 'Priya Patel', 26, 'Female', 'General Medicine', 'Dr. Sen', 14, '2026-03-02', 'No-Show', 80.00),
(5, 'Michael Chang', 71, 'Male', 'Cardiology', 'Dr. Mehta', 0, '2026-03-03', 'Completed', 150.00),
(6, 'Sarah Johnson', 19, 'Female', 'Pediatrics', 'Dr. Khan', 4, '2026-03-03', 'Cancelled', 90.00),
(7, 'Rajesh Gupta', 52, 'Male', 'Orthopedics', 'Dr. Evans', 21, '2026-03-04', 'No-Show', 200.00),
(8, 'Emily Davis', 39, 'Female', 'Dermatology', 'Dr. Iyer', 3, '2026-03-04', 'Completed', 100.00),
(9, 'John Miller', 63, 'Male', 'General Medicine', 'Dr. Sen', 2, '2026-03-05', 'Completed', 80.00),
(10, 'Neha Nair', 29, 'Female', 'Cardiology', 'Dr. Mehta', 10, '2026-03-05', 'Cancelled', 150.00);

-- Table Print or check table
select * from appointments;

-- A. Total Revenue vs. Lost Revenue from No-Shows
SELECT 
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN status = 'Completed' THEN fee ELSE 0 END) AS collected_revenue,
    SUM(CASE WHEN status = 'No-Show' THEN fee ELSE 0 END) AS lost_revenue_noshows
FROM appointments;

-- Find which department has the highest absenteeism rate.
SELECT 
    department,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_show_percentage
FROM appointments
GROUP BY department
ORDER BY no_show_percentage DESC;

-- C. Does Booking in Advance Increase No-Shows?
-- Compare lead times between completed visits and no-shows. 
SELECT 
    status,
    COUNT(*) AS appointment_count,
    ROUND(AVG(lead_time_days), 1) AS avg_lead_days
FROM appointments
GROUP BY status;
-- Business Question: Which doctor brings in the highest revenue from completed appointments?
SELECT 
    doctor_name,
    department,
    COUNT(*) AS completed_visits,
    SUM(fee) AS total_revenue
FROM appointments
WHERE status = 'Completed'
GROUP BY doctor_name, department
ORDER BY total_revenue DESC;

-- Which age demographic visits the hospital most frequently?
SELECT 
    CASE 
        WHEN age < 20 THEN 'Youth (<20)'
        WHEN age BETWEEN 20 AND 39 THEN 'Young Adults (20-39)'
        WHEN age BETWEEN 40 AND 59 THEN 'Middle-aged (40-59)'
        ELSE 'Seniors (60+)'
    END AS age_group,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_visits
FROM appointments
GROUP BY 
    CASE 
        WHEN age < 20 THEN 'Youth (<20)'
        WHEN age BETWEEN 20 AND 39 THEN 'Young Adults (20-39)'
        WHEN age BETWEEN 40 AND 59 THEN 'Middle-aged (40-59)'
        ELSE 'Seniors (60+)'
    END
ORDER BY total_appointments DESC;

-- Categorize appointments by advance booking time to identify the no-show rate for last-minute vs. long-term bookings.
SELECT 
    CASE 
        WHEN lead_time_days = 0 THEN 'Same Day'
        WHEN lead_time_days BETWEEN 1 AND 3 THEN 'Short Notice (1-3 Days)'
        WHEN lead_time_days BETWEEN 4 AND 7 THEN 'Standard (4-7 Days)'
        ELSE 'Long Notice (>1 Week)'
    END AS lead_category,
    COUNT(*) AS total_scheduled,
    SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_show_rate_pct
FROM appointments
GROUP BY 
    CASE 
        WHEN lead_time_days = 0 THEN 'Same Day'
        WHEN lead_time_days BETWEEN 1 AND 3 THEN 'Short Notice (1-3 Days)'
        WHEN lead_time_days BETWEEN 4 AND 7 THEN 'Standard (4-7 Days)'
        ELSE 'Long Notice (>1 Week)'
    END
ORDER BY no_show_rate_pct DESC;

-- Is there any significant difference in completion rates between male and female patients?
SELECT 
    gender,
    COUNT(*) AS total_booked,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed,
    ROUND(100.0 * SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) / COUNT(*), 1) AS completion_rate_pct
FROM appointments
GROUP BY gender;

-- Which departments have more than 1 no-show? (Filtering aggregated groups using HAVING)
SELECT 
    department,
    SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) AS total_no_shows
FROM appointments
GROUP BY department
HAVING SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) >= 1
ORDER BY total_no_shows DESC;

-- What does the daily performance and status breakdown look like across each scheduled date?
SELECT 
    appointment_date,
    COUNT(*) AS total_scheduled,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) AS no_shows,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancellations
FROM appointments
GROUP BY appointment_date
ORDER BY appointment_date ASC;

-- Find all completed appointments that had a consultation fee strictly higher than the overall hospital average fee.
SELECT 
    appointment_id,
    patient_name,
    department,
    fee
FROM appointments
WHERE status = 'Completed' 
  AND fee > (SELECT AVG(fee) FROM appointments);
  
  -- Rank doctors inside each department based on total completed fees generated.
  SELECT 
    department,
    doctor_name,
    SUM(fee) AS revenue,
    RANK() OVER (
        PARTITION BY department 
        ORDER BY SUM(fee) DESC
    ) AS dept_rank
FROM appointments
WHERE status = 'Completed'
GROUP BY department, doctor_name;
