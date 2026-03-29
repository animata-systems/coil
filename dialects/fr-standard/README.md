# COIL:fr-standard — Dialecte français standard

> « Écris tes scénarios dans la langue dans laquelle tu penses. »

**Statut :** dialecte officiel, inclus dans la distribution standard.

Ce dialecte fournit un mappage idiomatique en français de toutes les constructions COIL. Chaque mot-clé est choisi pour être immédiatement compréhensible par un francophone — sans connaissances en programmation, sans détour par l'anglais.

---

## Principes de conception

1. **Impératif.** Les opérateurs sont des verbes à l'impératif : DÉFINIS, REÇOIS, PENSE. Le protocole s'adresse à l'environnement d'exécution comme à un exécutant : « fais ceci. »

2. **Français naturel.** Les mots-clés utilisent le français courant, pas le jargon technique. `ÉCRIS` plutôt que `ENVOIE` — parce qu'on dit « écris-moi » dans un messageur, pas « envoie-moi un message ». `AU PLUS` plutôt que `TIMEOUT` — parce que « au plus 10 minutes » est du français naturel.

3. **Un mot si possible.** Les formes d'un seul mot sont préférées. Les formes composées uniquement là où un seul mot serait ambigu : `RÉPONSE À`, `AU PLUS`.

4. **Indices catégoriels.** La connotation du mot indique la catégorie de l'opérateur : bloquant (`REÇOIS`, `ATTENDS`), lançant (`PENSE`, `EXÉCUTE`, `ÉCRIS`), instantané (`DÉFINIS`, `MODIFIE`).

---

## Opérateurs Core

| ID | FR | Sémantique |
|---|---|---|
| `Op.Actors` | `PARTICIPANTS` | Déclarer les participants du protocole. Ceux qui agissent dans le scénario. |
| `Op.Tools` | `OUTILS` | Déclarer les outils disponibles. Ce avec quoi les agents travaillent. |
| `Op.Define` | `DÉFINIS` | Créer une nouvelle valeur nommée. Comme en mathématiques : définir un terme. |
| `Op.Set` | `MODIFIE` | Modifier une valeur existante. Pas `DÉFINIS` — la valeur existe déjà. |
| `Op.Receive` | `REÇOIS` | Liaison bloquante depuis l'environnement. Le protocole attend que l'environnement fournisse une valeur. |
| `Op.Think` | `PENSE` | Lancer une étape cognitive LLM. Le modèle reçoit un problème et y réfléchit. |
| `Op.Execute` | `EXÉCUTE` | Appeler un outil. Couvre les appels ponctuels et les sessions interactives. |
| `Op.Send` | `ÉCRIS` | Écrire un message dans un canal. Pas `ENVOIE` — on dit « écris-moi », pas « envoie-moi ». La langue des messageurs. |
| `Op.Wait` | `ATTENDS` | Point de synchronisation. Bloquer jusqu'à ce que les promesses soient résolues. |
| `Op.Exit` | `TERMINE` | Mettre fin au protocole. Une ligne, aucun argument. |
| `Kw.End` | `FIN` | Fermer un bloc. Chaque opérateur de bloc se termine par `FIN`. |

---

## Modificateurs

### Configuration du modèle (PENSE)

| ID | FR | Sémantique |
|---|---|---|
| `Mod.Via` | `VIA` | Quel modèle LLM utiliser. `VIA $modèle_rapide` — acheminer la tâche via ce modèle. |
| `Mod.As` | `COMME` | Définition du rôle (compétences). `COMME $analyste` — pense comme cet expert. Références uniquement. |
| `Mod.Using` | `AVEC` | Outils disponibles pour le LLM. `AVEC !recherche, !calcul` — le modèle peut appeler ceux-ci. |

### Énoncé de la tâche (PENSE)

| ID | FR | Sémantique |
|---|---|---|
| `Mod.Goal` | `OBJECTIF` | But de l'étape cognitive. Ce que l'on veut atteindre. |
| `Mod.Input` | `ENTRÉE` | Énoncé du problème. Les données avec lesquelles travailler. |
| `Mod.Context` | `CONTEXTE` | Données supplémentaires, arrière-plan, contraintes. |
| `Mod.Result` | `RÉSULTAT` | Spécification de sortie structurée. Ce que le LLM doit déterminer. |

### Adressage (ÉCRIS)

| ID | FR | Sémantique |
|---|---|---|
| `Mod.To` | `VERS` | Adresse du canal. `VERS #support` — livrer à ce canal. Direction de l'envoi. |
| `Mod.For` | `POUR` | Destinataire. `POUR @expert` — ce message est pour ce participant. |
| `Mod.ReplyTo` | `RÉPONSE À` | Référence de réponse. À quel message on répond. |
| `Mod.Await` | `ATTENTE` | Politique d'attente de réponse. `ATTENTE QUELCONQUE` — attendre au moins une réponse. Nom, distinct de `ATTENDS` (verbe). |
| `Mod.Timeout` | `AU PLUS` | Délai maximum. `AU PLUS 10m` — abandonner après 10 minutes. |

### Synchronisation (ATTENDS)

| ID | FR | Sémantique |
|---|---|---|
| `Mod.On` | `CIBLE` | Promesses attendues. `CIBLE ?plan, ?données` — les cibles de l'attente. |
| `Mod.Mode` | `MODE` | Mode d'attente. Combien de promesses doivent être résolues. |
| `Pol.All` | `TOUS` | Attendre toutes les promesses listées. |
| `Pol.Any` | `QUELCONQUE` | Attendre n'importe laquelle des promesses listées. |
| `Pol.None` | `AUCUN` | Ne pas attendre de réponse. Envoyer et oublier. |
| `Mod.Timeout` | `AU PLUS` | Délai maximum. Même mot-clé que dans ÉCRIS — cohérent. |

### Appel d'outil (EXÉCUTE)

| ID | FR | Sémantique |
|---|---|---|
| `Mod.Using` | `AVEC` | Quel outil appeler. `AVEC !recherche` — obligatoire, exactement un. |

---

## Opérateurs Extended

| ID | FR | Sémantique |
|---|---|---|
| `Op.If` | `SI` | Branchement conditionnel. Déterministe, sans LLM. |
| `Op.Repeat` | `RÉPÈTE` | Boucle avec limite obligatoire. `RÉPÈTE 5` ou `RÉPÈTE JUSQUE $prêt AU PLUS 5`. |
| `Op.Each` | `CHAQUE` | Itérer sur les éléments d'une liste. `CHAQUE $tâche DE $plan.fichiers`. Invariable — pas d'accord de genre avec l'identifiant. |
| `Op.Gather` | `RASSEMBLE` | Agréger des résultats en une seule valeur. |
| `Op.Signal` | `SIGNAL` | Envoyer des données dans un flux existant. |

### Modificateurs d'itération

| ID | FR | Sémantique |
|---|---|---|
| `Mod.Until` | `JUSQUE` | Condition de sortie de boucle. `RÉPÈTE JUSQUE $prêt AU PLUS 5`. Forme simplifiée de « jusqu'à », sans apostrophe — compatible avec le lexeur. |
| `Mod.Limit` | `AU PLUS` | Plafond d'itérations (dans RÉPÈTE). Obligatoire — les boucles sans limite sont invalides. |
| `Mod.From` | `DE` | Source de la liste pour itération. `CHAQUE $élément DE $liste`. |

---

## Types de RÉSULTAT

| ID | FR | Sémantique |
|---|---|---|
| `Typ.Text` | `TEXTE` | Valeur chaîne de caractères. |
| `Typ.Number` | `NOMBRE` | Valeur numérique. |
| `Typ.Flag` | `MARQUEUR` | Valeur booléenne. Marqué ou non — comme une case à cocher. |
| `Typ.Choice` | `CHOIX(...)` | Enum — l'une des valeurs listées. |
| `Typ.List` | `LISTE` | Tableau d'éléments structurés. |

---

## Suffixes de durée

| ID | FR | Sémantique |
|---|---|---|
| `Dur.Seconds` | `s` | Secondes. |
| `Dur.Minutes` | `m` | Minutes. |
| `Dur.Hours` | `h` | Heures. |

---

## Résolution contextuelle

`AU PLUS` est mappé sur deux identifiants abstraits. Le contexte de l'opérateur détermine sans ambiguïté lequel est visé :

| Phrase | Contexte | ID abstrait |
|---|---|---|
| `AU PLUS` | À l'intérieur de `ÉCRIS` ou `ATTENDS` | `Mod.Timeout` |
| `AU PLUS` | À l'intérieur de `RÉPÈTE` | `Mod.Limit` |

« Au plus 10 minutes » (délai) et « au plus 5 fois » (limite d'itérations) — une seule expression naturelle couvre les deux cas.

---

## Exemple : agent de recherche

```coil
' ═══════════════════════════════════════
' Environnement
' ═══════════════════════════════════════
PARTICIPANTS expert, auteur
OUTILS recherche

' ═══════════════════════════════════════
' Rôles — profils d'expertise pour le LLM.
' Quelles connaissances et quelle approche
' le LLM doit adopter pour la tâche.
' ═══════════════════════════════════════
DÉFINIS compétence_recherche
<<
Tu es un analyste-chercheur.
Tu travailles avec des requêtes non structurées.
Tu cherches toujours les sources primaires et indiques
ton degré de confiance dans tes conclusions.
Tu évites les spéculations.
Si les données sont insuffisantes — tu le dis clairement.
>>
FIN

DÉFINIS expertise_domaine
<<
Tu maîtrises l'analyse produit.
Tu connais les métriques de rétention, d'activation et de churn.
Tu sais lire les funnels et les rapports de cohorte.
Dans ton analyse, tu distingues toujours
la corrélation de la causalité.
>>
FIN

' ═══════════════════════════════════════
' Données d'entrée — l'environnement doit fournir
' ces valeurs avant que le protocole ne continue.
' ═══════════════════════════════════════
REÇOIS requête
<<
Requête utilisateur pour la recherche.
>>
FIN

REÇOIS historique
<<
Historique des requêtes précédentes sur ce sujet.
>>
FIN

REÇOIS dossier_id
<<
Identifiant du dossier en cours.
>>
FIN

' ═══════════════════════════════════════
' 1. Énoncé de la tâche — structuré comme un
'    problème de mathématiques :
'    COMME    — rôle / profil d'expert
'    OBJECTIF — ce que l'on veut atteindre
'    ENTRÉE   — données du problème
'    CONTEXTE — informations de fond
'    RÉSULTAT — ce qu'il faut déterminer
'
' PENSE s'exécute en arrière-plan. Crée une
' promesse de résultat ?analyse et un flux
' en direct ~analyse. Les entrées peuvent être
' complétées pendant la réflexion via SIGNAL.
' ═══════════════════════════════════════
PENSE analyse
  COMME $compétence_recherche, $expertise_domaine
  OBJECTIF <<
  Préparer une réponse fondée avec des sources.
  >>
  ENTRÉE <<
  Recherche la requête de l'utilisateur. Intègre
  toutes les données qui arrivent via le flux
  pendant l'analyse.
  >>
  CONTEXTE <<
  Requête : $requête
  Historique : $historique
  >>
  RÉSULTAT
  * réponse: TEXTE - réponse finale
  * sources: LISTE - références citées
    * ref: TEXTE - lien de la source
    * pourquoi: TEXTE - en quoi c'est pertinent
  * confiance: CHOIX(haute, moyenne, faible)
FIN

' ═══════════════════════════════════════
' 2. Collecte de données — en parallèle avec
'    la réflexion. La recherche et la demande
'    d'avis ne bloquent ni l'une l'autre ni PENSE.
' ═══════════════════════════════════════
EXÉCUTE trouvé
  AVEC !recherche
  - query: $requête
  - limit: 10
FIN

ÉCRIS avis
  VERS #consultations
  POUR @expert
  ATTENTE QUELCONQUE
  AU PLUS 10m
  <<
  Besoin d'un avis d'expert sur la requête : $requête
  >>
FIN

' ═══════════════════════════════════════
' 3. Compléter les entrées pendant la réflexion.
'    Les données arrivent dans un ordre quelconque —
'    chaque résultat est injecté dans ~analyse
'    immédiatement. Le LLM l'intègre sans redémarrer.
' ═══════════════════════════════════════
RÉPÈTE 2
  ATTENDS données
    CIBLE ?trouvé, ?avis
    MODE QUELCONQUE
  FIN

  SIGNAL ~analyse
    <<
    $données
    >>
  FIN
FIN

' ═══════════════════════════════════════
' 4. L'analyse est terminée.
'    Le résultat intègre les données initiales,
'    les résultats de recherche et l'avis d'expert.
' ═══════════════════════════════════════
ATTENDS
  CIBLE ?analyse
FIN

' ═══════════════════════════════════════
' 5. Transmettre la réponse.
' ═══════════════════════════════════════
ÉCRIS
  VERS #résultats/$dossier_id
  POUR @auteur
  <<
  $analyse.réponse
  >>
FIN

TERMINE
```

---

## Notes

**Pourquoi JUSQUE et non JUSQU'À ?**
La forme naturelle en français est « jusqu'à ». Mais l'apostrophe est aussi le caractère de commentaire en COIL (`'` en début de ligne). Pour éviter toute ambiguïté au niveau du lexeur, le dialecte utilise la forme simplifiée `JUSQUE` — une forme reconnue du français, légèrement littéraire, mais parfaitement compréhensible.

**Pourquoi ATTENDS (opérateur) et ATTENTE (modificateur) ?**
L'opérateur `ATTENDS` est un verbe à l'impératif : « attends ! ». Le modificateur `ATTENTE` est un nom : la politique d'attente. Les deux dérivent de « attendre » mais sont des formes grammaticales distinctes — verbe vs nom — ce qui évite toute confusion.
