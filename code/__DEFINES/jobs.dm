#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_SLOTFULL 5
/// Job unavailable due to incompatibility with an antag role.
#define JOB_UNAVAILABLE_ANTAG_INCOMPAT 6
/// Checks for character age.
#define JOB_UNAVAILABLE_AGE 7

/// Used when the `get_job_unavailable_error_message` proc can't make sense of a given code.
#define GENERIC_JOB_UNAVAILABLE_ERROR "Error: Unknown job availability."

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"
#define DEFAULT_BIBLE "Default Bible Name"
#define DEFAULT_BIBLE_REPLACE(religion) "The Holy Book of [religion]"

#define JOB_DISPLAY_ORDER_DEFAULT 0

// Keys for jobconfig.toml
#define JOB_CONFIG_PLAYTIME_REQUIREMENTS "Playtime Requirements"
#define JOB_CONFIG_REQUIRED_ACCOUNT_AGE "Required Account Age"
#define JOB_CONFIG_REQUIRED_CHARACTER_AGE "Required Character Age"
#define JOB_CONFIG_SPAWN_POSITIONS "Spawn Positions"
#define JOB_CONFIG_TOTAL_POSITIONS "Total Positions"

/**
 * =======================
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * =======================
 * These names are used as keys in many locations in the database
 * you cannot change them trivially without breaking job bans and
 * role time tracking, if you do this and get it wrong you will die
 * and it will hurt the entire time
 */

//No department
#define JOB_ASSISTANT "Assistant-助手"
#define JOB_PRISONER "Prisoner-囚犯"
//Command
#define JOB_CAPTAIN "Captain-舰长"
#define JOB_HEAD_OF_PERSONNEL "Head Of Personnel-人事部长"
#define JOB_HEAD_OF_SECURITY "Head of Security-安保首长"
#define JOB_RESEARCH_DIRECTOR "Research Director-研究主管"
#define JOB_CHIEF_ENGINEER "Chief Engineer-工程师长"
#define JOB_CHIEF_MEDICAL_OFFICER "Chief Medical Officer-首席医疗官"
#define JOB_BRIDGE_ASSISTANT "Bridge Assistant-舰桥助手"
//Silicon
#define JOB_AI "AI"
#define JOB_CYBORG "Cyborg"
#define JOB_PERSONAL_AI "Personal AI"
//Security
#define JOB_WARDEN "Warden-典狱官"
#define JOB_DETECTIVE "Detective-侦探"
#define JOB_SECURITY_OFFICER "Security Officer-警员"
#define JOB_SECURITY_OFFICER_MEDICAL "Security Officer (Medical)"
#define JOB_SECURITY_OFFICER_ENGINEERING "Security Officer (Engineering)"
#define JOB_SECURITY_OFFICER_SCIENCE "Security Officer (Science)"
#define JOB_SECURITY_OFFICER_SUPPLY "Security Officer (Cargo)"
#define JOB_CORRECTIONS_OFFICER "Corrections Officer-狱警" // SKYRAT EDIT ADDITION
//Engineering
#define JOB_STATION_ENGINEER "Engineer-工程师"
#define JOB_ATMOSPHERIC_TECHNICIAN "Atmospheric Technician-大气技工"
#define JOB_ENGINEERING_GUARD "Engineering Guard-工程保全" // SKYRAT EDIT ADDITION
//Medical
#define JOB_CORONER "Coroner-验尸官"
#define JOB_MEDICAL_DOCTOR "Medical Doctor-医生"
#define JOB_PARAMEDIC "Paramedic-急救员"
#define JOB_CHEMIST "Chemist-化学家"
#define JOB_VIROLOGIST "Virologist-病毒学家"
#define JOB_ORDERLY "Orderly-安全医官" // SKYRAT EDIT ADDITION
//Science
#define JOB_SCIENTIST "Scientist-研究员"
#define JOB_ROBOTICIST "Roboticist-机械学者"
#define JOB_GENETICIST "Geneticist-基因学家"
#define JOB_SCIENCE_GUARD "Science Guard-科研安保"
//Supply
#define JOB_QUARTERMASTER "Quartermaster-军需官"
#define JOB_CARGO_TECHNICIAN "Cargo Technician-货仓技工"
#define JOB_CARGO_GORILLA "Cargo Gorilla"
#define JOB_SHAFT_MINER "Shaft Miner-竖井矿工"
#define JOB_BITRUNNER "Bitrunner-比特矿工"
#define JOB_CUSTOMS_AGENT "Customs Agent-海关" // SKYRAT EDIT ADDITION
//Service
#define JOB_BARTENDER "Bartender-酒保"
#define JOB_BOTANIST "Botanist-植物学家"
#define JOB_COOK "Cook-厨师"
#define JOB_JANITOR "Janitor-清洁工"
#define JOB_CLOWN "Clown-小丑"
#define JOB_MIME "Mime-默剧演员"
#define JOB_CURATOR "Curator-图书馆长"
#define JOB_LAWYER "Lawyer-律师"
#define JOB_CHAPLAIN "Chaplain-牧师"
#define JOB_PSYCHOLOGIST "Psychologist-心理学家"
#define JOB_BARBER "Barber-理发师" // SKYRAT EDIT ADDITION
#define JOB_BOUNCER "Service Guard-民事安全员" // SKYRAT EDIT ADDITION
//ERTs
#define JOB_ERT_DEATHSQUAD "Death Commando"
#define JOB_ERT_COMMANDER "Emergency Response Team Commander"
#define JOB_ERT_OFFICER "Security Response Officer"
#define JOB_ERT_ENGINEER "Engineering Response Officer"
#define JOB_ERT_MEDICAL_DOCTOR "Medical Response Officer"
#define JOB_ERT_CHAPLAIN "Religious Response Officer"
#define JOB_ERT_JANITOR "Janitorial Response Officer"
#define JOB_ERT_CLOWN "Entertainment Response Officer"
//CentCom
#define JOB_CENTCOM "Central Command"
#define JOB_CENTCOM_OFFICIAL "CentCom Official"
#define JOB_CENTCOM_ADMIRAL "Admiral"
#define JOB_CENTCOM_COMMANDER "CentCom Commander"
#define JOB_CENTCOM_VIP "VIP Guest"
#define JOB_CENTCOM_BARTENDER "CentCom Bartender"
#define JOB_CENTCOM_CUSTODIAN "Custodian"
#define JOB_CENTCOM_THUNDERDOME_OVERSEER "Thunderdome Overseer"
#define JOB_CENTCOM_MEDICAL_DOCTOR "Medical Officer"
#define JOB_CENTCOM_RESEARCH_OFFICER "Research Officer"
#define JOB_CENTCOM_SPECIAL_OFFICER "Special Ops Officer"
#define JOB_CENTCOM_PRIVATE_SECURITY "Private Security Force"
// SKYRAT EDIT ADDITION START
#define JOB_BLUESHIELD "Blueshield"
#define JOB_NT_REP "Nanotrasen Consultant"
// Nanotrasen Naval Command jobs
#define JOB_NAVAL_ENSIGN "Ensign"
#define JOB_NAVAL_LIEUTENANT "Lieutenant"
#define JOB_NAVAL_LTCR "Lieutenant Commander"
#define JOB_NAVAL_COMMANDER "Commander"
#define JOB_NAVAL_CAPTAIN "Captain"
#define JOB_NAVAL_REAR_ADMIRAL "Rear Admiral"
#define JOB_NAVAL_ADMIRAL "Admiral"
#define JOB_NAVAL_FLEET_ADMIRAL "Fleet Admiral"
// Off-Station
#define JOB_SPACE_POLICE "Space Police"
#define JOB_SOLFED "SolFed"
#define JOB_SOLFED_LIASON "SolFed Liason"
// SKYRAT EDIT ADDITION END

#define JOB_GROUP_ENGINEERS list( \
	JOB_STATION_ENGINEER, \
	JOB_ATMOSPHERIC_TECHNICIAN, \
)


#define JOB_DISPLAY_ORDER_ASSISTANT 1
#define JOB_DISPLAY_ORDER_CAPTAIN 2
#define JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL 3
#define JOB_DISPLAY_ORDER_BRIDGE_ASSISTANT 4
#define JOB_DISPLAY_ORDER_BARTENDER 5
#define JOB_DISPLAY_ORDER_BOTANIST 6
#define JOB_DISPLAY_ORDER_COOK 7
#define JOB_DISPLAY_ORDER_JANITOR 8
#define JOB_DISPLAY_ORDER_CLOWN 9
#define JOB_DISPLAY_ORDER_MIME 10
#define JOB_DISPLAY_ORDER_CURATOR 11
#define JOB_DISPLAY_ORDER_LAWYER 12
#define JOB_DISPLAY_ORDER_CHAPLAIN 13
#define JOB_DISPLAY_ORDER_PSYCHOLOGIST 14
#define JOB_DISPLAY_ORDER_AI 15
#define JOB_DISPLAY_ORDER_CYBORG 16
#define JOB_DISPLAY_ORDER_CHIEF_ENGINEER 17
#define JOB_DISPLAY_ORDER_STATION_ENGINEER 18
#define JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN 19
#define JOB_DISPLAY_ORDER_QUARTERMASTER 20
#define JOB_DISPLAY_ORDER_CARGO_TECHNICIAN 21
#define JOB_DISPLAY_ORDER_SHAFT_MINER 22
#define JOB_DISPLAY_ORDER_BITRUNNER 23
#define JOB_DISPLAY_ORDER_CARGO_GORILLA 24
#define JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER 25
#define JOB_DISPLAY_ORDER_MEDICAL_DOCTOR 26
#define JOB_DISPLAY_ORDER_PARAMEDIC 27
#define JOB_DISPLAY_ORDER_CHEMIST 28
#define JOB_DISPLAY_ORDER_VIROLOGIST 29
#define JOB_DISPLAY_ORDER_CORONER 30
#define JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR 31
#define JOB_DISPLAY_ORDER_SCIENTIST 32
#define JOB_DISPLAY_ORDER_ROBOTICIST 33
#define JOB_DISPLAY_ORDER_GENETICIST 34
#define JOB_DISPLAY_ORDER_HEAD_OF_SECURITY 35
#define JOB_DISPLAY_ORDER_WARDEN 36
#define JOB_DISPLAY_ORDER_DETECTIVE 37
#define JOB_DISPLAY_ORDER_SECURITY_OFFICER 38
#define JOB_DISPLAY_ORDER_PRISONER 39
#define JOB_DISPLAY_ORDER_SECURITY_MEDIC 100 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_CORRECTIONS_OFFICER 101 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_NANOTRASEN_CONSULTANT 102 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_BLUESHIELD 103 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_ORDERLY 104 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_SCIENCE_GUARD 105 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_BOUNCER 106 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_ENGINEER_GUARD 107 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_CUSTOMS_AGENT 108 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_EXP_CORPS 109 //SKYRAT EDIT ADDITON

#define DEPARTMENT_UNASSIGNED "No Department"

#define DEPARTMENT_BITFLAG_SECURITY (1<<0)
#define DEPARTMENT_SECURITY "Security-安保部"
#define DEPARTMENT_BITFLAG_COMMAND (1<<1)
#define DEPARTMENT_COMMAND "Command-指挥部"
#define DEPARTMENT_BITFLAG_SERVICE (1<<2)
#define DEPARTMENT_SERVICE "Service-服务部"
#define DEPARTMENT_BITFLAG_CARGO (1<<3)
#define DEPARTMENT_CARGO "Cargo-后勤部"
#define DEPARTMENT_BITFLAG_ENGINEERING (1<<4)
#define DEPARTMENT_ENGINEERING "Engineering-工程部"
#define DEPARTMENT_BITFLAG_SCIENCE (1<<5)
#define DEPARTMENT_SCIENCE "Science-科研部"
#define DEPARTMENT_BITFLAG_MEDICAL (1<<6)
#define DEPARTMENT_MEDICAL "Medical-医疗部"
#define DEPARTMENT_BITFLAG_SILICON (1<<7)
#define DEPARTMENT_SILICON "Silicon"
#define DEPARTMENT_BITFLAG_ASSISTANT (1<<8)
#define DEPARTMENT_ASSISTANT "Assistant"
#define DEPARTMENT_BITFLAG_CAPTAIN (1<<9)
#define DEPARTMENT_CAPTAIN "Captain"
#define DEPARTMENT_BITFLAG_CENTRAL_COMMAND (1<<10) //SKYRAT EDIT CHANGE
#define DEPARTMENT_CENTRAL_COMMAND "Central Command" //SKYRAT EDIT CHANGE

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_CREW_MANIFEST (1<<1)
/// Whether the mob is equipped through SSjob.EquipRank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether the job is considered a regular crew member of the station. Equipment such as AI and cyborgs not included.
#define JOB_CREW_MEMBER (1<<3)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<4)
/// Whether this job appears in bold in the job menu.
#define JOB_BOLD_SELECT_TEXT (1<<5)
/// Reopens this position if we lose the player at roundstart.
#define JOB_REOPEN_ON_ROUNDSTART_LOSS (1<<6)
/// If the player with this job can have quirks assigned to him or not. Relevant for new player joinable jobs and roundstart antags.
#define JOB_ASSIGN_QUIRKS (1<<7)
/// Whether this job can be an intern.
#define JOB_CAN_BE_INTERN (1<<8)
/// This job cannot have more slots opened by the Head of Personnel (but admins or other random events can still do this).
#define JOB_CANNOT_OPEN_SLOTS (1<<9)
/// This job will not display on the job menu when there are no slots available, instead of appearing greyed out
#define JOB_HIDE_WHEN_EMPTY (1<<10)
/// This job cannot be signed up for at round start or recorded in your preferences
#define JOB_LATEJOIN_ONLY (1<<11)
/// This job is a head of staff.
#define JOB_HEAD_OF_STAFF (1<<12)

/// Combination flag for jobs which are considered regular crew members of the station.
#define STATION_JOB_FLAGS (JOB_ANNOUNCE_ARRIVAL|JOB_CREW_MANIFEST|JOB_EQUIP_RANK|JOB_CREW_MEMBER|JOB_NEW_PLAYER_JOINABLE|JOB_REOPEN_ON_ROUNDSTART_LOSS|JOB_ASSIGN_QUIRKS|JOB_CAN_BE_INTERN)
/// Combination flag for jobs which are considered heads of staff.
#define HEAD_OF_STAFF_JOB_FLAGS (JOB_BOLD_SELECT_TEXT|JOB_CANNOT_OPEN_SLOTS|JOB_HEAD_OF_STAFF)
/// Combination flag for jobs which are enabled by station traits.
#define STATION_TRAIT_JOB_FLAGS (JOB_CANNOT_OPEN_SLOTS|JOB_HIDE_WHEN_EMPTY|JOB_LATEJOIN_ONLY&~JOB_REOPEN_ON_ROUNDSTART_LOSS)

#define FACTION_NONE "None"
#define FACTION_STATION "Station"

// Variable macros used to declare who is the supervisor for a given job, announced to the player when they join as any given job.
#define SUPERVISOR_CAPTAIN "the Captain"
#define SUPERVISOR_CE "the Chief Engineer"
#define SUPERVISOR_CMO "the Chief Medical Officer"
#define SUPERVISOR_HOP "the Head of Personnel"
#define SUPERVISOR_HOS "the Head of Security"
#define SUPERVISOR_QM "the Quartermaster"
#define SUPERVISOR_RD "the Research Director"

/// Mind traits that should be shared by every head of staff. has to be this way cause byond lists lol
#define HEAD_OF_STAFF_MIND_TRAITS TRAIT_FAST_TYING, TRAIT_HIGH_VALUE_RANSOM
