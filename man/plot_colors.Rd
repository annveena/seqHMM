% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/plot_colors.R
\name{plot_colors}
\alias{plot_colors}
\title{Plot colorpalettes}
\usage{
plot_colors(x, labels = NULL)
}
\arguments{
\item{x}{A vector of colors.}

\item{labels}{A vector of labels for colors. If omitted, given color names are used.}
}
\description{
Function \code{plot_colors} plots colors and their labels for easy visualization of a colorpalette.
, or if omitted, their
given names (as defined by the user)
}
\examples{
plot_colors(colorpalette[[5]], labels = c("one", "two", "three", "four", "five"))

plot_colors(colorpalette[[10]])

plot_colors(1:7)

plot_colors(c("yellow", "orange", "red", "purple", "blue", "green"))

plot_colors(rainbow(15))
}
\seealso{
See e.g. the \code{\link{colorpalette}} data and \code{RColorBrewer}
package for ready-made color palettes.
}

