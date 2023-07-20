"""
literals.py

This is a collection of 'puzzle elements', categories, literals, whatever you want to call
them, which are used as the building blocks of zebra puzzles. Examples include people's
favorite colors, preferred drinks, pets, etc.

Each class must provide (but we have no way of enforcing this) a description of each
puzzle element. These get used to make human-readable clues. The classes must also provide
a custom __repr__ method that gets used in the puzzle description.

Included is a base Literal class from which all literals should inherit. To extend these,
just import Literal and implement a class like the ones here.
"""

from enum import Enum

class PuzzleElement(Enum):
	"""
	Common parent class for all puzzle elements (colors, occupations, pets, etc.).

	We can't make this an ABC because ABC and Enum have different metaclasses, and that'd be
	super confusing. But override the description method!
	"""

	@classmethod
	def description(cls):
		return "".join(cls.__members__)  # type:ignore

class Kiro(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each house has a different type of Kiro"

	kaya = "the Kaya Kiro"
	sugar_sketch = "the Sugar Sketch Kiro"
	silosaur = "the Kiro disguised as a Silosaur"
	skyrant = "the Kiro in a Skyrant costume "
	traptor_costume = "the Kiro in a Traptor costume"
	terasaur_costume = "the Terasaur Costume Kiro"
	skeleko = "the Skeleko Kiro"
	zodiac_dragon = "the Zodiac Dragon Kiro"
	gem_dragon = "the Gem Dragon Kiro"
	plushie = "the Plushie Kiro"
	gloray = "the Gloray Kiro"
	rabbit = "the Rabbit Kiro"
	holiday_sweets = "the Holiday Sweets Kiro"
	baby = "the Baby Kiro"
	zaeris = "the Zaeris Kiro"

class Smoothie(PuzzleElement):
	@classmethod
	def description(cls):
		return "Everyone has a favorite smoothie"

	cherry = "the adoptable who likes Cherry smoothies"
	desert = "the Desert smoothie lover"
	watermelon = "the Watermelon smoothie lover"
	dragonfruit = "the Dragonfruit smoothie lover"
	lime = "the adoptable who drinks Lime smoothies"
	blueberry = "the adoptable who drinks Blueberry smoothies"
	lemon = "the Lemon smoothie lover"
	dusk = "the adoptable whose favorite smoothie is Dusk"
	dawn = "the adoptable who likes Dawn smoothies"
	spring = "the adoptable who likes Spring smoothies"
	seafoam = "the adoptable who likes Seafoam smoothies"
	phantom_spring = "the adoptable who likes Phantom Spring smoothies"
	abyss = "the adoptable whose favorite smoothie is Abyss"
	butterscotch = "the Butterscotch smoothie drinker"
	lilac = "the Lilac smoothie drinker"
	sakura = "the adoptable whose favorite smoothie is Sakura"
	life = "the Life smoothie drinker"
	darkness = "the Darkness smoothie drinker"
	earth = "the adoptable who likes Earth smoothies"

class Bottlecap(PuzzleElement):
	@classmethod
	def description(cls):
		return "Everyone collects a certain type of Bottlecap"

	red = "the person who has red bottlecaps"
	yellow = "the person who likes yellow Caps"
	green = "the green bottle cap keeper"
	blue = "the blue bottlecap hoarder"
	silver = "the silver cap winner"
	gold = "the person who collects gold bottlecaps"
	teal = "the teal bottlecap collector"

class RecolorMedal(PuzzleElement):
	@classmethod
	def description(cls):
		return "Everyone has a recolor or medal"

	top_level = "the top level adoptable"
	second_ed = "the 2nd edition adoptable"
	ghost = "the ghost recolor"
	pink = "the pink adoptable"
	gold = "the adoptable with a heart of gold"

class NPC(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each is an NPC on the site"

	dirt_digger_jim = "Dirt Digger Jim"
	amelia = "Amelia"
	fishin_chip = "Fishin' Chip"
	ringmaster_riley = "Ringmaster Riley"
	crowley = "Crowley"
	silver_the_kua = "Silver the Kua"
	jagger = "Jagger"

class FavoriteGame(PuzzleElement):
	@classmethod
	def description(cls):
		return "Everyone has a favorite game"

	dirt_digger = "the person who likes Dirt Digger"
	guess_the_number = "the one who plays Guess the Number"
	fishing_fever = "the Fishing Fever lover"
	sock_summoning = "the person who plays Sock Summoning"
	wonder_wheel = "the person who spins the Wonder Wheel"
	fetch = "the person playing Fetch"
	quality_assurance = "the person who plays Quality Assurance"
	stop_and_swap = "the one who often plays Stop and Swap"
	uchi_fusion = "the one who plays Uchi Fusion"
	freedom_forest = "the one in Freedom Forest"

class Tribe(PuzzleElement):
	@classmethod
	def description(cls):
		return "Everyone has an Altazan tribe"

	quake = "the one in the Quake tribe"
	cursed = "the Cursed tribe member"
	forest = "the Forest tribe member"
	volcano = "the person in the Volcano tribe"
	storm = "the person in the Storm tribe"

class Kaya(PuzzleElement):
	@classmethod
	def description(cls):
		return "They are five different types of Kaya"

	joy = "the Kaya of Joy"
	life = "the Kaya of Life"
	harmony = "the Kaya of Harmony"
	wisdom = "the Kaya of Wisdom"
	love = "the Kaya of Love"

class TraptorPrimary(PuzzleElement):
	@classmethod
	def description(cls):
		return "They have different primary colors"

	majestic = "the Majestic Traptor"
	grand = "the Grand Traptor"
	stunning = "the Stunning Traptor"
	marvellous = "the Marvellous Traptor"
	heroic = "the Heroic Traptor"

class TraptorSecondary(PuzzleElement):
	@classmethod
	def description(cls):
		return "They have different secondary colors"

	sky = "the Sky Traptor"
	forest = "the Forest Traptor"
	night = "the Night Traptor"
	sun = "the Sun Traptor"
	sand = "the Sand Traptor"

class TraptorTertiary(PuzzleElement):
	@classmethod
	def description(cls):
		return "They have different tertiary colors"

	soarer = "the Soarer Traptor"
	diver = "the Diver Traptor"
	screecher = "the Screecher Traptor"
	hunter = "the Hunter Traptor"
	nurturer = "the Nurturer Traptor"

class Egg(PuzzleElement):
	@classmethod
	def description(cls):
		return "They are each giving out a type of egg"

	golden = "the one giving out Golden Eggs"
	trollden = "the one who keeps Trollden Eggs"
	topaz = "the one with Topaz Eggs"
	crystal = "the one giving out Crystal Eggs"
	traptor = "the one who has Traptor Eggs"
	marinodon = "the one giving out Marinodon Eggs"

class Dinomon(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each is a different species of Dinomon"

	terasaur = "the Terasaur"
	carnodon = "the Carnodon"
	silosaur = "the Silosaur"
	marinodon = "the Marinodon"
	traptor = "the Traptor"

class UchiType(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each is a different type of Uchi"

	skunk = "the Skunk Uchi"
	eyes = "the Eyes Uchi"
	umbral = "the Umbral Uchi"
	mummy = "the Mummy Uchi"

class UchiPrimary(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each Uchi has a different body color"

	blue = "the blue body Uchi"
	red = "the Uchi with a red body"
	yellow = "the yellow body Uchi"
	green = "the Uchi with a green body"

class UchiSecondary(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each Uchi has a different secondary color (e.g., eyes, umbral, etc.)"

	black = "the Uchi with secondary color black"
	orange = "the Uchi with secondary color orange"
	purple = "the Uchi with secondary color purple"
	white = "the Uchi with secondary color white"

class Colour(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each person has a favorite color"

	yellow = "the person who loves yellow"
	red = "the person whose favorite color is red"
	white = "the person who loves white"
	green = "the person whose favorite color is green"
	blue = "the person who loves blue"
	black = "the person whose favorite color is black"
	purple = "the person who loves purple"

class Nationality(PuzzleElement):
	@classmethod
	def description(cls):
		return "They are all of different nationalities"

	dane = "the Dane"
	brit = "the British person"
	swede = "the Swedish person"
	norwegian = "the Norwegian"
	german = "the German"
	french = "the French person"
	american = "the American"
	spaniard = "the Spaniard"
	brazilian = "the Brazilian person"

class Animal(PuzzleElement):
	@classmethod
	def description(cls):
		return "They keep different animals"

	horse = "the person who keeps horses"
	cat = "the cat lover"
	bird = "the bird keeper"
	fish = "the fish enthusiast"
	dog = "the dog owner"
	snake = "the snake lover"
	pig = "the pig keeper"

class Drink(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each person has a favorite drink"

	water = "the one who only drinks water"
	tea = "the tea drinker"
	milk = "the person who likes milk"
	coffee = "the coffee drinker"
	root_beer = "the root beer lover"
	coke = "the person who drinks coke"
	ribena = "the ribena lover"
	ginger_beer = "the person who drinks ginger beer"

class Cigar(PuzzleElement):
	@classmethod
	def description(cls):
		return "Everyone has a favorite cigar"

	pall_mall = "the person partial to Pall Mall"
	prince = "the Prince smoker"
	blue_master = "the person who smokes Blue Master"
	dunhill = "the Dunhill smoker"
	blends = "the person who smokes many different blends"

class Male(PuzzleElement):
	@classmethod
	def description(cls):
		return "Each is accompanied by their partner"

	eric = "Erid"
	fred = "Fred"
	john = "John"
	paul = "Paul"
	timothy = "Timothy"
	graham = "Graham"

class Flower(PuzzleElement):
	@classmethod
	def description(cls):
		return "They all have a favorite flower"

	carnations = "a carnations arrangement"
	daffodils = "a bouquet of daffodils"
	lilies = "the bouquet of lilies"
	roses = "the rose bouquet"
	tulips = "the vase of tulips"
	orchids = "the orchids"
	peonies = "the bouquet of peonies"

class Food(PuzzleElement):
	@classmethod
	def description(cls):
		return "They all have a favourite food"

	grilled_cheese = "the person eating grilled cheese"
	pizza = "the pizza lover"
	spaghetti = "the spaghetti eater"
	stew = "the one having stew"
	stir_fry = "the person with stir fry"
	chinese = "the chinese eater"
	sushi = "the one having sushi"

class Female(PuzzleElement):
	@classmethod
	def description(cls):
		return "They each have a different name"

	aniya = "Aniya"
	holly = "Holly"
	janelle = "Janelle"
	kailyn = "Kailyn"
	penny = "Penny"
	robyn = "Robyn"
	emma = "Emma"

__all__ = [
	"PuzzleElement",
	"Kiro",
	"Smoothie",
	"Bottlecap",
	"RecolorMedal",
	"NPC",
	"FavoriteGame",
	"Tribe",
	"Kaya",
	"TraptorPrimary",
	"TraptorSecondary",
	"TraptorTertiary",
	"Egg",
	"Dinomon",
	"UchiType",
	"UchiPrimary",
	"UchiSecondary",
	"Colour",
	"Nationality",
	"Animal",
	"Drink",
	"Cigar",
	"Male",
	"Flower",
	"Food",
	"Female",
]
