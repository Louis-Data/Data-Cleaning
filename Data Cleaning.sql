/*
Cleaning Data in SQL Queries
*/

Select *
From PortfolioProject..NashvilleHousing


--Standardize Data Format

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)



 ----------------------------------------------------------------------------------------

--Populate Property Address Data



Select NULLIF(PropertyAddress, '') AS PropertyAddress
From PortfolioProject..NashvilleHousing
WHERE PropertyAddress is null OR PropertyAddress = '';

SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, NULLIF(a.PropertyAddress,'') AS PropertyAddress, b.ParcelID, NULLIF(b.PropertyAddress,'') AS PropertyAddress,
ISNULL(NULLIF(a.PropertyAddress,''),NULLIF(b.PropertyAddress,''))
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE NULLIF(a.PropertyAddress,'') is null;

UPDATE a
SET PropertyAddress = ISNULL(NULLIF(a.PropertyAddress,''),NULLIF(b.PropertyAddress,''))
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE NULLIF(a.PropertyAddress,'') is null;



 ----------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

Select NULLIF(PropertyAddress, '') AS PropertyAddress
From PortfolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
From PortfolioProject..NashvilleHousing





SELECT OwnerAddress
From PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)



 ----------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field



SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER by 2

 SELECT SoldAsVacant
,	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
 From PortfolioProject..NashvilleHousing

 UPDATE [NashvilleHousing ]
 SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
 From PortfolioProject..NashvilleHousing



 ----------------------------------------------------------------------------------------
 
 --Remove Duplicates



WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress



SELECT *
From PortfolioProject..NashvilleHousing


 ----------------------------------------------------------------------------------------

 --Delete Unused Columns

 
 SELECT *
 FROM PortfolioProject..NashvilleHousing

 ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress