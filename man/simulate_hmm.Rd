% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/simulate_hmm.R
\name{simulate_hmm}
\alias{simulate_hmm}
\title{Simulate hidden Markov models}
\usage{
simulate_hmm(n_sequences, initial_probs, transition_matrix, emission_matrix,
  sequence_length)
}
\arguments{
\item{n_sequences}{Number of simulations.}

\item{initial_probs}{A vector of initial state probabilities.}

\item{transition_matrix}{A matrix of transition probabilities.}

\item{emission_matrix}{A matrix of emission probabilities or a list of such objects (one for each channel).}

\item{sequence_length}{Length for simulated sequences.}
}
\value{
A list of state sequence objects of class \code{stslist}.
}
\description{
Simulate sequences of observed and hidden states given parameters of a hidden Markov model.
}
\examples{
# Parameters for a HMM
emission_matrix <- matrix(c(0.5, 0.2, 0.5, 0.8), 2, 2)
transition_matrix <- matrix(c(5/6, 1/6, 1/6, 5/6), 2, 2)
initial_probs <- c(1, 0)

# Setting seed for simulation
set.seed(1)

# Simulating sequences
sim <- simulate_hmm(
  n_sequences = 10, initial_probs = initial_probs,
  transition_matrix = transition_matrix,
  emission_matrix = emission_matrix,
  sequence_length = 20)
}
\seealso{
\code{\link{build_hmm}} and \code{\link{fit_hmm}} for building
and fitting hidden Markov models; \code{\link{ssplot}} for plotting
multiple sequence data sets; \code{\link{seqdef}} for more
information on state sequence objects; and \code{\link{simulate_mhmm}}
for simulating mixture hidden Markov models.
}

