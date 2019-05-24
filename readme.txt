Projet de BE CHTI 2019
Binôme : Louis Chauvet
         Laura Burlon-Roux
         
Localisation du projet final : /ASM/FINAL/Project.uvprojx


Le programme fonctionne sans erreur lorsqu'il est implanté sur malette : une cible s'allume avec sa led associée,
et une fois qu'elle a été atteinte par un tir deux fois, elle s'éteint (ainsi que sa led) et une nouvelle cible aléatoire s'allume
avec sa led associée. Chaque tir incrémente le score du joueur qui a tiré, et joue le son de marquage de point
(à savoir : il y a un décalage de 1 entre la numérotation des pistolets et des joueurs :
les joueurs 1, 2, 3 et 4 sont associés respectivements aux pistolets P2, P3, P4 et P5).


descriptif des fichiers linkés:

-callback.s : fonction lançant le son lors d'un marquage de point
-etat.inc : structure et constantes utilisées pour la lecture de fichiers sons
-Trigo.asm : table de valeur des cosinus et sinus pour la lecture de fichiers sons
-dft.s : fonction renvoyant la dft de degré k sur 64 points du signal reçu
-modcarre.s : utilise dft() pour calculer la partie reelle et imaginaire de la dft du signal et ajoute leur carré
-arghh.asm : fichier du son joué lors d'un marquage de point, codé en asm
-Affichage_Valise : librairie de fonctions utilisées pour interragir avec la valise de jeu
-gassp72.h : librairie pour interragir avec les sorties et sorties standards des microcontroleurs utilisés

