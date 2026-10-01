# 🏥 Hospital Patient & Appointment Analysis

<p align="center">
  <img src="https://img.shields.io/badge/Language-SQL-CC292B?style=for-the-badge&logo=mysql&logoColor=white" alt="SQL Badge" />
  <img src="https://img.shields.io/badge/Domain-Healthcare%20Analytics-0078D4?style=for-the-badge" alt="Healthcare Badge" />
  <img src="https://img.shields.io/badge/Status-Completed-success?style=for-the-badge" alt="Status Badge" />
</p>

---

## 📌 Table of Contents
* [Overview](#-overview)
* [Key Business Questions Answered](#-key-business-questions-answered)
* [Database Schema & Structure](#-database-schema--structure)
* [Core SQL Analytical Queries](#-core-sql-analytical-queries)
* [Setup & Execution](#-setup--execution)
* [Future Roadmap](#-future-roadmap)

---

## 🔎 Overview
A comprehensive healthcare data analytics project focused on analyzing patient appointment records, tracking attendance patterns, identifying no-show drivers, and optimizing department scheduling through structured SQL queries.

> [!NOTE]
> All analytical queries and schema scripts are contained in `Hospital_Patient & Appointment Analysis..sql`.

---

## 💡 Key Business Questions Answered

* **Patient Attendance Patterns:** What percentage of booked appointments result in completed visits versus no-shows or cancellations?
* **Lead Time & Scheduling Delays:** How does the time gap between booking date and actual appointment date affect patient attendance?
* **Demographics & Chronic Conditions:** Which age groups and pre-existing condition cohorts exhibit the highest appointment dropout rates?
* **Departmental Utilization:** Which medical departments experience peak appointment congestion and scheduling bottlenecks?

---

## 🗂️ Database Schema & Structure

<details>
<summary><b>Click to view typical table attributes & metrics</b></summary>

<br>

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `PatientID` | INT / VARCHAR | Unique identifier for each patient |
| `AppointmentID` | INT / VARCHAR | Unique identifier for each booked visit |
| `ScheduledDay` | TIMESTAMP | The date/time the appointment was booked |
| `AppointmentDay` | DATE | The scheduled date of the actual appointment |
| `Age` / `Gender` | INT / VARCHAR | Demographic characteristics of the patient |
| `Department` | VARCHAR | Specialized medical department or clinic |
| `NoShow` / `Status` | VARCHAR / BOOLEAN | Attendance outcome (Completed, No-Show, Cancelled) |

</details>

---

## ⚡ Core SQL Analytical Queries

<details>
<summary><b>Click to expand query highlights</b></summary>

<br>

### 1. Overall Appointment Attendance & No-Show Rate
```sql
SELECT 
    Status,
    COUNT(*) AS TotalAppointments,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage
FROM Appointments
GROUP BY Status;
