This note explains the contents of the data file HouseElectionSpending2018 (available in csv or dta format).

Each row corresponds to a U.S. House election in 2018.

The sample is restricted to contested elections between an incumbent and a challenger.

Summary of variables
state: state postal code

dist: district number

incumbent: "R" if the incumbent is a Republican, "D" if the incumbent is a Democrat

repvoteshare: the Republican candidate's two-party vote share (i.e., Republican votes/(Republican votes + Democratic votes) in 2018

repspending: a measure of the campaign spending of the Republican (specifically, the natural logarithm of dollars spent plus 1)

demspending: a measure of the campaign spending of the Democrat (specifically, the natural logarithm of dollars spent plus 1)

(Note: because campaign spending is measured as the natural logarithm of dollars spent, we approximately interpret a one-unit 
increase in these variables as a doubling of campaign spending)

trumpvoteshare: the two-party vote share of Donald Trump (the Republican) in the 2016 presidential election in that district

lagrepvoteshare: the Republican candidate's two-party vote share in the previous House election (in 2016)