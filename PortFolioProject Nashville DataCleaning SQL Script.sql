
--Cleaning Data in SQL Quries


select *
from PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

select SaleDateConverted, Convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

-------------------------------------------------------------------------------------------------



--Population Property Address Data

select *
from PortfolioProject.dbo.NashvilleHousing



--where PropertyAddress is Null
Order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID =	b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


update a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID =	b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------------------------------------------



--Breaking out Address Into Individual Cloums (address, City, State)



Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select
Substring(PropertyAddress, 1, Charindex(',',PropertyAddress) -1 ) as Address
, Substring(PropertyAddress, Charindex(',',PropertyAddress) +1, Len(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(2225);

update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',',PropertyAddress) -1 )


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(2225);

update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',',PropertyAddress) +1, Len(PropertyAddress))


Select *
from PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'), 3)
,PARSENAME(Replace(OwnerAddress,',','.'), 2)
,PARSENAME(Replace(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing



Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(2225);

update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)


Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(2225);

update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(2225);

update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Select *
from PortfolioProject.dbo.NashvilleHousing



-----------------------------------------------------------------------------------------------------




--Change Y and N To Yes and No "Sold as Vacant" Field



Select Distinct(SoldasVacant), Count(SoldasVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldasVacant
Order by 2


Select SoldasVacant
, Case When SoldasVacant = 'Y' Then 'Yes'
when SoldasVacant = 'N' Then 'No'
Else SoldasVacant
End
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
Set SoldasVacant = Case When SoldasVacant = 'Y' Then 'Yes'
when SoldasVacant = 'N' Then 'No'
Else SoldasVacant
End

--------------------------------------------------------------------------------------------------



--Remove Duplicates



with RowNumCTE As(
select *,
	ROW_NUMBER() Over (
	Partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order by
		UniqueID
		) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
from RowNumCTE
where row_num> 1
order by PropertyAddress



Select *
from PortfolioProject.dbo.NashvilleHousing



-------------------------------------------------------------------------------------------



-- Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate

