#' Interactive Stacked Plots of Multichannel Sequences and/or Most Probable 
#' Paths for Mixture Hidden Markov Models
#' 
#' Function \code{mssplot} plots stacked sequence plots of observation sequences 
#' and/or most probable hidden state paths for each model of the \code{mhmm} 
#' object (model chosen according to the most probable path).
#' 
#' 
#' 
#' @export
#' 
#' @param x Mixture hidden Markov model object of class \code{mhmm}.
#'
#' @param ask If true and \code{which.plots} is NULL, \code{plot.mhmm} operates in interactive mode, via \code{\link{menu}}. Defaults to \code{FALSE}.
#' 
#' @param which.plots The number(s) of the requested model as an integer vector. The default \code{NULL} produces all plots.
#'   
#' @param hidden.paths Most probable paths of hidden states, i.e. output from \code{\link{hidden_paths}} function.
#'   
#' @param plots What to plot. One of \code{"obs"} for observations, \code{"hidden.paths"}
#'   for most probable paths, or \code{"both"} for observations 
#'   and most probable paths (the default).
#'   
#' @param type The type of the plot. Available types are \code{"I"} for index 
#'   plots and \code{"d"} for state distribution plots (the default). See 
#'   \code{\link{seqplot}} for details.
#'   
#' @param sortv A sorting variable or a sort method (one of \code{"from.start"},
#'   \code{"from.end"}, \code{"mds.obs"}, or \code{"mds.hidden"}) for 
#'   \code{type == "I"}. The value \code{"mds.hidden"} is only available for 
#'   \code{which = "both"} and \code{which = "hidden.paths"}. Options \code{"mds.obs"} and 
#'   \code{"mds.hidden"} automatically arrange the sequences according to the 
#'   scores of multidimensional scaling (using \code{\link{cmdscale}}) for the 
#'   observed sequences or most probable paths of hidden states from \code{\link{hidden_paths}}. 
#'   MDS scores are computed from distances/dissimilarities using a metric 
#'   defined in argument \code{dist.method}. See \code{\link{plot.stslist}} for 
#'   more details on \code{"from.start"} and \code{"from.end"}.
#'   
#' @param sort.channel The number of the channel according to which the 
#'   \code{"from.start"} or \code{"from.end"} sorting is done. Sorting according
#'   to hidden states is called with value 0. The default value is 1 (the first 
#'   channel).
#'   
#' @param dist.method The metric to be used for computing the distances of the 
#'   sequences if multidimensional scaling is used for sorting. One of "OM" 
#'   (optimal Matching, the default), "LCP" (longest common prefix), "RLCP" 
#'   (reversed LCP, i.e. longest common suffix), "LCS" (longest common 
#'   subsequence), "HAM" (Hamming distance), "DHD" (dynamic Hamming distance). 
#'   Transition rates are used for defining substitution costs if needed. See
#'   \code{\link{seqdef}} for more information on the metrics.
#'   
#' @param with.missing Controls whether missing states are included in state 
#'   distribution plots (\code{type = "d"}). The default is \code{FALSE}.
#'   
#' @param title A vector of titles for the graphics. The default is \code{NA}: if 
#'   \code{title.n = TRUE}, only the number of subjects is plotted. \code{FALSE} 
#'   prints no title, even when \code{title.n = TRUE}.
#'   
#' @param title.n Controls whether the number of subjects is printed in the 
#'   title of the plot. The default is \code{TRUE}: n is plotted if \code{title}
#'   is anything but \code{FALSE}.
#'   
#' @param cex.title Expansion factor for setting the size of the font for the 
#'   title. The default value is 1. Values lesser than 1 will reduce the size of
#'   the font, values greater than 1 will increase the size.
#'   
#' @param title.pos Controls the position of the main title of the plot. The 
#'   default value is 1. Values greater than 1 will place the title higher.
#'   
#' @param withlegend Defines if and where the legend for the states is plotted. 
#'   The default value \code{"auto"} (equivalent to \code{TRUE} and 
#'   \code{right}) creates separate legends for each requested plot and 
#'   positiones them on the right-hand side of the plot. Other possible values 
#'   are \code{"bottom"},
#'   \code{"right.combined"}, and \code{"bottom.combined"}, of which the last 
#'   two create a combined legend in the selected position. Value 
#'   \code{FALSE} prints no legend.
#'   
#' @param ncol.legend (A vector of) the number of columns for the legend(s). The
#'   default \code{"auto"} creates one column for each legend.
#'   
#' @param with.missing.legend If set to \code{"auto"} (the default), a legend 
#'   for the missing state is added automatically if one or more of the 
#'   sequences in the data/channel contains missing states and \code{type = "I"}. 
#'   If \code{type = "d"} missing states are omitted from the legends unless 
#'   \code{with.missing = TRUE}. With the value \code{TRUE} a 
#'   legend for the missing state is added in any case; equivalently 
#'   \code{FALSE} omits the legend for the missing state.
#'   
#' @param legend.prop Sets the proportion of the graphic area used for plotting 
#'   the legend when \code{withlegend} is not \code{FALSE}. The default value is
#'   0.3. Takes values from 0 to 1.
#'   
#' @param cex.legend Expansion factor for setting the size of the font for the 
#'   labels in the legend. The default value is 1. Values lesser than 1 will 
#'   reduce the size of the font, values greater than 1 will increase the size.
#'   
#' @param hidden.states.colors A vector of colors assigned to hidden states (as ordered by 
#'   the \code{\link{hidden_paths}} function). The default value \code{"auto"} uses 
#'   the colors assigned to the \code{stslist} object created with \code{seqdef} if 
#'   \code{hidden.paths} is given; otherwise colors from \code{\link{colorpalette}} are 
#'   automatically used. 
#'   
#' @param hidden.states.labels Labels for the hidden states. The default value 
#'   \code{"auto"} uses the labels of the \code{hidden.paths} argument if given; otherwise the number
#'   of the hidden state.
#'   
#' @param xaxis Controls whether an x-axis is plotted below the plot at the 
#'   bottom. The default value is \code{TRUE}.
#'   
#' @param xlab An optional label for the x-axis. If set to \code{NA}, no label 
#'   is drawn.
#'   
#' @param xtlab Optional labels for the x-axis tick labels.  If unspecified, the
#'   column names of the \code{seqdata} sequence object are used (see 
#'   \code{\link{seqdef}}).
#'   
#' @param xlab.pos Controls the position of the x axis label. The default value 
#'   is 1. Values greater to 1 will place the label further away from the plot.
#'   
#' @param ylab Labels for the channels. A vector of names for each channel 
#'   (observations). The default value \code{"auto"} uses the names provided in 
#'   \code{x$channel_names} if \code{x} is an \code{hmm} object; otherwise the 
#'   names of the list in \code{x} if given, or the
#'   number of the channel if names are not given. \code{FALSE} prints no labels.
#'   
#' @param hidden.states.title Optional label for the hidden state plot (in the 
#'   y-axis). The default is \code{"Hidden states"}.
#'   
#' @param ylab.pos Controls the position of the y axis labels (labels for 
#'   channels and/or hidden states). Either \code{"auto"} or a numerical vector 
#'   indicating on how far away from the plots the titles are positioned. The 
#'   default value \code{"auto"} positions all titles on line 1.
#'   Shorter vectors are recycled.
#'   
#' @param cex.lab Expansion factor for setting the size of the font for the axis
#'   labels. The default value is 1. Values lesser than 1 will reduce the size 
#'   of the font, values greater than 1 will increase the size.
#'   
#' @param cex.axis Expansion factor for setting the size of the font for the 
#'   axis. The default value is 1. Values lesser than 1 will reduce the size of 
#'   the font, values greater than 1 will increase the size.
#'   
#' @param ... Other arguments to be passed to \code{\link{seqplot}} to produce 
#'   the appropriate plot method.
#'   
#' @seealso \code{\link{build_mhmm}} and \code{\link{fit_mhmm}} for building and 
#'   fitting mixture hidden Markov models; and 
#'   \code{\link{mhmm_biofam}} for information on the model used in examples.
#'   
#' @examples 
#' # Loading mixture hidden Markov model (mhmm object)
#' # of the biofam data
#' data(mhmm_biofam)
#' 
#' # Plotting the first cluster only
#' mssplot(mhmm_biofam, which.plots = 1)
#' 
#' \dontrun{
#' # Interactive plot
#' mssplot(mhmm_biofam)
#' }
#' 
#'   
#' @seealso \code{\link{build_mhmm}} and \code{\link{fit_mhmm}} for building and 
#'   fitting mixture hidden Markov models, \code{\link{hidden_paths}} for 
#'   computing the most probable paths (Viterbi paths) of hidden states, and
#'   \code{\link{plot.mhmm}} for plotting \code{mhmm} objects as directed graphs.


mssplot <- function(x, ask = FALSE, which.plots = NULL, hidden.paths = NULL,
                    plots = "both", type = "d", 
                    sortv = NULL, sort.channel = 1, dist.method = "OM",
                    with.missing = FALSE,
                    title = NA, title.n = TRUE, cex.title = 1, title.pos = 1,
                    withlegend = "auto", ncol.legend = "auto", 
                    with.missing.legend = "auto",                         
                    legend.prop = 0.3, cex.legend = 1,
                    hidden.states.colors = "auto", hidden.states.labels = "auto",
                    xaxis = TRUE, xlab = NA, xtlab = NULL, xlab.pos = 1,
                    ylab = "auto", hidden.states.title = "Hidden states", 
                    ylab.pos = "auto", 
                    cex.lab = 1, cex.axis = 1, ...){
  
  # Checking for class of x
  if(!inherits(x, "mhmm")){
    stop("Your object x is not a mhmm object. Use build_mhmm and fit_mhmm to create one.")
  }

    
  oldPar <- par(no.readonly = TRUE)
  on.exit(par(oldPar))
  
  oldWarn <- options("warn")
  options(warn = 1)
  on.exit(options(oldWarn), add = TRUE)
  
  # ssp arguments (besides mhmm object and hidden.paths)
  args <- as.list(match.call())[-(1:2)]
  if("ask" %in% names(args)){
    args <- args[-which(names(args) == "ask")]
  }
  if("which.plots" %in% names(args)){
    args <- args[-which(names(args) == "which.plots")]
  }
  if("hidden.paths" %in% names(args)){
    args <- args[-which(names(args) == "hidden.paths")]
  }
  if(!("title" %in% names(args))){
    titles <- x$cluster_names
  }else{
    if(length(title) != x$n_clusters){
      warning("The length of the vector provided for the title argument does not match the number of clusters. Automatic titles were used instead.")
      titles <- x$cluster_names
    }else{
      titles <- args$title
    }
    args <- args[-which(names(args) == "title")]
  }
  if(length(ylab) == 1 && ylab == "auto"){
    args$ylab <- x$channel_names
  }
  
  if(is.null(hidden.paths)){
    hidden.paths <- suppressWarnings(suppressMessages(hidden_paths(x)))
  }
  
  if(!("hidden.states.labels" %in% names(args))){
    hidden.states.labels <- NULL
    for(i in 1:x$n_clusters){
      hidden.states.labels <- c(hidden.states.labels, paste("State", 1:x$n_states[i]))
    }
  }
  hidden.pathslabs <- list()
  k <- 0
  for(i in 1:x$n_clusters){
    hidden.pathslabs[[i]] <- hidden.states.labels[(k+1):(k+x$n_states[i])]
    k <- k+x$n_states[i]
  }
  
  if(!("hidden.states.colors" %in% names(args))){
    hidden.states.colors <- seqHMM::colorpalette[[length(alphabet(hidden.paths))]]
  }
  hidden.pathscols <- list()
  k <- 0
  for(i in 1:x$n_clusters){
    hidden.pathscols[[i]] <- hidden.states.colors[(k+1):(k+x$n_states[i])]
    k <- k+x$n_states[i]
  }
  
  summ <- summary(x)
  
  hidden.pathsm <- unique(summ$most_probable_cluster)
  mm <- NULL
  if(length(hidden.pathsm)<x$n_clusters){
    mm <- which(!(x$cluster_names%in%hidden.pathsm))
    warning(paste("When computing the most probable paths, no subjects were assigned to following clusters:", paste(x$cluster_names[mm], collapse = ", ")))
  }
  
  if(!is.null(which.plots)){
    if(any(!is.numeric(which.plots)) || any(!(which.plots %in% 1:x$n_clusters))){
      stop(paste0("The which.plot argument only accepts numerical values between 1 and ", x$n_clusters, "."))
    }else if(any(which.plots %in% mm)){
      warning("You requested cluster(s) with no subjects. Plotting only relevant clusters.")
      which.plots <- setdiff(which.plots, mm)
    }
  }else if(!ask && is.null(which.plots)){
    which.plots <- 1:x$n_clusters
    # removing clusters with no subjects (according to hidden.paths)
    which.plots <- setdiff(which.plots, mm)
  }
  
  
  if(x$n_channels == 1){
    x$observations <- list(x$observations)
  }
  if (ask && is.null(which.plots)) {
    tmenu <- 1:x$n_clusters
    tmenu <- setdiff(tmenu, mm)
    tmenunames <- x$cluster_names[tmenu]
    plot.new()
    repeat {
      pick <- menu(tmenunames, title = "\n Select cluster (or 0 to exit):\n")
      if(pick == 0){
        return(invisible())
      }else{
        args$x <- lapply(x$observations, function(y) y[summ$most_probable_cluster == x$cluster_names[tmenu[pick]],])
        args$hidden.states.labels <- hidden.pathslabs[[pick]]
        args$hidden.paths <- suppressWarnings(suppressMessages(
          seqdef(hidden.paths[summ$most_probable_cluster == x$cluster_names[tmenu[pick]],], 
                 labels = args$hidden.states.labels)))
        args$hidden.states.colors <- hidden.pathscols[[pick]]
        args$title <- titles[tmenu[pick]]
        do.call(ssplotM,args = args)
      }
    }
  }else if (ask && !is.null(which.plots)) {
    tmenu <- which.plots
    tmenunames <- x$cluster_names[which.plots]
    plot.new()
    repeat {
      pick <- menu(tmenunames, title = "\n Select cluster (or 0 to exit):\n")
      if(pick == 0){
        return(invisible())
      }else{
        args$x <- lapply(x$observations, function(y) y[summ$most_probable_cluster == x$cluster_names[tmenu[pick]],])
        args$hidden.states.labels <- hidden.pathslabs[[pick]]
        args$hidden.paths <- suppressWarnings(suppressMessages(
          seqdef(hidden.paths[summ$most_probable_cluster == x$cluster_names[tmenu[pick]],], 
                 labels = args$hidden.states.labels)))
        args$hidden.states.colors <- hidden.pathscols[[pick]]
        args$title <- titles[tmenu[pick]]
        do.call(ssplotM,args = args)
      }
    }
  }else{
    ask <- length(which.plots) > 1
    plot.new()
    for (i in which.plots) {
      args$x <- lapply(x$observations, function(y) y[summ$most_probable_cluster == x$cluster_names[i],])
      args$hidden.states.labels <- hidden.pathslabs[[i]]
      args$hidden.paths <- suppressWarnings(suppressMessages(
        seqdef(hidden.paths[summ$most_probable_cluster == x$cluster_names[i],], labels = args$hidden.states.labels)))
      args$hidden.states.colors <- hidden.pathscols[[i]]
      args$title <- titles[i]
      do.call(ssplotM,args = args)
      if (ask) {
        op <- par(ask = TRUE)
      }
    }
    # par(ask = FALSE)
  }
  invisible()
}