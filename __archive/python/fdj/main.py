import random

numeros = [i+1 for i in range(50)]
print(numeros)

for alea in range(random.randrange(100000)):
    random.randrange(50)

#construire 10 grilles
for grille in range(10):
    print(('Grille {0}').format(grille+1))
    for boule in range(5):
        tirage = random.randrange((len(numeros)))
        print(numeros[tirage],end=',')
        del numeros[tirage]
    print()
    print(
        random.randrange(10)+1, ' / ',
        random.randrange(10)+1)

assert(len(numeros) == 0)
