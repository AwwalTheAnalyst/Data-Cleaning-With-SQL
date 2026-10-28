-- Before cleaning a messy data in MySQl, we can't work with the raw data as a professional. A duplicate data has to be created, so let's do that!
CREATE TABLE layoffs_work
LIKE layoffs;

-- It's done, now we can input the values in the raw data to the new table we just created.
INSERT layoffs_work
SELECT *
FROM layoffs;

-- So let's check our new table, if it's the same with our raw data.
SELECT *
FROM layoffs_work;

-- We need to follow these steps for our data cleaning
-- Step1: Remove Duplicates
-- Step2: Standardize data
-- Step3: Null values and Blanks
-- Step4: Remove irrelevant/unnecessary columns

-- Step1: Remove Duplicates
-- Before we can remove duplicates, we need to know/identify the duplicates first.
-- How can we do that? looking at our data, there isn't a unique value or ID we could use to fast track our identification. 
-- So, we need to find an alternative by using row number with partition by all columns in our table.
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
FROM layoffs_work;

-- We've gotten our unique values to identify the duplicates, so check out the duplicates
-- And to do that we need to create Common Temporary Expressions CTEs
-- Let's create the CTE
WITH duplicate_cte AS (
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
FROM layoffs_work
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- There are 5 duplicates, we can crosscheck that by checking out the each companies in the duplicate output
SELECT *
FROM layoffs_work
WHERE company = 'Casper';
-- As we can see, we are definitely right on the duplicates, so we need to them all but it's tricky

-- To delete the duplicates, we need to follow these methods;
-- Right click on our table (layoffs_work), Select Copy to Clipboard and Select create statements and paste it.
-- Edit the statements: change the table name(layoffs_work) to our new table name(layoffs_work1) and add row_num column to the table and specify it's an integer.
-- After the creation, we can insert values to our new table.
CREATE TABLE `layoffs_work1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- It's created, let insert the values.
INSERT INTO layoffs_work1
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
FROM layoffs_work;

-- Now, we can filter the table. And also identify what to delete.
SELECT *
FROM layoffs_work1
WHERE row_num > 1;

-- Let's delete the duplicates
DELETE
FROM layoffs_work1
WHERE row_num > 1;

-- it's done, there isn't duplicates anymore. 
SELECT *
FROM layoffs_work1;

-- Note: we will be working with the new table now (layoffs_work1)

-- Step2: Standardize data
-- This step is about removing whitespaces from some strings, 
-- correcting some spellings and using the correct string to the column that warrant it in order to make it a standard data.
-- Let's remove whitespaces from the rows that needs it
SELECT company, TRIM(company)
FROM layoffs_work1;

-- We can update our table now with the corrected column
UPDATE layoffs_work1
SET company = TRIM(company);

-- If there's no whitespaces to get rid off, we can check out for spellings now
SELECT DISTINCT industry
FROM layoffs_work1
ORDER BY 1;

-- From the output from the query above, we could notice that there's inconsistency of spellings with the 'Crypto' industry. let's correct that. 
SELECT *
FROM layoffs_work1
WHERE industry LIKE 'Crypto%';

-- So, it has to be 'Crypto' not CryptoCurrency/Crypto Currency. Let's update that
UPDATE layoffs_work1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- We can check other columns for spelling corrections
SELECT DISTINCT country
FROM layoffs_work1
ORDER BY 1;

-- From the above output, we could notice that the 'United States' has a row with a period. So, let's correct that
-- You might think TRIM could do the trick but unfortunately it couldn't, so we had to a trick or alternative(TRAILING '')
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_work1
ORDER BY 1;

-- That has been corrected, let's update our column now
UPDATE layoffs_work1
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Looking back to all our columns format, we could notice that 'date' is in text format instead of date format. 
-- Let's make correction with that
-- Notice we use back tick instead of quote for the date because date is a keyword here
SELECT `date`, STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_work1;

-- That's in standard date format, though not in date format as we intended but we're definitely going to do that but let's update our column first
UPDATE layoffs_work1
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

-- We can change our date to date format now by altering the table
ALTER TABLE layoffs_work1
MODIFY COLUMN `date` DATE;

-- Step3: Null values and Blank
-- To work with columns that has Null values or Blanks, we need identify the rows that we can populate first
-- Befor we can actually populate the blanks, we need to convert them to Null
-- Let's identify the column we are going to be working with
SELECT industry
FROM layoffs_work1
ORDER BY 1;

-- After checking the columns one after the other, we get to identify the 'industry' column has some rows that can be populated
-- But before that, we need to convert the blanks to Null
UPDATE layoffs_work1
SET industry = NULL 
WHERE industry = '';

SELECT *
FROM layoffs_work1
WHERE industry IS NULL;

SELECT *
FROM layoffs_work1
WHERE company = 'Airbnb';

-- Now, the populate work can start and to do that, we are going to use JOIN, SELF JOIN esp.
-- And we will doing the joining based on company as their key 
SELECT t1.industry, t2.industry
FROM layoffs_work1 t1
JOIN layoffs_work1 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Well, we've populated the rows. We can update the column now
UPDATE layoffs_work1 t1
JOIN layoffs_work1 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Step4: Remove irrelevant/unnecessary columns
-- Before we can do that, we need to be sure the columns is irrelevant to the data analysis/exploratory
-- So, let's check some columns out
SELECT *
FROM layoffs_work1;

SELECT *
FROM layoffs_work1
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- From the output above, we don't have data to calculate the null values in those columns, so it's not necessary to us.
-- We can go ahead and delete those columns. 
DELETE
FROM layoffs_work1
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- If we could have the data for the total employee in the company, we could be able to calc the null values in the total_laid_off and percentage_laid_off
-- So, we closer to the end of our data cleaning 
-- But there is something we still have to do, which is dropping the row_num column because we don't need it anymore
-- And irrelevant column has to be removed. 
ALTER TABLE layoffs_work1
DROP COLUMN row_num;

-- We are done with cleaning the messy data. 
