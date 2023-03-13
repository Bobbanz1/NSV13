/obj/effect/spawner/lootdrop/decoration
	name = "decoration loot spawner"
	desc = "Time for some bling bling."

/obj/effect/spawner/lootdrop/decoration/flower
	name = "random flower spawner"
	loot = list(
		/obj/item/reagent_containers/food/snacks/grown/poppy,
		/obj/item/reagent_containers/food/snacks/grown/harebell,
		/obj/item/reagent_containers/food/snacks/grown/trumpet,
		/obj/item/grown/sunflower,
	)

/obj/effect/spawner/lootdrop/contraband
	name = "contraband loot spawner"
	desc = "Pstttthhh! Pass it under the table."

/obj/effect/spawner/lootdrop/contraband/narcotics
	name = "narcotics loot spawner"
	loot = list(
		/obj/item/reagent_containers/syringe/contraband/space_drugs,
		/obj/item/reagent_containers/syringe/contraband/krokodil,
		/obj/item/reagent_containers/syringe/contraband/methamphetamine,
		/obj/item/reagent_containers/syringe/contraband/bath_salts,
		/obj/item/reagent_containers/syringe/contraband/fentanyl,
		/obj/item/reagent_containers/syringe/contraband/morphine,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/lsd,
		/obj/item/storage/pill_bottle/psicodine,
	)

/obj/effect/spawner/lootdrop/contraband/cannabis
	name = "Random Cannabis Spawner" //blasphemously overpowered, use extremely sparingly (if at all)
	loot = list(
		/obj/item/reagent_containers/food/snacks/grown/cannabis = 25,
		/obj/item/reagent_containers/food/snacks/grown/cannabis/white = 25,
		/obj/item/reagent_containers/food/snacks/grown/cannabis/death = 24,
		/obj/item/reagent_containers/food/snacks/grown/cannabis/rainbow = 25,
		/obj/item/reagent_containers/food/snacks/grown/cannabis/ultimate = 1, //very rare on purpose
	)

/obj/effect/spawner/lootdrop/entertainment
	name = "entertainment loot spawner"
	desc = "It's time to paaaaaarty!"

/obj/effect/spawner/lootdrop/entertainment/musical_instrument
	name = "musical instrument spawner"
	loot = list(
		/obj/item/instrument/violin = 5,
		/obj/item/instrument/banjo = 5,
		/obj/item/instrument/guitar = 5,
		/obj/item/instrument/eguitar = 5,
		/obj/item/instrument/glockenspiel = 5,
		/obj/item/instrument/accordion = 5,
		/obj/item/instrument/trumpet = 5,
		/obj/item/instrument/saxophone = 5,
		/obj/item/instrument/trombone = 5,
		/obj/item/instrument/recorder = 5,
		/obj/item/instrument/harmonica = 5,
		/obj/item/instrument/bikehorn = 2,
		/obj/item/instrument/violin/golden = 2,
		/obj/item/instrument/musicalmoth = 1,
	)

/obj/effect/spawner/lootdrop/entertainment/coin
	name = "coin spawner"
	icon_state = "random_gambling"
	loot = list(
		/obj/item/coin/iron = 5,
		/obj/item/coin/silver = 3,
		/obj/item/coin/plasma = 3,
		/obj/item/coin/uranium = 3,
		/obj/item/coin/diamond = 2,
		/obj/item/coin/bananium = 2,
		/obj/item/coin/adamantine = 2,
		/obj/item/coin/mythril = 2,
		/obj/item/coin/twoheaded = 1,
		/obj/item/coin/antagtoken = 1,
		/obj/item/coin/arcade_token = 1,
	)

/obj/effect/spawner/lootdrop/entertainment/money_medium
	name = "money spawner"
	icon_state = "random_gambling"
	loot = list(
		/obj/item/stack/spacecash/c100 = 25,
		/obj/item/stack/spacecash/c200 = 15,
		/obj/item/stack/spacecash/c50 = 10,
		/obj/item/stack/spacecash/c500 = 5,
		/obj/item/stack/spacecash/c1000 = 1,
	)

/obj/effect/spawner/lootdrop/entertainment/plushie
	name = "plushie spawner"
	loot = list( // the plushies that aren't of things trying to kill you
		/obj/item/toy/plush/carpplushie, // well, maybe they can be something that tries to kill you a little bit
		/obj/item/toy/plush/slimeplushie,
		/obj/item/toy/plush/lizardplushie,
		/obj/item/toy/plush/snakeplushie,
		/obj/item/toy/plush/beeplushie,
		/obj/item/toy/plush/moth,
	)

/obj/effect/spawner/lootdrop/entertainment/plushie_delux
	name = "plushie delux spawner"
	loot = list(
		// common plushies
		/obj/item/toy/plush/slimeplushie = 5,
		/obj/item/toy/plush/lizardplushie = 5,
		/obj/item/toy/plush/snakeplushie = 5,
		/obj/item/toy/plush/beeplushie = 5,
		/obj/item/toy/plush/moth/random = 5,
		// rare plushies
		/obj/item/toy/plush/carpplushie = 3,
		/obj/item/toy/plush/awakenedplushie = 3,
		/obj/item/toy/plush/rouny = 3,
		// super rare plushies
		/obj/item/toy/plush/bubbleplush = 2,
		/obj/item/toy/plush/plushvar = 2,
		/obj/item/toy/plush/narplush = 2,
	)

/obj/effect/spawner/lootdrop/entertainment/toy
	name = "toy spawner"
	loot = list()

/obj/effect/spawner/lootdrop/entertainment/toy/Initialize(mapload)
	loot += GLOB.arcade_prize_pool
	. = ..()
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/lootdrop/entertainment/cigarette_pack
	name = "cigarette pack spawner"
	loot = list(
		/obj/item/storage/fancy/cigarettes = 3,
		/obj/item/storage/fancy/cigarettes/dromedaryco = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 1,
	)

/obj/effect/spawner/lootdrop/entertainment/cigar
	name = "cigar spawner"
	loot = list(
		/obj/item/clothing/mask/cigarette/cigar = 3,
		/obj/item/clothing/mask/cigarette/cigar/havana = 2,
		/obj/item/clothing/mask/cigarette/cigar/cohiba = 1,
	)

/obj/effect/spawner/lootdrop/entertainment/lighter
	name = "lighter spawner"
	loot = list(
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 10,
		/obj/item/lighter = 1,
	)

/obj/effect/spawner/lootdrop/food_or_drink
	name = "food or drink loot spawner"
	desc = "Nom nom nom"

/obj/effect/spawner/lootdrop/food_or_drink/donkpockets_single
	name = "single donk pocket spawner"
	loot = list(
		/obj/item/reagent_containers/food/snacks/donkpocket,
		/obj/item/reagent_containers/food/snacks/donkpocket/spicy,
		/obj/item/reagent_containers/food/snacks/donkpocket/teriyaki,
		/obj/item/reagent_containers/food/snacks/donkpocket/pizza,
		/obj/item/reagent_containers/food/snacks/donkpocket/berry,
		/obj/item/reagent_containers/food/snacks/donkpocket/honk,
	)

/obj/effect/spawner/lootdrop/food_or_drink/refreshing_beverage
	name = "good soda spawner"
	loot = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola = 3,
		/obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 3,
		/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy = 2,
		/obj/item/reagent_containers/food/drinks/soda_cans/thirteenloko = 2,
		/obj/item/reagent_containers/food/drinks/beer/light = 2,
		/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 1,
		/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 1,
		/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 1,
		/obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 1,
		/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 1,
		/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 1,
		/obj/item/reagent_containers/food/drinks/soda_cans/cola = 1,
	)

/obj/effect/spawner/lootdrop/food_or_drink/booze
	name = "booze spawner"
	loot = list(
		/obj/item/reagent_containers/food/drinks/beer = 75,
		/obj/item/reagent_containers/food/drinks/ale = 25,
		/obj/item/reagent_containers/food/drinks/beer/light = 5,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/gin = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 5,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,
		/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,
		/obj/item/reagent_containers/food/drinks/bottle/hcider = 5,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 5,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 5,
		/obj/item/reagent_containers/food/drinks/bottle/grappa = 5,
		/obj/item/reagent_containers/food/drinks/bottle/applejack = 5,
		/obj/item/reagent_containers/glass/bottle/ethanol = 2,
		/obj/item/reagent_containers/food/drinks/bottle/fernet = 2,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 2,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium = 2,
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager = 2,
		/obj/item/reagent_containers/food/drinks/bottle/patron = 1,
		/obj/item/reagent_containers/food/drinks/bottle/lizardwine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka = 1,
		/obj/item/reagent_containers/food/drinks/bottle/trappist = 1,
	)

/obj/effect/spawner/lootdrop/food_or_drink/snack
	name = "snack spawner"
	loot = list(
		/obj/item/reagent_containers/food/snacks/spacetwinkie = 5,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 5,
		/obj/item/reagent_containers/food/snacks/candy = 5,
		/obj/item/reagent_containers/food/snacks/chips = 5,
		/obj/item/reagent_containers/food/snacks/sosjerky = 5,
		/obj/item/reagent_containers/food/snacks/no_raisin = 5,
		/obj/item/reagent_containers/food/snacks/energybar = 5,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 5,
		/obj/item/reagent_containers/food/snacks/cornchips = 5,
		/obj/item/reagent_containers/food/snacks/syndicake = 1,
	)


/obj/effect/spawner/lootdrop/food_or_drink/salad
	name = "salad spawner"
	loot = list(
			/obj/item/reagent_containers/food/snacks/salad/herbsalad,
			/obj/item/reagent_containers/food/snacks/salad/validsalad,
			/obj/item/reagent_containers/food/snacks/salad/fruit,
			/obj/item/reagent_containers/food/snacks/salad/jungle,
			/obj/item/reagent_containers/food/snacks/salad/aesirsalad,
	)

/obj/effect/spawner/lootdrop/food_or_drink/dinner
	name = "dinner spawner"
	loot = list(
			/obj/item/reagent_containers/food/snacks/bearsteak,
			/obj/item/reagent_containers/food/snacks/enchiladas,
			/obj/item/reagent_containers/food/snacks/stewedsoymeat,
			/obj/item/reagent_containers/food/snacks/burger/bigbite,
			/obj/item/reagent_containers/food/snacks/burger/superbite,
			/obj/item/reagent_containers/food/snacks/burger/fivealarm,
	)

/obj/effect/spawner/lootdrop/food_or_drink/condiment
	name = "condiment spawner"
	loot = list(
		/obj/item/reagent_containers/food/condiment/saltshaker = 3,
		/obj/item/reagent_containers/food/condiment/peppermill = 3,
		/obj/item/reagent_containers/food/condiment/pack/ketchup = 3,
		/obj/item/reagent_containers/food/condiment/pack/hotsauce = 3,
		/obj/item/reagent_containers/food/condiment/pack/astrotame = 3,
		/obj/item/reagent_containers/food/condiment/pack/bbqsauce = 3,
		/obj/item/reagent_containers/food/condiment/bbqsauce = 1,
		/obj/item/reagent_containers/food/condiment/soysauce = 1,
	)

/obj/effect/spawner/lootdrop/medical
	name = "medical loot spawner"
	desc = "Doc, gimmie something good."

/obj/effect/spawner/lootdrop/medical/minor_healing
	name = "minor healing spawner"
	loot = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/gauze,
	)

/obj/effect/spawner/lootdrop/engineering
	name = "engineering loot spawner"
	desc = "All engineering related spawners go here"

/obj/effect/spawner/lootdrop/engineering/flashlight
	name = "flashlight spawner"
	loot = list(
		/obj/item/flashlight = 20,
		/obj/item/flashlight/flare = 10,
		/obj/effect/spawner/lootdrop/glowstick = 10,
		/obj/item/flashlight/lantern = 5,
		/obj/item/flashlight/seclite = 4,
	)
