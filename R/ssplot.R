#' Stacked Plots of Multichannel Sequences and/or Most Probable 
#' Paths from Hidden Markov Models
#' 
#' Function \code{ssplot} plots stacked sequence plots of sequence object created with the \code{\link{seqdef}} function or observations and/or most probable paths of \code{hmm} objects.
#' 
#' 
#' 
#' @export
#' 
#' @param x Either hidden Markov model object of class \code{hmm} or a 
#'   sequence object created with the \code{\link{seqdef}} function or a list of
#'   sequence objects.
#'   
#'   
#' @param hidden.paths Output from \code{\link{hidden_paths}} function. Optional, if 
#'   \code{x} is a hmm object or if \code{type=="obs"}.
#'   
#' @param plots What to plot. One of \code{"obs"} for observations (the default), 
#'   \code{"hidden.paths"} for most probable paths, or \code{"both"} for observations 
#'   and most probable paths.
#'   
#' @param type The type of the plot. Available types are \code{"I"} for index 
#'   plots and \code{"d"} for state distribution plots (the default). See 
#'   \code{\link{seqplot}} for details.
#'   
#' @param sortv A sorting variable or a sort method (one of \code{"from.start"},
#'   \code{"from.end"}, \code{"mds.obs"}, or \code{"mds.hidden"}) for 
#'   \code{type=="I"}. The value \code{"mds.hidden"} is only available for 
#'   \code{which="both"} and \code{which="hidden.paths"}. Options \code{"mds.obs"} and 
#'   \code{"mds.hidden"} automatically arrange the sequences according to the 
#'   scores of multidimensional scaling (using \code{\link{cmdscale}}) for the 
#'   observed or hidden states path data from \code{\link{hidden_paths}}. 
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
#'   distribution plots (\code{type="d"}). The default is \code{FALSE}.
#'   
#' @param title Title for the graphic. The default is \code{NA}: if 
#'   \code{title.n=TRUE}, only the number of subjects is plotted. \code{FALSE} 
#'   prints no title, even when \code{title.n=TRUE}.
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
#'   sequences in the data/channel contains missing states and \code{type="I"}. 
#'   If \code{type="d"} missing states are omitted from the legends unless 
#'   \code{with.missing=TRUE}. With the value \code{TRUE} a 
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
#' @param hidden.states.colors A vector of colors assigned to hidden states. The default 
#'   value \code{"auto"} uses the colors assigned to the stslist object created 
#'   with \code{seqdef} if \code{hidden.paths} is given; otherwise otherwise colors from 
#'   \code{\link{colorpalette}} are automatically used. 
#'   
#' @param hidden.states.labels Labels for the hidden states. The default value 
#'   \code{"auto"} uses the names provided in \code{x$state_names} if \code{x} is
#'   an hmm object; otherwise the number of the hidden state.
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
#' @examples 
#' \dontrun{
#' 
#' data(biofam3c)
#' 
#' # Creating sequence objects
#' child.seq <- seqdef(biofam3c$children, start = 15)
#' marr.seq <- seqdef(biofam3c$married, start = 15)
#' left.seq <- seqdef(biofam3c$left, start = 15)
#' 
#' ## Choosing colors
#' attr(child.seq, "cpal") <- c("#66C2A5", "#FC8D62")
#' attr(marr.seq, "cpal") <- c("#AB82FF", "#E6AB02", "#E7298A")
#' attr(left.seq, "cpal") <- c("#A6CEE3", "#E31A1C")
#' 
#' 
#' # Plotting state distribution plots of observations
#' ssplot(list(child.seq, marr.seq, left.seq))
#' 
#' # Plotting sequence index plots of observations
#' ssplot(
#'   list(child.seq, marr.seq, left.seq), type = "I", 
#'   # Sorting subjects according to the beginning of the 2nd channel (marr.seq)
#'   sortv = "from.start", sort.channel = 2, 
#'   # Controlling the size, positions, and names for channel labels
#'   ylab.pos = c(1, 2, 1), cex.lab = 1, ylab = c("Children", "Married", "Left home"), 
#'   # Plotting without legend
#'   withlegend = FALSE
#'   )
#' 
#' # Plotting hidden Markov models
#' 
#' # Loading a ready-made HMM for the biofam data
#' data(hmm_biofam)
#' 
#' # Plotting observations and hidden states paths
#' ssplot(
#'   hmm_biofam, type = "I", plots = "both", 
#'   # Sorting according to multidimensional scaling of hidden states paths
#'   sortv = "mds.hidden", 
#'   ylab = c("Children", "Married", "Left home"), 
#'   # Controlling title
#'   title = "Biofam", cex.title = 1.5,
#'   # Labels for x axis and tick marks
#'   xtlab = 15:30, xlab = "Age"
#'   )
#' 
#' # Computing the most probable paths of hidden states
#' hidden.paths <- hidden_paths(hmm_biofam)
#' hidden.paths.seq <- seqdef(
#'   hidden.paths, labels=paste("Hidden state", 1:4)
#'   )
#' 
#' # Plotting observations and hidden state paths
#' ssplot(
#'   hmm_biofam, type = "I", plots = "hidden.paths", 
#'   # Sequence object of most probable paths
#'   hidden.paths = hidden.paths.seq,
#'   # Sorting according to the end of hidden state paths
#'   sortv = "from.end", sort.channel = 0,
#'   # Contolling legend position, type, and proportion
#'   withlegend = "bottom", legend.prop = 0.15,
#'   # Plotting without title and y label
#'   title = FALSE, ylab = FALSE
#'   )
#'   }
#' @seealso \code{\link{ssp}} for creating \code{ssp} objects and \code{\link{plot.ssp}}
#' and \code{\link{gridplot}} for plotting these; 
#' \code{\link{build_hmm}} and \code{\link{fit_hmm}} for building and 
#' fitting hidden Markov models; \code{\link{hidden_paths}} for 
#' computing the most probable paths of hidden states; and \code{\link{biofam3c}}
#' \code{\link{hmm_biofam}} for information on the data and model used in the example.


ssplot <- function(x, hidden.paths=NULL,
                plots="obs", type="d", 
                sortv=NULL, sort.channel=1, dist.method="OM",
                with.missing=FALSE,
                title=NA, title.n=TRUE, cex.title=1, title.pos=1,
                withlegend="auto", ncol.legend="auto", 
                with.missing.legend="auto",                         
                legend.prop=0.3, cex.legend=1,
                hidden.states.colors="auto", hidden.states.labels="auto",
                xaxis=TRUE, xlab=NA, xtlab=NULL, xlab.pos=1,
                ylab="auto", hidden.states.title="Hidden states", 
                ylab.pos="auto", 
                cex.lab=1, cex.axis=1, ...){
  
  sspargs <- do.call(ssp,args=as.list(match.call())[-1])
  plot.new()  
  grid.newpage()
  savepar <- par(no.readonly = TRUE)
  do.call(SSPlotter,args=sspargs)
  par(savepar)
}