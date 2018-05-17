
DECLARE @Today AS DATE
SET @Today = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)

DECLARE @BegOfCM AS DATE
SET @BegOfCM = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE() -4) , 0)

DECLARE @BegOfPM AS DATE
SET @BegOfPM = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE() -4) -1, 0)

DECLARE @CloseCM AS DATE
SET @CloseCM = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE() -4) +1, 0) + 3

DECLARE @ClosePM AS DATE
SET @ClosePM = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE() -4) , 0) + 3

DECLARE @DaysLeftInCM AS INT
SET @DaysLeftInCM = DATEDIFF(DAY,@Today,@CloseCM)

   
-----------------------------------------------------------------------------------------------------------------


  SELECT CHR.GLMonth
		,CASE WHEN CHR.GLMonth = @BegOfCM
			   AND CAST(CHR.EnterTime AS DATE) > dbo.AddDays(@Today,-7) THEN CAST(@DaysLeftInCM + 1 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfCM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@Today,-13) AND dbo.AddDays(@Today,-7) THEN CAST(@DaysLeftInCM + 8 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfCM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@Today,-20) AND dbo.AddDays(@Today,-14) THEN CAST(@DaysLeftInCM + 15 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfCM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@Today,-27) AND dbo.AddDays(@Today,-21) THEN CAST(@DaysLeftInCM + 22 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfCM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@Today,-34) AND dbo.AddDays(@Today,-28) THEN CAST(@DaysLeftInCM + 29 AS VARCHAR(2)) + ' Days till close'
			 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM + 22) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM + 28) THEN CAST(@DaysLeftInCM - 27 AS VARCHAR(2)) + ' Days till close'			  
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM + 15) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM + 21) THEN CAST(@DaysLeftInCM - 20 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM + 8) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM + 14) THEN CAST(@DaysLeftInCM - 13 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM + 1) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM + 7) THEN CAST(@DaysLeftInCM - 6 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM - 6) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM) THEN CAST(@DaysLeftInCM + 1 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM - 13) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM - 7) THEN CAST(@DaysLeftInCM + 8 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM - 20) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM - 14) THEN CAST(@DaysLeftInCM + 15 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM - 27) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM - 21) THEN CAST(@DaysLeftInCM + 22 AS VARCHAR(2)) + ' Days till close'
			  WHEN CHR.GLMonth = @BegOfPM
			   AND CAST(CHR.EnterTime AS DATE) BETWEEN dbo.AddDays(@ClosePM, -@DaysLeftInCM - 34) AND dbo.AddDays(@ClosePM, -@DaysLeftInCM - 28) THEN CAST(@DaysLeftInCM + 29 AS VARCHAR(2)) + ' Days till close'
		 END AS 'RunDate'
		,CHR.UnitNum
		,CHR.PatNum
		,CHR.MedRecNo
		,CHR.InsPlan
		,CHR.PatType
		,CHR.ProcAmt
		,CHR.FAA
		,CHR.ExtenuatingCircumstances
		,CHR.Driver
		,CHR.BadDebtType
		
	INTO #TempSubSet

    FROM RRSCWPDBS01.faWorkspace.dbo.CharityDriversDaily CHR			
  
   WHERE CHR.GLMonth >= @BegOfPM
   

-----------------------------------------------------------------------------------------------------------------


  SELECT TSS.GLMonth
		,CASE WHEN LEFT(TSS.RunDate,1) IN ('-',0) THEN 'Close'
												  ELSE TSS.RunDate
		 END AS RunDate
		,TSS.UnitNum
		,TSS.PatNum
		,TSS.MedRecNo
		,TSS.InsPlan
		,TSS.PatType
		,SUM(TSS.ProcAmt) AS 'CharityAmount'
		,TSS.FAA
		,TSS.ExtenuatingCircumstances
		,TSS.Driver
		,TSS.BadDebtType
  
	FROM #TempSubSet TSS

GROUP BY TSS.GLMonth
		,TSS.RunDate
		,TSS.UnitNum
		,TSS.PatNum
		,TSS.MedRecNo
		,TSS.InsPlan
		,TSS.PatType
		,TSS.FAA
		,TSS.ExtenuatingCircumstances
		,TSS.Driver
		,TSS.BadDebtType
			 
HAVING SUM(TSS.ProcAmt) <> 0


-----------------------------------------------------------------------------------------------------------------
			 
			 
DROP TABLE #TempSubSet