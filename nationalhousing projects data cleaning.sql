--1 standardize date format
select * from [National Housing]
select* from [National Housing]
select SaleDate, convert(date,saledate) from [National Housing]  --- starting it was not wworking but after alter and update this is started wworking.
alter table[National Housing] drop column saledateconverted
update [National Housing] set saledate = convert(date,saledate) -- not working

Alter table [National Housing] add saledateconverted date

update [National Housing] set saledateconverted = convert(date,saledate)

--2 Populate property address data
--a) propertyaddress

select* from [National Housing] 
--where PropertyAddress is null 
order by ParcelID

select a.ParcelID, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress,b.PropertyAddress)
from [National Housing] a join [National Housing] b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.PropertyAddress)
from [National Housing] a join [National Housing] b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--3 breaking out addressinto individual column(addess,city,state)
select PropertyAddress from [National Housing]


select substring(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1) as address,
substring(PropertyAddress,CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress)) as address 
from [National Housing]

Alter table [National Housing] add PropertysplitAddress varchar(255)

update [National Housing] set PropertysplitAddress = substring(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1)

Alter table [National Housing] add PropertycityAddress varchar(255)

update [National Housing] set PropertycityAddress = substring(PropertyAddress,CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress))

select* from [National Housing]

--b) owwner address
 select OwnerAddress from [National Housing]

  select PARSENAMe(replace(owneraddress,',','.'), 3),
  PARSENAMe(replace(owneraddress,',','.'), 2),
  PARSENAMe(replace(owneraddress,',','.'), 1)
  from [National Housing]

  Alter table [National Housing] add ownersplitaddress varchar(255)
update [National Housing] set ownersplitaddress = PARSENAMe(replace(owneraddress,',','.'), 3)

Alter table [National Housing] add ownersplitaddresscity varchar(255)
update [National Housing] set ownersplitaddresscity =   PARSENAMe(replace(owneraddress,',','.'), 2)

Alter table [National Housing] add ownersplitaddressstate varchar(255)
update [National Housing] set ownersplitaddressstate =  PARSENAMe(replace(owneraddress,',','.'), 1)

--change y and n  to Yes and No in sold as vacant feild


select distinct(soldasvacant),count(soldasvacant)
from [National Housing] group by soldasvacant order by 2

select distinct(soldasvacant),
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end
from [National Housing]

update [National Housing]
set soldasvacant = 
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end

- -4- Remove duplicate
--rank,orderrank,row number
select * from [National Housing]


with cte_rownum as(
select *, ROW_NUMBER() over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference 
order by uniqueid) as row_num from [National Housing])
delete from cte_rownum where row_num >1 
--order by propertyaddress

with cte_rownum as(
select *, ROW_NUMBER() over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference 
order by uniqueid) as row_num from [National Housing])
select * from cte_rownum where row_num >1 order by propertyaddress


5 delete unused column
select * from [National Housing]

alter table [National Housing] drop column propertyaddress,owneraddress,taxdistrict

alter table [National Housing] drop column saledate












