set.seed(123)
normals <- rnorm(10000, 0, 1)
plot(density(normals))
beta_price <- exp(-6.41375 + 2.96762 * normals)
mean(beta_price) # Why is it so different than the theoretical expected value?
theoretical_mean <- exp(-6.41375 + 2.96762^2 / 2)
plot(density(beta_price))


beta_wetlands <- - exp(-1.35251 + 3.00529 * normals)


mWTA_wetlands <- - beta_wetlands / beta_price
plot(density(mWTA_wetlands))

beta_CC <- (-0.34960 + 0.06189*1.837) + 1.29781 * normals
plot(density(beta_CC))

mWTA_CC <- - beta_CC / beta_price
plot(density(mWTA_CC))
density(mWTA_CC)


lognormals <- exp(normals)

