/// Modelo de un plato del catálogo de Sabor Caribe.
class Dish {
  final String name;
  final String imageAsset;
  final int rating; // estrellas llenas (0 a 5)
  final double ratingValue; // valor numérico mostrado junto a las estrellas
  final int reviews; // número de reseñas
  final String price;
  final String category;
  final String description;
  final List<String> ingredients;
  final int favoritesCount; // cuántas personas lo han marcado como favorito

  const Dish({
    required this.name,
    required this.imageAsset,
    required this.rating,
    required this.ratingValue,
    required this.reviews,
    required this.price,
    required this.category,
    this.description = '',
    this.ingredients = const [],
    this.favoritesCount = 0,
  });
}

/// Categorías disponibles para filtrar el catálogo.
const List<String> categories = [
  'Todos',
  'Sopas',
  'Pescados',
  'Carnes',
  'Tradicionales',
];

/// Catálogo de platos típicos de la costa Caribe colombiana.
const List<Dish> dishes = [
  Dish(
    name: 'Mote de Queso',
    imageAsset: 'assets/image/MoteDeQueso.jpg',
    rating: 5,
    ratingValue: 4.8,
    reviews: 124,
    price: '\$18.500 COP',
    category: 'Sopas',
    favoritesCount: 38,
    description: 'Sopa tradicional con queso costeño, maíz y plátano.',
    ingredients: [
      'Ñame',
      'Queso costeño',
      'Cebolla larga',
      'Ajo',
      'Cilantro',
      'Mantequilla',
    ],
  ),
  Dish(
    name: 'Mojarra Frita con Arroz de Coco',
    imageAsset: 'assets/image/MojarraCoco.jpg',
    rating: 5,
    ratingValue: 4.7,
    reviews: 98,
    price: '\$22.000 COP',
    category: 'Pescados',
    favoritesCount: 31,
    description:
        'Mojarra fresca acompañada de arroz de coco, patacón y ensalada.',
    ingredients: [
      'Mojarra entera',
      'Coco rallado',
      'Arroz',
      'Limón',
      'Patacón',
      'Ensalada fresca',
    ],
  ),
  Dish(
    name: 'Sancocho de Carne Salada',
    imageAsset: 'assets/image/CarneSalada.jpg',
    rating: 4,
    ratingValue: 4.6,
    reviews: 87,
    price: '\$17.500 COP',
    category: 'Carnes',
    favoritesCount: 24,
    description:
        'Tradicional sancocho con carne salada, plátano, yuca y mazorca.',
    ingredients: [
      'Carne salada',
      'Yuca',
      'Ñame',
      'Plátano',
      'Mazorca',
      'Cilantro',
    ],
  ),
  Dish(
    name: 'Pastel de Cerdo',
    imageAsset: 'assets/image/PastelCerdo.jpg',
    rating: 5,
    ratingValue: 4.5,
    reviews: 76,
    price: '\$15.000 COP',
    category: 'Tradicionales',
    favoritesCount: 19,
    description:
        'Delicioso pastel relleno de carne de cerdo, con un sabor único de la costa.',
    ingredients: [
      'Carne de cerdo',
      'Arroz',
      'Hoja de bijao',
      'Alverja',
      'Zanahoria',
      'Especias criollas',
    ],
  ),
  Dish(
    name: 'Carnero Guisado',
    imageAsset: 'assets/image/CarneroGuisado.jpg',
    rating: 5,
    ratingValue: 4.9,
    reviews: 112,
    price: '\$23.000 COP',
    category: 'Carnes',
    favoritesCount: 27,
    description: 'Carnero guisado lentamente con sofrito criollo costeño.',
    ingredients: [
      'Carne de carnero',
      'Tomate',
      'Cebolla',
      'Pimentón',
      'Comino',
      'Papa criolla',
    ],
  ),
];

/// Cuántas personas en total han marcado al menos un plato como
/// favorito (dato simulado, para la pantalla de Favoritos).
const int totalPeopleWhoFavorited = 50;

/// Una persona marcando un plato como favorito "hace un momento" —
/// usado en la fila de historias y el ranking de la pantalla de
/// Favoritos. Son datos simulados mientras no haya cuentas reales.
class FavoriteActivity {
  final String personName;
  final String dishName;
  final String timeAgo;
  final int avatarColorValue;

  const FavoriteActivity({
    required this.personName,
    required this.dishName,
    required this.timeAgo,
    required this.avatarColorValue,
  });
}

const List<FavoriteActivity> favoriteActivities = [
  FavoriteActivity(
    personName: 'Valeria',
    dishName: 'Mojarra Frita con Arroz de Coco',
    timeAgo: 'hace 2 h',
    avatarColorValue: 0xFFE57373,
  ),
  FavoriteActivity(
    personName: 'Carlos',
    dishName: 'Mote de Queso',
    timeAgo: 'hace 5 h',
    avatarColorValue: 0xFF64B5F6,
  ),
  FavoriteActivity(
    personName: 'Ana',
    dishName: 'Carnero Guisado',
    timeAgo: 'hace 8 h',
    avatarColorValue: 0xFFBA68C8,
  ),
  FavoriteActivity(
    personName: 'Luis',
    dishName: 'Sancocho de Carne Salada',
    timeAgo: 'ayer',
    avatarColorValue: 0xFF81C784,
  ),
  FavoriteActivity(
    personName: 'Camila',
    dishName: 'Mote de Queso',
    timeAgo: 'ayer',
    avatarColorValue: 0xFFFFB74D,
  ),
];
