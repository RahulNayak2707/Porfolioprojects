select*
from Projectportfolio..CovidDeaths
where continent is not null
order by 3,4

select*
from Projectportfolio..CovidVaccinations
order by 3,4

--Total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
from Projectportfolio..CovidDeaths
where location like '%India%'
order by 1,2

--total cases vs population
--shows what percentage of people got covid

select location,date,population,total_cases,(total_cases/population)*100 as casepercentage 
from Projectportfolio..CovidDeaths
where location like '%India%'
order by 1,2

--Countries with highest infection rate compared to population

select location,population,max(total_cases)as highestcasecount,max((total_cases/population))*100 as populationinfectedpercentage
from Projectportfolio..CovidDeaths
--where location like '%India%'
group by location,population
order by populationinfectedpercentage desc

--countries with highest death count

select location,max(cast(total_deaths as int))as Totaldeathcount
from Projectportfolio..CovidDeaths
--where location like '%India%'
where continent is not null
group by location
order by Totaldeathcount desc

-- Global numbers

select sum(new_cases)as Total_cases,sum(cast(new_deaths as int)) as Total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from Projectportfolio..CovidDeaths
--where location like '%India%'
where continent is not null
order by 1,2


--total population vs vaccination

select d.continent ,d.location,d.date,d.population,v.new_vaccinations
,sum(cast(v.new_vaccinations as int))  over(partition by d.location order by d.location,d.date)
as rollingpeoplevaccinated
from Projectportfolio..CovidDeaths d
join
Projectportfolio..CovidVaccinations v
on d.location=v.location
and d.date=v.date
where d.continent is not null
order by 2,3




--Use CTE

with popvsvac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select d.continent ,d.location,d.date,d.population,v.new_vaccinations
,sum(cast(v.new_vaccinations as int))  over(partition by d.location order by d.location,d.date)
as rollingpeoplevaccinated
from Projectportfolio..CovidDeaths d
join
Projectportfolio..CovidVaccinations v
on d.location=v.location
and d.date=v.date
where d.continent is not null

)

select *, (rollingpeoplevaccinated/population)*100 as vaccinatedpeoplepercentage from popvsvac 


-- Creating views to store data 

create view vaccinatedpeoplepercentage as
select d.continent ,d.location,d.date,d.population,v.new_vaccinations
,sum(cast(v.new_vaccinations as int))  over(partition by d.location order by d.location,d.date)
as rollingpeoplevaccinated
from Projectportfolio..CovidDeaths d
join
Projectportfolio..CovidVaccinations v
on d.location=v.location
and d.date=v.date
where d.continent is not null






