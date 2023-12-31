"""
puzzle_generator.py

This is a driver script that can be used to generate new zebra puzzles.
"""

import sys
import random
from collections.abc import Iterable
from itertools import product
from icecream import ic  # pyright: ignore[reportMissingTypeStubs]

from clues import (
	Clue,
	beside,
	consecutive,
	found_at,
	left_of,
	not_at,
	one_between,
	right_of,
	same_house,
	two_between,
)

#from elements import PuzzleElement, Smoothie, TraptorPrimary, TraptorSecondary, TraptorTertiary
from elements import *
from puzzle import Puzzle
from sat_utils import itersolve

def generate_found_at(puzzle, solution):
	"""Generate the `found_at` / `not_at` Clue instances"""

	clues = set()

	for element, loc in solution.items():
		clues.add(found_at(element, loc))

		for house in puzzle.houses:
			if house != loc:
				clues.add(not_at(element, house))

	return clues

def generate_same_house(puzzle, solution):
	"""Generate the `same_house` Clue instances"""

	clues = set()

	for house in puzzle.houses:
		items_at_house = {item: loc for item, loc in solution.items() if loc == house}
		pairs = {
			(item1, item2) for item1, item2 in product(items_at_house, repeat=2) if item1 != item2
		}

		for pair in pairs:
			clues.add(same_house(pair[0], pair[1], puzzle.houses))

	return clues

def generate_consecutive_beside(puzzle, solution):
	"""Generate the `consecutive` / `beside` Clue instances

	(Note that consecutive is just a more informative version of beside. Since they have the same
	structure, for every possible combination we'll just keep one.
	"""

	clues = set()

	for left, right in zip(puzzle.houses, puzzle.houses[1:]):
		items_left = {item: loc for item, loc in solution.items() if loc == left}
		items_right = {item: loc for item, loc in solution.items() if loc == right}
		pairs = {
			(item1, item2) for item1, item2 in product(items_left, items_right)
		}

		for pair in pairs:
			# consecutive is just a more informative version of beside, but they have same structure
			# because of this, don't include both
			if random.randint(0, 1) == 0:
				clues.add(consecutive(pair[0], pair[1], puzzle.houses))
			else:
				clues.add(beside(pair[0], pair[1], puzzle.houses))

	return clues

def generate_left_right_of(puzzle, solution):
	"""Generate the `left_of` / `right_of` Clue instances

	Note that since (x left-of y) is guaranteed to be redundant with (b right-of a), we only add
	one of these clues to the final set.
	"""

	clues = set()

	for left, right in product(puzzle.houses, puzzle.houses):
		if left >= right:
			continue

		items_left = {item: loc for item, loc in solution.items() if loc == left}
		items_right = {item: loc for item, loc in solution.items() if loc == right}
		pairs = {
			(item1, item2) for item1, item2 in product(items_left, items_right)
		}

		for pair in pairs:
			if random.randint(0, 1) == 0:
				clues.add(left_of(pair[0], pair[1], puzzle.houses))
			else:
				clues.add(right_of(pair[1], pair[0], puzzle.houses))

	return clues

def generate_one_between(puzzle, solution):
	"""Generate the `one_between` Clue instances"""

	clues = set()

	for left, right in zip(puzzle.houses, puzzle.houses[2:]):
		items_left = {item: loc for item, loc in solution.items() if loc == left}
		items_right = {item: loc for item, loc in solution.items() if loc == right}
		pairs = {
			(item1, item2) for item1, item2 in product(items_left, items_right)
		}

		for pair in pairs:
			clues.add(one_between(pair[0], pair[1], puzzle.houses))

	return clues

def generate_two_between(puzzle, solution):
	"""Generate the `two_between` Clue instances"""

	clues = set()

	for left, right in zip(puzzle.houses, puzzle.houses[3:]):
		items_left = {item: loc for item, loc in solution.items() if loc == left}
		items_right = {item: loc for item, loc in solution.items() if loc == right}
		pairs = {
			(item1, item2) for item1, item2 in product(items_left, items_right)
		}

		for pair in pairs:
			clues.add(two_between(pair[0], pair[1], puzzle.houses))

	return clues

def has_unique_solution(puzzle, clues):
	"""Test if a puzzle has a unique solution under a given set of clues."""

	with puzzle.with_clues(clues):
		print(f"Testing puzzle with {len(puzzle.clues)} clues")
		solutions = itersolve(puzzle.as_cnf())
		_first_solution = next(solutions)

		# test if second solution exists or not; if it doesn't, uniquely solvable
		return next(solutions, None) is None

def try_to_remove(puzzle, clues, n):
	"""
	Attempt to remove n clues from a set of candidate clues; if we are able to, return the new,
	smaller set of clues. If not, return the original set.
	"""

	def weight(clue):
		# relative probabilities of each type of clue being selected for removal
		weights = {
			not_at: 0.75,
			found_at: 0.75,
			same_house: 0.75,
			left_of: 1.2,
			right_of: 1.2,
			beside: 1.2,
			one_between: 1.5,
			two_between: 1.5,
		}

		return weights.get(type(clue), 1)

	weights = [weight(clue) for clue in clues]
	candidates = set(random.choices(list(clues), weights, k=n))

	clues = clues.difference(candidates)

	if has_unique_solution(puzzle, clues):
		print(f"Removed {len(candidates)} clues.")
		return clues

	# we needed at least one of those, add them all back
	clues = clues | candidates
	return clues

def reduce_individually(puzzle, clues, removed):
	"""
	Attempt to remove each candidate clue one by one.

	The sets `clues` and `removed` are modified in-place. Unnecessary clues get removed from `clues`
	and added to `removed`. If no clues can be removed, we return the original two sets.
	"""

	candidates = random.sample(tuple(clues), len(clues))

	for clue in candidates:
		clues.remove(clue)

		if has_unique_solution(puzzle, clues):
			print(f"Removed {clue=}")
			removed.add(clue)
			continue  # we were fine to remove this clue

		clues.add(clue)

	return clues, removed

def reduce_clues(puzzle, clues):
	"""
	Reduce a set of clues to a minimally solvable set.

	A minimally solvable 5-house, 4-attribute puzzle takes between 10 and 20 clues to solve. The
	original set of clues will likely be in the hundreds, and the majority are likely to be
	redundant. We can quickly reduce the set of clues by batch removing clues from the large
	candidate pool.

	The algorithm for batch reduction:
	 1. shuffle all the clues
	 2. attempt to remove 10% of the clues; with this 90%-clue set, test if the puzzle is solvable.
	 3a. if yes: keep them removed, go back to 2 and repeat
	 3b. if no: add them back, keep going to 4
	 4. the same as step (3), but this time trying to remove 5% of the clues
	 5. the same as step (3), but this time trying to remove a single clue

	After we've tried and failed to remove a *single* clue, then the (first part of the) reduction
	algorithm is done; having that clue was necessary for us to have a unique solution. This doesn't
	necessarily mean that *all* the clues are need, though, which is what the secondary reduction
	is for.

	The *secondary reduction process* is much simpler: now that the set is narrowed substantially,
	we can be more brute-forcey. Attempt to remove each clue and see if the puzzle is still
	solvable.

	However, the secondary reduction process can result in a puzzle that is *too hard* to solve
	(though technically uniquely solvable by a computer or sufficiently skilled human). This
	algorithm returns a second set of clues that were removed during the secondary reduction
	process. These can be thought of as extra clues to add or hints to give to anyone solving the
	puzzle.

	"""

	# this is a stupid way to shuffle the set of clues without modifying it
	minimal_clues = set(random.sample(tuple(clues), k=len(clues)))

	while True:
		print(f"There are {len(minimal_clues)} clues in ba sing se")

		# Walrus time!
		#
		# If the size of minimal_clues before we try to remove some clues is greater than the size
		# after, then those clues were fine to remove. Go back to the top of the loop and keep
		# removing more. But if the size is the same, we needed some of those clues. Try to remove
		# a smaller amount.
		#
		# We use the walrus operator to update minimal_clues in place during the comparison. It'll
		# either be a reduced set of clues or the original set of clues.
		if len(minimal_clues) > len(minimal_clues := try_to_remove(puzzle, minimal_clues, len(minimal_clues) // 10)):
			continue

		if len(minimal_clues) != len(minimal_clues := try_to_remove(puzzle, minimal_clues, len(minimal_clues) // 20)):
			continue

		if len(minimal_clues) == len(minimal_clues := try_to_remove(puzzle, minimal_clues, 1)):
			break

	# secondary reduction time! While we can still remove clues, do so; then we're done.
	print("Starting the secondary reduction.")
	removed_clues = set()

	while True:
		minimal_clues_size = len(minimal_clues)
		minimal_clues, removed_clues = reduce_individually(puzzle, minimal_clues, removed_clues)

		if len(minimal_clues) == minimal_clues_size:
			break

	return minimal_clues, removed_clues

def main(params):
	ic.configureOutput(outputFunction=print)
	random.seed()
	element_types1 = [Kiro, Smoothie, Bottlecap, NPC, FavoriteGame, Tribe, Egg, Colour, Nationality, Animal, Drink, Male, Flower, Food, Female]
	element_types = []

	# Size of puzzle = number of "houses" or whatever
	# NB: MUST ONLY BE 4 or 5!
	puzzle_size = int(params[0])

	random.shuffle(element_types1)
	
	for _ in range(puzzle_size):
		element_types.append(element_types1.pop())

	if element_types[0] == Male:
		element_types[0] = Female
		element_types[1] = Male
	elif element_types[1] == Male:
		element_types[0] = Female
	elif element_types[2] == Male:
		element_types[0] = Female
	elif element_types[3] == Male:
		element_types[0] = Female
	elif puzzle_size == 5 and element_types[4] == Male:
		element_types[0] = Female

	# Some elements have extra members, and we need to randomize the solution
	# random.sample takes N (puzzle_size) values without replacement
	puzzle_elements = {
		# Smoothie: [Smoothie.lilac, Smoothie.earth, ...],
		# TraptorPrimary: [TraptorPrimary.marvellous, TraptorPrimary.heroic, ...]
		# etc ...
	}

	for element in element_types:
		members = list(element.__members__.values())
		puzzle_elements[element] = random.sample(members, puzzle_size)

	# Construct the solution now
	solution = {
		# Smoothie.lilac: 1,
		# Smoothie.earth: 2,
		# ...,
		# TraptorPrimary.marvellous: 1,
		# TraptorPrimary.heroic: 2,
		# ...,
	}

	for element, members in puzzle_elements.items():
		solution.update({el: pos + 1 for pos, el in enumerate(members)})

	# set up the puzzle with default constraints
	puzzle = Puzzle (
		element_types = element_types,
		elements = solution.keys(),
		n_houses = puzzle_size,
	).set_constraints()

	print(f"\nOriginal puzzle\n{'-' * 30}")
	ic(puzzle)

	# generate all the clues
	clues = set()

	for generate_function in (
		generate_found_at,
		generate_same_house,
		generate_consecutive_beside,
		generate_left_right_of,
		generate_one_between,
		generate_two_between,
	):
		clues = clues.union(generate_function(puzzle, solution))

	print(f"\nStarting puzzle reduction ...\n{'-' * 30}")
	reduced, extras = reduce_clues(puzzle, clues)

	for clue in reduced:
		puzzle.add_clue(clue)

	print(f"\nNarrowed puzzle\n{'-' * 15}")
	ic(puzzle)
	print(f"\nSupplemental clues\n{'-' * 18}")

	for clue in extras:
		print(f" - {clue}")

	print()
	print(f"\nSolution\n{'-' * 8}")

	for index in range(puzzle_size):
		print(f"({index+1}) |>")
		print(*[f"- {elements[index]}" for _, elements in puzzle_elements.items()], sep="\n")
		print()

if __name__ == "__main__":
	main(sys.argv[1:])
