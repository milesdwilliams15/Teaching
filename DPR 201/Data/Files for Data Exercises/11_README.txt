For this exercise, we'll be analyzing the following data set:
"GOTV_Experiment.csv".

The data comes from a large-scale get-out-the-vote experiment conducted
on registered voters around the country in the run-up to the November 2018
midterm elections. A non-partisan group identified 50,000 individuals to
include in the study of all ages, races, and party affiliations. Every 
individual in the study had a unique address, so no two individuals in 
the study live in the same household.

The non-partisan group randomly assigned about half of the individuals in the
sample to received get-out-the-vote interventions. Specifically, they attempted
to visit each of the treated individuals in person by visiting their residences.
If the person answered the door, they would try to talk to them about the importance
of voting and give them information about the upcoming election. If they could not
reach the person, they would try again, and some doors were visited up to 5 times
in the hopes of reaching all the treated subjects.

Your task is to analyze the data and estimate the average effect of these get-out-the-vote
interventions on voter turnout. However, several factors complicate the analysis,
and you and your group will have to decide how to handle each of the challenges listed
below.

1. Blocked random assignment: The non-partisan group wanted to devote more of their
efforts to rural and suburban areas, so they varied the probability of treatment assignment
depending on whether the subject lived in an urban area or not. Specifically, if a subject
lived in an urban area, their ex-ante probability of being assigned to treatment was .2, but
if they lived in a suburban or rural area, their probability of being assigned to treatment was .8. 

2. Noncompliance: Not everyone assigned to the treatment group answered the door, so
not all of them received the treatment. Conditional on being assigned to the treatment condition,
only about 77 percent of those individuals were successfully contacted.

3. Attrition: Some subjects moved, died, or mysteriously dropped off the voter rolls between the 
time that they were assigned to a treatment condition and the researchers were able to ascertain
whether they voted. So we don't know whether they voted, and the "turnout" variable is missing
for these individuals.


Description of Variables
female: 1 for female, 0 otherwise
age: age in years at time of 2018 midterm election
white: 1 if white, 0 otherwise
black: 1 if black, 0 otherwise
employed: 1 if employed, 0 otherwise
urban: 1 if the subject lives in an urban area, 0 if they live in a suburban or rural area
treatmentattempt: 1 if the subject was randomly assigned to receive treatment, 0 otherwise
successfultreatment: 1 if the subject was successfully contacted and received the treatment, 0 otherwise
turnout: 1 if the subject voted, 0 if they did not vote, missing if we don't know


Note: The data is made up. This is not from a real experiment. One advantage of this is that
your instructor knows what the actual effect of the treatment is in the made-up data. You should
still analyze this as if it's real data, but you should not update your beliefs about the effects
of get-out-the-vote efforts based on this data.