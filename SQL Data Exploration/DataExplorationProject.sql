/*
Covid-19 Data - Exploration Project
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


-- Total Cases vs Total Deaths
-- Likelihood of dying if you contract Covid-19
SELECT location, date, total_cases, total_deaths, CAST(total_deaths AS float)/CAST(total_cases AS float)*100 AS DeathPercentage
FROM CovidDeaths
--WHERE location LIKE '%Canada%' 
WHERE continent IS NOT NULL 
ORDER BY 1, 2


-- Total Cases vs Population
-- Percentage of the population infected with Covid-19
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM CovidDeaths
--WHERE location LIKE '%Canada%' 
WHERE continent IS NOT NULL
ORDER BY 1, 2


-- Countries with the Highest Infection Rate
SELECT location, population, MAX(CAST(total_cases AS int)) AS HighestInfectionCount,  MAX((total_cases/Population)*100) AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- Countries with the Highest Death Count
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Continents with the Highest Death Count
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE location IN ('Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Overall numbers
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
--WHERE location LIKE '%Canada%' 
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Total Administered Doses vs Total Fully Vaccinated 
SELECT d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingAdministeredDoses, v.people_fully_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v
	ON d.location = v.location
	AND d.date = v.date
--WHERE d.location LIKE '%Canada%'
WHERE d.continent IS NOT NULL
ORDER BY 1,2

-- Using CTE to perform a calculation
WITH PopvsDos(location, date, population, new_vaccinations, RollingAdministeredDoses, people_fully_vaccinated)
AS
(
SELECT d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingAdministeredDoses, v.people_fully_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v
	ON d.location = v.location
	AND d.date = v.date
--WHERE d.location LIKE '%Canada%'
WHERE d.continent IS NOT NULL
)
SELECT *, (RollingAdministeredDoses/population) AS AverageDosesPerPerson, (people_fully_vaccinated/population)*100 AS FullyVaccinatedPercentage
FROM PopvsDos
ORDER BY 1,2

-- Using Temp Table to perform a calculation
DROP TABLE IF EXISTS #AverageDosesPerPerson
CREATE TABLE #AverageDosesPerPerson
(
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingAdministeredDoses numeric
)
INSERT INTO #AverageDosesPerPerson
Select d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingAdministeredDoses
FROM CovidDeaths d
JOIN CovidVaccinations v
	ON d.location = v.location
	AND d.date = v.date
--WHERE d.location LIKE '%Canada%'
WHERE d.continent IS NOT NULL
SELECT *, (RollingAdministeredDoses/population) AS AverageDosesPerPerson
FROM #AverageDosesPerPerson
ORDER BY 1, 2


-- View to store data for later visualizations
CREATE VIEW FullyVaccinatedPercentage AS
SELECT d.location, d.date, d.population, v.new_vaccinations, v.people_fully_vaccinated,
(v.people_fully_vaccinated/d.population)*100 AS FullyVacinnatedPercentage
FROM CovidDeaths d
JOIN CovidVaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL

SELECT * FROM FullyVaccinatedPercentage
WHERE location LIKE '%Canada%'
ORDER BY 1, 2
