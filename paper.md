# Benefit-risk assessment of statins: different analyses for different decisions (working title) #

 - TODO: figure out a better title (All)
 - (Suggestion by Gert) The right tool for the right job: preference models and elicitation methods in multi-criteria benefit-risk assessment

Gert van Valkenhoef (1, *), Huseyin Naci (2, 3), Tommi Tervonen (4), A. E. Ades (5), Aris Angelis (2), Douwe Postmus (1)

(1) Department of Epidemiology, University Medical Center Groningen, University of Groningen, The Netherlands  
(2) LSE Health, London School of Economics and Political Science, London, UK  
(3) Department of Population Medicine, Harvard Medical School and Harvard Pilgrim Health Care Institute, Boston, MA, USA  
(4) Econometric Institute, Erasmus School of Economics, Erasmus University Rotterdam, The Netherlands  
(5) School of Social and Community Medicine, University of Bristol, UK  
(*) Corresponding author. Email: g.h.m.van.valkenhoef@rug.nl


## Abstract ##

Decision makers in different health care settings need to weigh the benefits and harms of alternative strategies.
Health care decisions include marketing authorization by regulatory agencies, reimbursement and coverage by health technology assessment bodies, practice guideline formulation by clinical groups, and treatment selection by clinicians and patients in clinical practice.
While these decisions differ in some important respects, they also have much in common.
First, they involve important trade-offs among multiple attributes measured on different scales.
Second, they strive to be evidence-based, often using randomized controlled trials.
Third, they need to account for significant uncertainty in the effectiveness and safety of alternative scenarios.
Given the challenging nature of such decisions it is not surprising that multiple criteria decision analysis (MCDA), a family of formal methods that help decision makers structure these problems, is receiving increasing attention to inform health care decisions.
However, despite the recent interest in MCDA, certain methodological aspects of multi-criteria preference modeling remain are poorly understood, specifically around how preferences at the individual and population levels differ, and what types of analyses are most useful to inform decisions at different settings.
In this paper, we survey different types of preference information and how they may be used in formal analyses aiming to inform individual or population-level decisions.
We demonstrate how preferences should be elicited in a meaningful way that would minimize bias.
Using statin selection in clinical practice as a case study, we also show how alternative elicitation approaches produce different treatment recommendations.
In addition to providing an overview of various tools available to researchers and decision makers, we discuss implications for decision-making in different settings.

## Introduction ##

Many decisions in health care involve assessing the balance of favourable and unfavourable effects of alternative treatment regimens, taking into account the associated uncertainties [CITE].
For example, regulatory authorities assess whether a new drug is expected to do more good than harm when treating a condition in a specific target population [CITE].

Many have suggested the use of some form of multiple criteria decision analysis in regulatory benefit-risk assessments [@holden2003;@mussen2007;@felli2009;@smaa-br;@network-br;@coplan2011], including the European Medicines Agency's own benefit-risk project [@ema-br-wp2], and research on MCDA in health is increasing [@diaby2013].
The scope of regulatory benefit-risk assessment is usually fairly limited in the sense that the evidence base consists solely of the clinical trials submitted by the applicant [CITE] and the number of comparators is small because the objective is usually to ensure that the drug is beneficial as compared to not treating the condition, rather than to identify the best treatment [CITE].
The formulation of treatment guidelines depends on a similar process of benefit-risk deliberation, although in this case the analysis will be much more inclusive in terms of both evidence and the number of comparators, since the goal is to identify the best treatment option given the available evidence [CITE].
In addition, guideline formulation may also focus on identifying sub-populations that respond particularly well or particularly badly to specific treatments, and will also take into account the feasibility of implementing each treatment in the given health care setting [CITE].

Prescribers often depend on guidelines and experience when identifying the best treatment for a specific patient, but may also refer to systematic reviews or directly to clinical trials [CITE].
In essence, the prescription problem is similar to the regulatory benefit-risk problem, with two important differences: (1) the decision should take into account the individual patient's preferences rather than determine what is acceptable at the population level and (2) it may be questioned whether the population-level evidence from clinical trials or systematic reviews thereof applies to the individual patient [CITE huseyin-mcda?].

Reimbursement decisions typically include several different aspects, including an assessment similar to the regulatory benefit-risk assessment and a cost-effectiveness analysis that contrasts long-term health effects versus the long-term costs of a treatment [CITE].
Cost-effectiveness analysis is interesting in that it often includes preferences at two different levels: the policy maker's preferences for health care spending versus health benefits and the patients' preferences expressed as health state utilities.
Although it can be argued that the standard cost-effectiveness framework is a form of MCDA [@smaa-cea] and so is the Quality Adjusted Life Year [CITE], the focus of this paper is on the benefit-risk type of decision rather than on the health economic setting.
This enables a unified focus on decisions involving trade-offs between multiple criteria that are directly expressed by the relevant expert(s) or patient.

 - TODO: An introduction explaining the challenges in decision making for different healthcare settings that mainly arise due to methodological gaps in synthesis and interpretation of evidence. Settings include drug and treatment selection, marketing authorisation, coverage/reimbursement.

 - TODO: Highlight the case of prescribing and treatment selection while choosing it as the topic of the case study.

 - TODO: Describe the statins case (Huseyin / ?)

## Methods ##

### Alternatives and criteria ###

 - TODO: describe the decision problem

### Criteria measurements ###

 - TODO: Describe the statins data set (Huseyin)

### Preference modeling ###

 - TODO: Describe MAVT (Tommi)
 - TODO: Discuss differences in modeling individual / population preferences (?)
 - TODO: Describe different elicitation methods (Gert, Tommi, Douwe, ++?)
 - TODO: Describe SMAA (Tommi)

## Results ##

 - TODO: Results of preference elicitation from some "experts" using different elicitation techniques (?)
 - NOTE/Tommi: need to elicit piecewise partial value functions (bisection?), weight ranges (interval swing), and the MAVT parameterization using indirect techniques
 - NOTE/Tommi: I guess we will make the case analysis using policy/prescription decision preferences, and discuss later on what would be the differences/challenges when trying to model population preferences?
 - Results from a SMAA analysis, using (i) linear partial VF and (ii) piecewise linear partial VFs, with different accuracy of the preferences

## Discussion ##

 - TODO: Describe why we did not apply MAUT / the cons of MAUT (Tommi and Douwe)
 - TODO: policy implications, mainly for prescribing and treatment selections, but possibly also touching on the other settings we introduced at the beginning (Huseyin and Aris)

## Study highlights ##

## Acknowledgements ##

## Conflict of interest/disclosure ##

TT declares no conflict of interest.
GvV has provided consulting services to Johnson & Johnson and (as a subcontractor of Deloitte) for UCB Pharma on the conduct of network meta-analyses. 

## Author contributions ##


## Table and Figure captions ##

Captions for the tables and figures (let's keep them in separate files for now).
