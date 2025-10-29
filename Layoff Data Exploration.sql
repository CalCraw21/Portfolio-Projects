-- Exploratory Data Analysis

Select *
From layoffs_staging2;

Select Max(total_laid_off), Max(percentage_laid_off)
From layoffs_staging2;

Select *
From layoffs_staging2
Where percentage_laid_off = 1
Order By total_laid_off Desc;

Select *
From layoffs_staging2
Where percentage_laid_off = 1
Order By funds_raised_millions Desc;

Select company, Sum(total_laid_off)
From layoffs_staging2
Group By company
Order By 2 Desc;

Select Min(`date`), Max(`date`)
From layoffs_staging2;

Select industry, Sum(total_laid_off)
From layoffs_staging2
Group By industry
Order By 2 Desc;

Select country, Sum(total_laid_off)
From layoffs_staging2
Group By country
Order By 2 Desc;

Select Year(`date`), Sum(total_laid_off)
From layoffs_staging2
Group By Year(`date`)
Order By 1 Desc;

Select stage, Sum(total_laid_off)
From layoffs_staging2
Group By stage
Order By 2 Desc;

Select Substring(`date`,1,7) As `Month`, Sum(total_laid_off)
From layoffs_staging2
Where Substring(`date`,1,7) Is Not Null
Group By `Month`
Order By 1 Asc;

With Rolling_Total As
(
Select Substring(`date`,1,7) As `Month`, Sum(total_laid_off) As total_off
From layoffs_staging2
Where Substring(`date`,1,7) Is Not Null
Group By `Month`
Order By 1 Asc
)
Select `Month`, total_off, Sum(total_off) Over(Order By `Month`) As rolling_total
From Rolling_Total;

Select company, Sum(total_laid_off)
From layoffs_staging2
Group By company
Order By 2 Desc;

Select company, Year(`date`) , Sum(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
Order By 3 Desc;

With Company_Year (company, years, total_laid_off) As
(
Select company, Year(`date`) , Sum(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
), Company_Year_Rank As
(Select *, Dense_Rank() Over(Partition By years Order By total_laid_off Desc) As Ranking
From Company_Year
Where years Is Not Null
)
Select *
From Company_Year_Rank
Where Ranking <= 5;