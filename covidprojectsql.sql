select * from CovidDeaths
order by location, date

select * from CovidDeaths
where location = 'Poland'
order by location, date

select * from CovidVaccinations
where location = 'Poland'
order by location, date

SELECT DISTINCT LOCATION FROM CovidDeaths
order by location

select location,date,population,total_cases,total_deaths,
ROUND((total_cases/population)*100,2) as '% of population sick',
ROUND((cast(total_deaths as int)/total_cases)*100,2) as '% of dead population among sick people'
from CovidDeaths
where location = 'Poland'
order by location, date

select location, max(cast(Total_deaths as int)) as TotalDeaths
from CovidDeaths
where continent is not null
group by location 
order by TotalDeaths desc

select location,
ROUND(max(cast(Total_deaths as int))/population*100,2) as PercentageOfPopDeath,
max(total_deaths) as TotalDeathsNumber
from CovidDeaths
where continent is not null
group by location,population
order by PercentageOfPopDeath DESC

select location,
max(cast(Total_deaths as int)) as TotalDeaths,
ROUND(max(cast(Total_deaths as int))/population*100,2) as PercentageOfPopDeath,
ROUND(max(cast(Total_deaths as int))/max(total_cases)*100,2) as PercentageOfPopDeathAmongInfected,
max(cast(Total_deaths as int)) as TotalDeathsNumber
from CovidDeaths
where continent is null
group by location,population
order by PercentageOfPopDeath DESC

select cd.date,cd.new_deaths,cd.new_cases, (cv.people_vaccinated/cd.population)*100 as PercentageOfPopVacinated
from CovidDeaths cd join CovidVaccinations cv on cd.location = cv.location and cd.date = cv.date
where cd.location = 'Poland'
order by cd.date

select datepart(year,cd.date), 
datepart(month,cd.date),
SUM(cast(cd.new_deaths as int)) as newdeaths,
SUM(cd.new_cases) as newcases,
MAX(cast(cv.people_vaccinated as int))/MAX(cd.population)*100 as PercentageOfPopVacinated
from CovidDeaths cd join CovidVaccinations cv on cd.location = cv.location and cd.date = cv.date
where cd.location = 'Poland'
group by datepart(year,cd.date),datepart(month,cd.date)
order by datepart(year,cd.date),datepart(month,cd.date)

select MAX(cd.population)
from CovidDeaths cd join CovidVaccinations cv on cd.location = cv.location and cd.date = cv.date
where cd.location ='Poland'

select cd.location,datepart(year,cd.date) as year, 
datepart(month,cd.date) as month,
SUM(cast(cd.new_deaths as int)) as newdeaths,
SUM(cd.new_cases) as newcases,
MAX(cast(cv.people_vaccinated as int))/MAX(cd.population)*100 as PercentageOfPopVacinated
from CovidDeaths cd join CovidVaccinations cv on cd.location = cv.location and cd.date = cv.date
group by cd.location, datepart(year,cd.date),datepart(month,cd.date)
order by cd.location, datepart(year,cd.date),datepart(month,cd.date)

--

select cd.location,max(cd.population),datepart(year,cd.date) as year, 
datepart(month,cd.date) as month,
SUM(cast(cd.new_deaths as int)) as newdeaths,
SUM(cd.new_cases) as newcases,
MAX(cast(cv.people_vaccinated as int))/MAX(cd.population)*100 as PercentageOfPopVacinated
from CovidDeaths cd join CovidVaccinations cv on cd.location = cv.location and cd.date = cv.date
where cd.continent is null
group by cd.location, datepart(year,cd.date),datepart(month,cd.date)
order by cd.location, datepart(year,cd.date),datepart(month,cd.date)


with x as(
select location,continent, MAX(cast(replace(female_smokers,',','.') as float) + cast(replace(male_smokers,',','.') as float))/2 as PercentageOfPopSmokers,
MAX(hospital_beds_per_thousand) as hospital_beds_per_thousand,
ROUND(SUM(cast(new_deaths as int))/SUM(new_cases)*100,2) as PercentageOfPatientsWhoDied,
Sum(cast(new_deaths as int)) as TotalDeaths
from CovidDeaths
where continent is not null
group by continent,location)
select * from x 
where TotalDeaths >20000
order by PercentageOfPatientsWhoDied desc

select location, max(people_vaccinated) as people_vaccinated, max(people_fully_vaccinated) as people_fully_vaccinated
from CovidVaccinations
where continent is not null
group by location
order by location

create view TotalCases as  
select location, max(total_cases) as total_cases
from CovidDeaths
where continent is not null
group by location

select * from TotalCases order by total_cases desc

with y as( 
select cd.location, max(cast (cv.people_vaccinated as int))/max(cd.population) * 100 as PercentageOfPopVacinated
from CovidVaccinations cv join CovidDeaths cd on cv.location = cd.location and cv.date = cd.date 
where cd.population>1000000
group by cd.location)
select *, rank() over (order by PercentageOfPopVacinated desc) as VaccinationRank from y 


