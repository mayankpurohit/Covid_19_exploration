-- SELECT * FROM `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb` LIMIT 1000

-- select data which we need to use
select location, date, total_cases, new_cases, total_deaths, population
from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb` order by location, date;

-- find death_rate(mortality rate)
select location, date, total_cases, (total_deaths/total_cases)*100 as death_rate, population from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb`
where location = 'India' and continent is not null
order by location, date;

-- find percentage of population infected
select location, date, total_cases, (total_cases/population)*100 as infected_population_percentage from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb`
where location = 'India' and continent is not null order by location, date;


-- find country with highest infected population
select location, MAX(total_cases) as max_infection_count, MAX((total_cases/population))*100 as max_infected_population
from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb`
group by location, population order by max_infected_population desc;


-- find country with highest deaths
select location, max(cast(total_deaths as int)) as max_death_count from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb`
where continent is not null group by location order by max_death_count desc;

-- highest death count continent wise
select continent, max(cast(total_deaths as int)) as max_death_count from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb`
where continent is not null
group by continent order by max_death_count desc;


-- find total cases, total death worldwide
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death_count, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage 
from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb` 
where continent is not null;


select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (PARTITION BY dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from `bigquery-tutorial-331505.covid_19_dataset.covid_death_tb` dea
join `bigquery-tutorial-331505.covid_19_dataset.covid_vaccination_tb` vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
order by location, date;



