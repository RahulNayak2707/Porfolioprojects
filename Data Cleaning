/*
Cleaning data in sql 
*/

Select * from  Projectportfolio..NVHouse



--Standardized date format

Select saledateconverted, CONVERT(date,SaleDate) as saledate2
from  Projectportfolio..NVHouse

Update Projectportfolio..NVHouse
    set SaleDate=CONVERT(date,SaleDate)

alter table projectportfolio..NVHouse add saledateconverted date

Update Projectportfolio..NVHouse
    set saledateconverted=CONVERT(date,SaleDate)






-- Populate property address

Select * from  Projectportfolio..NVHouse
--where PropertyAddress is null


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.propertyaddress,b.propertyaddress)
from  Projectportfolio..NVHouse a
join Projectportfolio..NVHouse b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is not null


update a
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
 from Projectportfolio..NVHouse a
join Projectportfolio..NVHouse b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null




--breaking out address into individual column(address, city, state)

Select PropertyAddress 
from  Projectportfolio..NVHouse

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from  Projectportfolio..NVHouse

alter table projectportfolio..NVHouse add propertysplitaddress nvarchar(255)

update projectportfolio..NVHouse 
set propertysplitaddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

alter table projectportfolio..NVHouse 
add propertysplitcity nvarchar(255)

update projectportfolio..NVHouse 

SET propertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from Projectportfolio..NVHouse







select Owneraddress from Projectportfolio..NVHouse

select PARSENAME(REPLACE(owneraddress,',','.'),3)
,PARSENAME(REPLACE(owneraddress,',','.'),2)
,PARSENAME(REPLACE(owneraddress,',','.'),1)
from Projectportfolio..NVHouse


alter table projectportfolio..NVHouse 
add Ownersplitaddress nvarchar(255)

update projectportfolio..NVHouse 
set Ownersplitaddress=PARSENAME(REPLACE(owneraddress,',','.'),3)

alter table projectportfolio..NVHouse 
add Ownersplitcity nvarchar(255)

update projectportfolio..NVHouse 
SET Ownersplitcity = PARSENAME(REPLACE(owneraddress,',','.'),2)

alter table projectportfolio..NVHouse 
add Ownersplitstate nvarchar(255)

update projectportfolio..NVHouse 
SET Ownersplitstate = PARSENAME(REPLACE(owneraddress,',','.'),1)


select * from Projectportfolio..NVHouse





--Change Y and N to Yes and No in "Sold as Vacant" field

select soldasvacant from Projectportfolio..NVHouse


select distinct(soldasvacant),COUNT(soldasvacant)
from Projectportfolio..NVHouse
group by SoldAsVacant
order by 2

select soldasvacant
,case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 
from Projectportfolio..NVHouse

update Projectportfolio..NVHouse
set soldasvacant=case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 




--Remove duplicates


with rownumcte as(
select *, 
ROW_NUMBER() over ( 
     partition by ParcelID,
				       PropertyAddress,
				          SalePrice,
				          SaleDate,
				           LegalReference

				           order by uniqueid
				             )row_num
							 from Projectportfolio..NVHouse
)

 select * from rownumcte 
  where row_num>1
  --order by 2
--from Projectportfolio..NVHouse




--delete unused columns

select * from Projectportfolio..NVHouse

alter table Projectportfolio..NVHouse
drop column propertyaddress, owneraddress,saledate,taxdistrict





