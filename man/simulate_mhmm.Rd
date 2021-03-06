% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/simulate_mhmm.R
\name{simulate_mhmm}
\alias{simulate_mhmm}
\title{Simulate Mixture Hidden Markov Models}
\usage{
simulate_mhmm(n_sequences, initial_probs, transition_matrix, emission_matrix,
  sequence_length, formula, data, coefficients)
}
\arguments{
\item{n_sequences}{Number of simulations.}

\item{initial_probs}{A list containing vectors of initial state probabilities
for submodels of each cluster.}

\item{transition_matrix}{A list of matrices of transition probabilities for submodels of each cluster.}

\item{emission_matrix}{A list which contains matrices of emission probabilities or a list of such
objects (one for each channel) for submodels of each cluster. Note that the matrices must have
dimensions m x s where m is the number of hidden states and s is the number of unique symbols
(observed states) in the data.}

\item{sequence_length}{Length for simulated sequences.}

\item{formula}{Covariates as an object of class \code{\link{formula}}, left side omitted.}

\item{data}{An optional data frame, list or environment containing the variables in the model.
If not found in data, the variables are taken from \code{environment(formula)}.}

\item{coefficients}{An optional k x l matrix of regression coefficients for time-constant covariates
for mixture probabilities, where l is the number of clusters and k is the number of
covariates. A logit-link is used for mixture probabilities. The first column is set to zero.}
}
\value{
A list of state sequence objects of class \code{stslist}.
}
\description{
Simulate sequences of observed and hidden states given parameters of a mixture hidden Markov model.
}
\examples{
emission_matrix_1 <- matrix(c(0.75, 0.05, 0.25, 0.95), 2, 2)
emission_matrix_2 <- matrix(c(0.1, 0.8, 0.9, 0.2), 2, 2)
colnames(emission_matrix_1) <- colnames(emission_matrix_2) <- c("heads", "tails")
transition_matrix_1 <- matrix(c(9, 0.1, 1, 9.9)/10, 2, 2)
transition_matrix_2 <- matrix(c(35, 1, 1, 35)/36, 2, 2)
rownames(emission_matrix_1) <- rownames(transition_matrix_1) <-
  colnames(transition_matrix_1) <- c("coin 1", "coin 2")
rownames(emission_matrix_2) <- rownames(transition_matrix_2) <-
  colnames(transition_matrix_2) <- c("coin 3", "coin 4")
initial_probs_1 <- c(1, 0)
initial_probs_2 <- c(1, 0)

n <- 50
set.seed(123)
covariate_1 <- runif(n)
covariate_2 <- sample(c("A", "B"), size = n, replace = TRUE,
  prob = c(0.3, 0.7))
dataf <- data.frame(covariate_1, covariate_2)

coefs <- cbind(cluster_1 = c(0, 0, 0), cluster_2 = c(-1.5, 3, -0.7))
rownames(coefs) <- c("(Intercept)", "covariate_1", "covariate_2B")

sim <- simulate_mhmm(
  n = n, initial_probs = list(initial_probs_1, initial_probs_2),
  transition_matrix = list(transition_matrix_1, transition_matrix_2),
  emission_matrix = list(emission_matrix_1, emission_matrix_2),
  sequence_length = 25, formula = ~covariate_1 + covariate_2,
  data = dataf, coefficients = coefs)

ssplot(
  sim$observations, hidden.paths = sim$states, plots = "both",
  sortv = "mds.hidden")

hmm <- build_mhmm(sim$observations,
initial_probs = list(initial_probs_1, initial_probs_2),
  transition_matrix = list(transition_matrix_1, transition_matrix_2),
  emission_matrix = list(emission_matrix_1, emission_matrix_2),
  formula = ~covariate_1 + covariate_2,
  data = dataf)

fit <- fit_mhmm(hmm, local = FALSE, global = FALSE)

paths <- hidden_paths(fit$model)

ssplot(list(estimates = paths, true = sim$states), sortv = "mds.obs",
  ylab = c("estimated paths", "true (simulated)"))
}
\seealso{
\code{\link{build_mhmm}} and \code{\link{fit_mhmm}} for building
and fitting mixture hidden Markov models; \code{\link{ssplot}} for plotting
multiple sequence data sets; \code{\link{seqdef}} for more
information on state sequence objects; and \code{\link{simulate_hmm}}
for simulating hidden Markov models.
}

