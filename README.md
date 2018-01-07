# The predictive capabilites of the ITCH-model:  Experimental evidence of model fit with perceived losses

Code and data used to get the results published in the paper "The predictive capabilites of the ITCH-model:  Experimental evidence of model fit with perceived losses"

## Code overview
* The 2 main codes to run are in "/src"
  * coefficients: Creates the ITCH coefficients for the desired conditions and 
                  his standard errors. The graphical outputs are stored in 
                  graphs/coefficients including the ones used on the paper.
  * crossvalidated_comparisons: Runs 100 out-of sample comparisons between models
                  as explained on the paper. Graphical output are stored on 
                  graphs/crossvalidated_comparisons including the ones used on the
                  paper. Results are also saved in the /output directory
* The core functions used on the /src files are stored on /lib. 
* Packages used: 
   * Several R packages:
   * boot
   * ggplot2
   * Hmisc
   * plyr
   * reshape

## Data overview
Data is stored on /data/data_final.csv

* Condition: Numeric index of the treatment to which a participant was
             assigned. There are for conditions in the dataset, listed
             below. In the code there are also a "Condition 0", that is 
             defined as all participants from all conditions.
    * 1 - Delay, Gain
    * 2 - Speedup, Gain
    * 3 - Delay, Loss
    * 4 - Speedup, Loss

* X1: The monetary value in euros associated with the smaller, sooner reward.

* T1: The time of receipt in weeks associated with the smaller, sooner reward.

* X2: The monetary value in euros associated with the larger, latter reward.

* T2: The time of receipt in weeks associated with the larger, latter reward.

* LaterOptionChosen: Dummy variable. 1 if the larger, later option was chosen, 0 if not.

Note: Data has already subtracted the loss for the endowment in the Delay-Loss and Speedup-Loss framings

## Acknowledgments

As explained on the paper the code used for this experiment uses partially the public available code
from the paper "Money Earlier or Later? Simple Heuristics Explain Intertemporal Choices 
Better Than Delay Discounting Does" from Marzilli et al. (2015) that is published here:
https://github.com/johnmyleswhite/IntertemporalChoiceHeuristics by John Myles White. 
Mainly all changes to their code are specified in comments (as some notes on given processes), 
making his explanation and Code Walkthrough useful. Their full paper and Open Practices can also 
be accessed here: https://pdfs.semanticscholar.org/1800/8d3c4a95ec6ab84e85351d73737c0305b152.pdf
