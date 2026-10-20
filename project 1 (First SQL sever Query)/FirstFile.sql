select * 
from [Portfolio project]..CovidDeaths
where continent is not null
order by 3, 4

--select * 
--from [Portfolio project]..CovidVaccinations
--order by 3, 4

-- we select the data that we are going to use

select Location, date, total_cases, new_cases,total_deaths, population
from [Portfolio project]..CovidDeaths
where continent is not null
order by 1, 2

-- looking at total_cases vs total_deaths
-- shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deaths_percentage
from [Portfolio project]..CovidDeaths
where continent is not null and location like '%states%'
order by 1, 2

-- looking at the total_cases vs population
-- shows what percentage of population got covid

select Location, date, population, total_cases, (total_cases/population) * 100 as percentage_of_population
from [Portfolio project]..CovidDeaths
-- where location like '%states%'
where continent is not null
order by 1, 2

-- looking at countries with highest infection rate compared to population  

select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)) * 100 as Percent_Population_Infected
from [Portfolio project]..CovidDeaths
-- where location like '%states%'
where continent is not null
group by Location, population
order by Percent_Population_Infected desc

-- showing countries with highest death count per population  

select Location,max(cast(total_deaths as int)) as HighestDeathCount
from [Portfolio project]..CovidDeaths
-- where location like '%states%'
where continent is not null
group by Location
order by HighestDeathCount desc

-- let's break things down by continent
-- showing continents with the highest death count per population

select continent, max(cast(total_deaths as int)) as HighestDeathCount
from [Portfolio project]..CovidDeaths
-- where location like '%states%'
where continent is not null
group by continent
order by HighestDeathCount desc

-- global numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPercentage 
from [Portfolio project]..CovidDeaths
where continent is not null
group by date
order by 1, 2

-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
from [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
on  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- USE CTE

with PopvsVac (continent, location, date, population, 
			   new_vaccination, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over 
(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
from [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
on  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

-- Temp Table

drop table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated	
--, (RollingPeopleVaccinated/population)*100
from [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
on  dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null
-- order by 2, 3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPeopleVaccinated

-- creating view to store data for later visualizations

create view PercentPeopleVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated	
--, (RollingPeopleVaccinated/population)*100
from [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
on  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3