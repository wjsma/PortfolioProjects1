Select * 
from PortfolioProject.dbo.coviddeath
order by 3,4

Select * 
from PortfolioProject.dbo.covidvacination
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject.dbo.coviddeath
order by 1,2

--looking at total cases vs total deaths
--shows likelyhood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (convert(float,total_deaths)/ nullif(convert(float,total_cases),0))*100 as deathperectage
from portfolioproject.dbo.coviddeath
where location like '%afghanistan%'
order by 1,2

--looking at total cases vs population
-- shows what percentage of population got covid

select location, date, population, total_cases, (convert(float,total_deaths)/ nullif(convert(float,population),0))*100 as deathperectage
from portfolioproject.dbo.coviddeath
where location like '%afghanistan%'
order by 1,2

--looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
from portfolioproject.dbo.coviddeath
--where location like '%afghanistan%'
group by location, population
order by percentpopulationinfected desc

--showing countries with hightest death count per population

select location, MAX(total_deaths) as TotalDeathCount
from portfolioproject.dbo.coviddeath
--where location like '%afghanistan%'
where location is not null
group by location
order by TotalDeathCount desc

--Lets see by breaking things down by continent


--Showing the continent highest Death count per Population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolioproject.dbo.coviddeath
--where location like '%afghanistan%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Gobal numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPerectage
from portfolioproject.dbo.coviddeath
--where location like '%afghanistan%'
where continent is not null
order by 1,2


-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVacination vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   order by 2,3

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_vactinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVacination vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   --order by 2,3
   )
   Select *, (RollingPeopleVaccinated/Population)*100
   from PopvsVac

   -- Temp Table

   Drop table if exists #PercentPopulationVaccinated
   create table #PercentPopulationVaccinated
   (
   Continent nvarchar(255),
   Location nvarchar(255),
   Date datetime,
   Population numeric,
   New_vaccination numeric,
   RollingPeopleVaccinated numeric
   )

   insert into #PercentPopulationVaccinated
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVacination vac
   on dea.location = vac.location
   and dea.date = vac.date
   --where dea.continent is not null
   --order by 2,3

   Select *, (RollingPeopleVaccinated/Population)*100
   from #PercentPopulationVaccinated;

--creating view to store for later visualiZations

CREATE VIEW PercentPopulationVaccinated AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVacination vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null;
   --order by 2,3

   Select * 
   from PercentPopulationVaccinated





