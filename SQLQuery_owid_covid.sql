-- Select data for use
select country, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by country, date;

-- Total cases vs total deaths
-- Death rate in Canada if covid contracted
select country, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
from PortfolioProject..CovidDeaths
where total_cases > 0 and continent is not null and lower(country) like ('%canada%')
order by country, date;

-- Examine total cases vs population
select country, date, population, total_cases, (total_cases/population)*100 as infected_percentage
from PortfolioProject..CovidDeaths
where total_cases > 0 and continent is not null
order by country, date;

-- Percentage of population infected with per country
select country, population, max(total_cases) as max_infection_count, max((total_cases/population))*100 as infected_percentage
from PortfolioProject..CovidDeaths
where total_cases > 0 and continent is not null
group by country, population
order by infected_percentage desc;

-- Total death count per country
select country, max(total_deaths) as total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by country
order by total_death_count desc;

-- Total death count per continent
select country, max(total_deaths) as total_death_count
from PortfolioProject..CovidDeaths
where continent is null and country in ('Europe', 'North America', 'South America', 'Asia', 'Africa', 'Oceania')
group by country
order by total_death_count desc;

-- Global daily covid death rate
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
	case
		when sum(new_cases) = 0 then null
		else sum(new_deaths)/sum(new_cases) * 100
	end as death_rate
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by date;

-- Global covid cases, covid deaths, and death rate
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
	case
		when sum(new_cases) = 0 then null
		else sum(new_deaths)/sum(new_cases) * 100
	end as death_rate
from PortfolioProject..CovidDeaths
where continent is not null;

-- Examining total population vs vaccinations
select a.continent, a.country, a.date, a.population, b.new_vaccinations,
	sum(cast(b.new_vaccinations as float)) over (partition by a.country order by a.country, a.date) as cumulative_vaccinations
from PortfolioProject..CovidDeaths a
join PortfolioProject..CovidVaccinations b
	on a.country = b.country
	and a.date = b.date
where a.continent is not null
order by a.country, a.date;


-- Using Common Table Expression (CTE) to examine percentage of population vaccinated
with pop_vaccinated (Continent, Country, Date, Population, New_vaccinations, Cumulative_vaccinations)
as
(
select a.continent, a.country, a.date, a.population, b.new_vaccinations,
	sum(cast(b.new_vaccinations as float)) over (partition by a.country order by a.country, a.date) as cumulative_vaccinations
from PortfolioProject..CovidDeaths a
join PortfolioProject..CovidVaccinations b
	on a.country = b.country
	and a.date = b.date
where a.continent is not null
--order by a.country, a.date;
)
select *, (cumulative_vaccinations/population)*100 as percent_pop_vaccinated
from pop_vaccinated


-- Using a Temp Table
drop table if exists #PercentPopVaccinated
create table #PercentPopVaccinated
(
Continent nvarchar(255), 
Country nvarchar(255), 
Date datetime, 
Population numeric,
New_vaccinations numeric,
Cumulative_vaccinations numeric
)

insert into #PercentPopVaccinated
select a.continent, a.country, a.date, a.population, b.new_vaccinations,
	sum(cast(b.new_vaccinations as float)) over (partition by a.country order by a.country, a.date) as cumulative_vaccinations
from PortfolioProject..CovidDeaths a
join PortfolioProject..CovidVaccinations b
	on a.country = b.country
	and a.date = b.date
where a.continent is not null

select *, (cumulative_vaccinations/population)*100 as percent_pop_vaccinated
from #PercentPopVaccinated
order by country, date

-- Create view to store data for later visualizations
create view PercentPopVaccinated as
select a.continent, a.country, a.date, a.population, b.new_vaccinations,
	sum(cast(b.new_vaccinations as float)) over (partition by a.country order by a.country, a.date) as cumulative_vaccinations
from PortfolioProject..CovidDeaths a
join PortfolioProject..CovidVaccinations b
	on a.country = b.country
	and a.date = b.date
where a.continent is not null


Select *
From PercentPopVaccinated