"epi.kappa" <- function(dat, method = "fleiss", alternative = c("two.sided", "less", "greater"), conf.level = 0.95){
   
  if (nrow(dat) != 2 | ncol(dat) != 2) 
    stop("Error: epi.kappa dat requires a two-row, two-column table")
    
  N. <- 1 - ((1 - conf.level) / 2)
  z <- qnorm(N., mean = 0, sd = 1)
  lower <- "lower"
  upper <- "upper"
  
  n <- sum(dat)
  
  ## Exact binomial confidence limits from function binom::binom.confint. Changed 190716.
  .funincrisk <- function(ndat, nconf.level){
    alpha <- 1 - conf.level
    alpha2 <- 0.5 * alpha
    x <- ndat[,1]; n <- ndat[,2]
    
    p <- x/n
    x1 <- x == 0; x2 <- x == n
    lb <- ub <- x
    lb[x1] <- 1
    ub[x2] <- n[x2] - 1
    lcl <- 1 - qbeta(1 - alpha2, n + 1 - x, lb)
    ucl <- 1 - qbeta(alpha2, n - ub, x + 1)
    
    if (any(x1)) 
      lcl[x1] <- rep(0, sum(x1))
    
    if (any(x2)) 
      ucl[x2] <- rep(1, sum(x2))
    
    rval <- data.frame(est = p, lower = lcl, upper = ucl)
    rval
  }
  
  if(method == "fleiss"){
    # Turn cell frequencies into proportions:                                                                              x
    ndat <- dat / n
    
    # Overall proportion of observed agreement, pO
    # pO <- sum(diag(ndat))
    tmp <- .funincrisk(ndat = as.matrix(cbind((dat[1,1] + dat[2,2]), sum(dat))), nconf.level = conf.level)
    pO.p <- as.numeric(tmp[,1])
    pO.l <- as.numeric(tmp[,2])
    pO.u <- as.numeric(tmp[,3])
    
    # Overall proportion of chance-expected agreement, pE
    r.totals <- apply(ndat, MARGIN = 1, FUN = sum)
    c.totals <- apply(ndat, MARGIN = 2, FUN = sum)
    pE.p <- sum(r.totals * c.totals)
    
    # Overall kappa (Equation 18.12 in Fleiss):
    kappa.p <- (pO.p - pE.p) / (1 - pE.p)
    
    # Standard error of kappa (Equation 18.13 in Fleiss):
    tmp.1 <- 1 / ((1 - pE.p) * sqrt(n))
    tmp.2 <- sqrt(pE.p + pE.p^2 - sum((r.totals * c.totals) * (r.totals + c.totals)))
    se.kappa <- tmp.1 * tmp.2
    kappa.l <- kappa.p - (z * se.kappa)
    kappa.u <- kappa.p + (z * se.kappa)
  }
  
  if(method == "watson"){
    # Overall proportion of observed agreement, pO
    tmp <- .funincrisk(ndat = as.matrix(cbind((dat[1,1] + dat[2,2]), sum(dat))), nconf.level = conf.level)
    pO.p <- as.numeric(tmp[,1])
    pO.l <- as.numeric(tmp[,2])
    pO.u <- as.numeric(tmp[,3])
    
    # Expected proportion of agreement, pE:
    r.totals <- apply(dat, MARGIN = 1, FUN = sum)
    c.totals <- apply(dat, MARGIN = 2, FUN = sum)
    pE.p <- sum(r.totals * c.totals) / n^2
    
    # Overall kappa (Equation 18.12 in Fleiss):
    kappa.p <- (pO.p - pE.p) / (1 - pE.p)
    
    # Standard error of kappa (page 1170 of Watson and Petrie 2010):
    se.kappa <- sqrt((pO.p * (1- pO.p)) / (n * (1 - pE.p)^2))
    kappa.l <- kappa.p - (z * se.kappa)
    kappa.u <- kappa.p + (z * se.kappa)
  }
  
  if(method == "altman"){
    # Overall proportion of observed agreement, pO
    n <- sum(dat)
    
    tmp <- .funincrisk(ndat = as.matrix(cbind((dat[1,1] + dat[2,2]), sum(dat))), nconf.level = conf.level)
    pO.p <- as.numeric(tmp[,1])
    pO.l <- as.numeric(tmp[,2])
    pO.u <- as.numeric(tmp[,3])
    
    # Overall proportion of chance-expected agreement, pE
    r.totals <- apply(dat, MARGIN = 1, FUN = sum)
    c.totals <- apply(dat, MARGIN = 2, FUN = sum)
    pE.p <- sum(r.totals * c.totals) / n^2
    
    kappa.p <- (pO.p - pE.p) / (1 - pE.p)
    se.kappa <- sqrt((pO.p * (1 - pO.p)) / (n * (1 - pE.p)^2))
    kappa.l <- kappa.p - (z * se.kappa)
    kappa.u <- kappa.p + (z * se.kappa)
  }
  
  # Bias index, the difference in proportions of 'yes' for the two raters (after Byrt et al. 1993, added 010814).
  # The Bias index is equal to zero if and only if the marginal proportions are equal.
  # BI = (a + b)/N - (a + c)/N
  # Confidence interval calculation same as that used for attributable risk (Rothman p 135 equation 7-2).
  a <- dat[1,1] + dat[1,2]
  c <- dat[1,1] + dat[2,1]
  
  bi.p <- ((a / n) - (c / n))
  bi.se <- (sqrt(((a * (n - a))/n^3) + ((c * (n - c))/n^3)))
  bi.l <- (bi.p - (z * bi.se))
  bi.u <- (bi.p + (z * bi.se))
  
  # Prevalence index, the difference between the probability of 'Yes' and the probability of 'No' (after Byrt et al. 1993, added 010814).
  # PI = (a / N) - (d / N)
  # Confidence interval calculation same as that used for attributable risk (Rothman p 135 equation 7-2).
  a <- dat[1,1]
  d <- dat[2,2]
  
  pi.p <- ((a / n) - (d / n))
  pi.se <- (sqrt(((a * (n - a))/n^3) + ((d * (n - d))/n^3)))
  pi.l <- (pi.p - (z * pi.se))
  pi.u <- (pi.p + (z * pi.se))
  
  # Population adjusted, bias corrected kappa (after Byrt et al. 1993, added 010814):
  pabak.p <- 2 * pO.p - 1
  pabak.l <- 2 * pO.l - 1   
  pabak.u <- 2 * pO.u - 1
  
  # Test of effect (Equation 18.14 in Fleiss). Code for p-value taken from z.test function in TeachingDemos package:
  effect.z <- kappa.p / se.kappa
  alternative <- match.arg(alternative)
  p.effect <- switch(alternative, two.sided = 2 * pnorm(abs(effect.z), lower.tail = FALSE), less = pnorm(effect.z), greater = pnorm(effect.z, lower.tail = FALSE))
  
  # McNemar's test (Dohoo, Martin, Stryhn):
  mcnemar <- (dat[1,2] - dat[2,1])^2 / (dat[1,2] + dat[2,1])
  p.chi2 <- 1 - pchisq(mcnemar, df = 1)
  
  # Results:
  prop.agree <- data.frame(obs = pO.p, exp = pE.p)
  pindex <- data.frame(est = pi.p, se = pi.se, lower = pi.l, upper = pi.u) 
  bindex <- data.frame(est = bi.p, se = bi.se, lower = bi.l, upper = bi.u)
  pabak <- data.frame(est = pabak.p, lower = pabak.l, upper = pabak.u)
  kappa <- data.frame(est = kappa.p, se = se.kappa, lower = kappa.l, upper = kappa.u)
  z <- data.frame(test.statistic = effect.z, p.value = p.effect)
  mcnemar <- data.frame(test.statistic = mcnemar, df = 1, p.value = p.chi2)
  rval <- list(prop.agree = prop.agree, pindex = pindex, bindex = bindex, pabak = pabak, kappa = kappa, z = z, mcnemar = mcnemar)
  return(rval)
}
