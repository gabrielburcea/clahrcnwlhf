% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/descriptive_analysis.R
\name{consecutive.diff.time}
\alias{consecutive.diff.time}
\title{consecutive.diff.time}
\usage{
consecutive.diff.time(df, c1, c2, nm = "consec.diff", sc)
}
\arguments{
\item{df}{the dataframe}

\item{c1}{a column name of a POSIXct column}

\item{c2}{a column name of a POSIXct column}

\item{nm}{new column name}

\item{sc}{screening column}
}
\value{
a dataframe which is a copy of df with a new column added, with name
given by the parameter nm. Each entry of this new column is equal to [the
entry in that row of c2] - [the entry in c1 from the row above], except where
a screening column, sc, is TRUE, in which case the new column entry is NA for
that row.
}
\description{
consecutive.diff.time
}

