--inspecting dataset

select * from [dbo].[sales_data_sample]

--standardized orderdate format

Select orderdate, CONVERT(date,orderdate) 
from  [dbo].[sales_data_sample]

alter table [dbo].[sales_data_sample]
add orderdateconverted date

update [dbo].[sales_data_sample] 
set orderdateconverted = CONVERT(date,orderdate)



--checking unique values
select distinct status from [dbo].[sales_data_sample] --Nice one to plot
select distinct year_id from [dbo].[sales_data_sample]
select distinct PRODUCTLINE from [dbo].[sales_data_sample] ---Nice to plot
select distinct COUNTRY from [dbo].[sales_data_sample] ---Nice to plot
select distinct DEALSIZE from [dbo].[sales_data_sample] ---Nice to plot
select distinct TERRITORY from [dbo].[sales_data_sample] ---Nice to plot



--Analysis 1
--showing sales by productline

select productline,sum(sales ) as revenue
from [dbo].[sales_data_sample] 
group by productline
order by 2 desc

select year_id,sum(sales ) as revenue
from [dbo].[sales_data_sample] 
group by year_id
order by 2 desc

---As we saw that in 2005 the revenue generated is very low because they operate only for 5 months.

select dealsize,sum(sales ) as revenue
from [dbo].[sales_data_sample] 
group by dealsize
order by 2 desc

select territory,sum(sales ) as revenue
from [dbo].[sales_data_sample] 
group by territory
order by 2 desc

------What was the best month for sales in a specific year? How much was earned that month?
select month_id, sum(sales ) revenue, count(ordernumber) frequency 
from [dbo].[sales_data_sample] 
where year_id = 2005 --checking year wise
group by month_id
order by sum(sales ) desc

--November seems to be the month, what product do they sell in November, 
--we have seen that the classic cars has most sold products

select month_id, productline, sum(sales ) revenue, count(ordernumber) frequency 
from [dbo].[sales_data_sample] 
where year_id = 2005 --checking year wise
group by month_id,productline
order by sum(sales ) desc


----Who is our best customer (this could be best answered with RFM)

drop table if exists #rfm;
with rfm as(
select customername,
sum(sales) Monetaryvalue,
avg(sales) avgmonetaryvalue,
count(orderdate) frequency,
max(orderdateconverted) last_order_date,
(select max(orderdateconverted) from [dbo].[sales_data_sample]) max_order_date,
datediff(DD,max(orderdateconverted),(select max(orderdateconverted) from [dbo].[sales_data_sample])) recency
from [dbo].[sales_data_sample]
group by customername
),
rfm_clac as(
select r.* ,
ntile(4) over (order by recency desc) rfm_recency,
ntile(4) over (order by frequency) rfm_frequency,
ntile(4) over (order by Monetaryvalue) rfm_monetaryvalue

from rfm r
) 
select c.*, rfm_recency+rfm_frequency+rfm_monetaryvalue as rfm_cell,
cast(rfm_recency as varchar)+cast(rfm_frequency as varchar)+cast(rfm_monetaryvalue as varchar) rfm_string_values
into #rfm
from rfm_clac c

select * from #rfm


select customername , rfm_recency, rfm_frequency, rfm_monetaryvalue,
	case 
		when rfm_string_values in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		when rfm_string_values in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven�t purchased lately) slipping away
		when rfm_string_values in (311, 411, 331) then 'new customers'
		when rfm_string_values in (222, 223, 233, 322) then 'potential churners'
		when rfm_string_values in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_string_values in (433, 434, 443, 444) then 'loyal'
	end rfm_segment

from #rfm

--what product are most often sold together
--select * from [dbo].[sales_data_sample] where ORDERNUMBER =  10411

select distinct OrderNumber, stuff(

	(select ',' + PRODUCTCODE
	from [dbo].[sales_data_sample] p
	where ORDERNUMBER in 
		(

			select ORDERNUMBER
			from (
				select ORDERNUMBER, count(*) rn
				FROM[dbo].[sales_data_sample]
				where STATUS = 'Shipped'
				group by ORDERNUMBER
			)m
			where rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path (''))

		, 1, 1, '') ProductCodes

from [dbo].[sales_data_sample] s
order by 2 desc


---EXTRAs----
--What city has the highest number of sales in a specific country
select city, sum (sales) Revenue
from [dbo].[sales_data_sample]
where country = 'UK'
group by city
order by 2 desc



---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc