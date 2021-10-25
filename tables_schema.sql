-- Category: Epidemic 

-- Create a new table called 'epidemic_casesMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_casesMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
    cases_new INT COMMENT "Cases reported in the 24h since the last report",
    cases_import INT COMMENT "Imported cases reported in the 24h since the last report",
    cases_recovered INT COMMENT "Recovered cases reported in the 24h since the last report",
    cases_active INT COMMENT "Covid+ individuals who have not recovered or died",
    cases_cluster INT COMMENT "Number of cases attributable to clusters; The difference between cases_new and the sum of cases attributable to clusters is the number of sporadic cases",
    cases_pvax INT COMMENT "Number of partially-vaccinated individuals who tested positive for Covid (perfect subset of cases_new), where 'partially vaccinated' is defined as receiving at least 1 dose of a 2-dose vaccine at least 1 day prior to testing positive, or receiving the Cansino vaccine between 1-27 days before testing positive",
    cases_fvax INT COMMENT "Number of fully-vaccinated who tested positive for Covid (perfect subset of cases_new), where 'fully vaccinated' is defined as receiving the 2nd dose of a 2-dose vaccine at least 14 days prior to testing positive, or receiving the Cansino vaccine at least 28 days before testing positive",
    cases_child INT COMMENT "Number of new cases of individuals from the age of 0-11 in the 24h since the last report",
    cases_adolescent INT COMMENT "Number of new cases of individuals from the age of 12-17 in the 24h since the last report",
    cases_adult INT COMMENT "Number of new cases of individuals from the age of 18-59 in the 24h since the last report",
    cases_elderly INT COMMENT "Number of new cases of individuals from the age of 60 onwards in the last 24h since the last report",
    cluster_import INT COMMENT "Number of clusters from imported clusters",
    cluster_religious INT COMMENT "Number of clusters from religious activities",
    cluster_community INT COMMENT "Number of clusters from coummnity activities",
    cluster_highRisk INT COMMENT "Number of clusters from high risk areas",
    cluster_education INT COMMENT "Number of clusters originating from education related activities and locations",
    cluster_dententionCenter INT COMMENT "Number of clusters originating from dententions centers",
    cluster_workplace INT COMMENT "Number of clusters originating from workplaces"
);

-- Create a new table called 'epidemic_casesState' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_casesState (
    date DATE COMMENT 'Date of the record',
    state NVARCHAR(50) COMMENT 'Name of state',
    cases_new INT COMMENT 'Cases reported in the 24h since the last report',
    cases_import INT COMMENT 'Imported cases reported in the 24h since the last report',
    cases_recovered INT COMMENT 'Recovered cases reported in the 24h since the last report',
    cases_active INT COMMENT 'Covid+ individuals who have not recovered or died',
    cases_cluster INT COMMENT 'Number of cases attributable to clusters; The difference between cases_new and the sum of cases attributable to clusters is the number of sporadic cases',
    cases_pvax INT COMMENT 'Number of partially-vaccinated individuals who tested positive for Covid (perfect subset of cases_new), where "partially vaccinated" is defined as receiving at least 1 dose of a 2-dose vaccine at least 1 day prior to testing positive, or receiving the Cansino vaccine between 1-27 days before testing positive',
    cases_fvax INT COMMENT 'Number of fully-vaccinated who tested positive for Covid (perfect subset of cases_new), where "fully vaccinated" is defined as receiving the 2nd dose of a 2-dose vaccine at least 14 days prior to testing positive, or receiving the Cansino vaccine at least 28 days before testing positive',
    cases_child INT COMMENT 'Number of new cases of individuals from the age of 0-11 in the 24h since the last report',
    cases_adolescent INT COMMENT 'Number of new cases of individuals from the age of 12-17 in the 24h since the last report',
    cases_adult INT COMMENT 'Number of new cases of individuals from the age of 18-59 in the 24h since the last report',
    cases_elderly INT COMMENT 'Number of new cases of individuals from the age of 60 onwards in the last 24h since the last report',
    PRIMARY KEY (date, state)
);

-- Create a new table called 'epidemic_clusters' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_clusters (
    cluster NVARCHAR(100) NOT NULL PRIMARY KEY COMMENT "Unique textual identifier of cluster | serves as the primary key for current table",
    state NVARCHAR(50) COMMENT "Geographical epicentre of cluster",
    district NVARCHAR(590) COMMENT "If localised, inter-district and inter-state clusters are possible and present in the dataset",
    date_announced DATE COMMENT "Date of declaration as cluster",
    date_last_onset DATE COMMENT "Most recent date of onset of symptoms for individuals within the cluster. note that this is distinct from the date on which said individual was tested, and the date on which their test result was received; consequently, today's date may not necessarily be present in this column.",
    category NVARCHAR(50) COMMENT "Classification of cluster. possible values are [import, religious, community, highRisk, education, detentionCentre, workplace]",
    status NVARCHAR(50) COMMENT "active or ended",
    cases_new INT COMMENT "Number of new cases detected within cluster in the 24h since the last report",
    cases_total INT COMMENT "Total number of cases traced to cluster",
    cases_active INT COMMENT "Active cases within cluster",
    tests INT COMMENT " Number of tests carried out on individuals within the cluster; denominator for computing a cluster's current positivity rate",
    icu INT COMMENT "Number of individuals within the cluster currently under intensive care",
    deaths INT COMMENT "Number of individuals within the cluster who passed away due to COVID-19",
    recovered INT COMMENT "Number of individuals within the cluster who tested positive for and subsequently recovered from COVID-19"
);

-- Create a new table called 'epidemic_deathsMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_deathsMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary skey for current table",
    deaths_new INT COMMENT "Deaths due to COVID-19 based on date reported to public",
    deaths_bid INT COMMENT "Deaths due to COVID-19 which were brought-in dead based on date reported to public (perfect subset of deaths_new)",
    deaths_new_dod INT COMMENT "Deaths due to COVID-19 based on date of death",
    deaths_bid_dod INT COMMENT "Deaths due to COVID-19 which were brought-in dead based on date of death (perfect subset of deaths_new_dod)",
    deaths_pvax INT COMMENT "Number of partially-vaccinated individuals who died due to COVID-19 based on date of death (perfect subset of deaths_new_dod), where 'partially vaccinated' is defined as receiving at least 1 dose of a 2-dose vaccine at least 1 day prior to testing positive, or receiving the Cansino vaccine between 1-27 days before testing positive.",
    deaths_fvax INT COMMENT "Number of fully-vaccinated who died due to COVID-19 based on date of death (perfect subset of deaths_new_dod), where 'fully vaccinated' is defined as receiving the 2nd dose of a 2-dose vaccine at least 14 days prior to testing positive, or receiving the Cansino vaccine at least 28 days before testing positive.",
    deaths_tat INT COMMENT "Median days between date of death and date of report for all deaths reported on the day"
);

-- Creates a new table called 'epidemic_deathsState' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_deathsState (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "", 
    deaths_new INT COMMENT "Deaths due to COVID-19 based on date reported to public",
    deaths_bid INT COMMENT "Deaths due to COVID-19 which were brought-in dead based on date reported to public (perfect subset of deaths_new)",
    deaths_new_dod INT COMMENT "Deaths due to COVID-19 based on date of death",
    deaths_bid_dod INT COMMENT "Deaths due to COVID-19 which were brought-in dead based on date of death (perfect subset of deaths_new_dod)",
    deaths_pvax INT COMMENT "Number of partially-vaccinated individuals who died due to COVID-19 based on date of death (perfect subset of deaths_new_dod), where 'partially vaccinated' is defined as receiving at least 1 dose of a 2-dose vaccine at least 1 day prior to testing positive, or receiving the Cansino vaccine between 1-27 days before testing positive.",
    deaths_fvax INT COMMENT "Number of fully-vaccinated who died due to COVID-19 based on date of death (perfect subset of deaths_new_dod), where 'fully vaccinated' is defined as receiving the 2nd dose of a 2-dose vaccine at least 14 days prior to testing positive, or receiving the Cansino vaccine at least 28 days before testing positive.",
    deaths_tat INT COMMENT "Median days between date of death and date of report for all deaths reported on the day",
    PRIMARY KEY (date, state)
);

-- Creates a new table called 'epidemic_hospital' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_hospital (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state, with similar qualification on exhaustiveness of date-state combos as PKRC data",
    beds INT COMMENT "Total hospital beds (with related medical infrastructure)",
    beds_covid INT COMMENT "Total beds dedicated for COVID-19",
    beds_noncrit INT COMMENT "Total hospital beds for non-critical care",
    admitted_pui INT COMMENT "Number of individuals admitted that are suspected to have COVID-19",
    admitted_covid INT COMMENT "Number of individual admitted that are COVID-19 positive",
    admitted_total INT COMMENT "Total number of individual admitted",
    discharged_pui INT COMMENT "Number of individuals that have been discharged that are suspected to have COVID-19",
    discharged_covid INT COMMENT "Number of individuals that have been discharged that are COVID-19 positive",
    discharged_total INT COMMENT "Total number of individuals that have been discharged",
    hosp_covid INT COMMENT "Number of individuals that are in hospitals for COVID-19",
    hosp_pui INT COMMENT "Number of individuals that are in hospitals for suspected COVID-19",
    hosp_noncovid INT COMMENT "Number of individuals that are in hospitals not for COVID-19",
    PRIMARY KEY (date, state)
);

-- Creates a new table called 'epidemic_icu' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_icu (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state, with similar qualification on exhaustiveness of date-state combos as PKRC data",
    beds_icu INT COMMENT "Total gazetted ICU beds",
    beds_icu_rep INT COMMENT "Total beds aside from (3) which are temporarily or permanently designated to be under the care of Anaesthesiology & Critical Care departments",
    beds_icu_total INT COMMENT "Total critical care beds available (with related medical infrastructure)",
    beds_icu_covid INT COMMENT "Total critical care beds dedicated for COVID-19",
    vent INT COMMENT "Total available ventilators",
    vent_port INT COMMENT "Total available portable ventilators",
    icu_covid INT COMMENT "Number of individuals in ICU due to COVID-19",
    icu_pui INT COMMENT "Number of individuals in ICU that are suspected of COVID-19",
    icu_noncovid INT COMMENT "Number of individuals in ICU not due to COVID-19",
    vent_covid INT COMMENT "Number of individuals on mechanical ventilation due to COVID-19",
    vent_pui INT COMMENT "Number of individuals on mechanical ventilation that are suspected of COVID-19",
    vent_noncovid INT COMMENT "Number of individuals on mechanical ventilation not due to COVID-19",
    vent_used INT COMMENT "Number of ventilators that are in use",
    vent_port_used INT COMMENT "Number of portable ventilators that are in use",
    PRIMARY KEY (date, state)
);

-- Creates a new table called 'epidemic_pkrc' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_pkrc (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state; note that (unlike with other datasets), it is not necessary that there be an observation for every state on every date. for instance, there are no PKRCs in W.P. Kuala Lumpur and W.P Putrajaya.",
    beds INT COMMENT "Total PKRC beds (with related medical infrastructure)",
    admitted_pui INT COMMENT "Number of individuals that are admitted that are suspected of COVID-19",
    admitted_covid INT COMMENT "Number of individuals that are admitted due to COVID-19",
    admitted_total INT COMMENT "Total number of indivduals admitted",
    discharge_pui INT COMMENT "Number of individuals discharged that are suspected of COVID-19",
    discharge_covid INT COMMENT "Number of individuals discharged due to COVID-19",
    discharge_total INT COMMENT "Total number of individuals discharged",
    pkrc_covid INT COMMENT "Number of individuals that are in PKRC due to COVID-19",
    pkrc_pui INT COMMENT "Number of individuals that are in PKRC that are suspected of COVID-19",
    pkrc_noncovid INT COMMENT "umber of individuals not due to COVID-19",
    PRIMARY KEY (date, state)
);

-- Creates a new table called 'epidemic_testsMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_testsMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
    rtk_ag INT COMMENT "Number of tests done using Antigen Rapid Test Kits (RTK-Ag)",
    pcr INT COMMENT "Number of tests done using Real-time Reverse Transcription Polymerase Chain Reaction (RT-PCR) technology"
);

-- Creates a new table called 'epidemic_testsStates' in schema 'covidMY'
CREATE TABLE covidMY.epidemic_testsStates (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state",
    rtk_ag INT COMMENT "Number of tests done using Antigen Rapid Test Kits (RTK-Ag)",
    pcr INT COMMENT "Number of tests done using Real-time Reverse Transcription Polymerase Chain Reaction (RT-PCR) technology",
    PRIMARY KEY (date, state)
);


-- Subcategory: Linelist


-- Creates a new table called 'linelist_cases' in schema 'covidMY'
CREATE TABLE covidMY.linelist_cases (
    date DATE COMMENT "Date of the record",
    days_dose1 INT COMMENT "Number of days between the positive sample date and the individual's first dose (if any); values 0 or less are nulled",
    days_dose2 INT COMMENT "Number of days between the positive sample date and the individual's second dose (if any); values 0 or less are nulled",
    vaxtype NVARCHAR(100) COMMENT "Type of vaccine",
    import BOOLEAN COMMENT "True if imported case",
    cluster BOOLEAN COMMENT "True if part of cluster",
    symptomatic BOOLEAN COMMENT "True if symptomatic",
    state INT COMMENT "State of residence",
    district INT COMMENT "District of residence",
    age INT COMMENT "Age",
    male BOOLEAN COMMENT "Gender",
    malaysian BOOLEAN COMMENT "True if Malaysian",
    PRIMARY KEY (date, days_dose1, days_dose2, vaxtype, import, cluster, symptomatic, state, district, age, male, malaysian)
);

-- Creates a new table called 'linelist_deaths' in schema 'covidMY'
CREATE TABLE covidMY.linelist_deaths (
    date DATE COMMENT "Date of the record",
    date_announced DATE COMMENT "Date the death was annouced",
    date_positive DATE COMMENT "Date the individual was tested positive",
    date_dose1 DATE COMMENT "Date of first dose",
    date_dose2 DATE COMMENT "Date of second dose",
    vaxtype NVARCHAR(100) COMMENT "Type of vaccine",
    state NVARCHAR(50) COMMENT "State name",
    age INT COMMENT "Age of deceased",
    male BOOLEAN COMMENT "Gender",
    bid BOOLEAN COMMENT "True if brought in dead",
    malaysian BOOLEAN COMMENT "True if Malaysian",
    comorb BOOLEAN COMMENT "True if individual had comorbidities",
    PRIMARY KEY (date, date_announced, date_positive, date_dose1, date_dose2, vaxtype, state, age, male, bid, malaysian, comorb)
);

-- Creates a new table called 'linelist_paramGeo' in schema 'covidMY'
CREATE TABLE covidMY.linelist_paramGeo (
    state NVARCHAR(50) COMMENT "State name",
    district NVARCHAR(100) COMMENT "District name",
    idxs INT COMMENT "State ID",
    idxd INT COMMENT "District ID (-1 equals to state)",
    PRIMARY KEY (idxs, idxd)
);


-- Category: MySejahtera


-- Creates a new table called 'mysejahtera_checkinMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.mysejahtera_checkinMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
    checkins INT COMMENT "Total number of checkins",
    unique_ind INT COMMENT "Number of unique accounts that checked in",
    unique_loc INT COMMENT "Number of unique premises checked into"
);

-- Creates a new table called 'mysejahtera_checkinMalaysiaTime' in schema 'covidMY'
CREATE TABLE covidMY.mysejahtera_checkinMalaysiaTime (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
    period_0 INT COMMENT "00:00 - 00:29",
    period_1 INT COMMENT "00:30 - 00:59",
    period_2 INT COMMENT "01:00 - 01:29",
    period_3 INT COMMENT "01:30 - 01:59",
    period_4 INT COMMENT "02:00 - 02:29",
    period_5 INT COMMENT "02:30 - 02:59",
    period_6 INT COMMENT "03:00 - 03:29",
    period_7 INT COMMENT "03:30 - 03:59",
    period_8 INT COMMENT "04:00 - 04:29",
    period_9 INT COMMENT "04:30 - 04:59",
    period_10 INT COMMENT "05:00 - 05:29",
    period_11 INT COMMENT "05:30 - 05:59",
    period_12 INT COMMENT "06:00 - 06:29",
    period_13 INT COMMENT "06:30 - 06:59",
    period_14 INT COMMENT "07:00 - 07:29",
    period_15 INT COMMENT "07:30 - 07:59",
    period_16 INT COMMENT "08:00 - 08:29",
    period_17 INT COMMENT "08:30 - 08:59",
    period_18 INT COMMENT "09:00 - 09:29",
    period_19 INT COMMENT "09:30 - 09:59",
    period_20 INT COMMENT "10:00 - 10:29",
    period_21 INT COMMENT "10:30 - 10:59",
    period_22 INT COMMENT "11:00 - 11:29",
    period_23 INT COMMENT "11:30 - 11:59",
    period_24 INT COMMENT "12:00 - 12:29",
    period_25 INT COMMENT "12:30 - 12:59",
    period_26 INT COMMENT "13:00 - 13:29",
    period_27 INT COMMENT "13:30 - 13:59",
    period_28 INT COMMENT "14:00 - 14:29",
    period_29 INT COMMENT "14:30 - 14:59",
    period_30 INT COMMENT "15:00 - 15:29",
    period_31 INT COMMENT "15:30 - 15:59",
    period_32 INT COMMENT "16:00 - 16:29",
    period_33 INT COMMENT "16:30 - 16:59",
    period_34 INT COMMENT "17:00 - 17:29",
    period_35 INT COMMENT "17:30 - 17:59",
    period_36 INT COMMENT "18:00 - 18:29",
    period_37 INT COMMENT "18:30 - 18:59",
    period_38 INT COMMENT "19:00 - 19:29",
    period_39 INT COMMENT "19:30 - 19:59",
    period_40 INT COMMENT "20:00 - 20:29",
    period_41 INT COMMENT "20:30 - 20:59",
    period_42 INT COMMENT "21:00 - 21:29",
    period_43 INT COMMENT "21:30 - 21:59",
    period_44 INT COMMENT "22:00 - 22:29",
    period_45 INT COMMENT "22:30 - 22:59",
    period_46 INT COMMENT "23:00 - 23:29",
    period_47 INT COMMENT "23:30 - 23:59"
);

-- Creates a new table called 'mysejahtera_checkinState' in schema 'covidMY'
CREATE TABLE covidMY.mysejahtera_checkinState (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state",
    checkins INT COMMENT "Total number of checkins",
    unique_ind INT COMMENT "Number of unique accounts that checked in",
    unique_loc INT COMMENT "Number of unique premises checked into",
    PRIMARY KEY (date, state)
);

-- Creates a new table called 'mysejahtera_traceMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.mysejahtera_traceMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
    casual_contacts INT COMMENT "Number of casual contacts identified and notified by CPRC's automated contact tracing system",
    hide_large INT COMMENT "Number of large hotspots identified by CPRC's hotspot identification system",
    hide_small INT COMMENT "Number of small hotspots identified by CPRC's hotspot identification system"
);


-- Category: Vaccination // Will be inserted from another repository


-- Creates a new table called 'vaccination_aefi' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_aefi (
    date DATE COMMENT "Date of the record",
    vaxtype NVARCHAR(50) COMMENT "Vaccination Type",
    daily_total INT,
    daily_serious_npra INT,
    daily_nonserious INT,
    daily_nonserious_npra INT,
    daily_nonserious_mysj_dose1 INT,
    daily_nonserious_mysj_dose2 INT,
    d1_site_pain INT,
    d1_site_swelling INT,
    d1_site_redness INT,
    d1_tiredness INT,
    d1_headache INT,
    d1_muscle_pain INT,
    d1_joint_pain INT,
    d1_weakness INT,
    d1_fever INT,
    d1_vomiting INT,
    d1_chills INT,
    d1_rash INT,
    d2_site_pain INT,
    d2_site_swelling INT,
    d2_site_redness INT,
    d2_tiredness INT,
    d2_headache INT,
    d2_muscle_pain INT,
    d2_joint_pain INT,
    d2_weakness INT,
    d2_fever INT,
    d2_vomiting INT,
    d2_chills INT,
    d2_rash INT,
    PRIMARY KEY (date,vaxtype,daily_total,daily_serious_npra,daily_nonserious,daily_nonserious_npra,daily_nonserious_mysj_dose1,daily_nonserious_mysj_dose2,d1_site_pain,d1_site_swelling,d1_site_redness,d1_tiredness,d1_headache,d1_muscle_pain,d1_joint_pain,d1_weakness,d1_fever,d1_vomiting,d1_chills,d1_rash,d2_site_pain,d2_site_swelling,d2_site_redness,d2_tiredness,d2_headache,d2_muscle_pain,d2_joint_pain,d2_weakness,d2_fever,d2_vomiting,d2_chills,d2_rash)
);

-- Creates a new table called 'vaccination_aefiSerious' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_aefiSerious (
    date DATE COMMENT "Date of the record",
    vaxtype NVARCHAR(50) COMMENT "Vaccination Type",
    suspected_anaphylaxis INT,
    acute_facial_paralysis INT,
    venous_thromboembolism INT,
    myo_pericarditis INT,
    PRIMARY KEY (date, vaxtype, suspected_anaphylaxis, acute_facial_paralysis, venous_thromboembolism, myo_pericarditis)
);

-- Creates a new table called 'vaccination_vaxSchool' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_vaxSchool (
    code NVARCHAR(20) PRIMARY KEY COMMENT "ID of school",
    school NVARCHAR(100),
    state INT,
    district INT,
    postcode INT,
    lat FLOAT,
    lon FLOAT,
    dose1_staff FLOAT,
    dose2_staff FLOAT,
    dose1_student FLOAT,
    dose2_student FLOAT,
    dose1_12 FLOAT,
    dose1_13 FLOAT,
    dose1_14 FLOAT,
    dose1_15 FLOAT,
    dose1_16 FLOAT,
    dose1_17 FLOAT,
    dose1_18 FLOAT,
    dose2_12 FLOAT,
    dose2_13 FLOAT,
    dose2_14 FLOAT,
    dose2_15 FLOAT,
    dose2_16 FLOAT,
    dose2_17 FLOAT,
    dose2_18 FLOAT
);

-- Creates a new table called 'vaccination_vaxMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_vaxMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
	daily_partial INT COMMENT "1st doses (for double-dose vaccines) delivered between 0000 and 2359 on date",
    daily_full INT COMMENT "2nd doses (for single-dose vaccines) and 1-dose vaccines (e.g. Cansino) delivered between 0000 and 2359 on date.",
    daily_booster INT COMMENT "Booster/third doses delivered between 0000 and 2359 on date.",
    daily INT COMMENT "daily_partial + daily_full + daily_booster",
    daily_partial_child INT,
    daily_full_child INT,
    cumul_partial INT COMMENT "sum of daily_partial + cansino for all T <= date, i.e. number of people with at least 1 dose",
    cumul_full INT COMMENT "sum of daily_full for all T <= date, i.e. number of people who have completed their vaccination regimen",
    cumul_booster INT COMMENT "sum of daily_booster for all T <= date, i.e. number of people who have received a booster",
    cumul INT COMMENT "cumul_partial + cumul_full + cumul_booster - cumulative cansino doses to date, i.e. total doses administered",
    cumul_partial_child INT COMMENT "number of children (< 18yo) who have received their 1st dose (thus far, only Pfizer is used)",
    cumul_full_child INT COMMENT "number of children (< 18yo) who have received their 2nd dose (thus far, only Pfizer is used)",
    pfizer1 INT COMMENT "1st doses of double-dose vaccine type Pfizer delivered between 0000 and 2359 on date",
    pfizer2 INT COMMENT "2nd doses of double-dose vaccine type Pfizer delivered between 0000 and 2359 on date",
    sinovac1 INT COMMENT "1st doses of double-dose vaccine type Sinovac delivered between 0000 and 2359 on date",
    sinovac2 INT COMMENT "2nd doses of double-dose vaccine type Sinovac delivered between 0000 and 2359 on date",
    astra1 INT COMMENT "1st doses of double-dose vaccine type Astrazeneca delivered between 0000 and 2359 on date",
    astra2 INT COMMENT "2nd doses of double-dose vaccine type Astrazeneca delivered between 0000 and 2359 on date",
    cansino INT COMMENT "Doses of single-dose vaccine type CanSino delivered between 0000 and 2359 on date",
    pending INT COMMENT "Doses delivered that are 'quarantined' in the Vaccine Management System due to errors and/or inconsistencies in vaccine bar code, batch number, et cetera"
);

-- Creates a new table called 'vaccination_vaxStates' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_vaxStates (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state",
	daily_partial INT COMMENT "1st doses (for double-dose vaccines) delivered between 0000 and 2359 on date",
    daily_full INT COMMENT "2nd doses (for single-dose vaccines) and 1-dose vaccines (e.g. Cansino) delivered between 0000 and 2359 on date.",
    daily_booster INT COMMENT "Booster/third doses delivered between 0000 and 2359 on date.",
    daily INT COMMENT "daily_partial + daily_full + daily_booster",
    daily_partial_child INT,
    daily_full_child INT,
    cumul_partial INT COMMENT "sum of daily_partial + cansino for all T <= date, i.e. number of people with at least 1 dose",
    cumul_full INT COMMENT "sum of daily_full for all T <= date, i.e. number of people who have completed their vaccination regimen",
    cumul_booster INT COMMENT "sum of daily_booster for all T <= date, i.e. number of people who have received a booster",
    cumul INT COMMENT "cumul_partial + cumul_full + cumul_booster - cumulative cansino doses to date, i.e. total doses administered",
    cumul_partial_child INT COMMENT "number of children (< 18yo) who have received their 1st dose (thus far, only Pfizer is used)",
    cumul_full_child INT COMMENT "number of children (< 18yo) who have received their 2nd dose (thus far, only Pfizer is used)",
    pfizer1 INT COMMENT "1st doses of double-dose vaccine type Pfizer delivered between 0000 and 2359 on date",
    pfizer2 INT COMMENT "2nd doses of double-dose vaccine type Pfizer delivered between 0000 and 2359 on date",
    sinovac1 INT COMMENT "1st doses of double-dose vaccine type Sinovac delivered between 0000 and 2359 on date",
    sinovac2 INT COMMENT "2nd doses of double-dose vaccine type Sinovac delivered between 0000 and 2359 on date",
    astra1 INT COMMENT "1st doses of double-dose vaccine type Astrazeneca delivered between 0000 and 2359 on date",
    astra2 INT COMMENT "2nd doses of double-dose vaccine type Astrazeneca delivered between 0000 and 2359 on date",
    cansino INT COMMENT "Doses of single-dose vaccine type CanSino delivered between 0000 and 2359 on date",
    pending INT COMMENT "Doses delivered that are 'quarantined' in the Vaccine Management System due to errors and/or inconsistencies in vaccine bar code, batch number, et cetera",
    PRIMARY KEY (date, state)
);

-- Creates a new table called 'vaccination_vaxRegMalaysia' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_vaxRegMalaysia (
    date DATE NOT NULL PRIMARY KEY COMMENT "Date of the record | serves as the primary key for current table",
    total INT COMMENT "Number of unique registrants, with de-duplication done based on ID",
    phase2 INT COMMENT "Number of unique individuals eligible for Phase 2, i.e. individuals who are at least 1 of elderly, comorb, oku (note: not the sum of the 3)",
    mysj INT COMMENT "Number of individuals registered via MySejahtera",
    call_cen INT COMMENT "Number of individuals registered via the call centre, who do not have an existing registration via MySejahtera",
    web INT COMMENT "Number of individuals registered via the website (including on-behalf-of registrations done during outreach) who do not have an existing registration via MySejahtera or the call centre",
    children INT COMMENT "Number of individuals below 18yo",
    elderly INT COMMENT "Number of individuals aged 60yo and above",
    comorb INT COMMENT "Number of individuals self-declaring at least 1 comorbidity",
    oku INT COMMENT "Number of individuals self-declaring as OKU"
);

-- Creates a new table called 'vaccination_vaxRegStates' in schema 'covidMY'
CREATE TABLE covidMY.vaccination_vaxRegStates (
    date DATE COMMENT "Date of the record",
    state NVARCHAR(50) COMMENT "Name of state",
    total INT COMMENT "Number of unique registrants, with de-duplication done based on ID",
    phase2 INT COMMENT "Number of unique individuals eligible for Phase 2, i.e. individuals who are at least 1 of elderly, comorb, oku (note: not the sum of the 3)",
    mysj INT COMMENT "Number of individuals registered via MySejahtera",
    call_cen INT COMMENT "Number of individuals registered via the call centre, who do not have an existing registration via MySejahtera",
    web INT COMMENT "Number of individuals registered via the website (including on-behalf-of registrations done during outreach) who do not have an existing registration via MySejahtera or the call centre",
    children INT COMMENT "Number of individuals below 18yo",
    elderly INT COMMENT "Number of individuals aged 60yo and above",
    comorb INT COMMENT "Number of individuals self-declaring at least 1 comorbidity",
    oku INT COMMENT "Number of individuals self-declaring as OKU",
    PRIMARY KEY (date, state)
);



-- Category: Population
-- This category has only one static table that contains the data of Malaysia's population

-- Creates a new table called 'population' in schema 'covidMY'
CREATE TABLE covidMY.population (
    idxs INT NOT NULL PRIMARY KEY COMMENT "ID for state | serves as the primary key for current table",
    state NVARCHAR(50) COMMENT "Name of state",
    pop INT COMMENT "Total population of state",
    pop_12 INT COMMENT "Total population from 0-12 in state",
    pop_18 INT COMMENT "Total population from 18-60 in state",
    pop_60 INT COMMENT "Total population above the age of 60 in state"
);
