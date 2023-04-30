select * from covid_vaccinations_tests
select distinct(continent) from covidDeath 
select distinct(location )from covidDeath where continent is Null 
--result names of all continent +  Lower middle income,World,Low income ,European Union	,International
--,Upper middle income ,High income 


--looking at total cases vs total deaths 
select date , continent,location ,total_cases ,total_deaths,round((total_deaths / total_cases)*100,3) as death_persent  from covidDeath
where location = 'china'
order by  date,continent, location

--looking at countries with higest infection rate compared to population 
select	 location,population,max(total_cases) max_cases,max(total_cases/population) maxInfection from covidDeath
group by location,population
order by maxInfection desc

--looking at countries with higest death rate compared to population 
select	 location,population,max(total_deaths ) max_death,max(total_deaths/population)*100 maxdeathRate
from covidDeath
where continent is not null
group by location,population
order by maxdeathRate desc


--looking at continent with higest deacth count  

with cte 
as (select continent, location ,max(total_deaths) mts from covidDeath
where continent is not null
group by continent,location)
select continent,sum(mts) total_d from 	 cte
group by continent
order by total_d desc
-- 	or 
select location , max(total_deaths) total_d from covidDeath
where continent is null 
group by location
order by total_d desc

--looking at continent with higest infection rate compared to population 
select location , max(total_deaths) total_d	,max(total_deaths/population)*100 maxdeathRate
from covidDeath
where continent is null 
group by location
order by total_d desc

--global numbers			 
select date ,sum(new_cases)	toatal_cases,sum(new_deaths) total_deaths
from covidDeath
group by date
order by date asc

-------------------------------------
--looking for total population vs vaccinations
select cv.continent,cv.location,cv.date ,cd.population,total_vaccinations,new_vaccinations,(total_vaccinations/ cd.population)*100
from covid_vaccinations_tests cv
inner join covidDeath cd on cd.location  = cv.location	
			and cd.date = cv.date
where cv.continent is not null
--group by cv.location
order by cv.location asc,cv.date asc
------------------------------------
drop table if exists #pop_vaccPercent
create table #pop_vaccPercent
(
	continent nvarchar(255),
	location  nvarchar(255),
	date datetime	,
	population	 numeric,
	total_vaccinations numeric,
	vaccPERpop    numeric
)
insert into #pop_vaccPercent
select cv.continent,cv.location,cv.date ,cd.population,total_vaccinations,(total_vaccinations/ cd.population)*100
from covid_vaccinations_tests cv
inner join covidDeath cd on cd.location  = cv.location	
			and cd.date = cv.date
where cv.continent is not null
--group by cv.location
order by cv.location asc,cv.date asc

 

