# Q1A) Display Country code, income groups containing the word "lower" or "low" and gross savings exceeding 20 for the economical year 2015

select distinct e5.code, e5.income_group, e5.gross_savings from economy_2015 as e5 where income_group IN
(select income_group from economy_2015 where (income_group like "%Lower" or income_group like "%Low%" )) and gross_savings > 20;

# Q1B) Display Country code, income groups containing the word "High" or "Upper" and gross savings exceeding 20 for the economical year 2019

select distinct e9.code, e9.income_group, e9.gross_savings from economy_2019 as e9 where income_group IN
(select income_group from economy_2015 where (income_group like "%High%" or income_group like "%Upper%" )) and gross_savings > 20;

# Q2) Find the count of customers from each country who have availed "A&S Consulting Group" services and sort it in descending order.

SELECT Country, COUNT(*) AS Count FROM customer
GROUP BY Country
ORDER BY Count desc;


#Q3.) Write a SQL query using EXISTS to retrieve the details of only those customers who have given an ‘excellent’ rating along with customer 
#name and customer country 

SELECT customer_first_name AS First_Name, customer_last_name AS Last_Name, country
FROM customer c
WHERE EXISTS (SELECT *
FROM feedback AS sf
WHERE sf.rating = 'Excellent' AND c.cust_id = sf.cust_id);


# (MID LEVEL QUERY)

#Q4) Write a SQL Query to display all the details of common countries having prime minister and president for particular continent along with their 
# independent year

select s.country, s.continent, pm.prime_minister, p.president, s.indep_year from states as s
join prime_ministers as pm
on s.country = pm.country
join president as p
on pm.country = p.country

# Q5) Retrieve 15 feedback Id's and the corresponding rating given by different customers for the services offered to them along with their first and 
# last name.


select Feedback_Id, Customer_First_Name, Customer_Last_Name, Rating FROM feedback
JOIN customer ON feedback.Cust_Id=customer.Cust_Id
WHERE rating IN ('Excellent', 'Good')
ORDER BY 4 
LIMIT 15;

# Q6) Find the country and continent whose independence year is between 1910 and 1970, and also whose economic behavior is characterized by 
# an inflation rate and gdp percapita that are greater than their own averages for the year 2010.


SELECT country_name, continent, Indep_Year, Region, e.inflation_rate from
(select Code, Country_name, Continent, Region, Indep_Year from nation where indep_year between '1910' and '1970') as sub1
inner join economy as e
on e.code = sub1.code
where inflation_rate > ( select avg(inflation_rate) from economy where gdp_percapita > (select avg(gdp_percapita) from economy)) and year = '2010'

# Q7) Using Common Table Expression, compose a SQL query to display 9 records of language name, country code, percentage of languages spoken, 
# and government form of these country code.

with sample as (select * from (select name, code, percent from lingo) as l where percent > 50)
select sample.name as Lang_Name, sample.code as Country_Code, sample.percent as Lang_Percent, n.gov_form as Gov_Form
from nation as n
right join sample
using(code) limit 9;

# Write a SQL query using ANY to extract the list of countries, income group, and GDP for only those countries with life expectancy greater than 83

  SELECT code, income_group, gdp_percapita 
  FROM economy 
  WHERE code = ANY (SELECT country_code 
  FROM population 
  WHERE life_expectancy > '83');



# Q8) Display City name, country code, Prime Minister name, Country name, City Population, 
# city Urban Population, Surface Area of country, country constitution name, and its currency name and 
# its fractional unit which has a metro population not equals to zero and display 12 records for only 
# India, United Kingdom, oman, Australia, Pakistan countries and sort the metro population column in ascending order.

Select distinct c.name_city as City_Name, c.country_code as Country_Code, pm.prime_minister as Prime_Ministers, n.country_name as Country_Name,
c.city_proper_pop as City_Pop, c.metroarea_pop as Metro_Pop, c.urbanarea_pop as Urban_Pop, n.surface_area as Surface_Area_C,
n.gov_form as Constitution_Name, ps.curr_code as Currency_Code , ps.frac_unit from cities as c
inner join nation as n
on c.country_code = n.code
inner join currency as ps
on n.code = ps.code
inner join prime_ministers as pm
on n.country_name = pm.country
where metroarea_Pop > (select min(Metroarea_Pop) from cities WHERE cities.country_code = ps.code) and country_code IN ('IND', 'GBR', 'OMN', 'AUS', 'PAK')
order by 6
limit 12;


# Q9) Retrieve several details for the Year 2010 population that indicate whether the official language of a particular country(code) is True or False,
# as well as the percentage of each language spoken in the country and the life expectancy for 2010 with the country code.

with Invest_CTE as (
select country_code, year, pop_id, life_expectancy, size from population as p where p.year in (select year from population where year = '2010') 
and life_expectancy > 58 and life_expectancy is not null )

select l.lang_id as ID, l.name as lang_name, l.code as country_code, l.official as Official_language, l.percent, Invest_CTE.life_expectancy, Invest_CTE.year from lingo as l Right JOIN Invest_CTE
on l.code = Invest_CTE.country_code
where percent > (select min(percent) from lingo)
order by l.lang_id asc;



# Q10) Find the Investment Prediction of all the countries for making investment by investor based on the year of 2015 and generate those countries name and 
# their sub attributes which has greater than or equal to maximum gdp_percapita.


select en.code as Code_Country, nt.country_name as CN_Name, en.year as Investment_Year, en.gross_savings as Gross_Sav ,cn.basic_unit as currency_name, (en.imports + en.exports) as Investment_Trade,
case when en.imports > en.exports then 'Investment for Trading is Bad'
when en.imports < en.exports then 'Investment for Trading is Good' else '50-50 Chances for Investment' end as Prediction
from economy as en
left join currency as cn
on en.code = cn.code
left join nation as nt
on en.code = nt.code
where en.year = '2015' and en.gdp_percapita >= (select max(en.gdp_percapita) from economy) and cn.basic_unit is not null

# Q11) Determine the top most Countries whose total investment is greater than the average of itself for Low income group category specially for the 
# singular year of 2015

Select nt.country_name as Names_of_Country, count(ct.name_city) as Total_Count from nation as nt
inner join cities as ct
on nt.code = ct.country_code
inner join economy as e
on ct.country_code = e.code
where total_investment > ( select avg(total_investment) from economy where income_group like "low%" and year = (select distinct year from economy_2015))
group by Names_of_Country
order by 2 desc;




