/* SQL DATA CLEANING using Nashville housing prices database */

select * from dbo.Navashille_Data
/*---------------------Converting sale date format-----------------*/
select SaleDate,CONVERT(Date,SaleDate)from dbo.Navashille_Data

alter table dbo.Navashille_Data
add SaleDateConv Date;
select * from dbo.Navashille_Data
update dbo.Navashille_Data
set SaleDateConv=CONVERT(Date,SaleDate);
/* ------------------Removing null from property address-------------------*/
select * from dbo.Navashille_Data;
select * from dbo.Navashille_Data
where PropertyAddress is NULL
order by ParcelID
select a.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.propertyAddress,b.PropertyAddress)
from dbo.Navashille_Data a
join dbo.Navashille_Data b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;
update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.Navashille_Data a
join dbo.Navashille_Data b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;
select * from dbo.Navashille_Data
where PropertyAddress is null;

/*--------------------Breaking property address into address, city, state------------------*/

select PropertyAddress from dbo.Navashille_Data

select PropertyAddress,
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as PropAddress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as PropCity
from dbo.Navashille_Data

alter table dbo.Navashille_Data
add PropAddress nvarchar(255);

update dbo.Navashille_Data
set PropAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table dbo.Navashille_Data
add PropCity nvarchar(255);

update dbo.Navashille_Data
set PropCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select PropertyAddress,PropAddress,PropCity from dbo.Navashille_Data

/*-------------------Breaking down Owner address------------------*/


select OwnerAddress from dbo.Navashille_Data

select ownerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from dbo.Navashille_Data


alter table dbo.Navashille_Data
add OwnerAdd nvarchar(255);

update dbo.Navashille_Data
set OwnerAdd=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table dbo.Navashille_Data
add OwnerCity nvarchar(255);


update dbo.Navashille_Data
set OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


alter table dbo.Navashille_Data
add OwnerState nvarchar(255);

update dbo.Navashille_Data
set OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select * from dbo.Navashille_Data

/*----------------------Convert 'SoldAsVacant' column to Yes/No ----------------------*/


select distinct(SoldAsVacant),count(SoldAsVacant)
from dbo.Navashille_Data
group by SoldAsVacant
order by 2


select SoldAsVacant,
Case
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
End
from dbo.Navashille_Data

update dbo.Navashille_Data
set SoldAsVacant=
case
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
End

select distinct(SoldAsVacant),count(SoldAsVacant) from dbo.Navashille_Data
group by SOldAsVacant

/*---------------------------------------Removing duplicate records---------------------*/

select *,
ROW_NUMBER()over(
partition by parcelid,propertyAddress,SalePrice,SaleDate,LegalReference
order by uniqueid)as row_num
from dbo.Navashille_Data
order by row_num desc;

with rownumcte as
(
select *,
ROW_NUMBER()over(
partition by parcelid,propertyAddress,SalePrice,SaleDate,LegalReference
order by uniqueid)as row_num
from dbo.Navashille_Data
)
select *
from rownumcte
where row_num>1

with rownumcte as
(
select *,
ROW_NUMBER()over(
partition by parcelid,propertyAddress,SalePrice,SaleDate,LegalReference
order by uniqueid)as row_num
from dbo.Navashille_Data
)
delete
from rownumcte
where row_num>1

select count(*)
from dbo.Navashille_Data

/*-------------Deleting unnecessary columns-----------------*/


select * 
from dbo.Navashille_Data

alter table dbo.Navashille_Data
drop column PropertyAddress,OwnerAddress,TaxDistrict

alter table dbo.Navashille_Data
drop column SaleDate

select *
from dbo.Navashille_Data











