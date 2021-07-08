#!/usr/bin/env python3

observations = [
    "12233344456223566146",
    "23322145614552234456"
]

# Prepare dictionary of trigrams and counts
counts = dict()
for obs in observations:
    for i in range(len(obs) - 2):
        trigram = obs[i: i + 3]
        indx = tuple(trigram)
        if indx not in counts:
            counts[indx] = 0
        counts[indx] += 1

test = input("Enter the first two rolls : ")

# Prepare dictionary of possible third number and their frequencies
outcomes = dict()
for (r0, r1, r2), count in counts.items():
    if r0 != test[0] or r1 != test[1]:
        continue
    outcomes[r2] = count

if len(outcomes) == 0:
    print("No sequences of this form appeared before!")
else:
    # Calculate probability
    total = 0
    best = None
    for c, count in outcomes.items():
        total += count
        if count > outcomes.get(best, 0):
            best = c
    print("Most probable number is {}, with probability {}.".format(best, outcomes[best] / total))
