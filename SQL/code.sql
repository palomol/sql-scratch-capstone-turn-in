   ---------------------------------------------------------
---     		SQL- Laura Palomo López
   
   ---------------------------------------------------------
   
   
    --- COLUMNAS DE LA TABLA
    
  /*  select * from page_visits
    limit 10;
*/

-----------------------------
--pregunta 1
-----------------------------
-----n de fuentes
select distinct utm_source
from page_visits;

select count (distinct (utm_source))
 from page_visits;
                      
                        
 --n de campaas
                        
select distinct utm_campaign
from page_visits;

select count (distinct (utm_campaign))
 from page_visits;

 
 --- como estan relacionadas?
 
 select utm_campaign, utm_source, count(*)
 from page_visits
 group by 1,2
 order by 1,2;
 
 -----------------------------
--pregunta 2
-----------------------------

-- paginas distintas?

select distinct page_name
from page_visits
order by page_name;


 -----------------------------
--pregunta 3
-----------------------------
-- de cuantos primeros toques se responsabiliza cada campaa?


WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT 
		pv.utm_campaign,
    count(*)
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
    group by pv.utm_campaign;
    
     -----------------------------
--pregunta 4
-----------------------------
-- de cuantos ultimos toques se responsabiliza cada campaa?


WITH last_touch AS (
    SELECT user_id,
        max(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT 
		pv.utm_campaign,
    count(*)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    group by pv.utm_campaign;


     -----------------------------
--pregunta 5
-----------------------------
--cuantos visitantes hacen una compra?


select count(distinct user_id) as user
from page_visits
where page_name='4 - purchase';

select distinct user_id as user
from page_visits
where page_name='4 - purchase'

     -----------------------------
--pregunta 6
-----------------------------

--cuantos ultimos toques hay en la pagina de commpras?

-- esta seria por campaa
WITH last_touch AS (
    SELECT user_id,
        max(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT 
		pv.utm_campaign,
    count(*)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    where pv.page_name='4 - purchase'
    group by pv.utm_campaign;
 
 --esto seria en total   
 WITH last_touch AS (
    SELECT user_id,
        max(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT 
		
    count(*)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    where pv.page_name='4 - purchase'
    ;
 -----------------------------
--pregunta 7
-----------------------------

-- cual es el viaje tpico del usuario?
-- aqui los usuarios son distintos. Hay usuarios que no pasan de la primera pagina


select distinct page_name, count(distinct user_id)
from page_visits
group by 1
order by 1
;


--numero de visitas
select count(*) 
from page_visits;

--numero de usuarios diferentes

select count(distinct user_id)
from page_visits;

-------Aqui vemos que porcentaje de usuarios llega al final de la compra
with conteo as(
select count(distinct user_id) as usuario, 
count(distinct case
       when page_name='1 - landing_page' then user_id end) as landing_page,
count(distinct case
       when page_name='2 - shopping_cart' then user_id end) as shopping_cart,
 
count(distinct case
       when page_name='3 - checkout' then user_id end) as checkout,
 count(distinct case
       when page_name='4 - purchase' then user_id end) as purchase
from page_visits
  )
  
select 
round((landing_page/ (1.0 * usuario)) *100) as '%_langing_page',
round((shopping_cart/ (1.0 * usuario)) *100)  as '%_shopping_cart',
round((checkout/(1.0 * usuario)) *100) as '%_checkout',
round((purchase/(1.0 * usuario)) *100 ) as '%_purchase'
from conteo
;
