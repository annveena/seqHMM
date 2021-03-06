#' Build a Hidden Markov Model
#' 
#' Function build_hmm constructs an object of class \code{hmm}.
#' @export
#' @useDynLib seqHMM
#' @param observations TraMineR stslist (see \code{\link[TraMineR]{seqdef}}) containing 
#' the sequences, or a list of such objects (one for each channel).
#' @param transition_matrix A matrix of transition probabilities.
#' @param emission_matrix A matrix of emission probabilities or a list of such 
#' objects (one for each channel). Emission probabilities should follow the 
#' ordering of the alphabet of observations (\code{alphabet(observations)}, returned as \code{symbol_names}). 
#' @param initial_probs A vector of initial state probabilities.
#' @param state_names A list of optional labels for the hidden states. If \code{NULL}, 
#' the state names are taken from the row names of the transition matrix. If this is 
#' also \code{NULL}, numbered states are used.
#' @param channel_names A vector of optional names for the channels.
#' @return Object of class \code{hmm}.
#' 
#' @examples 
#' require(TraMineR)
#' 
#' # Single-channel data
#'
#' data(mvad)
#' 
#' mvad.alphabet <- c("employment", "FE", "HE", "joblessness", "school", 
#'                    "training")
#' mvad.labels <- c("employment", "further education", "higher education", 
#'                  "joblessness", "school", "training")
#' mvad.scodes <- c("EM", "FE", "HE", "JL", "SC", "TR")
#' mvad.seq <- seqdef(mvad, 17:86, alphabet = mvad.alphabet, states = mvad.scodes, 
#'                    labels = mvad.labels, xtstep = 6)
#' 
#' # Starting values for the emission matrix
#' emiss <- matrix(NA, nrow = 4, ncol = 6)
#' emiss[1,] <- seqstatf(mvad.seq[, 1:12])[, 2] + 0.1
#' emiss[2,] <- seqstatf(mvad.seq[, 13:24])[, 2] + 0.1
#' emiss[3,] <- seqstatf(mvad.seq[, 25:48])[, 2] + 0.1
#' emiss[4,] <- seqstatf(mvad.seq[, 49:70])[, 2] + 0.1
#' emiss <- emiss / rowSums(emiss)
#' 
#' # Starting values for the transition matrix
#' 
#' tr <- matrix(
#'   c(0.80, 0.10, 0.05, 0.05,
#'     0.05, 0.80, 0.10, 0.05,
#'     0.05, 0.05, 0.80, 0.10,
#'     0.05, 0.05, 0.10, 0.80), 
#'   nrow=4, ncol=4, byrow=TRUE)
#' 
#' # Starting values for initial state probabilities
#' init <- c(0.3, 0.3, 0.2, 0.2)
#' 
#' # Building a hidden Markov model with starting values
#' init_hmm_1 <- build_hmm(
#'   observations = mvad.seq, transition_matrix = tr, 
#'   emission_matrix = emiss, initial_probs = init
#' )
#' 
#' #########################################
#' 
#' 
#' # Multichannel data
#' 
#' data(biofam3c)
#' 
#' # Building sequence objects
#' child.seq <- seqdef(biofam3c$children)
#' marr.seq <- seqdef(biofam3c$married)
#' left.seq <- seqdef(biofam3c$left)
#' 
#' # Starting values for emission matrices
#' emiss_child <- matrix(NA, nrow = 3, ncol = 2)
#' emiss_child[1,] <- seqstatf(child.seq[, 1:5])[, 2] + 0.1
#' emiss_child[2,] <- seqstatf(child.seq[, 6:10])[, 2] + 0.1
#' emiss_child[3,] <- seqstatf(child.seq[, 11:15])[, 2] + 0.1
#' emiss_child <- emiss_child / rowSums(emiss_child)
#' 
#' emiss_marr <- matrix(NA, nrow = 3, ncol = 3)
#' emiss_marr[1,] <- seqstatf(marr.seq[, 1:5])[, 2] + 0.1
#' emiss_marr[2,] <- seqstatf(marr.seq[, 6:10])[, 2] + 0.1
#' emiss_marr[3,] <- seqstatf(marr.seq[, 11:15])[, 2] + 0.1
#' emiss_marr <- emiss_marr / rowSums(emiss_marr)
#' 
#' emiss_left <- matrix(NA, nrow = 3, ncol = 2)
#' emiss_left[1,] <- seqstatf(left.seq[, 1:5])[, 2] + 0.1
#' emiss_left[2,] <- seqstatf(left.seq[, 6:10])[, 2] + 0.1
#' emiss_left[3,] <- seqstatf(left.seq[, 11:15])[, 2] + 0.1
#' emiss_left <- emiss_left / rowSums(emiss_left)
#' 
#' # Starting values for transition matrix
#' trans <- matrix(c(0.9, 0.07, 0.03,
#'                 0,  0.9,  0.1,
#'                 0,    0,    1), nrow = 3, ncol = 3, byrow = TRUE)
#' 
#' # Starting values for initial state probabilities
#' initial <- c(0.9, 0.09, 0.01)
#' 
#' # Building hidden Markov model with initial parameter values
#' init_hmm_2 <- build_hmm(
#'   observations = list(child.seq, marr.seq, left.seq), 
#'   transition_matrix = trans,
#'   emission_matrix = list(emiss_child, emiss_marr, emiss_left), 
#'   initial_probs = initial)
#' 
#' @seealso \code{\link{fit_hmm}} for fitting Hidden Markov models.

build_hmm<-function(observations,transition_matrix,emission_matrix,initial_probs,
  state_names=NULL, channel_names=NULL){
  
  if (!is.matrix(transition_matrix)) {
    stop(paste("Object provided for transition_matrix is not a matrix."))
  }
  if (!is.vector(initial_probs)) {
    stop(paste("Object provided for initial_probs is not a vector."))
  }
  
  if(dim(transition_matrix)[1]!=dim(transition_matrix)[2])
    stop("transition_matrix must be a square matrix.")
  n_states <- nrow(transition_matrix)
  
  if (is.null(state_names)) {
    if (is.null(state_names <- rownames(transition_matrix))) {
      state_names <- as.character(1:n_states)
    }
  } else {
    if (length(state_names) != n_states) stop("Length of state_names is not equal to the number of hidden states.")
  }
  
  if(!isTRUE(all.equal(rowSums(transition_matrix),rep(1,dim(transition_matrix)[1]),check.attributes=FALSE)))
    stop("Transition probabilities in transition_matrix do not sum to one.")
  
  dimnames(transition_matrix)<-list(from=state_names,to=state_names)
  
  if(is.list(emission_matrix) && length(emission_matrix)==1){
    emission_matrix <- emission_matrix[[1]]   
  }
  if(is.list(observations) && !inherits(observations, "stslist") && length(observations)==1){
    observations <- observations[[1]]
  }
  
  
  
  if(is.list(emission_matrix)){
    if(length(observations)!=length(emission_matrix)){
      stop("Number of channels defined by emission_matrix differs from one defined by observations.")
    }
    n_channels <- length(emission_matrix)
    for (j in 1:n_channels){
      if (!is.matrix(emission_matrix[[j]])) {
        stop(paste("Object provided in emission_matrix for channel", j, "is not a matrix."))
      }
    }
    
    n_sequences<-nrow(observations[[1]])
    length_of_sequences<-ncol(observations[[1]])
    
    symbol_names<-lapply(observations,alphabet)
    n_symbols<-sapply(symbol_names,length)
    
    if(any(sapply(emission_matrix,nrow)!=n_states))
      stop("Number of rows in emission_matrix is not equal to the number of states.")
    if(any(n_symbols!=sapply(emission_matrix,ncol)))
      stop("Number of columns in emission_matrix is not equal to the number of symbols.")
    if(!isTRUE(all.equal(c(sapply(emission_matrix,rowSums)),rep(1,n_channels*n_states),check.attributes=FALSE)))
      stop("Emission probabilities in emission_matrix do not sum to one.")
    
    if(is.null(channel_names)){
      channel_names<-as.character(1:n_channels)
    }else if(length(channel_names)!=n_channels){
      warning("The length of argument channel_names does not match the number of channels. Names were not used.")
      channel_names<-as.character(1:n_channels)
    }
    for(i in 1:n_channels)
      dimnames(emission_matrix[[i]])<-list(state_names=state_names,symbol_names=symbol_names[[i]])
    names(emission_matrix)<-channel_names
  } else {
    n_channels <- 1
    if (!is.matrix(emission_matrix)) {
      stop(paste("Object provided for emission_matrix is not a matrix."))
    }
    if (is.null(channel_names)) {
      channel_names <- "Observations"
    }
    n_sequences<-nrow(observations)
    length_of_sequences<-ncol(observations)
    symbol_names<-alphabet(observations)
    n_symbols<-length(symbol_names)
    
    if(n_states!=dim(emission_matrix)[1])
      stop("Number of rows in emission_matrix is not equal to the number of states.")
    if(n_symbols!=dim(emission_matrix)[2])
      stop("Number of columns in emission_matrix is not equal to the number of symbols.")
    if(!isTRUE(all.equal(rep(1,n_states),rowSums(emission_matrix),check.attributes=FALSE)))
      stop("Emission probabilities in emission_matrix do not sum to one.")
    dimnames(emission_matrix)<-list(state_names=state_names,symbol_names=symbol_names)
    
  }  
  
  names(initial_probs) <- state_names
  
  if(n_channels > 1){
    nobs <- sum(sapply(observations, function(x) sum(!(x == attr(observations[[1]], "nr") |
        x == attr(observations[[1]], "void") |
        is.na(x)))))/n_channels
  } else {
    nobs <- sum(!(observations == attr(observations, "nr") |
        observations == attr(observations, "void") |
        is.na(observations)))
  }
  
  model <- structure(list(observations=observations,transition_matrix=transition_matrix,
    emission_matrix=emission_matrix,initial_probs=initial_probs,
    state_names=state_names,
    symbol_names=symbol_names,channel_names=channel_names,
    length_of_sequences=length_of_sequences,
    n_sequences=n_sequences,
    n_symbols=n_symbols,n_states=n_states,
    n_channels=n_channels), class = "hmm", 
    nobs = nobs,
    df = sum(initial_probs > 0) - 1 + sum(transition_matrix > 0) - n_states + 
      sum(unlist(emission_matrix) > 0) - n_states * n_channels)
  
  model
}
