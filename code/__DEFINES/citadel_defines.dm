//Global defines for most of the unmentionables.
//Be sure to update the min/max of these if you do change them.
//Measurements are in imperial units. Inches, feet, yards, miles. Tsp, tbsp, cups, quarts, gallons, etc

//organ defines
#define BUTT_LAYER_INDEX		1
#define VAGINA_LAYER_INDEX		2
#define TESTICLES_LAYER_INDEX	3
#define GENITAL_LAYER_INDEX		4
#define PENIS_LAYER_INDEX		5

#define GENITAL_LAYER_INDEX_LENGTH 5 //keep it updated with each new index added, thanks.

//genital flags
#define GENITAL_BLACKLISTED		(1<<0) //for genitals that shouldn't be added to GLOB.genitals_list.
#define GENITAL_INTERNAL		(1<<1)
#define GENITAL_HIDDEN			(1<<2)
#define GENITAL_THROUGH_CLOTHES	(1<<3)
#define GENITAL_FUID_PRODUCTION	(1<<4)
#define CAN_MASTURBATE_WITH		(1<<5)
#define MASTURBATE_LINKED_ORGAN	(1<<6) //used to pass our mission to the linked organ
#define CAN_CLIMAX_WITH			(1<<7)
#define GENITAL_CAN_AROUSE		(1<<8)
#define GENITAL_UNDIES_HIDDEN	(1<<9)
#define UPDATE_OWNER_APPEARANCE	(1<<10)

#define DEF_VAGINA_SHAPE	"Human"

#define COCK_SIZE_DEF		6

#define COCK_DIAMETER_RATIO_MAX		0.42
#define COCK_DIAMETER_RATIO_DEF		0.25
#define COCK_DIAMETER_RATIO_MIN		0.15

#define DEF_COCK_SHAPE		"Human"

#define BALLS_VOLUME_BASE	25
#define BALLS_VOLUME_MULT	1

#define DEF_BALLS_SHAPE		"Single"

#define BALLS_SIZE_MIN		1
#define BALLS_SIZE_DEF		2
#define BALLS_SIZE_MAX		3

#define CUM_RATE			2 // units per 10 seconds
#define CUM_RATE_MULT		1
#define CUM_EFFICIENCY		1 //amount of nutrition required per life()

#define BREASTS_VOLUME_BASE	50	//base volume for the reagents in the breasts, multiplied by the size then multiplier. 50u for A cups, 850u for HH cups.
#define BREASTS_VOLUME_MULT	1	//global multiplier for breast volume.

#define BREASTS_SIZE_DEF	"c" //lowercase cause those sprite accessory don't use uppercased letters.

#define DEF_BREASTS_SHAPE	"Pair"

#define MILK_RATE			3
#define MILK_RATE_MULT		1
#define MILK_EFFICIENCY		1

#define BUTT_SIZE_DEF		1
#define BUTT_SIZE_MAX		5  //butt genitals are special in that they have caps. if there's the event there's even bigger butt sprites, raise this number.

//visibility toggles defines to avoid errors typos code errors.
#define GEN_VISIBLE_ALWAYS "Always visible"
#define GEN_VISIBLE_NO_CLOTHES "Hidden by clothes"
#define GEN_VISIBLE_NO_UNDIES "Hidden by underwear"
#define GEN_VISIBLE_NEVER "Always hidden"

//Citadel istypes
#define isgenital(A) (istype(A, /obj/item/organ/genital))

#define CRAWLUNDER_DELAY							30 //Delay for crawling under a standing mob

//Citadel toggles because bitflag memes
#define BREAST_ENLARGEMENT	(1<<0)
#define PENIS_ENLARGEMENT	(1<<1)
#define FORCED_FEM			(1<<2)
#define FORCED_MASC			(1<<3)
#define HYPNO				(1<<4)
#define NEVER_HYPNO			(1<<5)
#define NO_APHRO			(1<<6)
#define NO_ASS_SLAP			(1<<7)
#define BIMBOFICATION		(1<<8)

#define TOGGLES_CITADEL (BREAST_ENLARGEMENT|PENIS_ENLARGEMENT)

//special species definitions
#define MINIMUM_MUTANT_COLOR	"#202020" //this is how dark players mutant parts and skin can be
