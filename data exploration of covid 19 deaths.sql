/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
select * from [portfolio project]..CovidDeaths
order by 3,4

-- Select Data that we are going to be starting with

select location,date,total_cases,new_cases,total_deaths,population from [portfolio project]..CovidDeaths
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location,date,total_cases,new_cases,total_deaths,(total_cases/total_deaths)*100 as deathpercentage from [portfolio project]..CovidDeaths
order by 1,2

-- Countries with Highest Infection Rate compared to Population

select location,date,total_cases,new_cases,total_deaths,(total_cases/total_deaths)*100 as deathpercentage from [portfolio project]..CovidDeaths where location 
like '%canada%'

-- Countries with Highest Death Count per Population

select location, max(total_cases) as Highestinfectioncount,population,max(total_cases/population)*100 as deathpercentage from [portfolio project]..covidDeaths
group by location,population
order by deathpercentage desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathcount from [portfolio project]..covidDeaths where continent is not null
group by location
order by TotalDeathcount desc

select continent, max(cast(total_deaths as int)) as TotalDeathcount from [portfolio project]..covidDeaths where continent is not null
group by continent
order by TotalDeathcount desc

-- GLOBAL NUMBERS

select  date,total_cases, total_deaths, (total_deaths/total_cases ) *100 as Deathpercentage from [portfolio project]..covidDeaths where continent is not null
group by date
order by TotalDeathcount desc

---Showing contintents with the highest death count per population
-- Total Population vs Vaccinations


select  sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
 from [portfolio project]..covidDeaths where continent is not null
order by 1,2

select * from [portfolio project]..covidvaccinations

select * from [portfolio project]..coviddeaths dea
Join [portfolio project]..covidvaccinations vac
on dea.location= vac.location
and dea.date= vac.date

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.location,dea.continent, dea.date,dea.population, vac.new_vaccinations , sum (cast(new_vaccinations as int)) over (Partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated from [portfolio project]..coviddeaths dea
Join [portfolio project]..covidvaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date , Population, new_vaccinations, RollingPeopleVaccinated)
as (
select dea.location,dea.continent, dea.date,dea.population, vac.new_vaccinations , sum (cast(new_vaccinations as int)) over (Partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated from [portfolio project]..coviddeaths dea
Join [portfolio project]..covidvaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null

)
Select * ,(rollingpeoplevaccinated/Population)*100
from PopvsVac

----temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.location,dea.continent, dea.date,dea.population, vac.new_vaccinations , sum (cast(new_vaccinations as int)) over (Partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated from [portfolio project]..coviddeaths dea
Join [portfolio project]..covidvaccinations vac
on dea.location= vac.location
and dea.date= vac.date
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

----creating views
Create View PercentPopulationVaccinated as
select dea.location,dea.continent, dea.date,dea.population, vac.new_vaccinations , sum (cast(new_vaccinations as int)) over (Partition by dea.location order by
dea.location, dea.date) as RollingPeopleVaccinated from [portfolio project]..coviddeaths dea
Join [portfolio project]..covidvaccinations vac
on dea.location= vac.location
and dea.date= vac.date






