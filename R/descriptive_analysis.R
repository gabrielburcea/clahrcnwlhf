#' make_emergency_adms_dataset
#'
#' @param adc the cleaned admissions data
#'
#' @return the emergency admissions dataset with additional columns for analysis
#' @export
#'
#'
make_emergency_adms_dataset <- function(adc) {

  # Restrict to only those episodes whose AdmissionType is Emergency
  emergency_adms <- clahrcnwlhf::admission_data_clean[
    which(clahrcnwlhf::admission_data_clean[,"AdmissionType"] == "Emergency"),]

  # Add a column indicating if the episode primary diagnosis is heart failure
  emergency_adms <- clahrcnwlhf::make_diag_flag(emergency_adms,
                                                code_regex="I110|I255|I420|I429|
                                                I500|I501|I509",
                                                new_colname =
                                                  "Heart.Failure.Episode")
  # Add new patient and new spell flag columns
  emergency_adms <- clahrcnwlhf::new.pat(emergency_adms, id = "PseudoID",
                                         adt = "CSPAdmissionTime")
  emergency_adms <- clahrcnwlhf::new_spell(emergency_adms)

  # Return the dataset with the additional columns added
  emergency_adms

}

#' consecutive.diff.time
#'
#' @param df the dataframe
#' @param c1 a column name of a POSIXct column
#' @param c2 a column name of a POSIXct column
#' @param nm new column name
#' @param sc screening column
#'
#' @return a dataframe which is a copy of df with a new column added, with name
#' given by the parameter nm. Each entry of this new column is equal to [the
#' entry in that row of c2] - [the entry in c1 from the row above], except where
#' a screening column, sc, is TRUE, in which case the new column entry is NA for
#' that row.
#'
#' @export
#'
#'
consecutive.diff.time <- function(df,c1,c2,nm = "consec.diff",sc) {

  #This function forms a new column, with name given by the parameter nm,
  #each entry of
  #which is equal to the entry in that row of c2 -
  #the entry in c1 from the row above, except for rows where
  #a screening column, sc, is TRUE, in which case the
  #new column entry is NA for that row.
  #This function assumes that c1 and c2 are POSIXct date times ***TODO:check this assumption***

  #Lag c1 down by 1
  c1l <- c(as.POSIXlt(NA), df[[c1]][1:nrow(df)-1])

  #Subtract the lagged column 1 from column 2
  df[nm] <- difftime(df[[c2]],c1l)

  #Replace entries in the new column with NA for rows
  #in which sc is TRUE and return
  df[df[[sc]]==TRUE,][[nm]] <- NA

  df

}

#' lag.column
#'
#' @param df a dataframe
#' @param c1 name of a column of df
#' @param nm new column name
#' @param backlag direction of lagging
#' @param sc a screening column
#'
#' @return a copy of df with a new column in the dataframe that is equal to c1
#' but shifted either down (backlag = FALSE) or up (backlag = TRUE).
#' Furthermore, if a "screening" column sc is specified, then:
#' For backlag = FALSE, rows that are just above a TRUE in sc are not shifted
#' down - the row with the TRUE in has an NA in the new column (think new
#' patient rows when defining end of last episode)
#' For backlag = TRUE, rows that have a TRUE in sc are not shifted
#' up - the row above the TRUE has an NA in the new column (think new patient
#' rows when defining start of next episode)
#' @export
#'
#'
lag.column <- function(df,c1,nm = "lag.col",backlag = FALSE,sc = NULL) {

  #TODO: Properly annotate this function

  #This function creates a new column in the dataframe that is
  #Equal to c1 but shifted either down (backlag = FALSE) or
  #up (backlag = TRUE). Furthermore, if a "screening" column
  #sc is specified, then:
  #For backlag = FALSE, rows that are just above a TRUE in sc
  #are not shifted down - the row with the TRUE in has an NA
  #in the new column (think new patient rows when defining
  #end of last episode)
  #For backlag = TRUE, rows that have a TRUE in sc are not shifted
  #up - the row above the TRUE has an NA in the new column
  #(think new patient rows when defining start of next episode

  if (backlag == FALSE) {
    df[nm] <- df[c1]
    df[[nm]][2:nrow(df)] <- df[[c1]][1:nrow(df)-1]
    is.na(df[nm])[1] <- TRUE
  } else {
    df[nm] <- df[c1]
    df[[nm]][1:nrow(df)-1] <- df[[c1]][2:nrow(df)]
    is.na(df[nm])[nrow(df)] <- TRUE
  }
  if (!is.null(sc)){
    if(backlag==FALSE){
      df[df[[sc]]==TRUE,][[nm]] <- NA
    } else {
      sc2 <- df[sc]
      sc2[1:nrow(df)-1,] <- df[[sc]][2:nrow(df)]
      sc2[nrow(df),] <- TRUE
      df[sc2==TRUE,][[nm]] <- NA
    }

  }
  df

}

#' new.pat
#'
#' @param df an episode dataframe
#' @param id the column name of the id field
#' @param a.dt the column name of the admission datetime field
#' @param epno the episode number in the spell
#'
#' @return a dataframe which is a copy of df with a new column
#' "new.pat" which is TRUE if the row represents an
#' episode that is the first for that PAT_CODE, and
#' FALSE if the row above represents an episode for
#' the same patient.
#' @export
#'
#'
new.pat <- function(df, id = "PseudoID", adt = "CSPAdmissionTime",
                    epno="EpisodeNumber") {

  #This function sorts the dataframe, first by id
  #then by a.dt, and creates a new column
  #"new.pat" which is TRUE if the row represents an
  #episode that is the first for that PAT_CODE, and
  #FALSE if the row above represents an episode for
  #the same patient.

  df <- df[order(df[,id],df[,adt],df[,epno]),]

  #Do consecutive diff of id with itself and store the
  #result in a new column "new.pat"
  df <- consecutive.diff(df, id, id,"new.pat")

  #Replace this column with TRUE if there is a difference
  #(new patient), and FALSE if there isn't (same patient).
  df$new.pat <- sapply(df$new.pat, function(x) {
    if(is.na(x)||!(x==0)){return(TRUE)}
    else {return(FALSE)}})
  #Return the dataframe
  df
}

#' new_spell
#'
#' @param df an episode dataframe
#' @param id the column name of the id field
#' @param adt the column name of the admission datetime field
#' @param npat the column name of the new patient flag field
#' @param epno the episode number in the spell
#'
#' @return a dataframe which is a copy of df with a new column
#' new_spell which is TRUE if the row represents an
#' episode that is the first for that patient and that admission datetime, and
#' FALSE if the row above represents an episode for
#' the same patient and same admission datetime.
#' @export
#'
new_spell <- function(df, id = "PseudoID", adt = "CSPAdmissionTime",
                      npat = "new.pat", epno="EpisodeNumber") {
  df <- df[order(df[,id],df[,adt],df[,epno]),]
  df <- consecutive.diff.time(df, c1 = adt, c2 = adt, nm = "new_spell",
                              sc = npat)
  df$new_spell <- sapply(df$new_spell, function(x)
    if(is.na(x)||!(x==0)){return(TRUE)}
    else {return(FALSE)})

  df
}

#' make.spellnumber.2
#'
#' @param df episode dataframe
#'
#' @return df with added column for spell number
#' @export
#'
#'
make.spellnumber.2 <- function(df) {

  #This function takes the output of make.newspell
  #and assigns to each episode a spell number and episode order
  #With progress bar

  n <- nrow(df)

  #create 2 columns full of zeros
  df$spell_number <- 0
  df$episode_order <- 0

  #Get column index numbers
  newspell.col <- grep("new_spell",colnames(df))
  spellnumber.col <- grep("spell_number",colnames(df))
  episodeorder.col <- grep("episode_order",colnames(df))

  #Set up progress bar
  pb <- winProgressBar(title="Progress",
                       label="0% done", min=0, max=100, initial=0)



  #Initiate the first spell to be number 1, and the first
  #episode within it to have order 1.
  df[1,spellnumber.col] <- 1
  df[1,episodeorder.col] <- 1

  #loop down incrementing spell.number,
  #resetting to 1 for new spells
  for (i in 2:n) {
    if (df[i,newspell.col]==FALSE) {
      #If this row is not a new spell, copy the
      #spellnumber from the previous row, and
      #increment the episode order by 1
      df[i,spellnumber.col] <- df[(i-1),spellnumber.col]
      df[i,episodeorder.col] <- df[(i-1),episodeorder.col] + 1
    } else {
      #Otherwise, increment the spellnumber and
      #set the episode order to 1
      df[i,spellnumber.col] <- df[(i-1),spellnumber.col] + 1
      df[i,episodeorder.col] <- 1
    }

    #Update progress bar
    info <- sprintf("%d%% done", round((i/n)*100))
    setWinProgressBar(pb, (i/n)*100, label=info)

  }
  #close the progress bar
  close(pb)

  #return the dataframe
  df

}



#' consecutive diff
#'
#' @param df the dataframe
#' @param c1 a column name of a numerical column
#' @param c2 a column name of a numerical column
#' @param nm new column name
#'
#' @return a dataframe which is a copy of df with a new column added, with name
#' given by the parameter nm. Each entry of this new column is equal to [the
#' entry in that row of c2] - [the entry in c1 from the row above]
#' @export
#'
#'
consecutive.diff <- function(df,c1,c2,nm = "consec.diff") {

  #This function forms a new column, "df$nm" each entry of
  #which is equal to the entry in that row of c2 -
  #the entry in c1 from the row above

  #Lag c1 down by 1
  c1l <- c(NA, df[[c1]][1:nrow(df)-1])

  #Subtract the lagged column 1 from column 2 and return
  df[nm] <- df[[c2]] - c1l
  df

}


#' make_diag_flag
#'
#' @param dataframe
#' @param colname
#' @param code_regex
#' @param new_colname
#'
#' @return dataframe with diagnosis flag column added
#' @export
#'
make_diag_flag <- function(dataframe, colname = "PrimaryDiagnosis", code_regex,
                           new_colname = "diag.flag") {

  #This function needs to be modified to accept a vector of codes
  #Could convert to regex within the function?
  #i. This is designated by any of the following ICD-10 codes: I11.0 Hypertensive
  #heart disease with (congestive) heart failure; I25.5 Ischaemic cardiomyopathy;
  #I42.0 Dilated cardiomyopathy; I42.9 Cardiomyopathy, unspecified; I50.0 Congestive
  #heart failure; I50.1 Left ventricular failure; I50.9 Heart failure, unspecified.


  dataframe[,new_colname] <- grepl(code_regex, dataframe[,colname], perl=TRUE)
  dataframe

}



#' disch_time_table
#'
#' Produces a table of number of rows of a dataframe df per time period of the
#' column DischargeDate
#'
#' @param df dataframe in question
#' @param split_by the time period to split by. Defaults to months.
#'
#' @return a vector of row counts for each time period
#' @export
#'
disch_time_table <- function(df, split_by = '%Y-%m') {
  df$splitby <- factor(format(df$DischargeDate, split_by))
  df_splt <- split.data.frame(df, df$splitby)

  m <- sapply(df_splt, nrow)

  m

}