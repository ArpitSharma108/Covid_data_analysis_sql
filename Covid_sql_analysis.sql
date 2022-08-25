SELECT * FROM covid_deaths
ORDER BY 3,4
SELECT * FROM covid_vaccinations
ORDER BY 3,4

SELECT Location, date, total_cases,new_cases,new_deaths,total_deaths,population
FROM covid_deaths
ORDER BY 1,2

UPDATE covid_deaths SET
total_cases=NULL WHERE total_cases=0

SELECT Location, date, total_cases,total_deaths,(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 AS percentage_deaths
FROM covid_deaths
WHERE Location='India'
ORDER BY 1,2

UPDATE covid_deaths SET
population=NULL WHERE population=0

SELECT Location, date, total_cases,total_deaths,(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS percentage_deaths
FROM covid_deaths
WHERE Location='India'
ORDER BY 1,2

SELECT Location, date, MAX(total_cases) AS HighestInfec, MAX((CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100) AS percentage_deaths
FROM covid_deaths
GROUP BY Location, date
ORDER BY HighestInfec

UPDATE covid_deaths SET continent = NULL WHERE continent =' '

SELECT Location, MAX(CAST(total_deaths as INT)) AS death_count
FROM covid_deaths
WHERE Continent is Not Null
Group By Location
Order BY death_count desc

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dths.continent,dths.Location,dths.date,dths.population,vacc.new_vaccinations
,SUM(Convert(BIGINT,vacc.new_vaccinations) ) OVER(Partition By dths.Location Order By dths.date,dths.location)as RollingPeopleVaccinated
FROM covid_deaths dths
JOIN covid_vaccinations vacc
ON dths.location=vacc.location
AND dths.date=vacc.date
WHERE dths.Continent is NOT NULL

)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac