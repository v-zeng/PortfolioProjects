### SQL Data Exploration
Simple SQL Data exploration performed in Microsoft SQL Server Management Studio (SSMS)

## Table of Contents
* [General Info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)
* [Query Breakdown and Purpose](#query-breakdown-and-purpose)
* [SQL Techniques and Methods used](#sql-techniques-and-methods-used)
* [Performance Considerations](#performance-considerations)
* [Next Steps and Future Extensions](#next-steps-and-future-extensions)

## General Info

This project explores COVID-19 data from 2020 to 2024 using SQL queries in Microsoft SQL Server Management Studio (SSMS). The data was sourced from Our World in Data (OWID), a scientific online publication, and focuses on key COVID-19 metrics such as total infections, death counts, death rates, and vaccination rates across countries and continents.

The primary goal of this project is to analyze the impact of COVID-19 on global populations by comparing infection rates, death rates, and vaccination progress. The insights derived from these queries provide a clear view of the pandemic's effects on public health and can inform future public health strategies.

The data is visualized in a separate Tableau project.

## Technologies
This project is created using:
*SSMS (SQL Server Management Studio) version 19.3.4.0

## Setup
* Download the COVID-19 dataset from the [Our World in Data GitHub](https://github.com/owid/covid-19-data?tab=readme-ov-file). Right-click the CSV link and choose "Save Link As".
  * Note: The GitHub datasets found in the link above are no longer updated since August 19, 2024.

* Save the following columns as a spreadsheet (xlsx) for COVID-19 Deaths:
  * 
`iso_code`, `continent`, `country`, `date`, `population`, `total_cases`, `new_cases`, `new_cases_smoothed`, `new_deaths_smoothed`, `total_deaths`, `new_deaths`, `total_cases_per_million`, `new_cases_per_million`, `new_cases_smoothed_per_million`, `total_deaths_per_million`, `new_deaths_per_million`, `new_deaths_smoothed_per_million`, `reproduction_rate`, `icu_patients`, `icu_patients_per_million`, `hosp_patients`, `hosp_patients_per_million`, `weekly_icu_admissions`, `weekly_icu_admissions_per_million`, `weekly_hosp_admissions`, `weekly_hosp_admissions_per_million`

* Save the following columns as an xlsx for COVID-19 Vaccinations:
  * `iso_code`, `continent`, `country`, `date`, `new_tests`, `total_tests`, `total_tests_per_thousand`, `new_tests_per_thousand`, `new_tests_smoothed`, `new_tests_smoothed_per_thousand`, `positive_rate`, `tests_per_case`, `total_vaccinations`, `people_vaccinated`, `people_fully_vaccinated`, `total_boosters`, `new_vaccinations`, `new_vaccinations_smoothed`, `total_vaccinations_per_hundred`, `people_vaccinated_per_hundred`, `people_fully_vaccinated_per_hundred`, `total_boosters_per_hundred`, `new_vaccinations_smoothed_per_million`, `new_people_vaccinated_smoothed`, `new_people_vaccinated_smoothed_per_hundred`

## Query Breakdown and Purpose

This section provides a breakdown of the key SQL queries used in the project, along with the purpose of each query.

### Purpose

The primary goal of the SQL queries in this project is to explore the COVID-19 dataset to gain insights into various aspects of the pandemic. Specifically, these queries focus on infection rates, death rates, vaccination efforts, and more. The purpose of the queries is to:

- Investigate the total number of COVID-19 cases and deaths across different countries.
- Analyze the death rate relative to the total cases, with a focus on specific countries (e.g., Canada).
- Examine the infection rate (percentage of the population infected) for different countries.
- Compare the total number of deaths across countries and continents.
- Calculate the global COVID-19 death rate and cases on a daily basis.
- Analyze vaccination rates across different countries and continents, examining how vaccination efforts compare to population size.
- Create temporary tables, common table expressions (CTEs), and views to store and visualize aggregated data for further analysis.

### Query Breakdown and Purpose

1. **Select data for use:**

   This query retrieves the basic data required for analysis, including total cases, new cases, total deaths, and population, ordered by country and date.

   ```sql
   select country, date, total_cases, new_cases, total_deaths, population
   from PortfolioProject..CovidDeaths
   order by country, date;

2. **Total cases vs total deaths (Death rate in Canada):
   This query calculates the death rate in Canada if COVID-19 is contracted. It uses the formula `(total_deaths / total_cases) * 100` to determine the percentage of deaths relative to total cases.
   ```sql
   select country, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
   from PortfolioProject..CovidDeaths
   where total_cases > 0 and continent is not null and lower(country) like ('%canada%')
   order by country, date;

3. **Examine total cases vs population:
   This query calculates the percentage of the population infected by dividing total cases by population and multiplying by 100.
   ```sql
   select country, date, population, total_cases, (total_cases/population)*100 as infected_percentage
   from PortfolioProject..CovidDeaths
   where total_cases > 0 and continent is not null
   order by country, date;
   
4. **Percentage of population infected per country:
   This query retrieves the maximum infection count for each country and calculates the percentage of the population infected.
   ```sql
   select country, population, max(total_cases) as max_infection_count, max((total_cases/population))*100 as infected_percentage
   from PortfolioProject..CovidDeaths
   where total_cases > 0 and continent is not null
   group by country, population
   order by infected_percentage desc;

5. **Total death count per country:
   This query calculates the total death count for each country, ordered by the highest death count.
   ```sql
   select country, max(total_deaths) as total_death_count
   from PortfolioProject..CovidDeaths
   where continent is not null
   group by country
   order by total_death_count desc;

 5. **Total death count per country:
   This query calculates the total death count for each country, ordered by the highest death count.
   ```sql
   select country, max(total_deaths) as total_death_count
   from PortfolioProject..CovidDeaths
   where continent is not null
   group by country
   order by total_death_count desc;
