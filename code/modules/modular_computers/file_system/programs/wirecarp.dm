/datum/computer_file/program/ntnetmonitor
	filename = "wirecarp"
	filedesc = "WireCarp-网络鲤鱼"
	downloader_category = PROGRAM_CATEGORY_SECURITY
	program_open_overlay = "comm_monitor"
	extended_desc = "该程序监视全站的NTNet网络，提供对日志系统的访问，并允许配置更改."
	size = 12
	run_access = list(ACCESS_NETWORK) //NETWORK CONTROL IS A MORE SECURE PROGRAM.
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_REQUIRES_NTNET
	tgui_id = "NtosNetMonitor"
	program_icon = "network-wired"

/datum/computer_file/program/ntnetmonitor/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("resetIDS")
			SSmodular_computers.intrusion_detection_alarm = FALSE
			return TRUE
		if("toggleIDS")
			SSmodular_computers.intrusion_detection_enabled = !SSmodular_computers.intrusion_detection_enabled
			return TRUE
		if("toggle_relay")
			var/obj/machinery/ntnet_relay/target_relay = locate(params["ref"]) in SSmachines.get_machines_by_type(/obj/machinery/ntnet_relay)
			if(!istype(target_relay))
				return
			target_relay.set_relay_enabled(!target_relay.relay_enabled)
			return TRUE
		if("purgelogs")
			SSmodular_computers.purge_logs()
			return TRUE
		if("toggle_mass_pda")
			if(!(params["ref"] in GLOB.pda_messengers))
				return
			var/datum/computer_file/program/messenger/target_messenger = GLOB.pda_messengers[params["ref"]]
			target_messenger.spam_mode = !target_messenger.spam_mode
			return TRUE

/datum/computer_file/program/ntnetmonitor/ui_data(mob/user)
	var/list/data = list()

	data["ntnetrelays"] = list()
	for(var/obj/machinery/ntnet_relay/relays as anything in SSmachines.get_machines_by_type(/obj/machinery/ntnet_relay))
		var/list/relay_data = list()
		relay_data["is_operational"] = !!relays.is_operational
		relay_data["name"] = relays.name
		relay_data["ref"] = REF(relays)

		data["ntnetrelays"] += list(relay_data)

	data["idsstatus"] = SSmodular_computers.intrusion_detection_enabled
	data["idsalarm"] = SSmodular_computers.intrusion_detection_alarm

	data["ntnetlogs"] = list()
	for(var/i in SSmodular_computers.modpc_logs)
		data["ntnetlogs"] += list(list("entry" = i))

	data["tablets"] = list()
	for(var/messenger_ref in get_messengers_sorted_by_name())
		var/datum/computer_file/program/messenger/app = GLOB.pda_messengers[messenger_ref]
		var/obj/item/modular_computer/pda = app.computer

		var/list/tablet_data = list()
		tablet_data["enabled_spam"] = app.spam_mode
		tablet_data["name"] = pda.saved_identification
		tablet_data["ref"] = REF(app)

		data["tablets"] += list(tablet_data)

	return data
