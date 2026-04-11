

import '../models/model_categorie.dart';

final List<Category> categories = [
  Category(
    id: 1,
    name: "INFRASTRUCTURE",
    subCategories: [
      "Routes",
      "Ponts",
      "Eclairage public",
      "eau",
      "électricité"
    ],
  ),
  Category(
    id: 2,
    name: "SANTE",
    subCategories: [
      "Dysfonctionnement centres de santé",
      "Pénuries médicaments",

    ],
  ),
  Category(
    id: 3,
    name: "EDUCATION",
    subCategories: [
      "Problèmes écoles",
      "Absentisme enseignants",
    ],
  ),
  Category(
    id: 4,
    name: "ENVIRONNEMENT",
    subCategories: [
      "Ordures",
      "Pollution",
      "Assainissement",
    ],
  ),
  Category(
    id: 5,
    name: "AGRICULTURE",
    subCategories: [
      "Accès intrants",
      "Soutien agricole",
    ],
  ),
  Category(
    id: 6,
    name: "ADMINISTRATION",
    subCategories: [
      "Lenteur",
      "Corruption suspectée",
      "Documents"
    ],

  ),
  Category(
      id: 7,
      name: "JUSTICE",
      subCategories: [
        "Dysfonctionnements",
        "Accès au droit"
      ]),
  Category(
      id: 8,
      name: "Autre",
      subCategories: [
        "Catégorie Ouverte"
      ])
];
