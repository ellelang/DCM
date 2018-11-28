# Discrete-Choice-Modeling

## Background
Stated Preference (SP) methods are widely applied to estimate the value of nonmarket commodities in the context of environmental policy and management. As survey-based methods, these approaches collect information about respondent preferences for the environmental amenities of interest by observing choices in hypothetical situations, aiming to know people's maximum willingness to pay (WTP) or minimum willingness to accept (WTA) compensation for changes in environmental quality.

Since the observed choices / preferences are made contingent on scenarios posted in the survey, environmental economics literature commonly uses the term contingent valuation (CV) to describe the process of utilizing stated preference data for valuation.

Discrete choice experiments (DCE), one of the most popular ways to elicit the preference information in a CV study, collect the data of decision makers' choices among a set of alternatives. Each alternative is stated in terms of a bundle of characteristics or attributes. So different alternatives are actually different 'bundles' of attributes, and what people value is these bundles. Using the observations of people's choices, researchers can infer (i) which attributes significantly influence their choices; (ii) what are the trade-offs among these attributes. Because usually the price or payment information is included as one attribute, the willing to pay/accept are essentially the trade-offs between the monetary value and the increase/decrease in any other non-monetary attribute.

## Modeling Procedures

### Random Utility Framework
The random utility framework starts with a structural model,

$U(choice 1) = f_1(attribute\ of\ choice 1, charactersitics\ of\ respondent, \epsilon_1, v, w)$
...
$U(choice J) = f_J(attribute\ of\ choice J, charactersitics\ of\ respondent, \epsilon_J, v, w)$

where $\epsilon_1,...\epsilon_J$ denote the unobserved random elements of the random utility functions, v and w will represent the unobserved individual heterogeneity built into models such as the error components and random parameters (mixed logit) models. The assumption that the choice made is alternative j such that

$U_j > U_q,\  \forall q \neq j$

The econometric model that describes the stochastic outcomes of the observed choices will be

$Prob(Y = j) = Prob (U_j > U_q,\ \forall q \neq j)$

### Multinomial Logit (MNL) Modeling

In this model, the individual’s choice among J alternatives is the one with maximum utility, where the utility functions are

$u_{ij} = \beta'x_{ij} + \epsilon_{ij} $

where
$U_{ij}$ = utility of alternative j to individual i
$x_{ij}$ = union of all attributes that appear in the utility functions.
$\epsilon_{ij}$ = random errors from independent type 1 extreme value distributions. $F(\epsilon_{ij} )= exp(exp(-\epsilon_{ij}))$

Based on this specification, the choice probabilities are

$Prob(Y = j) = Prob (U_j > U_q,\ \forall q \neq j)$
= $\frac{exp(\beta_j'x_{ij})}{\sum^j_{q = 0} exp(\beta_q'x_{iq})},\ j= 0,...,J$

### NLOGIT Syntax for MNL

```
"READ; file="\\D:\OneDrive\Farm survey\Nlogit\dataset_nlogit.csv"; Nobs=7025; Nvar=22;

Names=id,Y,cset,task,alti,wld,cc,nm,pay,crent,votea,voteb,
tax,lake,stream,gender,age,edu,area,income,incomef,county $

dstat; rhs=* $

sample; 2-7025 $

MLOGIT
;Lhs=Y,cset,alti
;Choices=VolCons,Current
;Rhs=wld,cc,nm,pay
;Robust
;Marginal Effects

```
