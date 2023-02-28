UPDATE country_vaccination_stats AS cvs
SET daily_vaccinations = medians.median_daily_vaccinations
FROM (
    SELECT country, 
           COALESCE(
               PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY daily_vaccinations),
               0
           ) AS median_daily_vaccinations
    FROM country_vaccination_stats
    WHERE daily_vaccinations IS NOT NULL
    GROUP BY country
) AS medians
WHERE cvs.country = medians.country
AND cvs.daily_vaccinations IS NULL;