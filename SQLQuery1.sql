--Select * from CovidDeaths$
--where location='Finland';

--Select location,date,total_cases,new_cases,total_deaths,population 
--from CovidDeaths$



--Total Cases vs Total Deaths
--SELECT 
--    SUM(CAST(ISNULL(total_cases, 0) AS BIGINT)) AS total_cases,
--    SUM(CAST(ISNULL(total_deaths, 0) AS BIGINT)) AS total_deaths,
--    location
--FROM 
--    CovidDeaths$
--WHERE 
--    location IS NOT NULL
--GROUP BY 
--    location
--ORDER BY
--    location;



--DEATHS PER UNIT CASES

--SELECT 
--   location,
--   CAST(total_cases AS INT) AS tCases, CAST(total_deaths AS INT) AS tDeaths,
--   (total_deaths/total_cases)*100 AS tDeaths_per_tCases
--   from CovidDeaths$
--   WHERE location is not null and total_deaths is not null 
--   order by tDeaths_per_tCases desc



--PERCENTAGE TOTAL CASES PER POPULATION

--SELECT 
--location, 
--population as total_population,total_cases AS total_cases,
--(total_cases/population)*100 AS CasesPerPopulation
--FROM CovidDeaths$
--WHERE location is not null 
--ORDER BY CasesPerPopulation DESC

--COUNTRY WITH HIGHEST INFECTION RATE AS COMPARED TO PUPULATION
--SELECT location,population,max(total_cases) as total_cases ,
--       max(total_cases/population)*100 as InfectionRate
--FROM CovidDeaths$
--WHERE population is not null
--GROUP BY location,population
--ORDER BY InfectionRate DESC

--COUNTRY WITH HIGHEST DEATH RATE

--SELECT location,population,max(CAST(total_deaths AS INT)) as total_deaths ,
--       max(total_deaths/population)*100 as DeathRate
--FROM CovidDeaths$
--WHERE population is not null
--GROUP BY location,population
--ORDER BY DeathRate DESC



---NOW USING CONTINENT




--SELECT location,MAX(CAST(total_deaths as INT))AS TotalDeathCount
--FROM CovidDeaths$
--WHERE continent is not null
--GROUP BY location
--ORDER BY TotalDeathCount desc
 


 --SHOWING CONTINENT WITH MAX DEATHCOUNT
 --SELECT continent,MAX(CAST(total_deaths as INT))AS TotalDeathCount
 --FROM CovidDeaths$
 --WHERE continent is not null
 --GROUP BY continent



 ---GLOBAL NUMBERS
 --SELECT date,SUM(new_cases) as total_cases,SUM(CAST(new_deaths as INT)) as total_deaths,SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
 --FROM CovidDeaths$
 --WHERE continent is not null
 --GROUP BY date
 --order by 1,2
  

  --VACCINATION TABLE

  --JOINING BOTH COVID-DEATHS AND COVID-VACCINATION

  --SELECT * FROM CovidDeaths$ dae
  --JOIN
  --CovidVaccinations$ vac
  --ON
  --dae.location =vac.location
  --and dae.date=vac.date

  --Total Population vs Vaccination BY LOCATIONS

  --SELECT SUM(CAST(vac.total_vaccinations AS BIGINT)) AS VACCINATIONS,SUM(CAST(population AS BIGINT)) AS POPULATED,vac.location 
  --FROM
  --CovidDeaths$ dae
  --JOIN
  --CovidVaccinations$ vac
  --ON
  --dae.location =vac.location
  --and dae.date=vac.date
  --GROUP BY vac.location
  --ORDER BY vac.location



  --TOTAL POPULATION VS VACCINATIONS OVER-ALL

--  SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
--  FROM CovidDeaths$ dea
--  JOIN 
--  CovidVaccinations$ vac
--  ON
--  dea.location=vac.location
--  AND
--dea.date=vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3


--  SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
--  SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
--  AS ROLLING_VACCINATION
--  FROM CovidDeaths$ dea
--  JOIN 
--  CovidVaccinations$ vac
--  ON
--  dea.location=vac.location
--  AND
--dea.date=vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

--USING A CTE
--WITH POP_VS_VAC(Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
--AS (
--  SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
--  SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
--  AS ROLLING_VACCINATION
--  FROM CovidDeaths$ dea
--  JOIN 
--  CovidVaccinations$ vac
--  ON
--  dea.location=vac.location
--  AND
--dea.date=vac.date
--WHERE dea.continent is not null
----ORDER BY 2,3
--)
--SELECT* ,(RollingPeopleVaccinated/Population)*100 FROM POP_VS_VAC



---TEMP TABLE
--DROP TABLE IF EXISTS #PercentagePopulationVaccinated


--CREATE TABLE #PercentagePopulationVaccinated(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric)


--Insert into #PercentagePopulationVaccinated 
--SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
--  SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
--  AS ROLLING_VACCINATION
--  FROM CovidDeaths$ dea
--  JOIN 
--  CovidVaccinations$ vac
--  ON
--  dea.location=vac.location
--  AND
--dea.date=vac.date
--WHERE dea.continent is not null

--SELECT* ,(RollingPeopleVaccinated/Population)*100 FROM #PercentagePopulationVaccinated

--CREATING A VIEW FOR LATER USE
-- CREATE VIEW PercentagePopulationVaccinated 
-- AS
-- SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
--  SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
--  AS ROLLING_VACCINATION
--  FROM CovidDeaths$ dea
--  JOIN 
--  CovidVaccinations$ vac
--  ON
--  dea.location=vac.location
--  AND
--dea.date=vac.date
--WHERE dea.continent is not null

SELECT * FROM PercentagePopulationVaccinated