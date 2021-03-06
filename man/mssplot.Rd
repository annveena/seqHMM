% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/mssplot.R
\name{mssplot}
\alias{mssplot}
\title{Interactive Stacked Plots of Multichannel Sequences and/or Most Probable
Paths for Mixture Hidden Markov Models}
\usage{
mssplot(x, ask = FALSE, which.plots = NULL, hidden.paths = NULL,
  plots = "both", type = "d", sortv = NULL, sort.channel = 1,
  dist.method = "OM", with.missing = FALSE, title = NA, title.n = TRUE,
  cex.title = 1, title.pos = 1, withlegend = "auto",
  ncol.legend = "auto", with.missing.legend = "auto", legend.prop = 0.3,
  cex.legend = 1, hidden.states.colors = "auto",
  hidden.states.labels = "auto", xaxis = TRUE, xlab = NA, xtlab = NULL,
  xlab.pos = 1, ylab = "auto", hidden.states.title = "Hidden states",
  ylab.pos = "auto", cex.lab = 1, cex.axis = 1, ...)
}
\arguments{
\item{x}{Mixture hidden Markov model object of class \code{mhmm}.}

\item{ask}{If true and \code{which.plots} is NULL, \code{plot.mhmm} operates in interactive mode, via \code{\link{menu}}. Defaults to \code{FALSE}.}

\item{which.plots}{The number(s) of the requested model as an integer vector. The default \code{NULL} produces all plots.}

\item{hidden.paths}{Most probable paths of hidden states, i.e. output from \code{\link{hidden_paths}} function.}

\item{plots}{What to plot. One of \code{"obs"} for observations, \code{"hidden.paths"}
  for most probable paths, or \code{"both"} for observations
  and most probable paths (the default).}

\item{type}{The type of the plot. Available types are \code{"I"} for index
  plots and \code{"d"} for state distribution plots (the default). See
  \code{\link{seqplot}} for details.}

\item{sortv}{A sorting variable or a sort method (one of \code{"from.start"},
  \code{"from.end"}, \code{"mds.obs"}, or \code{"mds.hidden"}) for
  \code{type == "I"}. The value \code{"mds.hidden"} is only available for
  \code{which = "both"} and \code{which = "hidden.paths"}. Options \code{"mds.obs"} and
  \code{"mds.hidden"} automatically arrange the sequences according to the
  scores of multidimensional scaling (using \code{\link{cmdscale}}) for the
  observed sequences or most probable paths of hidden states from \code{\link{hidden_paths}}.
  MDS scores are computed from distances/dissimilarities using a metric
  defined in argument \code{dist.method}. See \code{\link{plot.stslist}} for
  more details on \code{"from.start"} and \code{"from.end"}.}

\item{sort.channel}{The number of the channel according to which the
  \code{"from.start"} or \code{"from.end"} sorting is done. Sorting according
  to hidden states is called with value 0. The default value is 1 (the first
  channel).}

\item{dist.method}{The metric to be used for computing the distances of the
  sequences if multidimensional scaling is used for sorting. One of "OM"
  (optimal Matching, the default), "LCP" (longest common prefix), "RLCP"
  (reversed LCP, i.e. longest common suffix), "LCS" (longest common
  subsequence), "HAM" (Hamming distance), "DHD" (dynamic Hamming distance).
  Transition rates are used for defining substitution costs if needed. See
  \code{\link{seqdef}} for more information on the metrics.}

\item{with.missing}{Controls whether missing states are included in state
  distribution plots (\code{type = "d"}). The default is \code{FALSE}.}

\item{title}{A vector of titles for the graphics. The default is \code{NA}: if
  \code{title.n = TRUE}, only the number of subjects is plotted. \code{FALSE}
  prints no title, even when \code{title.n = TRUE}.}

\item{title.n}{Controls whether the number of subjects is printed in the
  title of the plot. The default is \code{TRUE}: n is plotted if \code{title}
  is anything but \code{FALSE}.}

\item{cex.title}{Expansion factor for setting the size of the font for the
  title. The default value is 1. Values lesser than 1 will reduce the size of
  the font, values greater than 1 will increase the size.}

\item{title.pos}{Controls the position of the main title of the plot. The
  default value is 1. Values greater than 1 will place the title higher.}

\item{withlegend}{Defines if and where the legend for the states is plotted.
  The default value \code{"auto"} (equivalent to \code{TRUE} and
  \code{right}) creates separate legends for each requested plot and
  positiones them on the right-hand side of the plot. Other possible values
  are \code{"bottom"},
  \code{"right.combined"}, and \code{"bottom.combined"}, of which the last
  two create a combined legend in the selected position. Value
  \code{FALSE} prints no legend.}

\item{ncol.legend}{(A vector of) the number of columns for the legend(s). The
  default \code{"auto"} creates one column for each legend.}

\item{with.missing.legend}{If set to \code{"auto"} (the default), a legend
  for the missing state is added automatically if one or more of the
  sequences in the data/channel contains missing states and \code{type = "I"}.
  If \code{type = "d"} missing states are omitted from the legends unless
  \code{with.missing = TRUE}. With the value \code{TRUE} a
  legend for the missing state is added in any case; equivalently
  \code{FALSE} omits the legend for the missing state.}

\item{legend.prop}{Sets the proportion of the graphic area used for plotting
  the legend when \code{withlegend} is not \code{FALSE}. The default value is
  0.3. Takes values from 0 to 1.}

\item{cex.legend}{Expansion factor for setting the size of the font for the
  labels in the legend. The default value is 1. Values lesser than 1 will
  reduce the size of the font, values greater than 1 will increase the size.}

\item{hidden.states.colors}{A vector of colors assigned to hidden states (as ordered by
  the \code{\link{hidden_paths}} function). The default value \code{"auto"} uses
  the colors assigned to the \code{stslist} object created with \code{seqdef} if
  \code{hidden.paths} is given; otherwise colors from \code{\link{colorpalette}} are
  automatically used.}

\item{hidden.states.labels}{Labels for the hidden states. The default value
  \code{"auto"} uses the labels of the \code{hidden.paths} argument if given; otherwise the number
  of the hidden state.}

\item{xaxis}{Controls whether an x-axis is plotted below the plot at the
  bottom. The default value is \code{TRUE}.}

\item{xlab}{An optional label for the x-axis. If set to \code{NA}, no label
  is drawn.}

\item{xtlab}{Optional labels for the x-axis tick labels.  If unspecified, the
  column names of the \code{seqdata} sequence object are used (see
  \code{\link{seqdef}}).}

\item{xlab.pos}{Controls the position of the x axis label. The default value
  is 1. Values greater to 1 will place the label further away from the plot.}

\item{ylab}{Labels for the channels. A vector of names for each channel
  (observations). The default value \code{"auto"} uses the names provided in
  \code{x$channel_names} if \code{x} is an \code{hmm} object; otherwise the
  names of the list in \code{x} if given, or the
  number of the channel if names are not given. \code{FALSE} prints no labels.}

\item{hidden.states.title}{Optional label for the hidden state plot (in the
  y-axis). The default is \code{"Hidden states"}.}

\item{ylab.pos}{Controls the position of the y axis labels (labels for
  channels and/or hidden states). Either \code{"auto"} or a numerical vector
  indicating on how far away from the plots the titles are positioned. The
  default value \code{"auto"} positions all titles on line 1.
  Shorter vectors are recycled.}

\item{cex.lab}{Expansion factor for setting the size of the font for the axis
  labels. The default value is 1. Values lesser than 1 will reduce the size
  of the font, values greater than 1 will increase the size.}

\item{cex.axis}{Expansion factor for setting the size of the font for the
  axis. The default value is 1. Values lesser than 1 will reduce the size of
  the font, values greater than 1 will increase the size.}

\item{...}{Other arguments to be passed to \code{\link{seqplot}} to produce
  the appropriate plot method.}
}
\description{
Function \code{mssplot} plots stacked sequence plots of observation sequences
and/or most probable hidden state paths for each model of the \code{mhmm}
object (model chosen according to the most probable path).
}
\examples{
# Loading mixture hidden Markov model (mhmm object)
# of the biofam data
data(mhmm_biofam)

# Plotting the first cluster only
mssplot(mhmm_biofam, which.plots = 1)

\dontrun{
# Interactive plot
mssplot(mhmm_biofam)
}
}
\seealso{
\code{\link{build_mhmm}} and \code{\link{fit_mhmm}} for building and
  fitting mixture hidden Markov models; and
  \code{\link{mhmm_biofam}} for information on the model used in examples.

\code{\link{build_mhmm}} and \code{\link{fit_mhmm}} for building and
  fitting mixture hidden Markov models, \code{\link{hidden_paths}} for
  computing the most probable paths (Viterbi paths) of hidden states, and
  \code{\link{plot.mhmm}} for plotting \code{mhmm} objects as directed graphs.
}

