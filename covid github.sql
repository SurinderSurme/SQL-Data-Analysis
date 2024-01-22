select * 
from [Portfolio Project]..['Covid Deaths$']
order by 3, 4


--select * 
--from [Portfolio Project]..['Covid Vaccinations$']
--order by 3, 4


select location ,date, total_cases, new_cases,total_deaths,population
from [Portfolio Project]..['Covid Deaths$']
order by 1,2

-- Looking at Total Cases vs Total Death
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
FROM [Portfolio Project]..['Covid Deaths$']
where location like '%canada%'
ORDER BY 1, 2;


-- Total cases vs Population
-- shows what percentage of population got covid

SELECT 
    location,
    date,
    total_cases,
    population,
    (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM [Portfolio Project]..['Covid Deaths$']
where location like '%canada%'
ORDER BY 1, 2;

-- Countries with highest infection rate compared to population 

SELECT 
    location,
    population,
    MAX(total_cases) as HighestInfectionCount,
    (CONVERT(float, MAX(total_cases)) / NULLIF(CONVERT(float, Max(total_cases) / population), 0)) * 100 AS PercentPopulationInfected
FROM [Portfolio Project]..['Covid Deaths$']
-- WHERE location LIKE '%canada%'
GROUP BY location, Population
ORDER BY PercentPopulationInfected DESC;


---- Countries with Highest Death Count per Population

SELECT 
    Location,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..['Covid Deaths$']
-- WHERE Location LIKE '%states%'
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT 
    continent,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..['Covid Deaths$']
-- WHERE Location LIKE '%states%'
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM [Portfolio Project]..['Covid Deaths$']
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM 
    [Portfolio Project]..['Covid Deaths$'] dea
JOIN 
    [Portfolio Project]..['Covid Vaccinations$'] vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL 
ORDER BY 
    dea.location, dea.date;
