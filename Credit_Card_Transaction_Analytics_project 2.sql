
select 'customers' as table_name,count(*) as no_of_records from customers
union all
select 'cards',count(*) from cards 
union all
select 'merchants',count(*) from merchants 
union all
select 'branches',count(*) from branches 
union all 
select 'transactions',count(*) from transactions;

select * from customers;
select * from cards;
select * from merchants;
select * from branches;
select * from transactions;



---1.HOW many customers are in the databade
select count(*) from customers;

---2.how many credit card issued
select count(card_type) from cards;

---3.how many merchat are registered
select count(*) from merchants;

--4.how many branches does the bank have
select count(*) from branches;

---5.how many transactions are recoreds
select count(*) from transactions;

--6.what are the different cards
select category as cards from merchants group by category;
select card_type from cards group by card_type;---its work
select distinct card_type from cards;---this also same result

--7.what are the different card networks
select distinct network from cards;
select network from cards group by network;

--8..what are the different merchants categories
select distinct category from merchants;
select category from merchants group by category;

--9.what are the different transaction statuess
select status from transactions group by status;
select distinct status from transactions;

--10.what are the differeny payments mode
select distinct payment_mode from transactions;

--11.how may customers are there in each state
select state, count(distinct customer_id) from customers group by state;
------state_name,full_name of customers,noof customers in each state and total cutsomers,
select state,first_name,last_name,
first_name||' '|| last_name as full_name,--we use tgis also--concat(first_name,' ',last_name) as full_name,
count(*) over(partition by state) as no_of_customers_in_state,
count(*) over() as total_customers
from customers 
group by state,first_name,last_name,full_name
order by no_of_customers_in_state desc;


--12.how may customers are there in each city
select state,city, count(distinct customer_id) from customers group by state,city;
select city, count(distinct customer_id) from customers group by city;


--13.what is the avg annual income of customers
select round(avg(annual_income),2) as avg_annual_income from customers; 

--14.how many cards are active,blocked,expire
select status,count(*) total_cards from cards group by status order by total_cards desc ;

--15..how transations are approved,declined,reversed
select status,count(*) total_transaction_status from transactions group by status order by total_transaction_status;

--16.how many transactions are there in each payment method
select payment_mode,count(*) as total_transactions from transactions group by payment_mode order by total_transactions desc;

--17.which payment has the highest noof transaction
select payment_mode,count(*) as total_transactions from transactions group by payment_mode order by total_transactions desc limit 1;

--18.what is the total transaction ammount
select sum(amount) as total_amount from transactions;

--19.what is the avg transaction ammount
select avg(amount) as total_amount from transactions;

--20.what is the min and max transaction amount
select
max(amount) as max_amount,
min(amount) as min_amount 
from transactions;

--21. what is the approval transactin amount
select status,sum(amount) as total_amount from transactions group by status;---ITS SHOW ALL ststus sum amount
select status,sum(amount) as total_amount from transactions where upper(status)='APPROVED' group by status ;
select status,sum(amount) as total_amount from transactions group by status having upper(status)='APPROVED';

--22.how many transactions were made through each payment mode
select payment_mode,count(*) as total_transactions from transactions group by payment_mode order by total_transactions desc;

--23.what is the total spending by merchant category
select m.category,
sum(t.amount) as total_spending_amount
from transactions t
join merchants m
on t.merchant_id=m.merchant_id 
group by m.category
order by total_spending_amount desc ;


--24.--23.what is the avg spending/transaction values/atotal_ammount by each merchant category
select m.category,
round(avg(t.amount)::numeric,2) as avg_spending_amount,
sum(t.amount) as total_spending_amount
from transactions t
join merchants m
on t.merchant_id=m.merchant_id 
group by m.category
order by avg_spending_amount desc,total_spending_amount ;

---25.what is the total transaction amount by state
select m.state,
sum(t.amount) as total_spending_amount
from transactions t
join merchants m
on t.merchant_id=m.merchant_id 
group by m.state
order by total_spending_amount desc ;

--26.which city generates the highest transaction values
select m.city,
sum(t.amount) as total_spending_amount
from transactions t
join merchants m
on t.merchant_id=m.merchant_id 
group by m.city
order by total_spending_amount desc ;

--27.combine sate,city of highest transaction values/transaction amount
select m.state,m.city,
sum(t.amount) as total_spending_amount
from transactions t
join merchants m
on t.merchant_id=m.merchant_id 
group by m.state,m.city
order by total_spending_amount desc ;

--28.which branch generates the highest amount
select b.branch_id,b.branch_name,
sum(t.amount) as total_spending_amount
from transactions t
join branches b
on t.branch_id=b.branch_id
group by b.branch_id,b.branch_name
order by total_spending_amount desc ;

--29.what is avg credit limit for each credit card type
select card_type,
round(avg(credit_limit)::numeric,2) as avg_credit_limit
from cards 
group by card_type 
order by avg_credit_limit desc;
----------
select card_type,
sum(credit_limit) as total_credit_limit,
count(*) as noof_crdit_limit,
round(avg(credit_limit)::numeric,2) as avg_credit_limit
from cards 
group by card_type 
order by avg_credit_limit desc;

--30.how much cards does each customers have
select customer_id,
count(*) as total_cards
from cards 
group by customer_id
order by total_cards desc;
---------------------------------------
select customer_id, 
string_agg( card_type,',') as card_types,
count(*) as total_cards
from cards 
group by customer_id,card_type
order by total_cards desc;
------------------------------------------------
select customer_id, 
string_agg(distinct card_type,',') as card_types,
count(*) as total_cards
from cards 
group by customer_id,card_type
order by total_cards desc;


--31.WHIC CARD IS USED FOR THE HIGHEST TRANSACTIONS VALUE/AMOUNT
select c.card_type,
sum(t.amount) as total_transaction_amount
from cards c
join transactions t
on c.card_id=t.card_id 
group by c.card_type 
order by total_transaction_amount desc;


--31.WHIC CARD NETWORKS PROCESS THE HIGHEST TRANSACTIONS VALUE/AMOUNT
select c.network,
sum(t.amount) as total_transaction_amount
from cards c
join transactions t
on c.card_id=t.card_id 
group by c.network
order by total_transaction_amount desc;

--32.what is the total spending by month
select 
to_char(transaction_date::date,'month') as month,
sum(amount) as total_spending_by_month
from transactions 
group by to_char(transaction_date::date,'month'),EXTRACT(month from transaction_date::date)
order by EXTRACT(month from transaction_date::date);

--33.which month is the highest transaction amount
select 
to_char(transaction_date::date,'month') as month,
sum(amount) as total_spending_by_month
from transactions 
group by to_char(transaction_date::date,'month'),EXTRACT(month from transaction_date::date)
order by total_spending_by_month desc
limit 1;

--34.which day of the week has highest transaction amoumt
select 
to_char(transaction_date::date,'Day') as Day,
sum(amount) as total_spending_by_month
from transactions
group by to_char(transaction_date::date,'Day'),EXTRACT( DOW from transaction_date::date)
order by total_spending_by_month desc;
------
select 
to_char(transaction_date::date,'Day') as Day,
sum(amount) as total_spending_by_month
from transactions
group by to_char(transaction_date::date,'Day'),EXTRACT( DOW from transaction_date::date)
order by total_spending_by_month desc
limit 1;


---35.which payment mode generates the highest transaction amount
select payment_mode,
sum(amount) as spending_amount
from transactions
group by payment_mode
order by spending_amount desc;
--use limit 1;

--36.who are the top 10 customers by total spending
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
sum(t.amount) as total_spending_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id
group by c.customer_id,c.first_name ||' '|| c.last_name
order by total_spending_amount desc
limit 10;

--37.what are the top 10 customer by no of transactions
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
count(t.transaction_id) as no_of_transactions
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id
group by c.customer_id,c.first_name ||' '|| c.last_name
order by no_of_transactions desc
limit 10;

--38.which customers have never made a transaction
select c.customer_id,c.first_name ||' '|| c.last_name as full_name----------one method
from customers c
left join cards cr
on c.customer_id=cr.customer_id 
left join transactions t
on t.card_id=cr.card_id
where t.transaction_id is null
group by c.customer_id,c.first_name ||' '|| c.last_name 
order by customer_id;

create view ad as --------------method 2
select c.customer_id,c.first_name ||' '|| c.last_name as full_name
from customers c
left join cards cr
on c.customer_id=cr.customer_id 
left join transactions t
on t.card_id=cr.card_id
where t.transaction_id is null
group by c.customer_id,c.first_name ||' '|| c.last_name 
order by customer_id;

select count(*) from ad;


select customer_id,x.full_name,-------------method 3
sum(count_of_customers) over() as total_customers from(
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
COUNT(*) as count_of_customers
from customers c
left join cards cr
on c.customer_id=cr.customer_id 
left join transactions t
on t.card_id=cr.card_id
where t.transaction_id is null
group by c.customer_id,c.first_name ||' '|| c.last_name) as x 
order by customer_id;


---39.which customer have hihgest avg transaction value/amount
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
round(avg(t.amount)::numeric,2) as avg_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id
group by c.customer_id,c.first_name ||' '|| c.last_name
order by avg_amount desc
limit 1;

--.same but advance---in that we can modify what we have like top 10,top 1,
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
sum(t.amount) as total_amount,
count(t.transaction_id) as no_of_transactions,
string_agg(t.amount::text,',') as transaction_amount,
round(avg(t.amount)::numeric,2) as avg_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id
group by c.customer_id,c.first_name ||' '|| c.last_name
order by  customer_id;


--40.which customers have an annual income higher than the avg annual income of all customers

select customer_id,first_name ||' '|| last_name as full_name,annual_income
from customers 
where (annual_income) > (select avg(annual_income) as avg_income from customers)
order by annual_income desc;

--above queation can find how many  customers have an annual income higher than the avg annual income of all customers
create view count_of_customers as 
select customer_id,first_name ||' '|| last_name as full_name,annual_income
from customers 
where (annual_income) > (select avg(annual_income) as avg_income from customers)
order by annual_income desc;

select count(*) from count_of_customers;

--41.which high income customer have the highest tptal credit card spending
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,c.annual_income,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id
 where c.annual_income > (select avg(annual_income) from customers)
 group by c.customer_id,full_name,c.annual_income 
 order by total_spending desc;

--42.which customer have more than one credit card
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
count(cr.card_id) as total_cards
from customers c
join cards cr
on c.customer_id=cr.customer_id
group by c.customer_id,full_name 
having count(cr.card_id) >1 
order by total_cards;

--43.how many customers have more than one credit card
select count( *) from (-----------------one method
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
count(cr.card_id) as total_cards
from customers c
join cards cr
on c.customer_id=cr.customer_id
group by c.customer_id,full_name 
having count(cr.card_id) >1 
order by total_cards) as aaa;


create view ax as ---------2nd method
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
count(cr.card_id) as total_cards
from customers c
join cards cr
on c.customer_id=cr.customer_id
group by c.customer_id,full_name 
having count(cr.card_id) >1 
order by total_cards;

select count(*) from ax;

---44.which customer have the highest total credit limit across all the their customers
select c.customer_id,c.first_name ||' '|| c.last_name as full_name,
sum(cr.credit_limit) as total_credit_limit
from customers c
join cards cr
on c.customer_id=cr.customer_id
group by c.customer_id,full_name 
order by total_credit_limit desc;


---45.which merchat categories have the highest transaction decline rate
select distinct category from merchants;

select m.category,
count(*) as total_transactions,
sum(case when upper(t.status)='DECLINED'then 1 else 0 end ) as declined_transactions,
sum(case when upper(t.status)='DECLINED' then 1 else 0 end)*100/count(*) as declined_rate
from transactions t
join merchants m
on t.merchant_id=m.merchant_id 
group by m.category 
order by declined_transactions desc;

--46.which branches have the highest transactions declined rate
select br.branch_id,br.branch_name,
count(*) as total_transactions,
sum(case when upper(t.status)='DECLINED'then 1 else 0 end ) as declined_transactions,
sum(case when upper(t.status)='DECLINED' then 1 else 0 end)*100/count(*) as declined_rate
from transactions t
join branches br
on t.branch_id=br.branch_id
group by br.branch_id,br.branch_name
order by declined_transactions desc;


--47.which customers have the highest spending growth over time
with monthly_spending as (
select c.customer_id,
to_char(transaction_date::date,'month') as month,
sum(amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=t.card_id
group by c.customer_id, to_char(transaction_date::date,'month'),EXTRACT(month from transaction_date::date)
order by EXTRACT(month from transaction_date::date))
select customer_id,month,total_spending,
total_spending-lag(total_spending) over (partition by customer_id order by month) as spending_growth
from monthly_spending
order by spending_growth;


---48.what is the monthly transaction growth perantage
with monthly_spending as (
select
date_trunc('month',transaction_date::date) as month,
sum(amount) as total_spending
from transactions 
group by date_trunc('month',transaction_date::date)
)
select month,
lag(total_spending) over (order by month) as previous_month,
total_spending,
round(((total_spending-lag(total_spending) over (order by month))/lag(total_spending) over (order by month)*100)::numeric,2) as growth_percentage
from monthly_spending
order by month;


---49.what is the cumulative trasnaction amount over time
select
date_trunc('month',transaction_date::date) as month,
sum(amount) as total_spending,
sum(sum(amount)) over ( order  by date_trunc('month',transaction_date::date)) as cumulative_amount
from transactions 
group by date_trunc('month',transaction_date::date)
order by month;

select
to_char(transaction_date::date,'month') as month,
sum(amount) as total_spending,
sum(sum(amount)) over ( order  by to_char(transaction_date::date,'month')) as cumulative_amount
from transactions 
group by to_char(transaction_date::date,'month'),EXTRACT(month from transaction_date::date)
order by month;


--50.what is the percentage of total spending from top 10 customers
with customer_spending as (
select c.customer_id,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id
group by c.customer_id 
),
top_10 as (
 select sum(total_spending) as top_10_spending
 from(select total_spending
       from customer_spending
       order by total_spending desc 
       limit 10) as x
       )
 select top_10_spending,(select sum(total_spending) from customer_spending) as total_spending,
 round(((top_10_spending) /(select sum(total_spending) from customer_spending)*100)::numeric,2) as percantage_of_total 
 from top_10;

--------ADVANCED-WINDOW FUNCTION/CTE/BUSINESS
create index idx_cards_customer_id
on cards(customer_id);
create index idx_transactions_card_id
on transactions(card_id);
create index idx_transactions_brenches_id
on transactions(_id);
create indes


--51.how can we write rank customers by their total spending with each state
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
c.state,
sum(t.amount) as total_spending,
rank() over (partition by c.state order by sum(t.amount) desc) as rank
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=t.card_id
group by c.customer_id,c.first_name,c.last_name,c.state;

with customer_spending as (
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
c.state,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=t.card_id
group by c.customer_id,c.first_name,c.last_name,c.state
)
select customer_id,full_name,state,total_spending,
rank()over(partition by state order by total_spending desc ) as rank
from customer_spending 
order by state,rank;

--52.rank merchants by transaction revenue within each category
select distinct category from merchants;

select 
m.category,
m.merchant_id,
m.merchant_name,
sum(t.amount) as total_revenue,
rank() over(partition by m.category order by sum(t.amount) desc) as rank
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by m.category,
m.merchant_id,
m.merchant_name
order by m.category,rank;


--53.rank branches by transaction amount within each state
select distinct state from branches;

select 
b.state,
b.branch_id,
b.branch_name,
sum(t.amount) as total_revenue,
rank() over(partition by b.state order by sum(t.amount) desc) as rank
from branches b
join transactions t
on b.branch_id=t.branch_id
group by b.state,
b.branch_id,
b.branch_name
order by b.state,rank;


--54.what is the 3_month moving avg of th avg transaction value/amount
select to_char(transaction_date::date,'month') as month from transactions
group by month, extract(month from transaction_date::date) 
order by extract(month from transaction_date::date);

with monthly_data as( 
select date_trunc('month',transaction_date::date) as month,
round(avg(amount)::numeric,2) as avg_amount
from transactions 
group by month
)
select 
month,
avg_amount,
avg(avg_amount) over(order by month rows between 2 preceding and current row) as moving_avg
from monthly_data
order by month;


with monthly_data as( 
select 
to_char(transaction_date::date,'month') as month,
round(avg(amount)::numeric,2) as avg_amount
from transactions 
group by month, extract(month from transaction_date::date) 
order by extract(month from transaction_date::date)
)
select 
month,
avg_amount,
avg(avg_amount) over(order by month rows between 2 preceding and current row) as moving_avg
from monthly_data
order by month;

with monthly_data as( 
select date_trunc('month',transaction_date::date) as month_date,
round(avg(amount)::numeric,2) as avg_amount
from transactions 
group by month_date
)
select 
to_char(month_date,'month') as month,
avg_amount,
round(avg(avg_amount) over(order by month_date rows between 2 preceding and current row)::numeric,2) as moving_avg
from monthly_data
order by month_date;



--55.which customers have spending above their states avg spending
with customer_spending as (
select c.customer_id,
c.first_name ||' '||c.last_name as full_name,
c.state,
sum(t.amount) as total_spending
from  customers c
join cards cr 
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name,c.state
order by total_spending desc
),
avg_state_spending as (
select *,round(avg(total_spending) over (partition by state) ::numeric,2) as avg_state from customer_spending
)
select customer_id,full_name,state,total_spending ,avg_state from avg_state_spending
where total_spending>avg_state
order by state,total_spending desc;

---56.find the customers who make more transactions than the avg customers
with customer_transactions as (
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
count(t.transaction_id) no_of_transactions
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name
),
avg_transactions as (
select  round(avg(no_of_transactions)::numeric,2) as avg_transaction from customer_transactions
)
select ct.customer_id,ct.full_name,ct.no_of_transactions,ag.avg_transaction
from customer_transactions ct
cross join avg_transactions ag
where ct.no_of_transactions > ag.avg_transaction
order by ct.no_of_transactions desc;

--57.find the customerss have avg transaction value higher than the overall avg transaction value
with avg_customer_amount as (
select 
c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
round(avg(t.amount)::numeric,2) as avg_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name
order by c.customer_id
),
overall_avg as (
select avg(amount) as avg_amount from transactions
)
select acm.customer_id,full_name,avg_spending,oa.avg_amount
from avg_customer_amount acm
cross join overall_avg as oa
where acm.avg_spending > avg_amount
order by acm.customer_id;

--we can use join also
with avg_customer_amount as (
select 
c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
round(avg(t.amount)::numeric,2) as avg_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name
order by c.customer_id
),
overall_avg as (
select avg(amount) as avg_amount from transactions
)
select acm.customer_id,full_name,avg_spending,oa.avg_amount
from avg_customer_amount acm
 join overall_avg as oa
on acm.avg_spending > avg_amount
order by acm.customer_id;


--58.which customer have more used multiple payment  mode
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
count(distinct t.payment_mode) total_modes_used,
string_agg(distinct t.payment_mode,',') as payment_modes_names
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name
having count(distinct t.payment_mode) > 1
order by total_modes_used desc;

--59.which customer have more used multiple card networks
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
count(distinct cr.network) total_modes_used,
string_agg(distinct cr.network,',') as payment_modes_names
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name
having count(distinct cr.network) > 1
order by total_modes_used desc;

--60.find the merchants where their avg transaction amount is higher than the avg transaction amount of all the trasactions

with merchant_avg as (
select m.merchant_id,
m.merchant_name,
round(avg(t.amount)::numeric,2) as merchant_avg_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by m.merchant_id,m.merchant_name 
),
overall_avg as (
select round(avg(amount)::numeric,2) as overall_avg_amount from transactions
)
select mr.merchant_id,mr.merchant_name,mr.merchant_avg_amount,oa.overall_avg_amount
from merchant_avg mr
cross join overall_avg oa
where mr.merchant_avg_amount > oa.overall_avg_amount
order by mr.merchant_avg_amount desc;

--61.which customer have transactions in more than 3 different merchant category
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
count(distinct m.category) total_categories,
string_agg(distinct m.category,',') as payment_modes_names
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
join merchants m
on t.merchant_id=m.merchant_id
group by c.customer_id,full_name
having count(distinct m.category) > 3
order by total_categories desc;


--62.find the second highest amount
select amount from transactions order by amount desc;
select max(amount) from transactions where amount < (select max(amount) from transactions );--one method
select amount from transactions order by amount desc limit 1 offset 1;---another method
select amount from (select amount,dense_rank() over (order by amount desc) as rank from transactions ) x where rank=2; --another method

--63.find the 3rd highest amount
select amount from transactions order by amount desc limit 1 offset 2;

--64.find the total transactions amount for each payment mode
select payment_mode,
count(*) as no_of_transactions,
sum(amount) as total_amount
from transactions 
group by payment_mode;


---65.which payment mode has the highest avg trasnactions amount
select payment_mode,
count(*) as total_transactions,
round(avg(amount)::numeric,2) as avg_transaction_amount
from transactions
group by payment_mode
order by avg_transaction_amount desc;


---66.which payment mode has the highest  trasnactions amount
select payment_mode,
count(*) as total_transactions,
round(sum(amount)::numeric,2) as total_transaction_amount
from transactions
group by payment_mode
order by total_transaction_amount desc;

--67.which payment modes have the highest transaction approval rate
select payment_mode,
count(*) as total_transactions,
sum(case when upper(status)='APPROVED' then 1 else 0 end) as total_transaction_amount,
sum(case when upper(status)='APPROVED' then 1 else 0 end) *100/count(*) as approval_rate
from transactions
group by payment_mode
order by total_transaction_amount desc;

--68.which customers have used both online and atm payments
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
count(*) as total_transactions,
string_agg(distinct t.payment_mode,',') as modes
from customers c
join cards cr 
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
where t.payment_mode in ('Online','ATM')
group by c.customer_id,full_name
having count(distinct t.payment_mode)=2
order by c.customer_id;

--69.who is the highest spending customer in each month
select to_char(transaction_date::date,'year') as year ,
to_char(transaction_date::date,'month') as month from transactions 
group by month, year,
extract(month from transaction_date::date) 
order by extract(month from transaction_date::date);


with monthly_customer_spending as (
select
date_trunc('month',t.transaction_date::date) as month,
date_trunc('year',t.transaction_date::date) as year,
c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
sum(t.amount) as spending_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by month,year,c.customer_id,full_name
),
ranked_customer as (
select 
year,
month,
customer_id,
full_name,
spending_amount,
rank() over (partition by month order by spending_amount desc ) as rank 
from monthly_customer_spending
)
select 
to_char(year,'year') as years,
to_char(month,'mon') as months,
customer_id,
full_name,
spending_amount
from ranked_customer
where rank=1
order by month;


---70.which merchant has the highest transaction revenue in each month
with monthly_merchant_spending as (
select 
date_trunc('YEAR',transaction_date::date) as YEAR,
date_trunc('month',transaction_date::date) as month,
m.merchant_id,
m.merchant_name,
m.category as category,
string_agg(m.category,',') as categories,
count(*) as noof_transactions,
sum(t.amount) as total_revenue
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by year, month,m.merchant_id,m.merchant_name,category
),
ranked_merchant as (
select year, month,merchant_id,merchant_name,total_revenue,noof_transactions,category,categories,
rank()over(partition by month order by total_revenue desc) as rank
from monthly_merchant_spending
)
select
to_char(year,'year') as year_number,
to_char(month,'MONTH') as month_name,
merchant_id,
merchant_name,
noof_transactions,
category,
categories,
total_revenue
from ranked_merchant 
where rank=1
order by month,year;


select merchant_name,category from merchants group by merchant_name,category order by merchant_name;


with monthly_merchant_spending as (
select 
date_trunc('month',transaction_date::date) as month,
m.merchant_id,
m.merchant_name,
m.category as category,
string_agg(m.category,',') as categories,
count(*) as noof_transactions,
sum(t.amount) as total_revenue
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by  month,m.merchant_id,m.merchant_name,category
),
ranked_merchant as (
select month,merchant_id,merchant_name,total_revenue,noof_transactions,category,categories,
rank()over(partition by month order by total_revenue desc) as rank
from monthly_merchant_spending
)
select
to_char(month,'year') as years,
to_char(month,'MONTH') as month_name,
merchant_id,
merchant_name,
noof_transactions,
category,
categories,
total_revenue
from ranked_merchant 
where rank=1
order by extract(month from month),extract(year from month);


--71.each customers percentage contribution to total transactions amount
with customers_spending as (
select 
c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
sum(t.amount) as total_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name 
)
select customer_id,full_name,total_amount,
round((total_amount/sum(total_amount) over() * 100)::numeric,2) as contribution_rate
from customers_spending 
order by contribution_rate desc;



----REAL BUSINESS QUESTIONS FOR PROJECT
--72.which customer segment generates the most revenue
with  customer_segment as (
select 
c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
c.annual_income,
sum(t.amount) as total_amount,
case 
   when c.annual_income < 500000 then 'low income'
   when c.annual_income < 1000000 then 'medium income'
   else 'high income'
end as income_segment
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on t.card_id=cr.card_id 
group by c.customer_id,full_name,c.annual_income
)
select 
income_segment,
count(customer_id) as customers,
sum(total_amount) as total_segment
from customer_segment
group by income_segment 
order by total_segment desc;


---73.which payment modes are growing fastest

with monthly_payment as (
select
date_trunc('year',transaction_date::date) as year,
date_trunc('month',transaction_date::date) as month,
payment_mode,
sum(amount) as total_amount
from transactions 
group by year,month,payment_mode
),
growth as (
select
year,
month,
payment_mode,
total_amount,
lag(total_amount) over(partition by payment_mode order by month ) as previous_amount
from monthly_payment
)
select
to_char(year,'year') as years,
to_char(month,'month') as month_name,
payment_mode,
total_amount,
previous_amount,
round(((total_amount-previous_amount)/nullif(previous_amount,0) * 100)::numeric,2) as growth_percentage
from growth 
where previous_amount is not null
order by year,month,growth_percentage desc;



--74..which customer should the bank prioritize premium card offers
-------customers who have high income and high card spending those are ggod for premium card

with high_income as (------------one method
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
c.annual_income,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by c.customer_id,full_name,c.annual_income 
having c.annual_income > (select avg(annual_income) from customers) 
)
select * from high_income 
where total_spending > (select avg(total_spending) from high_income)
order by total_spending desc;


select c.customer_id,-------------another method
concat(c.first_name,' ',c.last_name) as full_name,
c.annual_income,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by c.customer_id,full_name,c.annual_income 
having c.annual_income > (select avg(annual_income) from customers
)
and sum(t.amount) > (select avg(customer_spending)
from (
      select 
      cr.customer_id,
      sum(t.amount) as customer_spending
      from cards cr
      join transactions t
      on cr.card_id=t.card_id 
      group by cr.customer_id ) as x
      )
      order by total_spending desc;
      


---75.which customer have high income but relatively low card spending
------------more than avg income but spend less than abg customer spending

with customer_spending as (
select
c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
c.annual_income,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by c.customer_id,full_name,c.annual_income  
),
averages as (
select 
avg(annual_income) as avg_income,
avg(total_spending) as total_avg_spending
from customer_spending
)
select 
cs.customer_id,
cs.full_name,
cs.annual_income,
cs.total_spending
from customer_spending cs
cross join averages av
where cs.annual_income > av.avg_income and cs.total_spending < av.total_avg_spending
order by cs.customer_id;


---76.which merchant have high transcation volume but low avg transcation value
with merchant_stats as (
select 
m.merchant_id,
m.merchant_name,
count(t.transaction_id) as no_of_transactions,
round(avg(t.amount)::numeric,2) as avg_transaction_amount,
sum(t.amount) as total_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by m.merchant_id,m.merchant_name
)
select 
merchant_id,
merchant_name,
no_of_transactions,
avg_transaction_amount,
total_amount
from merchant_stats
where no_of_transactions <(select avg(no_of_transactions) from merchant_stats)
and 
avg_transaction_amount < (select avg(avg_transaction_amount) from merchant_stats)
order by merchant_id;


--77.which branches are performing the above or below the bank average
with branch_revenue as (
select 
b.branch_id,
b.branch_name,
sum(t.amount) as total_revenue
from branches b
join transactions t
on b.branch_id=t.branch_id
group by b.branch_id,b.branch_name
),
bank_avg as (
select 
round(avg(total_revenue)::numeric,2)as avg_branch_revenue
from branch_revenue
)
select 
br.branch_id,
br.branch_name,
br.total_revenue,
ba.avg_branch_revenue,
case when br.total_revenue > ba.avg_branch_revenue then 'above'
     when br.total_revenue <ba.avg_branch_revenue then 'below'
     else 'avg'
 end as performances
 from branch_revenue br
 cross join bank_avg ba
 order by br.branch_id;

--78.how has transcation revenue changed month by month
with  monthly_revenue as (
select
date_trunc('month',transaction_date::date) as month,
sum(amount) as total_revenue
from transactions
group by month
),
monthly_growth as (
select 
month,
total_revenue,
round(lag(total_revenue) over(order by month)::numeric,2) as previous_revenue
from monthly_revenue
)
select 
to_char(month,'yyyy') as years,
to_char(month,'month') as months,
previous_revenue,
total_revenue,
round(((total_revenue-previous_revenue)/nullif(previous_revenue,0)*100)::numeric,2)as growth_percentage
from monthly_growth
order by month;

--79.which months show unusual spikes or drops in spending
 
with monthly_spending as (
select 
date_trunc('month',transaction_date::date) as month,
sum(amount) as total_spending
from transactions 
group by month
),
axxx as (
select
round(avg(total_spending)::numeric,2) as avg_spending,
round(stddev(total_spending)::numeric,2) as std_spending
from monthly_spending
)
select
to_char(month,'yyyy') as years,
to_char(month,'month') as months,
ms.total_spending,
ax.avg_spending,
ax.std_spending,
case when ms.total_spending > ax.avg_spending + 2 * ax.std_spending then 'unusual_spirke'
     when ms.total_spending < ax.avg_spending - 2 * ax.std_spending then 'unusual_drop'
     else 'normal'
     end as status
     from monthly_spending ms
     cross join axxx  ax
     order by ms.month;


-----VIEWS--------- FOR POWER- BI DHASBOARDS
--1.KPI ---total_transaction-amount
create or replace view total_revenue as
select sum(amount) as total_revenue 
from transactions;

select* from total_revenue;

---page one
---1.monthly_transaction_amount]
create or replace view monthly_transaction_amounts as 
select 
date_trunc('month',transaction_date::date) as month,
to_CHAR(transaction_date::date,'YYYY') as year,
to_CHAR(transaction_date::date,'month') as months,
sum(amount) as tota_revenue
from transactions
group by 
to_CHAR(transaction_date::date,'YYYY'),
EXTRACT(month from transaction_date::date),
to_CHAR(transaction_date::date,'month')
order by year,EXTRACT(month from transaction_date::date);

select * from monthly_transaction_amounts;

--2.monthly transactiom volume
create or replace view monthly_transaction_volume as 
select 
to_CHAR(transaction_date::date,'YYYY') as year,
to_CHAR(transaction_date::date,'month') as month_name,
count(*) as no_of_transactions
from transactions
group by 
to_CHAR(transaction_date::date,'YYYY'),
EXTRACT(month from transaction_date::date),
to_CHAR(transaction_date::date,'month')
order by year,EXTRACT(month from transaction_date::date);

select * from monthly_transaction_volume;

---3.spending by merchant category
create or replace view category_spending as 
select m.category as merchant_category,
sum(t.amount) as total_transaction_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by m.category
order by total_transaction_amount desc;

select * from category_spending;

--4.---spending by card type

create or replace view spending_by_card_type as 
select 
cr.card_type,
sum(t.amount) as total_spending
from cards cr
join transactions t 
on cr.card_id=t.card_id
group by cr.card_type
order by total_spending desc;

select * from spending_by_card_type;


--5.top 10 customers by spending
create or replace view top_10_customers as 
select 
c.customer_id,
concat(first_name,' ',last_name ) as full_name,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by c.customer_id,full_name
order by total_spending desc
limit 10;

select * from top_10_customers;

---PAGE 2
----1.-customer spending by income
select 
case 
	when c.annual_income < 500000 then 'below 5 lakhs'
	when c.annual_income < 1000000 then '5-10 lakhs'
    when c.annual_income < 2000000 then '10-20 lakhs'
    else 'above 20 lakhs'
end as income_group,
count(distinct c.customer_id) as totol_customers,
sum(t.amount) as total_spending,
case 
	when c.annual_income < 500000 then 1
	when c.annual_income < 1000000 then  2
	when c.annual_income < 2000000 then 3
	else 4
end as sort_order
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by income_group,sort_order
order by 4;

create or replace view  spending_by_income AS
select 
case 
	when c.annual_income < 500000 then 'below 5 lakhs'
	when c.annual_income < 1000000 then '5-10 lakhs'
    when c.annual_income < 2000000 then '10-20 lakhs'
    else 'above 20 lakhs'
end as income_group,
count(distinct c.customer_id) as totol_customers,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1
order by min(c.annual_income)

select * from spending_by_income;


---2.CUSTOMER SPENDING BY GENDER
create or replace view customer_spending_by_gender as 
select 
c.gender,
count(distinct c.customer_id) as total_transactions,
sum(t.amount) as total_spending
from customers c
join cards cr
on c.customer_id=cr.customer_id
join transactions t
on cr.card_id=t.card_id
group by 1
order by 1 desc;

select * from customer_spending_by_gender;

--3.custommer transaction frequency
create or replace view customer_transaction_frequency as 
with customer_transactions as (
select
c.customer_id,
count(t.transaction_id) as total_transactions
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1----4349 15
)
select 
case
	when total_transactions <=5 then 'low(1-5)'
	when total_transactions <=15 then 'medium(6-15)'
	else 'high(16+)'
end as cusromer_frequency,
count(*) as total_customers
from customer_transactions
group by 1
order by min(total_transactions);

select * from customer_transaction_frequency;

-------------------------------------------
with customer_transactions as (
select
c.customer_id,
count(t.transaction_id) as total_transactions
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1----4349 15
),
frequnecy_groups as (
select 
case
	when total_transactions <=5 then 'low(1-5)'
	when total_transactions <=15 then 'medium(6-15)'
	else 'high(16+)'
end as cusromer_frequency,
count(*) as total_customers
from customer_transactions
group by 1
order by min(total_transactions)
)
select 
cusromer_frequency,
total_customers,
sum(total_customers) over() as overall_customers
from frequnecy_groups;

select count(distinct customer_id) from customers;

--4.-customers by no of credit cards
create or replace view customers_by_card_count as 
select 
card_count,
count(*) as total_customers
from (
select 
c.customer_id,
count(cr.card_id) as card_count
from customers c
join cards cr
on c.customer_id=cr.customer_id 
group by 1
)
group by 1
order by 1;

select * from customers_by_card_count;

--5.top 10 customers by transaction count
create or replace view top_10_customers_by_transactions as 
select
c.customer_id,
concat(first_name,' ',last_name ) as full_name,
count(t.transaction_id) as total_transcations
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1,2
order by 3 desc
limit 10;



----PAGE 3---TRANSCATION ANALYSIS
---1.transacction amount by payment mode
create or replace view payment_mode_spending as 
select 
payment_mode,
count(*) as noof_transactions,
sum(amount) as transaction_amount
from transactions
group by 1
order by 3 desc;

select * from payment_mode_spending;

---2.transaction status------ ----------------check distribution of transaction status

create or replace view transaction_status as 
select 
status,
count(*) as noof_transactions,
sum(amount) as transaction_amount
from transactions 
group by 1
order by 3 desc;

select * from  transaction_status ; 

---3.avg transaction amount by merchant category
create or replace view transactions_by_merchant_category as 
select 
m.category as merchant_category,
count(*) as noof_transactions,
sum(t.amount) as transaction_amount,
round(avg(amount)::numeric,2) as avg_transaction_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by 1
order by 4 desc;

select * from transactions_by_merchant_category;

---4. transaction amount by network
create or replace view card_network_transctions as 
select 
cr.network as card_network,
count(*) as noof_transactions,
sum(t.amount) as transaction_amount
from transactions t
join cards cr
on t.card_id=cr.card_id 
group by 1
order by 3 desc;

select * from card_network_transctions;

---5.transaction amount by state
create or replace view state_transaction_spending as 
select 
c.state,
count(*) as noof_transactions,
sum(t.amount) as transaction_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id 
group by 1
order by 3 desc;

select * from state_transaction_spending;

-------------PAGE 4-----MERCHANT AND CATEGORY ANALYSIS
---1.top merchant by transaction amount
create or replace view top_merchants_spending as 
select 
m.merchant_id,
m.merchant_name,
m.category as merchant_category,
count(*) as noof_transactions,
sum(t.amount) as transaction_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by 1,2,3
order by 5 desc;

select * from top_merchants_spending ;


--2.merchant category transaction volume---which merchant category have the highest noof transactions
create or replace view merchant_category_transaction_volume as 
select 
m.category as merchant_category,
count(t.transaction_id) as noof_transactions,
sum(t.amount) as transaction_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by 1
order by 3 desc;

select * from merchant_category_transaction_volume;


---3.transaction decline rate by merchant category

create or replace view category_declined_rate as 
select 
m.category as merchants_category,
count(t.transaction_id) as noof_transactions,
count(*) filter(where upper(t.status) = 'DECLINED') as declined_transactions,
count(*) filter(where upper(t.status) = 'DECLINED') * 100/count(t.transaction_id) as declined_rate
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by 1
order by 4 desc;

select * from category_declined_rate;
----------------------------------------------------------------------------------------
create or replace view category_approved_rate as 
select 
m.category as merchants_category,
count(t.transaction_id) as noof_transactions,
count(*) filter(where upper(t.status) = 'APPROVED') as approved_transactions,
count(*) filter(where upper(t.status) = 'APPROVED') * 100/count(t.transaction_id) as approved_rate
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by 1
order by 4 desc;

select * from category_approved_rate;

---------------------------------------------------------------------------------------------------
create or replace view category_reversed_rate as 
select 
m.category as merchants_category,
count(t.transaction_id) as noof_transactions,
count(*) filter(where upper(t.status) = 'REVERSED') as reversed_transactions,
count(*) filter(where upper(t.status) = 'REVERSED') * 100/count(t.transaction_id) as reversed_rate
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by 1
order by 4 desc;

select * from category_reversed_rate;


---------
--4.avg transaction value by merchant
create or replace view merchant_avg_transaction_amount as 
select 
m.merchant_id,
m.merchant_name,
m.category as merchant_category,
sum(t.amount) as total_transaction_amount,
count(*) as noof_transactions,
round(avg(t.amount)::numeric,2) as avg_transaction_amount
from merchants m
join transactions t
on m.merchant_id=t.merchant_id 
group by 1,2,3
order by 6 desc;

select * from merchant_avg_transaction_amount ;


---5.merchant revenu constribution----------what percentage amount is contibution by each merchant category
create or replace  view merchant_category_revenue_contribution as 
select 
merchant_category,
transaction_amount,
revenue_contribution_percentage,
sum(transaction_amount) over() as overall_amount
from (
select 
m.category as merchant_category,
sum(t.amount) as transaction_amount,
round((sum(t.amount) * 100/sum(sum(t.amount)) over())::numeric,2) as revenue_contribution_percentage
from merchants m
join transactions t
on m.merchant_id=t.merchant_id
group by 1
)
group by 1,2,3
order by 3 desc;

select * from merchant_category_revenue_contribution;


----PAGE 5---GEOGRAPHICAL AND BRANCH ANALYSIS
---1.transaction amount by branch
create or replace view branch_transaction_spending as 
select 
b.branch_id,
b.branch_name,
sum(t.amount) as transaction_amount,
count(*) as total_transactions
from branches b
join transactions t
on b.branch_id=t.branch_id
group by 1,2
order by 3 desc;

select * from branch_transaction_spending;


--2.branch transction aolume

create or replace view branch_transaction_volume as 
select 
b.branch_id,
b.branch_name,
b.city,
b.state,
b.branch_type,
count(t.transaction_id) as total_transactions
from branches b
join transactions t
on b.branch_id=t.branch_id
group by 1,2,3,4,5
order by 6 desc;

select * from branch_transaction_volume;

-------------------------------------------------------------------------------------------------------------------
with aaa as (
select 
b.branch_id,
b.branch_name,
b.city,
b.state,
b.branch_type,
count(t.transaction_id) as total_transactions
from branches b
join transactions t
on b.branch_id=t.branch_id
group by 1,2,3,4,5
)
select *,
sum(total_transactions) over() as aaaaaa
from aaa;
-------------------------------------------------------------------------------------------------------------------------

--3.btranch declined rate
create or replace view branch_declined_rate as 
select 
b.branch_id,
b.branch_name,
b.city,
b.state,
b.branch_type,
count(t.transaction_id) as noof_transactions,
count(*) filter(where upper(t.status) = 'DECLINED') as declined_transactions,
count(*) filter(where upper(t.status) = 'DECLINED') * 100/count(t.transaction_id) as declined_rate
from branches b
join transactions t
on b.branch_id=t.branch_id
group by 1,2,3,4,5
order by 8 desc;

select * from branch_declined_rate;

----------------------------------------------------------------------------------------------- 
create or replace view branch_approved_rate as 
select 
b.branch_id,
b.branch_name,
b.city,
b.state,
b.branch_type,
count(t.transaction_id) as noof_transactions,
count(*) filter(where upper(t.status) = 'APPROVED') as approved_transactions,
count(*) filter(where upper(t.status) = 'APPROVED') * 100/count(t.transaction_id) as approved_rate
from branches b
join transactions t
on b.branch_id=t.branch_id
group by 1,2,3,4,5
order by 8 desc;

select * from branch_approved_rate;

-------------------------------------------------------------------------------------------------------
create or replace view branch_reversed_rate as 
select 
b.branch_id,
b.branch_name,
b.city,
b.state,
b.branch_type,
count(t.transaction_id) as noof_transactions,
count(*) filter(where upper(t.status) = 'REVERSED') as reversed_transactions,
count(*) filter(where upper(t.status) = 'REVERSED') * 100/count(t.transaction_id) as reversed_rate
from branches b
join transactions t
on b.branch_id=t.branch_id
group by 1,2,3,4,5
order by 8 desc;

select * from branch_reversed_rate;
--------------------------------------------------------------------------------------------------------------------------

------4.CUSTOMER DISTRIBUTION BY STATE
create or replace view customer_distribution_by_state as
select 
state,
count(*) as total_customers
from customers 
group by 1
order by 2 desc;

select * from customer_distribution_by_state;

--------------------------------------------------------
select 
state,
total_customers,
sum(total_customers) over() as aaa
from(
select 
state,
count(*) as total_customers
from customers 
group by state
)
group by 1,2
order by 2 desc;

---------------------------------------------------------------------------------------------------------------------------------

---5.transaction amount by ciry
create or replace view city_transactions_amount as 
select 
c.city,
c.state,
count(*) as noof_transactions,
sum(t.amount) as spending_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1,2
order by 4 desc;

select * from city_transactions_amount;

------------------------------------------------------------------------------------------------------------------------------------


---create or replace view branch_declined_rate as 

create or replace view decli_revers_approv_ratesss as
select 
count(transaction_id) as noof_transactions,
count(*) filter(where upper(status) = 'DECLINED') as declined_transactions,
count(*) filter(where upper(status) = 'DECLINED') * 100.0/count(transaction_id) as declined_rate,
count(*) filter(where upper(status) = 'APPROVED') as approved_transactions,
count(*) filter(where upper(status) = 'APPROVED') * 100.0/count(transaction_id) as approved_rate,
count(*) filter(where upper(status) = 'REVERSED') as reversed_transactions,
count(*) filter(where upper(status) = 'REVERSED') * 100.0/count(transaction_id) as reversed_rate
from transactions;
select * from decli_revers_approv_ratesss;



----------------------------------------------------------------------------------------------------------------------
---1.monthly_transaction_amount
create or replace view monthly_transaction_amountssssss as 
select 
count(*) as noof_transactions,
extract (year from transaction_date::date) as years,
to_CHAR(transaction_date::date,'mm') as month_numbers,
to_CHAR(transaction_date::date,'month') as month_names,
sum(amount) as tota_revenue
from transactions
group by 2,3,4
order by 2,3;

select * from monthly_transaction_amountssssss;

-----------------------------------------------------------------------------------------------------------
create or replace view customersss as 
select
c.customer_id,
concat(first_name,' ',last_name) as full_name,
sum(t.amount) as customer_total_amount,
round(avg(t.amount)::numeric,2) as customer_avg_amount
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1,full_name
order by 3;

---repeated customers
create or replace view repeated_customers  as 
select 
count(*) as repeated_customers from (
select
c.customer_id,
concat(first_name,' ',last_name) as full_name
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id
group by 1,2
having count(t.transaction_id)> 1
) asss;



-----avg_revenue per customers
create or replace view avg_revenue_per_customer  as 
select
round((sum(t.amount)/count(distinct c.customer_id))::numeric,2) as avg_revenue_per_customer
from customers c
join cards cr
on c.customer_id=cr.customer_id 
join transactions t
on cr.card_id=t.card_id;

















































	

















