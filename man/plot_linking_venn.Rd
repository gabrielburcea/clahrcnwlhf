% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bundle_linking.R
\name{plot_linking_venn}
\alias{plot_linking_venn}
\title{plot_linking_venn}
\usage{
plot_linking_venn(episodes = clahrcnwlhf::emergency_adms, linked_bundles,
  linked_nicor, plot_vd = TRUE)
}
\arguments{
\item{episodes}{dataframe of hospital admissions from data warehouse}

\item{linked_bundles}{output of link_bundles}

\item{linked_nicor}{output of link_nicor}

\item{plot_vd}{logical to indicate whether to actually draw the plot}
}
\value{
venn diagram showing linked data sources
}
\description{
plot_linking_venn
}

