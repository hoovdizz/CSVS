<#
Written to do bing points everyday
Sleep random times to not expect as automated robot
random number of searches every day
random sleep between searches
Export to log file time slept and date ran

Updated 1-5-2023
Made this Expanable via the web So i can add as needed and never have to open this script again.
#>
$file= "SearchHistory.txt"

#test mode Y = yes N = NO
$testmode="y"

$start=get-date


$RandomLoop = Get-Random -InputObject (36,37,38,39,40,41,42,43,44,45,46,47,50,51,52,53)
$RandomSleep = Get-Random -InputObject (0,60,380,1830,3660)
$AnotherRandom = Get-Random -InputObject (0,1,2,3,4,5,6,7,8,10,11,12,13,14,15)


$totalsleep = $RandomLoop + $RandomSleep + $AnotherRandom
$totalmin=$totalsleep/60

$AdjustedStart = New-TimeSpan -Days 0 -Hours 0 -Minutes $totalmin

$TrueStart=(get-date) + $AdjustedStart 

if ($totalmin -gt 60)
{
$totalhours=$totalmin/60
$time = $totalhours | % {$_.ToString("#.##")}
$message = "Executed on "+$start+" with a sleep of "+$time+ " Hours so it will start searching on " + $TrueStart
Write-Host $message
$message | out-file -append $file
}
elseif($totalmin -gt 1)

{
$time = $totalmin | % {$_.ToString("#.##")}
$message = "Executed on "+$start+" with a sleep of "+$time+ " Minutes so it will start searching on " + $TrueStart
Write-Host $message
$message | out-file -append $file
}
else
{
$time = $totalsleep | % {$_.ToString("#.##")}
$message = "Executed on "+$start+" with a sleep of "+$time+ " Seconds so it will start searching on " + $TrueStart
Write-Host $message
$message | out-file -append $file
}

#skip the sleep if we are just testing
if ($testmode -eq "n"){start-sleep $totalsleep}

#Pull Master Category
$Category = Invoke-WebRequest "https://raw.githubusercontent.com/hoovdizz/CSVS/main/categorys.csv" | ConvertFrom-Csv


#What Category Will we Look at today?
$RandomCategory = Get-Random -InputObject $Category.Funtime

$web1 = "https://raw.githubusercontent.com/hoovdizz/CSVS/main/" + $RandomCategory + ".csv"
$webpre = "https://raw.githubusercontent.com/hoovdizz/CSVS/main/" + $RandomCategory + "PRE.csv"

#Tell the User what we are looking up this time around
write-host "Starting the Search of"$RandomCategory

#Pull from web CSV's 
$subject = Invoke-WebRequest $web1 | ConvertFrom-Csv
$subjectPRE = Invoke-WebRequest $webpre | ConvertFrom-Csv
  

#Start the loop Genertaing Searches
for ($a = 0; $a -lt $RandomLoop; $a++) {
   
 $RandomQuestion = Get-Random -InputObject $subjectPRE.Funtime
 $RandomWord = Get-Random -InputObject $subject.Funtime
 

   

   #lets mimic the time to type it out
   $questionlength= $RandomWord.Length + $RandomQuestion.Length + $RandomLoop
   $questionlength += Get-Random -InputObject (3000,3400,3500,3600,3700,3800)
   
   write-host " Searching " $RandomQuestion$RandomWord
   
   #Sleep Mode Switch For really Searching
   if ($testmode -eq "N"){
   start-sleep -Milliseconds $questionlength
   Start-Process microsoft-edge:http://www.bing.com/search?q=$RandomQuestion$RandomWord -WindowStyle Minimized
    
   }
}

#once done Kill edge, no one likes you
if ($testmode -eq "N"){
start-sleep 120
if(Get-Process msedge -ea SilentlyContinue){Stop-Process -processname "msedge"}
}

#get finishing Time
$end=get-date


#write the report
$message = "Finished on "+$end+" and total of "+$RandomLoop+ " searches of the " +$RandomCategory+ " category"
Write-Host $message
$message | out-file -append $file
$spacer = "----------------------------------------------------------------"
$spacer  | out-file -append $file