#' Simulate Mixture Hidden Markov Models
#' 
#' Simulate sequences of observed and hidden states given parameters of a mixture hidden Markov model.
#'
#' @param n_sequences Number of simulations.
#' @param initial_probs A list containing vectors of initial state probabilities 
#' for submodels of each cluster.
#' @param transition_matrix A list of matrices of transition probabilities for submodels of each cluster.
#' @param emission_matrix A list which contains matrices of emission probabilities or a list of such 
#' objects (one for each channel) for submodels of each cluster. Note that the matrices must have 
#' dimensions m x s where m is the number of hidden states and s is the number of unique symbols 
#' (observed states) in the data.
#' @param sequence_length Length for simulated sequences.
#' @param formula Covariates as an object of class \code{\link{formula}}, left side omitted.
#' @param data An optional data frame, list or environment containing the variables in the model. 
#' If not found in data, the variables are taken from \code{environment(formula)}.
#' @param coefficients An optional k x l matrix of regression coefficients for time-constant covariates 
#' for mixture probabilities, where l is the number of clusters and k is the number of 
#' covariates. A logit-link is used for mixture probabilities. The first column is set to zero.
#' 
#' @return A list of state sequence objects of class \code{stslist}.
#' @seealso \code{\link{build_mhmm}} and \code{\link{fit_mhmm}} for building 
#' and fitting mixture hidden Markov models; \code{\link{ssplot}} for plotting 
#' multiple sequence data sets; \code{\link{seqdef}} for more
#' information on state sequence objects; and \code{\link{simulate_hmm}}
#' for simulating hidden Markov models.
#' @export
#' @examples 
#' emission_matrix_1 <- matrix(c(0.75, 0.05, 0.25, 0.95), 2, 2)
#' emission_matrix_2 <- matrix(c(0.1, 0.8, 0.9, 0.2), 2, 2)
#' colnames(emission_matrix_1) <- colnames(emission_matrix_2) <- c("heads", "tails")
#' transition_matrix_1 <- matrix(c(9, 0.1, 1, 9.9)/10, 2, 2)
#' transition_matrix_2 <- matrix(c(35, 1, 1, 35)/36, 2, 2)
#' rownames(emission_matrix_1) <- rownames(transition_matrix_1) <- 
#'   colnames(transition_matrix_1) <- c("coin 1", "coin 2")
#' rownames(emission_matrix_2) <- rownames(transition_matrix_2) <- 
#'   colnames(transition_matrix_2) <- c("coin 3", "coin 4")
#' initial_probs_1 <- c(1, 0)
#' initial_probs_2 <- c(1, 0)
#' 
#' n <- 50
#' set.seed(123)
#' covariate_1 <- runif(n)
#' covariate_2 <- sample(c("A", "B"), size = n, replace = TRUE, 
#'   prob = c(0.3, 0.7))
#' dataf <- data.frame(covariate_1, covariate_2)
#' 
#' coefs <- cbind(cluster_1 = c(0, 0, 0), cluster_2 = c(-1.5, 3, -0.7))
#' rownames(coefs) <- c("(Intercept)", "covariate_1", "covariate_2B")
#' 
#' sim <- simulate_mhmm(
#'   n = n, initial_probs = list(initial_probs_1, initial_probs_2), 
#'   transition_matrix = list(transition_matrix_1, transition_matrix_2), 
#'   emission_matrix = list(emission_matrix_1, emission_matrix_2), 
#'   sequence_length = 25, formula = ~covariate_1 + covariate_2,
#'   data = dataf, coefficients = coefs)
#' 
#' ssplot(
#'   sim$observations, hidden.paths = sim$states, plots = "both", 
#'   sortv = "mds.hidden")
#' 
#' hmm <- build_mhmm(sim$observations, 
#' initial_probs = list(initial_probs_1, initial_probs_2), 
#'   transition_matrix = list(transition_matrix_1, transition_matrix_2), 
#'   emission_matrix = list(emission_matrix_1, emission_matrix_2), 
#'   formula = ~covariate_1 + covariate_2,
#'   data = dataf)
#' 
#' fit <- fit_mhmm(hmm, local = FALSE, global = FALSE)
#' 
#' paths <- hidden_paths(fit$model)
#' 
#' ssplot(list(estimates = paths, true = sim$states), sortv = "mds.obs", 
#'   ylab = c("estimated paths", "true (simulated)"))
#' 
simulate_mhmm <- function(n_sequences, initial_probs, transition_matrix, 
  emission_matrix, sequence_length, formula, data, coefficients){
  
  if (is.list(transition_matrix)){
    n_clusters<-length(transition_matrix)
  } else {
    stop("transition_matrix is not a list.")
  }
  if (length(emission_matrix)!=n_clusters || length(initial_probs)!=n_clusters) {
    stop("Unequal list lengths of transition_matrix, emission_matrix and initial_probs.")
  }
  if (is.null(cluster_names <- names(transition_matrix))) {
    cluster_names <- paste("Cluster", 1:n_clusters)
  }
  
  if (is.list(emission_matrix[[1]])) {
    n_channels <- length(emission_matrix[[1]])
  } else {
    n_channels <- 1
    for(i in 1:n_clusters)
      emission_matrix[[i]] <- list(emission_matrix[[i]])
  }
  if (is.null(channel_names <- names(emission_matrix[[1]]))) {
    channel_names <- 1:n_channels
  }
  if (n_sequences < 2) {
    stop("Number of simulations (n_sequences) must be at least 2 for a mixture model.")
  }
  
  if (missing(formula)) {
    formula <- stats::formula(rep(1, n_sequences) ~ 1)
  }
  if (missing(data)) {
    data <- environment(formula)
  }
  if (inherits(formula, "formula")) {
    X <- model.matrix(formula, data)
    if (nrow(X) != n_sequences) {
      if (length(all.vars(formula)) > 0 && 
          sum(!complete.cases(data[all.vars(formula)])) > 0) {
        stop("Missing cases are not allowed in covariates. Use e.g. the complete.cases function to detect them, then fix, impute, or remove.") 
      } else {
        stop("Number of subjects in data for covariates does not match the number of subjects in the sequence data.")
      }
    }
    n_covariates <- ncol(X)
  } else {
    stop("Object given for argument formula is not of class formula.")
  }
  if (missing(coefficients)) {
    coefficients <- matrix(0, n_covariates, n_clusters)
  } else {
    if (ncol(coefficients) != n_clusters | nrow(coefficients) != n_covariates) {
      stop("Wrong dimensions of coefficients")
    }
    coefficients[, 1] <- 0
  }       
  
  pr <- exp(X %*% coefficients)
  pr <- pr / rowSums(pr)
  
  
  n_symbols <- sapply(emission_matrix[[1]], ncol)
  if (is.null(colnames(emission_matrix[[1]][[1]]))) {
    symbol_names <- lapply(1:n_channels, function(i) 1:n_symbols[i])
  } else symbol_names <- lapply(1:n_channels, function(i) colnames(emission_matrix[[1]][[i]]))
  
  obs <- lapply(1:n_channels, function(i) {
    suppressWarnings(suppressMessages(seqdef(matrix(NA, n_sequences, sequence_length), 
      alphabet = symbol_names[[i]])))})
  
  names(obs) <- channel_names
  
  n_states <- sapply(transition_matrix, nrow)
  if (is.null(rownames(transition_matrix[[1]]))) {
    state_names <- lapply(1:n_clusters, function(i) 1:n_states[i])
  } else state_names <- lapply(1:n_clusters, function(i) rownames(transition_matrix[[i]]))
  v_state_names <- unlist(state_names)
  if (length(unique(v_state_names)) != length(v_state_names)) {
    for (i in 1:n_clusters) {
      colnames(transition_matrix[[i]]) <- rownames(transition_matrix[[i]]) <- 
        paste(cluster_names[i], state_names[[i]], sep = ":")
    }
    v_state_names <- paste(rep(cluster_names, n_states), v_state_names, sep = ":")
  } 
  for (i in 1:n_clusters) {
    for (j in 1:n_channels) {
      rownames(emission_matrix[[i]][[j]]) <- 
        colnames(transition_matrix[[i]])
    }
  }
  
  
  
  states <- suppressWarnings(suppressMessages(seqdef(matrix(NA, 
    n_sequences, sequence_length), alphabet = v_state_names)))
  
  clusters <- numeric(n_sequences)
  for (i in 1:n_sequences) {
    clusters[i] <- sample(cluster_names, size = 1, prob = pr[i, ])
  }
  for (i in 1:n_clusters) {
    if(sum(clusters == cluster_names[i]) > 0) {
      sim <- simulate_hmm(n_sequences = sum(clusters == cluster_names[i]), initial_probs[[i]],
        transition_matrix[[i]], emission_matrix[[i]], sequence_length)
      if(n_channels > 1){
        for (k in 1:n_channels) {
          obs[[k]][clusters == cluster_names[i], ] <- sim$observations[[k]]
        }
      } else  obs[[1]][clusters == cluster_names[i], ] <- sim$observations
      states[clusters == cluster_names[i], ] <- sim$states
    }
  }
  
  
  p <- 0
  for (i in 1:n_channels) {
    attr(obs[[i]], "cpal") <- seqHMM::colorpalette[[
      length(unlist(symbol_names))]][(p + 1):(p + n_symbols[[i]])]
    p <- p + n_symbols[[i]]
  }
  
  if (length(unlist(symbol_names)) != length(alphabet(states))) {
    attr(states, "cpal") <- seqHMM::colorpalette[[length(alphabet(states))]]
  } else {
    attr(states, "cpal") <- seqHMM::colorpalette[[length(alphabet(states)) + 1]][1:length(alphabet(states))]
  }
  
  if (n_channels == 1) obs <- obs[[1]]
  
  
  list(observations = obs, states = states)
}