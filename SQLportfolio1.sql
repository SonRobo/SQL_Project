select * 
from first_portfolio_sql.dbo.CovidDeaths$
order by 3,4

select * 
from first_portfolio_sql.dbo.CovidVaccinations$
order by 3,4

--select data that we're going to be using
select location,date,total_cases,new_cases,total_deaths,population
from first_portfolio_sql.dbo.CovidDeaths$
order by 1,2

--looking at total cases vs deaths
select location,date,total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from first_portfolio_sql.dbo.CovidDeaths$
where location like '%viet%'
order by 1,2

--looking at total cases vs population
select location,date,total_cases,new_cases,population, (total_cases/population)*100 as got_covid_percentage
from first_portfolio_sql.dbo.CovidDeaths$
where location like '%viet%'
order by 1,2

--looking at country with highest infection rate
select location,population, max(total_cases) as highest_infection_count ,max((total_cases/population))*100 as highest_infection_rate
from first_portfolio_sql.dbo.CovidDeaths$
group by location,population 
order by highest_infection_rate desc

--showing country with highest death count per population
select location, max(cast(total_deaths as int)) as highest_death_count ,max((total_deaths/population))*100 as highest_death_rate
from first_portfolio_sql.dbo.CovidDeaths$
where continent is not null
group by location 
order by highest_death_count desc

--global
--death_percenntage_per_day
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 
as death_percentage
from first_portfolio_sql.dbo.CovidDeaths$
where continent is not null
group by date
order by 1
--death_percenntage_all_time
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 
as death_percentage_all_time
from first_portfolio_sql.dbo.CovidDeaths$
where continent is not null
order by 1
 
 select * 
 from first_portfolio_sql.dbo.CovidVaccinations$
 where location like '%maldives%'
 order by date
--looking at total population vs vaccinations
select *
from first_portfolio_sql.dbo.CovidDeaths$ as dea
join first_portfolio_sql.dbo.CovidVaccinations$ as vac
on vac.location = dea.location
and dea.date = dea.date
--cte
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
from first_portfolio_sql.dbo.CovidDeaths$ as dea
join first_portfolio_sql.dbo.CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
order by 2,3 
