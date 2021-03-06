#' Admission episode data for Northwick Park and Central Middlesex hospitals
#'
#' A dataset containing data on 807,603 episodes of inpatient care at Northwick
#' Park and Central Middlesex hospitals, for all patients discharged between
#' 2012 and 2016.
#'
#' @format A data frame with 807,603 observations of 30 variables. Each
#' observation corresponds to an episode of care.
#' \describe{
#'   \item{PseudoID}{Unique ID number of the patient. Original mapping back to
#'   hospital number remains behind North West London Hospitals NHS firewall}
#'   \item{AgeBand}{The age band that the patient was in at time of admission}
#'   \item{AdmissionDate}{The date of admission for the spell in hospital that
#'   this episode of care is part of}
#'   \item{CSPAdmissionTime}{The time that the patient was admitted}
#'   \item{DischargeDate}{The date of discharge for the spell in hospital that
#'   this episode of care is part of}
#'   \item{CSPDischargeTime}{The time that the patient was discharged from
#'   hospital}
#'   \item{PrimaryDiagnosis}{The primary diagnosis for this episode as an
#'   ICD-10 code}
#'   \item{SecondaryDiagnosis1}{The first secondary diagnosis for this episode,
#'   as an ICD-10 code. Subsequent fields document additional diagnoses,
#'   numbered 2 - 9}
#'   \item{LSOA}{The lower super output area of the patient's home postcode}
#'   \item{Postcode.Sector}{The postcode of the patient's home, up to sector
#'   level}
#'   \item{EthnicGroup}{The ethnicity of the patient recorded using the NHS data
#'   dictionary coding system
#'   \url{http://www.datadictionary.nhs.uk/data_dictionary/attributes/e/end/ethnic_category_code_de.asp}}
#'   \item{Sex}{The gender of the patient}
#'   \item{HRGV4Spell}{The spell level HRG4 code}
#'   \item{EpisodeNumber}{This is the number of the episode within the spell
#'   counting consecutively from the first}
#'   \item{EpisodeStartDate}{The date on which this episode began}
#'   \item{EpisodeStartTime}{The start time of this episode}
#'   \item{EpisodeEndDate}{The date on which this episode ended}
#'   \item{EpisodeEndTime}{The end time of this episode}
#'   \item{AdmissionMethodCode}{The method of admission coded using the NHS data
#'   dictionary coding system
#'   \url{http://www.datadictionary.nhs.uk/data_dictionary/attributes/a/add/admission_method_de.asp}}
#'   \item{AdmissionType}{Mapping of admission level code to the higher level
#'   categories Elective, Emergency, Maternity, Other}
#'   \item{CSPLastWard}{The ward from which the patient was discharged}
#'   \item{TreatmentFunctionCode}{The treatment function code for the episode,
#'   coded using the NHS data dictionary coding system
#'   \url{http://www.datadictionary.nhs.uk/data_dictionary/attributes/t/tran/treatment_function_code_de.asp?shownav=1}}
#'
#'
#'
#' }
"admission_data"
