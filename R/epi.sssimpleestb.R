epi.sssimpleestb <- function(N = 1E+06, Py, epsilon.r, conf.level = 0.95) 
{
    N. <- 1 - ((1 - conf.level) / 2)
    z <- qnorm(N., mean = 0, sd = 1)
    
    # Page 74 Levy and Lemeshow (equation 3.16):
    n <- (z^2 * N * (1 - Py) * Py) / (((N - 1) * (epsilon.r^2) * Py^2) + (z^2 * Py * (1 - Py)))
    f <- n / N
    if(f > 0.10){n <- n / (1 + n/N)}
    rval <- round(n, digits = 0)
    return(rval)
}
