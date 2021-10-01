This work wants to be carried out, comparing how the muscular forces calculated through the optimization vary as the speed with which the subject performed the test varies, to obtain this 2 threshold values are selected in order to distinguish different speed ranges ( FAST, MEDIUMM, SLOW).

Opty\_0.m

INPUT (SUBJECT [1:50], TRIAL[1:N], OPTIMIZATION METHOD)

OUTPUT (SOLUTION FROM OPTIMIZATION [MUSCLE IN THE MODEL])

Opty\_1.m

INPUT (SUBJECT [1:50], OPTIMIZATION METHOD)

OUTPUT (3 SOLUTION [classified:FAST/MEDIUM/SLOW] FROM OPTIMIZATION [MUSCLE IN THE MODEL])

OptyMuscle.m

INPUT (SUBJECT [1:50], OPTIMIZATION METHOD)

OUTPUT (ALL THE SOLUTION [classified:FAST/MEDIUM/SLOW] FROM OPTIMIZATION [MUSCLE IN THE MODEL])

OptyMuscleMean.m

INPUT (SUBJECT [1:50], OPTIMIZATION METHOD)

OUTPUT (MEAN(OUTPUT(OptyMuscle.m))) 
