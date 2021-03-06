\name{epi.sscc}

\alias{epi.sscc}

\title{
Sample size, power or minimum detectable odds ratio for an unmatched or matched case-control study
}

\description{
Calculates the sample size, power or minimum detectable odds ratio for an unmatched or matched case-control study.
}

\usage{
epi.sscc(OR, p0, n, power, r = 1, rho = 0, design = 1, sided.test = 2, 
   conf.level = 0.95, method = "unmatched", fleiss = FALSE)
}

\arguments{
  \item{OR}{scalar, the expected study odds ratio.}
  \item{p0}{scalar, the prevalence of exposure amongst the controls.}
  \item{n}{scalar, the total number of subjects in the study (i.e. the number of cases plus the number of controls).}
  \item{power}{scalar, the required study power.}
  \item{r}{scalar, the number in the control group divided by the number in the case group.}
  \item{rho}{scalar, the correlation between case and control exposures for matched pairs. Ignored when \code{method = "unmatched"}.}
  \item{design}{scalar, the design effect.}
  \item{sided.test}{use a one- or two-sided test? Use a two-sided test if you wish to evaluate whether or not the odds of exposure in cases is greater than or less than the odds of exposure in controls. Use a one-sided test to evaluate whether or not the odds of exposure in cases is greater than the odds of exposure in controls.}
  \item{conf.level}{scalar, the level of confidence in the computed result.}
  \item{method}{a character string defining the method to be used. Options are \code{unmatched} or \code{matched}.}
  \item{fleiss}{logical, indicating whether or not the Fleiss correction should be applied. This argument is ignored when \code{method = "matched"}.}
}

\details{
This function implements the methodology described by Dupont (1988). A detailed description of sample size calculations for case-control studies (with numerous worked examples, many of them reproduced below) is provided by Woodward (2005), pp. 381 to 426.
}

\value{
A list containing the following: 

  \item{n.total}{the total number of subjects required to estimate the specified odds ratio at the desired level of confidence and power (i.e. the number of cases plus the number of controls).}
  \item{n.case}{the total number of case subjects required to estimate the specified odds ratio at the desired level of confidence and power.}
  \item{n.control}{the total number of control subjects required to estimate the specified odds ratio at the desired level of confidence and power.}
  \item{power}{the power of the study given the number of study subjects, the specified odds ratio and the desired level of confidence.}
  \item{OR}{the expected detectable odds ratio given the number of study subjects, the desired power and desired level of confidence.}
}

\references{
Dupont WD (1988) Power calculations for matched case-control studies. Biometrics 44: 1157 - 1168.

Fleiss JL (1981). Statistical Methods for Rates and Proportions. Wiley, New York.

Kelsey JL, Thompson WD, Evans AS (1986). Methods in Observational Epidemiology. Oxford University Press, London, pp. 254 - 284.

Woodward M (2005). Epidemiology Study Design and Data Analysis. Chapman & Hall/CRC, New York, pp. 381 - 426.
}

\note{
The power of a study is its ability to demonstrate the presence of an association, given that an association actually exists.

See the documentation for \code{\link{epi.cohortsize}} which provides an example using the \code{design} facility implemented in this function. 
}

\examples{
## EXAMPLE 1 (from Woodward 2005 p. 412):
## A case-control study of the relationship between smoking and CHD is 
## planned. A sample of men with newly diagnosed CHD will be compared for
## smoking status with a sample of controls. Assuming an equal number of 
## cases and controls, how many study subject are required to detect an 
## odds ratio of 2.0 with 0.90 power using a two-sided 0.05 test? Previous 
## surveys have shown that around 0.30 of males without CHD are smokers.

epi.sscc(OR = 2.0, p0 = 0.30, n = NA, power = 0.90, r = 1, rho = 0, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "unmatched", 
   fleiss = FALSE)

## A total of 376 men need to be sampled: 188 cases and 188 controls.


## EXAMPLE 2 (from Woodward 2005 p. 414):
## Suppose we wish to determine the power to detect an odds ratio of 2.0 
## using a two-sided 0.05 test when 188 cases and 940 controls
## are available (that is, the ratio of controls to cases is 5:1). Assume 
## the prevalence of smoking in males without CHD is 0.30.

n <- 188 + 940
epi.sscc(OR = 2.0, p0 = 0.30, n = n, power = NA, r = 5, rho = 0, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "unmatched", 
   fleiss = TRUE)

## The power of this study, with the given sample size allocation is 0.99.

## EXAMPLE 3:
## The following statement appeared in a study proposal to identify risk 
## factors for campylobacteriosis in humans:

## `We will prospectively recruit 300 culture-confirmed Campylobacter cases 
## reported under the Public Health Act. We will then recruit one control per 
## case from general practices of the enrolled cases, using frequency matching 
## by age and sex. With exposure levels of 10% (thought to be realistic 
## given past foodborne disease case control studies) this sample size 
## will provide 80\% power to detect an odds ratio of 2 at the 5\% alpha 
## level.'

## Confirm the statement that 300 case subjects will provide 80\% power in 
## this study.

epi.sscc(OR = 2.0, p0 = 0.10, n = 600, power = NA, r = 1, rho = 0.01, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "matched", 
   fleiss = TRUE)

## If the true odds ratio for Campylobacter in exposed subjects relative to 
## unexposed subjects is 2.0 we will be able to reject the null hypothesis 
## that this odds ratio equals 1 with probability (power) 0.826. The Type I 
# error probability associated with this test of this null hypothesis is 0.05.


## EXAMPLE 4:
## We wish to conduct a case-control study to assess whether bladder cancer 
## may be associated with past exposure to cigarette smoking. Cases will be 
## patients with bladder cancer and controls will be patients hospitalised 
## for injury. It is assumed that 20\% of controls will be smokers or past 
## smokers, and we wish to detect an odds ratio of 2 with power 90\%. 
## Three controls will be recruited for every case. How many subjects need 
## to be enrolled in the study?

epi.sscc(OR = 2.0, p0 = 0.20, n = NA, power = 0.90, r = 3, rho = 0, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "unmatched", 
   fleiss = FALSE)

## A total of 620 subjects need to be enrolled in the study: 155 cases and 
## 465 controls.

## An alternative is to conduct a matched case-control study rather than the 
## unmatched design outlined above. One case will be matched to one control 
## and the correlation between case and control exposures for matched pairs 
## (rho) is estimated to be 0.01 (low). Using the same assumptions as those
## described above, how many study subjects will be required?

epi.sscc(OR = 2.0, p0 = 0.20, n = NA, power = 0.90, r = 1, rho = 0.01, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "matched", 
   fleiss = FALSE)

## A total of 456 subjects need to be enrolled in the study: 228 cases and 
## 228 controls.


## EXAMPLE 5:
## Code to reproduce the isograph shown in Figure 2 in Dupont (1988):
r <- 1
p0 = seq(from = 0.05, to = 0.95, length = 50)
OR <- seq(from = 1.05, to = 6, length = 100)
dat <- expand.grid(p0 = p0, OR = OR)
dat$n.total <- NA

for(i in 1:nrow(dat)){
   dat$n.total[i] <- epi.sscc(OR = dat$OR[i], p0 = dat$p0[i], n = NA, 
   power = 0.80, r = 1, rho = 0, design = 1, sided.test = 2, 
   conf.level = 0.95, method = "unmatched", fleiss = FALSE)$n.total
}  

grid.n <- matrix(dat$n.total, nrow = length(p0))
breaks <- c(22:30,32,34,36,40,45,50,55,60,70,80,90,100,125,150,175,
   200,300,500,1000)

par(mar = c(5,5,0,5), bty = "n")
contour(x = p0, y = OR, z = log10(grid.n), add = FALSE, levels = log10(breaks), 
   labels = breaks, xlim = c(0,1), ylim = c(1,6), las = 1, method = "flattest", 
   xlab = 'Proportion of controls exposed', ylab = "Minimum OR to detect")

\dontrun{
## The same plot using ggplot2:

library(ggplot2); library(directlabels)

p <- ggplot(data = dat, aes(x = p0, y = OR, z = n.total)) +
  geom_contour(aes(colour = ..level..), breaks = breaks) +
  xlab("Proportion of controls exposed") +
  ylab("Minimum OR to detect") +
  xlim(0,1) +
  ylim(1,6)

print(direct.label(p, list("far.from.others.borders", "calc.boxes", 
   "enlarge.box", hjust = 1, vjust = 1, box.color = NA, 
   fill = "transparent", "draw.rects")))
}

## EXAMPLE 6:
## From page 1164 of Dupont (1988). A matched case control study is to be 
## carried out to quantify the association between exposure A and an outcome B.
## Assume the prevalence of exposure in controls is 0.60 and the 
## correlation between case and control exposures for matched pairs (rho) is 
## 0.20 (moderate). Assuming an equal number of cases and controls, how many 
## subjects need to be enrolled into the study to detect an odds ratio of 3.0 
## with 0.80 power using a two-sided 0.05 test? 

epi.sscc(OR = 3.0, p0 = 0.60, n = NA, power = 0.80, r = 1, rho = 0.2, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "matched", 
   fleiss = FALSE)

## A total of 162 subjects need to be enrolled in the study: 81 cases and 
## 81 controls. 

## How many cases and controls are required if we select three 
## controls per case?

epi.sscc(OR = 3.0, p0 = 0.60, n = NA, power = 0.80, r = 3, rho = 0.2, 
   design = 1, sided.test = 2, conf.level = 0.95, method = "matched", 
   fleiss = FALSE)

## A total of 204 subjects need to be enrolled in the study: 51 cases and 
## 153 controls.

}

\keyword{univar}
