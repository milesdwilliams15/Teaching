The file "CongressionalData.csv" contains all the data necessary to complete 
this exercise successfully. 

Each row of the data set refers to a congressional district in a congressional
term. The data set spans the 108th to the 112th congresses (2003-2012).

The variable "state_dist" is a string variable indicating the state and
congressional district.

The variable "electionyear" indicates the year of the election leading up to 
this particular congressional term.

The variable "cong" refers to the congressional term.

"name" indicates the particular member of Congress that represented this
district in this term. You may not use this variable in your analysis, but you
at least have it as a reference.

The variable "republican" takes a value of 1 if the representative was a 
Republican and 0 if the representative was a Democrat. 

"rep_twoparty_pres" indicates the average Republican two-party vote share 
in that particular congressional district from the 2004 and 2008 presidential
elections. This should be a useful proxy for the general ideology of the 
district and may be useful as a control.

"rep_voteshare" indicates the Republican two-party vote share in the
congressional election leading up to this session. For example, a value of .51
means that a Republican candidate won by 1 percentage point and went on to
serve in that session. A value of .49 would incdicate that a Democrat won by 1
percentage point. This variable may be useful in your regression-discontinuity
analysis.

"cvp" is short for Conservative Vote Probability. This is a score assigned to
each member in each term summarizing their roll-call voting. Specifically, the
score measures the probability that each member voted conservatively across
all bills relative to the median member in that session. Because this is a 
relative probability, it can take positive or negative values, where negative
values indicate that a member was less conservative than the median member. 
This is the measure of representation that you can utilize for this 
exercise. Note that the scores are not necessarily comparable across
different sessions, so you will want to account for that in your analysis.

Note: The few cases where multiple members represented the same district in the
same session, where a representative was from a third party, or where a member 
switched parties in the middle of the term have been dropped. There are also a 
few cases where reliable election results are unavailable. This explains why 
there are fewer than 435 observations per congress.