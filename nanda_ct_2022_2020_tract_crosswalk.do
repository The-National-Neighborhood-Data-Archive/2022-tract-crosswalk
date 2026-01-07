capture log close

local infile "O:/NaNDA/Data/essential_businesses/datasets/nanda_ebusiness_Tract20_2020-2021_02"
local outfile "`infile'_tract22xwalk"
local intractfips "tract_fips20"
local tract22xwalk "O:/NaNDA/Data/crosswalks/ct_2022_2020_xwalk/2022-tract-crosswalk-main/2022tractcrosswalk"

****** you should not have to change anything below this line ******
use "`infile'", clear

display "check if `intractfips' starts with 090"
count if substr(`intractfips', 1, 3) == "090"
if `r(N)' > 0 {
	display "`intractfips' starts with 090 so it is tract_fips20, we need to add tract_fips22"
	capture clonevar tract_fips20 = `intractfips'
	* these tracts have no land area and no population, they are not in the crosswalk
	drop if inlist(tract_fips20, "09001990000", "09007990100", "09009990000", "09011990100")
	capture drop tract_fips22
	merge m:1 tract_fips20 using "`tract22xwalk'", keep(match master) keepusing(tract_fips22) nogen
	replace tract_fips22 = tract_fips20 if missing(tract_fips22)
	order tract_fips20 tract_fips22
}

display "check if `intractfips' starts with 091"
count if substr(`intractfips', 1, 3) == "091"
if `r(N)' > 0 {
	display "`intractfips' starts with 091 so it is tract_fips22, we need to add tract_fips20"
	capture clonevar tract_fips22 = `intractfips'
	* these tracts have no land area and no population, they are not in the crosswalk
	drop if inlist(tract_fips22, "09120990000", "09190990000", "09170990000", "09130990100", "09180990100")
	capture drop tract_fips20
	merge m:1 tract_fips22 using "`tract22xwalk'", keep(match master) keepusing(tract_fips20) nogen
	replace tract_fips20 = tract_fips22 if missing(tract_fips20)
	order tract_fips20 tract_fips22
}

display "these three numbers should match"
count if substr(`intractfips', 1, 2) == "09"
count if tract_fips20 != tract_fips22
count if tract_fips20 != tract_fips22 & substr(`intractfips', 1, 2) == "09" 

display "this number should be 0"
count if tract_fips20 != tract_fips22 & substr(`intractfips', 1, 2) != "09" 

save "`outfile'", replace

capture log close

