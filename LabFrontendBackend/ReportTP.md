# TP Frontend/Backend ASIC
## Analyse
### Résumé des résultats
Les résultats obtenus pour les différentes valeurs du facteur de déroulement (Unroll Factor) montrent des tendances claires sur plusieurs paramètres clés :

| Unroll Factor   | Période d'Horloge Optimale (ps)   |Surface des Portes (µm²)   |Consommation d'Énergie (W)   |Débit (s$^{-1}$)          |Efficacité Énergétique (J)|
| --- | --- | --- | --- | --- | --- |
|1                |2791             |3649.140     |1.12420e-03           |11196703.69     |0.78441055e-12|
|2                |4050             |7594.110     |1.43919e-03           |15432098.77     |1.457179875e-12|
|4                |7707             |16551.090    |2.14263e-03           |16219021.67     |4.128312353e-12|
|8                |14897            |34417.512    |4.50474e-03           |16781902.4      |16.77677795e-12|
|16               |29401            |71090.514    |5.28220e-03           |17006224.28     |38.82549055e-12|

-**Fréquence d'horloge maximale** : (`Clock Period`) augmente avec le facteur de déroulement (`Unroll Factor`), ce qui signifie que la fréquence d'horloge maximale diminue.
Le facteur de déroulement(`Unroll Factor`) 1 permet d'atteindre la fréquence la plus élevée, mais au prix d'un débit plus faible.
-**Surface de portes logiques** : Une augmentation du facteur de déroulement entraîne une augmentation significative de la surface, ce qui peut poser problème pour des contraintes de taille de puce.
-**Consommation totale** : Plus le facteur de déroulement est élevé, plus la consommation augmente. Cela est dû à la complexité accrue du circuit.
-**Débit** : Le débit augmente avec le facteur de déroulement, ce qui est un point positif pour des applications nécessitant un traitement rapide.
-**Efficacité énergétique** : L'efficacité énergétique se dégrade avec l'augmentation du facteur de déroulement, ce qui signifie que les configurations avec un facteur de déroulement plus élevé sont moins efficaces en termes de consommation d'énergie par opération de cryptographie.

## Conclusion
Pour déterminer la meilleure configuration, il faut trouver un équilibre entre plusieurs critères : la fréquence d'horloge maximale, la surface de portes logiques, la consommation d'énergie, et le débit de cryptographie. Les résultats montrent que :
- **Si la fréquence d'horloge maximale est prioritaire**, choisissez un facteur de déroulement plus bas, comme 1 ou 2.
- **Si le débit est prioritaire et les ressources sont disponibles**, choisissez un facteur de déroulement plus élevé, comme 8 ou 16.
- **Pour une meilleure efficacité énergétique**, optez pour un facteur de déroulement plus bas, comme 1 ou 2.

En fonction des nos besoins spécifiques de l'application, un compromis devra être trouvé. Si la priorité est donnée à une haute fréquence d'horloge et une faible consommation d'énergie, un facteur de déroulement bas comme 1 ou 2 est recommandé. Si le débit est le critère principal et que des ressources supplémentaires sont disponibles, un facteur de déroulement plus élevé comme 8 ou 16 pourrait être justifié.

En général, le **facteur de déroulement 2** semble être une solution équilibrée, offrant une bonne combinaison de débit, consommation d'énergie, et efficacité énergétique. Cette configuration permet de maintenir une fréquence d'horloge acceptable tout en offrant une amélioration significative du débit par rapport au facteur de déroulement 1. De plus, la surface de portes logiques et la consommation restent à des niveaux gérables, ce qui peut être crucial pour les applications où les ressources sont limitées. Toutefois, le choix final dépendra toujours des exigences spécifiques de notre application et des contraintes du projet. Si l'application nécessite une haute performance avec un débit maximal et qu'on peut accepter une augmentation de la consommation d'énergie et de la surface, alors une configuration avec un facteur de déroulement plus élevé pourrait être appropriée. En revanche, si l'efficacité énergétique et la conservation des ressources sont prioritaires, un facteur de déroulement plus bas sera plus avantageux.
