# Discrete-Choice-Modeling

- [Discrete-Choice-Modeling](#discrete-choice-modeling)
  * [Background](#background)
  * [Modeling Procedures](#modeling-procedures)
    + [Random Utility Framework](#random-utility-framework)
    + [Multinomial Logit (MNL) Modeling](#multinomial-logit--mnl--modeling)
    + [NLOGIT Syntax for MNL](#nlogit-syntax-for-mnl)

## Background
Stated Preference (SP) methods are widely applied to estimate the value of nonmarket commodities in the context of environmental policy and management. As survey-based methods, these approaches collect information about respondent preferences for the environmental amenities of interest by observing choices in hypothetical situations, aiming to know people's maximum willingness to pay (WTP) or minimum willingness to accept (WTA) compensation for changes in environmental quality.

Since the observed choices / preferences are made contingent on scenarios posted in the survey, environmental economics literature commonly uses the term contingent valuation (CV) to describe the process of utilizing stated preference data for valuation.

Discrete choice experiments (DCE), one of the most popular ways to elicit the preference information in a CV study, collect the data of decision makers' choices among a set of alternatives. Each alternative is stated in terms of a bundle of characteristics or attributes. So different alternatives are actually different 'bundles' of attributes, and what people value is these bundles. Using the observations of people's choices, researchers can infer (i) which attributes significantly influence their choices; (ii) what are the trade-offs among these attributes. Because usually the price or payment information is included as one attribute, the willing to pay/accept are essentially the trade-offs between the monetary value and the increase/decrease in any other non-monetary attribute.

## Modeling Procedures

### Random Utility Framework

The random utility framework starts with a structural model,

<img src="/tex/41266d926499e17ff3983d52197bcb4b.svg?invert_in_darkmode&sanitize=true" align=middle width=559.56582pt height=24.65753399999998pt/>
...
<img src="/tex/6a9400390e4cb72478a8436028557c5d.svg?invert_in_darkmode&sanitize=true" align=middle width=566.3053803pt height=24.65753399999998pt/>

where <img src="/tex/1a63ddc8c230194789f70b38525c6d42.svg?invert_in_darkmode&sanitize=true" align=middle width=50.08225694999998pt height=14.15524440000002pt/> denote the unobserved random elements of the random utility functions, v and w will represent the unobserved individual heterogeneity built into models such as the error components and random parameters (mixed logit) models. The assumption that the choice made is alternative j such that

<img src="/tex/443110a63a72643aa4c917e03c7d9c85.svg?invert_in_darkmode&sanitize=true" align=middle width=118.02515174999999pt height=22.831056599999986pt/>

The econometric model that describes the stochastic outcomes of the observed choices will be

<img src="/tex/818b2fdc3323fd488665d7adf218a8f3.svg?invert_in_darkmode&sanitize=true" align=middle width=279.8032248pt height=24.65753399999998pt/>

### Multinomial Logit (MNL) Modeling

Under the random utility framework, the individual’s choice among J alternatives is the one with maximum utility, where the utility functions are

<img src="/tex/776db559eafbf5cfb50abf950f2b23cc.svg?invert_in_darkmode&sanitize=true" align=middle width=116.17385504999999pt height=24.7161288pt/>

Based on the specification that random errors are from independent type I extreme value distributions, the choice probabilities are

<img src="/tex/818b2fdc3323fd488665d7adf218a8f3.svg?invert_in_darkmode&sanitize=true" align=middle width=279.8032248pt height=24.65753399999998pt/> =
<img src="/tex/6f4117ba7962d3edab16fce98ee75063.svg?invert_in_darkmode&sanitize=true" align=middle width=191.34422999999995pt height=39.017266199999995pt/>

### NLOGIT Syntax for MNL

```
"READ; file="\\D:\OneDrive\Farm survey\Nlogit\dataset_nlogit.csv"; Nobs=7025; Nvar=22;

Names=id,Y,cset,task,alti,wld,cc,nm,pay,crent,votea,voteb,
tax,lake,stream,gender,age,edu,area,income,incomef,county <img src="/tex/5ece49e93cdb12499e6c1e78c5dd7768.svg?invert_in_darkmode&sanitize=true" align=middle width=80.59385234999999pt height=45.84475499999998pt/>

sample; 2-7025 $

MLOGIT
;Lhs=Y,cset,alti
;Choices=VolCons,Current
;Rhs=wld,cc,nm,pay
;Robust
;Marginal Effects

```
