#define BEAN_CAPACITY 10 //amount of coffee beans that can fit inside the impressa coffeemaker

/obj/machinery/coffeemaker
	name = "咖啡机"
	desc = "一台modelo 3咖啡机，可以煮咖啡，并将其保持在176华氏度的完美温度，Piccionaia家用电器制造."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "coffeemaker_nopot_nocart"
	base_icon_state = "coffeemaker"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/coffeemaker
	anchored_tabletop_offset = 4
	var/obj/item/reagent_containers/cup/coffeepot/coffeepot = null
	var/brewing = FALSE
	var/brew_time = 20 SECONDS
	var/speed = 1
	/// The coffee cartridge to make coffee from. In the future, coffee grounds are like printer ink.
	var/obj/item/coffee_cartridge/cartridge = null
	/// The type path to instantiate for the coffee cartridge the device initially comes with, eg. /obj/item/coffee_cartridge
	var/initial_cartridge = /obj/item/coffee_cartridge
	/// The number of cups left
	var/coffee_cups = 15
	var/max_coffee_cups = 15
	/// The amount of sugar packets left
	var/sugar_packs = 10
	var/max_sugar_packs = 10
	/// The amount of sweetener packets left
	var/sweetener_packs = 10
	var/max_sweetener_packs = 10
	/// The amount of creamer packets left
	var/creamer_packs = 10
	var/max_creamer_packs = 10

	var/static/radial_examine = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_examine")
	var/static/radial_brew = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_brew")
	var/static/radial_eject_pot = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_pot")
	var/static/radial_eject_cartridge = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_cartridge")
	var/static/radial_take_cup = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_cup")
	var/static/radial_take_sugar = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sugar")
	var/static/radial_take_sweetener = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sweetener")
	var/static/radial_take_creamer = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_creamer")

/obj/machinery/coffeemaker/Initialize(mapload)
	. = ..()
	if(mapload)
		coffeepot = new /obj/item/reagent_containers/cup/coffeepot(src)
		cartridge = new /obj/item/coffee_cartridge(src)

/obj/machinery/coffeemaker/deconstruct()
	coffeepot?.forceMove(drop_location())
	cartridge?.forceMove(drop_location())
	return ..()

/obj/machinery/coffeemaker/Destroy()
	QDEL_NULL(coffeepot)
	QDEL_NULL(cartridge)
	return ..()

/obj/machinery/coffeemaker/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == coffeepot)
		coffeepot = null
		update_appearance(UPDATE_OVERLAYS)
	if(gone == cartridge)
		cartridge = null
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/RefreshParts()
	. = ..()
	speed = 0
	for(var/datum/stock_part/micro_laser/laser in component_parts)
		speed += laser.tier

/obj/machinery/coffeemaker/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("你距离太远，无法检查[src]的内容!")
		return

	if(brewing)
		. += span_warning("[src]正在煮.")
		return

	if(panel_open)
		. += span_notice("[src]的维修口打开了!")
		return

	if(coffeepot || cartridge)
		. += span_notice("[src]包含:")
		if(coffeepot)
			. += span_notice("- \A [coffeepot].")
		if(cartridge)
			. += span_notice("- \A [cartridge].")
		return

	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += "[span_notice("状态显示如下:")]\n"+\
		span_notice("- 煮咖啡效率 <b>[speed*100]%</b>.")
		if(coffeepot)
			for(var/datum/reagent/consumable/cawfee as anything in coffeepot.reagents.reagent_list)
				. += span_notice("- [cawfee.volume]单位咖啡在壶中.")
		if(cartridge)
			if(cartridge.charges < 1)
				. += span_notice("- 咖啡盒已空.")
			else
				. += span_notice("- 咖啡盒还有[cartridge.charges]剩余.")

	if (coffee_cups >= 1)
		. += span_notice("里面还有[coffee_cups]杯咖啡杯.")
	else
		. += span_notice("里面没有咖啡杯了.")

	if (sugar_packs >= 1)
		. += span_notice("里面还有[sugar_packs]包糖.")
	else
		. += span_notice("里面没糖了.")

	if (sweetener_packs >= 1)
		. += span_notice("里面还有[sweetener_packs]包甜味剂.")
	else
		. += span_notice("里面没有甜味剂了.")

	if (creamer_packs > 1)
		. += span_notice("里面还有[creamer_packs]包奶油.")
	else
		. += span_notice("里面没有奶油了.")

/obj/machinery/coffeemaker/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.can_perform_action(src, ALLOW_SILICON_REACH|FORBID_TELEKINESIS_REACH))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(brewing)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	replace_pot(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/coffeemaker/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/coffeemaker/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/coffeemaker/update_overlays()
	. = ..()
	. += overlay_checks()

/obj/machinery/coffeemaker/proc/overlay_checks()
	. = list()
	if(coffeepot)
		. += "coffeemaker_pot"
	if(cartridge)
		. += "coffeemaker_cartidge"
	return .

/obj/machinery/coffeemaker/proc/replace_pot(mob/living/user, obj/item/reagent_containers/cup/coffeepot/new_coffeepot)
	if(!user)
		return FALSE
	if(coffeepot)
		try_put_in_hand(coffeepot, user)
	if(new_coffeepot)
		coffeepot = new_coffeepot
	balloon_alert(user, "可替换咖啡壶")
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/coffeemaker/proc/replace_cartridge(mob/living/user, obj/item/coffee_cartridge/new_cartridge)
	if(!user)
		return FALSE
	if(cartridge)
		try_put_in_hand(cartridge, user)
	if(new_cartridge)
		cartridge = new_cartridge
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/coffeemaker/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/coffeemaker/attackby(obj/item/attack_item, mob/living/user, params)
	//You can only screw open empty grinder
	if(!coffeepot && default_deconstruction_screwdriver(user, icon_state, icon_state, attack_item))
		return FALSE

	if(default_deconstruction_crowbar(attack_item))
		return

	if(panel_open) //Can't insert objects when its screwed open
		return TRUE

	if (istype(attack_item, /obj/item/reagent_containers/cup/coffeepot) && !(attack_item.item_flags & ABSTRACT) && attack_item.is_open_container())
		var/obj/item/reagent_containers/cup/coffeepot/new_pot = attack_item
		. = TRUE //no afterattack
		if(!user.transferItemToLoc(new_pot, src))
			return TRUE
		replace_pot(user, new_pot)
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/cup/glass/coffee_cup) && !(attack_item.item_flags & ABSTRACT) && attack_item.is_open_container())
		var/obj/item/reagent_containers/cup/glass/coffee_cup/new_cup = attack_item
		if(new_cup.reagents.total_volume > 0)
			balloon_alert(user, "杯子必须清空！")
			return
		if(coffee_cups >= max_coffee_cups)
			balloon_alert(user, "咖啡杯盒已经满了！")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		coffee_cups++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/condiment/pack/sugar))
		var/obj/item/reagent_containers/condiment/pack/sugar/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "调味包必须是满的!")
			return
		if(sugar_packs >= max_sugar_packs)
			balloon_alert(user, "糖盒已满!")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		sugar_packs++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/condiment/creamer))
		var/obj/item/reagent_containers/condiment/creamer/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "调味包必须是满的!")
			return
		if(creamer_packs >= max_creamer_packs)
			balloon_alert(user, "奶油盒已满!")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		creamer_packs++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/condiment/pack/astrotame))
		var/obj/item/reagent_containers/condiment/pack/astrotame/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "调味包必须是满的!")
			return
		else if(sweetener_packs >= max_sweetener_packs)
			balloon_alert(user, "甜味剂盒已满!")
			return
		else if(!user.transferItemToLoc(attack_item, src))
			return
		sweetener_packs++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/coffee_cartridge) && !(attack_item.item_flags & ABSTRACT))
		var/obj/item/coffee_cartridge/new_cartridge = attack_item
		if(!user.transferItemToLoc(new_cartridge, src))
			return
		replace_cartridge(user, new_cartridge)
		balloon_alert(user, "以添加咖啡盒")
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

/obj/machinery/coffeemaker/proc/try_brew()
	if(!cartridge)
		balloon_alert(usr, "没有插入咖啡盒！")
		return FALSE
	if(cartridge.charges < 1)
		balloon_alert(usr, "咖啡盒是空的!")
		return FALSE
	if(!coffeepot)
		balloon_alert(usr, "没有咖啡壶!")
		return FALSE
	if(machine_stat & (NOPOWER|BROKEN))
		balloon_alert(usr, "机器未通电！")
		return FALSE
	if(coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		balloon_alert(usr, "咖啡壶已经满了!")
		return FALSE
	return TRUE

/obj/machinery/coffeemaker/ui_interact(mob/user) // The microwave Menu //I am reasonably certain that this is not a microwave //I am positively certain that this is not a microwave
	. = ..()

	if(brewing || !user.can_perform_action(src, ALLOW_SILICON_REACH))
		return

	var/list/options = list()

	if(coffeepot)
		options["弹出咖啡壶"] = radial_eject_pot

	if(cartridge)
		options["弹出咖啡盒"] = radial_eject_cartridge

	options["煮"] = radial_brew //brew is always available as an option, when the machine is unable to brew the player is told by balloon alerts whats exactly wrong

	if(coffee_cups > 0)
		options["咖啡杯"] = radial_take_cup

	if(sugar_packs > 0)
		options["糖包"] = radial_take_sugar

	if(sweetener_packs > 0)
		options["甜味剂"] = radial_take_sweetener

	if(creamer_packs > 0)
		options["奶油包"] = radial_take_creamer

	if(isAI(user))
		if(machine_stat & NOPOWER)
			return
		options["检查"] = radial_examine

	var/choice

	if(length(options) < 1)
		return
	if(length(options) == 1)
		choice = options[1]
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	// post choice verification
	if(brewing || (isAI(user) && machine_stat & NOPOWER) || !user.can_perform_action(src, ALLOW_SILICON_REACH))
		return

	switch(choice)
		if("煮")
			brew(user)
		if("弹出咖啡壶")
			eject_pot(user)
		if("弹出咖啡盒")
			eject_cartridge(user)
		if("检查")
			examine(user)
		if("弹出咖啡杯")
			take_cup(user)
		if("糖包")
			take_sugar(user)
		if("甜味剂")
			take_sweetener(user)
		if("奶油包")
			take_creamer(user)

/obj/machinery/coffeemaker/proc/eject_pot(mob/user)
	if(coffeepot)
		replace_pot(user)

/obj/machinery/coffeemaker/proc/eject_cartridge(mob/user)
	if(cartridge)
		replace_cartridge(user)

/obj/machinery/coffeemaker/proc/take_cup(mob/user)
	if(!coffee_cups) //shouldn't happen, but we all know how stuff manages to break
		balloon_alert(user, "没有咖啡杯了！")
		return
	var/obj/item/reagent_containers/cup/glass/coffee_cup/new_cup = new(get_turf(src))
	user.put_in_hands(new_cup)
	coffee_cups--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_sugar(mob/user)
	if(!sugar_packs)
		balloon_alert(user, "没有糖包了！")
		return
	var/obj/item/reagent_containers/condiment/pack/sugar/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sugar_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_sweetener(mob/user)
	if(!sweetener_packs)
		balloon_alert(user, "没有甜味剂了！")
		return
	var/obj/item/reagent_containers/condiment/pack/astrotame/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sweetener_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_creamer(mob/user)
	if(!creamer_packs)
		balloon_alert(user, "没有奶油包了！")
		return
	var/obj/item/reagent_containers/condiment/creamer/new_pack = new(drop_location())
	user.put_in_hands(new_pack)
	creamer_packs--
	update_appearance(UPDATE_OVERLAYS)

///Updates the smoke state to something else, setting particles if relevant
/obj/machinery/coffeemaker/proc/toggle_steam()
	QDEL_NULL(particles)
	if(brewing)
		particles = new /particles/smoke/steam/mild()
		particles.position = list(-6, 0, 0)

/obj/machinery/coffeemaker/proc/operate_for(time, silent = FALSE)
	brewing = TRUE
	if(!silent)
		playsound(src, 'sound/machines/coffeemaker_brew.ogg', 20, vary = TRUE)
	toggle_steam()
	use_power(active_power_usage * time * 0.1) // .1 needed here to convert time (in deciseconds) to seconds such that watts * seconds = joules
	addtimer(CALLBACK(src, PROC_REF(stop_operating)), time / speed)

/obj/machinery/coffeemaker/proc/stop_operating()
	brewing = FALSE
	toggle_steam()

/obj/machinery/coffeemaker/proc/brew()
	power_change()
	if(!try_brew())
		return
	operate_for(brew_time)
	coffeepot.reagents.add_reagent_list(cartridge.drink_type)
	cartridge.charges--

//Coffee Cartridges: like toner, but for your coffee!
/obj/item/coffee_cartridge
	name = "咖啡盒 - Caffè 通用"
	desc = "Piccionaia咖啡公司生产的咖啡盒，用于modelello 3系统."
	icon = 'icons/obj/food/cartridges.dmi'
	icon_state = "cartridge_basic"
	var/charges = 4
	var/list/drink_type = list(/datum/reagent/consumable/coffee = 120)

/obj/item/coffee_cartridge/examine(mob/user)
	. = ..()
	if(charges)
		. += span_warning("咖啡盒有[charges]部分剩余的咖啡.")
	else
		. += span_warning("咖啡盒没有剩余未使用的咖啡了.")

/obj/item/coffee_cartridge/fancy
	name = "咖啡盒 - Caffè 梦幻"
	desc = "Piccionaia咖啡公司生产的一种别致的咖啡盒，用于modelello 3系统."
	icon_state = "cartridge_blend"

//Here's the joke before I get 50 issue reports: they're all the same, and that's intentional
/obj/item/coffee_cartridge/fancy/Initialize(mapload)
	. = ..()
	var/coffee_type = pick("blend", "blue_mountain", "kilimanjaro", "mocha")
	switch(coffee_type)
		if("blend")
			name = "咖啡盒 - 混合"
			icon_state = "cartridge_blend"
		if("blue_mountain")
			name = "咖啡盒 - 蓝山"
			icon_state = "cartridge_blue_mtn"
		if("kilimanjaro")
			name = "咖啡盒 - 乞力马扎罗"
			icon_state = "cartridge_kilimanjaro"
		if("mocha")
			name = "咖啡盒 - 摩卡"
			icon_state = "cartridge_mocha"

/obj/item/coffee_cartridge/decaf
	name = "咖啡盒 - 脱咖啡因"
	desc = "Piccionaia咖啡公司生产的咖啡盒，用于modelello 3系统."
	icon_state = "cartridge_decaf"

// no you can't just squeeze the juice bag into a glass!
/obj/item/coffee_cartridge/bootleg
	name = "咖啡盒 - 草本混合"
	desc = "Piccionaia咖啡公司生产的咖啡盒，用于modelello 3系统."
	icon_state = "cartridge_bootleg"

// blank cartridge for crafting's sake, can be made at the service lathe
/obj/item/blank_coffee_cartridge
	name = "空咖啡盒"
	desc = "空的咖啡盒."
	icon = 'icons/obj/food/cartridges.dmi'
	icon_state = "cartridge_blank"

//now, how do you store coffee carts? well, in a rack, of course!
/obj/item/storage/fancy/coffee_cart_rack
	name = "咖啡盒架"
	desc = "一个小架子，用来存放咖啡盒."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "coffee_cartrack4"
	base_icon_state = "coffee_cartrack"
	contents_tag = "coffee cartridge"
	open_status = FANCY_CONTAINER_ALWAYS_OPEN
	spawn_type = /obj/item/coffee_cartridge
	spawn_count = 1

/obj/item/storage/fancy/coffee_cart_rack/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 4
	atom_storage.set_holdable(list(/obj/item/coffee_cartridge))

/*
 * impressa coffee maker
 * its supposed to be a premium line product, so its cargo-only, the board cant be therefore researched
 */

/obj/machinery/coffeemaker/impressa
	name = "Impressa牌咖啡机"
	desc = "这款咖啡机专为工业用途设计，它使用新鲜干燥的整颗咖啡豆制作咖啡."
	icon = 'icons/obj/machines/coffeemaker.dmi'
	icon_state = "coffeemaker_impressa"
	circuit = /obj/item/circuitboard/machine/coffeemaker/impressa
	initial_cartridge = null //no cartridge, just coffee beans
	brew_time = 15 SECONDS //industrial grade, its faster than the regular one
	density = TRUE
	pass_flags = PASSTABLE
	/// Current amount of coffee beans stored
	var/coffee_amount = 0
	/// List of coffee bean objects are stored
	var/list/coffee = list()

/obj/machinery/coffeemaker/impressa/Initialize(mapload)
	. = ..()
	if(mapload)
		coffeepot = new /obj/item/reagent_containers/cup/coffeepot(src)
		cartridge = null

/obj/machinery/coffeemaker/impressa/Destroy()
	QDEL_NULL(coffeepot)
	QDEL_NULL(coffee)
	return ..()

/obj/machinery/coffeemaker/impressa/examine(mob/user)
	. = ..()
	if(coffee)
		. += span_notice("内部研磨机含有 [coffee.len] 勺咖啡豆.")

/obj/machinery/coffeemaker/impressa/update_overlays()
	. = ..()
	. += overlay_checks()

/obj/machinery/coffeemaker/impressa/overlay_checks()
	. = list()
	if(coffeepot)
		if(coffeepot.reagents.total_volume > 0)
			. += "pot_full"
		else
			. += "pot_empty"
	if(coffee_cups > 0)
		if(coffee_cups >= max_coffee_cups/3)
			if(coffee_cups > max_coffee_cups/1.5)
				. += "cups_3"
			else
				. += "cups_2"
		else
			. += "cups_1"
	if(sugar_packs)
		. += "extras_1"
	if(creamer_packs)
		. += "extras_2"
	if(sweetener_packs)
		. += "extras_3"
	if(coffee_amount)
		if(coffee_amount < 0.7*BEAN_CAPACITY)
			. += "grinder_half"
		else
			. += "grinder_full"
	return .

/obj/machinery/coffeemaker/impressa/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in coffee)
		coffee -= gone
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/impressa/try_brew()
	if(coffee_amount <= 0)
		balloon_alert_to_viewers("没有咖啡豆!")
		return FALSE
	if(!coffeepot)
		balloon_alert_to_viewers("没有咖啡壶!")
		return FALSE
	if(machine_stat & (NOPOWER|BROKEN) )
		balloon_alert_to_viewers("机器未通电!")
		return FALSE
	if(coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		balloon_alert_to_viewers("咖啡壶已经满了!")
		return FALSE
	return TRUE

/obj/machinery/coffeemaker/impressa/attackby(obj/item/attack_item, mob/living/user, params)
	//You can only screw open empty grinder
	if(!coffeepot && default_deconstruction_screwdriver(user, icon_state, icon_state, attack_item))
		return

	if(default_deconstruction_crowbar(attack_item))
		return

	if(panel_open) //Can't insert objects when its screwed open
		return TRUE

	if (istype(attack_item, /obj/item/reagent_containers/cup/coffeepot) && !(attack_item.item_flags & ABSTRACT) && attack_item.is_open_container())
		var/obj/item/reagent_containers/cup/coffeepot/new_pot = attack_item
		if(!user.transferItemToLoc(new_pot, src))
			return TRUE
		replace_pot(user, new_pot)
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/cup/glass/coffee) && !(attack_item.item_flags & ABSTRACT) && attack_item.is_open_container())
		var/obj/item/reagent_containers/cup/glass/coffee/new_cup = attack_item //different type of cup
		if(new_cup.reagents.total_volume > 0 )
			balloon_alert(user, "咖啡杯必须清空!")
			return
		if(coffee_cups >= max_coffee_cups)
			balloon_alert(user, "咖啡杯盒已经满了!")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		coffee_cups++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/condiment/pack/sugar))
		var/obj/item/reagent_containers/condiment/pack/sugar/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "调味包必须是满的!")
			return
		if(sugar_packs >= max_sugar_packs)
			balloon_alert(user, "糖盒已满!")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		sugar_packs++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/condiment/creamer))
		var/obj/item/reagent_containers/condiment/creamer/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "调味包必须是满的!")
			return
		if(creamer_packs >= max_creamer_packs)
			balloon_alert(user, "奶油盒已满!")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		creamer_packs++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/condiment/pack/astrotame))
		var/obj/item/reagent_containers/condiment/pack/astrotame/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "调味包必须是满的!")
			return
		if(sweetener_packs >= max_sweetener_packs)
			balloon_alert(user, "甜味剂盒已满!")
			return
		if(!user.transferItemToLoc(attack_item, src))
			return
		sweetener_packs++
		update_appearance(UPDATE_OVERLAYS)
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/food/grown/coffee) && !(attack_item.item_flags & ABSTRACT))
		if(coffee_amount >= BEAN_CAPACITY)
			balloon_alert(user, "咖啡容器已经满了!")
			return
		if(!HAS_TRAIT(attack_item, TRAIT_DRIED))
			balloon_alert(user, "咖啡豆必须是干燥的!")
			return
		var/obj/item/food/grown/coffee/new_coffee = attack_item
		if(!user.transferItemToLoc(new_coffee, src))
			return
		coffee += new_coffee
		coffee_amount++
		balloon_alert(user, "添加咖啡")


	if (istype(attack_item, /obj/item/storage/box/coffeepack))
		if(coffee_amount >= BEAN_CAPACITY)
			balloon_alert(user, "咖啡容器已经满了!")
			return
		var/obj/item/storage/box/coffeepack/new_coffee_pack = attack_item
		for(var/obj/item/food/grown/coffee/new_coffee in new_coffee_pack.contents)
			if(HAS_TRAIT(new_coffee, TRAIT_DRIED)) //the coffee beans inside must be dry
				if(coffee_amount < BEAN_CAPACITY)
					if(user.transferItemToLoc(new_coffee, src))
						coffee += new_coffee
						coffee_amount++
						new_coffee.forceMove(src)
						balloon_alert(user, "添加咖啡")
						update_appearance(UPDATE_OVERLAYS)
					else
						return
				else
					return
			else
				balloon_alert(user, "咖啡包装内的非干燥咖啡豆!")
				return

	update_appearance(UPDATE_OVERLAYS)
	return TRUE //no afterattack

/obj/machinery/coffeemaker/impressa/take_cup(mob/user)
	if(!coffee_cups) //shouldn't happen, but we all know how stuff manages to break
		balloon_alert(user, "没有咖啡杯了!")
		return
	balloon_alert_to_viewers("咖啡杯")
	var/obj/item/reagent_containers/cup/glass/coffee/no_lid/new_cup = new(get_turf(src))
	user.put_in_hands(new_cup)
	coffee_cups--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/impressa/toggle_steam()
	QDEL_NULL(particles)
	if(brewing)
		particles = new /particles/smoke/steam/mild()
		particles.position = list(-2, 1, 0)

/obj/machinery/coffeemaker/impressa/brew()
	power_change()
	if(!try_brew())
		return
	operate_for(brew_time)
	coffeepot.reagents.add_reagent_list(list(/datum/reagent/consumable/coffee = 120))
	coffee.Cut(1,2) //remove the first item from the list
	coffee_amount--
	update_appearance(UPDATE_OVERLAYS)

#undef BEAN_CAPACITY
