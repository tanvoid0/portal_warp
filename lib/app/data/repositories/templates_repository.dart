import '../models/quest_template.dart';
import '../models/focus_area.dart';
import '../local/json_storage.dart';

/// Repository for quest templates using JSON file storage
class TemplatesRepository {
  static const String _filename = 'templates.json';

  Future<void> seedTemplatesIfEmpty() async {
    final templates = await getAllTemplates();
    if (templates.isNotEmpty) return;

    // Seed templates
    final seedTemplates = [
      const QuestTemplate(
        id: 'clothes_1',
        focusAreaId: FocusArea.clothes,
        title: 'Remove 10 non-clothes items from drawer',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Go through your drawer and remove any items that are not clothes.',
      ),
      const QuestTemplate(
        id: 'clothes_2',
        focusAreaId: FocusArea.clothes,
        title: 'Fold and file 10 shirts',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Take 10 shirts and fold them properly, then organize them in your drawer.',
      ),
      const QuestTemplate(
        id: 'clothes_3',
        focusAreaId: FocusArea.clothes,
        title: 'Create 1 outfit combo and save it',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Put together one complete outfit and take a photo or note it down.',
      ),
      const QuestTemplate(
        id: 'clothes_4',
        focusAreaId: FocusArea.clothes,
        title: 'Donate bag: pick 5 items',
        durationBucket: 10,
        difficulty: 3,
        instructions: 'Select 5 clothing items you no longer wear to donate.',
      ),
      const QuestTemplate(
        id: 'clothes_5',
        focusAreaId: FocusArea.clothes,
        title: 'Full drawer reset',
        durationBucket: 30,
        difficulty: 5,
        instructions: 'Completely reorganize your entire drawer from scratch.',
      ),
      const QuestTemplate(
        id: 'clothes_6',
        focusAreaId: FocusArea.clothes,
        title: 'Sort clothes by color',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Organize your clothes by color for easier outfit matching.',
      ),
      const QuestTemplate(
        id: 'clothes_7',
        focusAreaId: FocusArea.clothes,
        title: 'Fix 3 items that need repair',
        durationBucket: 10,
        difficulty: 3,
        instructions: 'Find and fix 3 clothing items that need buttons, zippers, or other repairs.',
      ),
      const QuestTemplate(
        id: 'clothes_8',
        focusAreaId: FocusArea.clothes,
        title: 'Organize one drawer section',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Pick one section of your drawer and organize it completely.',
      ),
      const QuestTemplate(
        id: 'clothes_9',
        focusAreaId: FocusArea.clothes,
        title: 'Declutter: Make 4 piles (Keep/Maybe/Donate/Trash)',
        durationBucket: 30,
        difficulty: 4,
        instructions: 'Sort clothes into Keep (fits, worn last year), Maybe, Donate/Sell, and Trash (stained/ripped).',
      ),
      const QuestTemplate(
        id: 'clothes_10',
        focusAreaId: FocusArea.clothes,
        title: 'Sort clothes by category (T-shirts, Shirts, Pants, Layers)',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Organize clothes into categories: T-shirts, Shirts, Pants, Layers, Gym, Sleepwear, Accessories.',
      ),
      const QuestTemplate(
        id: 'clothes_11',
        focusAreaId: FocusArea.clothes,
        title: 'Set up drawer: Underwear in one box, socks paired',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Organize drawer: underwear in one box, socks paired and stacked, tees file-folded vertically.',
      ),
      const QuestTemplate(
        id: 'clothes_12',
        focusAreaId: FocusArea.clothes,
        title: 'Create and save 1 casual outfit',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Put together one casual outfit (e.g., T-shirt + dark jeans + sneakers) and save it.',
      ),
      const QuestTemplate(
        id: 'clothes_13',
        focusAreaId: FocusArea.clothes,
        title: 'Create and save 1 professional outfit',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Put together one professional outfit (e.g., OCBD + chinos + loafers) and save it.',
      ),
      const QuestTemplate(
        id: 'clothes_14',
        focusAreaId: FocusArea.clothes,
        title: 'Pick tomorrow\'s outfit',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Choose and lay out your outfit for tomorrow night.',
      ),
      const QuestTemplate(
        id: 'clothes_15',
        focusAreaId: FocusArea.clothes,
        title: 'Clean shoes check',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Quick check: Are your shoes clean-ish? Quick wipe if needed.',
      ),
      // Skincare templates
      const QuestTemplate(
        id: 'skincare_1',
        focusAreaId: FocusArea.skincare,
        title: 'Morning: Rinse + moisturize + SPF',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Face: rinse/cleanse + moisturize + SPF. Quick and essential.',
      ),
      const QuestTemplate(
        id: 'skincare_2',
        focusAreaId: FocusArea.skincare,
        title: 'Night: Cleanse + moisturize',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Evening routine: full cleanse followed by moisturizer.',
      ),
      const QuestTemplate(
        id: 'skincare_3',
        focusAreaId: FocusArea.skincare,
        title: 'SPF in the morning',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Apply sunscreen as part of your morning routine.',
      ),
      const QuestTemplate(
        id: 'skincare_4',
        focusAreaId: FocusArea.skincare,
        title: 'Hair: Quick style with 1 product',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Style your hair with one product for a clean look.',
      ),
      const QuestTemplate(
        id: 'skincare_5',
        focusAreaId: FocusArea.skincare,
        title: 'Teeth: Brush + tongue',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Brush teeth and tongue. Add floss if you can.',
      ),
      const QuestTemplate(
        id: 'skincare_6',
        focusAreaId: FocusArea.skincare,
        title: 'Deodorant check',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Apply deodorant - always essential.',
      ),
      const QuestTemplate(
        id: 'skincare_7',
        focusAreaId: FocusArea.skincare,
        title: 'Nails trimmed',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Trim nails weekly for a clean appearance.',
      ),
      // Fitness templates
      const QuestTemplate(
        id: 'fitness_1',
        focusAreaId: FocusArea.fitness,
        title: 'Put on workout clothes',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Just get into your workout clothes - that\'s the first step!',
      ),
      const QuestTemplate(
        id: 'fitness_2',
        focusAreaId: FocusArea.fitness,
        title: 'Walk 10 minutes daily',
        durationBucket: 10,
        difficulty: 2,
        instructions: 'Take a 10-minute walk, either outside or on a treadmill. Daily habit.',
      ),
      const QuestTemplate(
        id: 'fitness_3',
        focusAreaId: FocusArea.fitness,
        title: 'Workout: 2-3x per week',
        durationBucket: 30,
        difficulty: 4,
        instructions: 'Complete a workout session. Start with 2x/week, build to 3x.',
      ),
      const QuestTemplate(
        id: 'fitness_4',
        focusAreaId: FocusArea.fitness,
        title: 'Posture check: Chest open, chin back',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Posture cue: "chest open, chin back, shoulders down" - do this 3x/day.',
      ),
      const QuestTemplate(
        id: 'fitness_5',
        focusAreaId: FocusArea.fitness,
        title: 'Mobility: 5 min after shower',
        durationBucket: 2,
        difficulty: 1,
        instructions: '5 minutes of mobility/stretching after your shower (optional but helpful).',
      ),
      const QuestTemplate(
        id: 'fitness_6',
        focusAreaId: FocusArea.fitness,
        title: 'Run-walk 20-30 min',
        durationBucket: 30,
        difficulty: 4,
        instructions: 'Do a run-walk interval session for 20-30 minutes.',
      ),
      // Cooking templates
      const QuestTemplate(
        id: 'cooking_1',
        focusAreaId: FocusArea.cooking,
        title: 'Choose tomorrow\'s meal',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Decide what you want to cook tomorrow and write it down.',
      ),
      const QuestTemplate(
        id: 'cooking_2',
        focusAreaId: FocusArea.cooking,
        title: 'Cook one simple meal',
        durationBucket: 30,
        difficulty: 3,
        instructions: 'Cook one complete meal from start to finish.',
      ),
      const QuestTemplate(
        id: 'cooking_3',
        focusAreaId: FocusArea.cooking,
        title: 'Meal prep: 4 portions for the week',
        durationBucket: 30,
        difficulty: 3,
        instructions: 'Meal prep once per week: prepare 4 portions of a meal.',
      ),
      const QuestTemplate(
        id: 'cooking_4',
        focusAreaId: FocusArea.cooking,
        title: 'Stock check: Essentials (eggs, rice, protein, veg)',
        durationBucket: 2,
        difficulty: 1,
        instructions: 'Check if you have essentials: eggs, rice/pasta, frozen veg, protein, yogurt, sauces.',
      ),
      const QuestTemplate(
        id: 'cooking_5',
        focusAreaId: FocusArea.cooking,
        title: 'Learn one new simple meal',
        durationBucket: 30,
        difficulty: 4,
        instructions: 'Learn and cook one new simple meal. Aim for 5 meals you can repeat.',
      ),
      const QuestTemplate(
        id: 'cooking_6',
        focusAreaId: FocusArea.cooking,
        title: 'Prep rice/veg for 2 meals',
        durationBucket: 30,
        difficulty: 3,
        instructions: 'Prepare rice and vegetables that will last for 2 meals.',
      ),
    ];

    await _saveTemplates(seedTemplates);
  }

  Future<List<QuestTemplate>> _loadTemplates() async {
    final data = await JsonStorage.readList(_filename);
    return data.map((json) => QuestTemplate.fromJson(json)).toList();
  }

  Future<void> _saveTemplates(List<QuestTemplate> templates) async {
    final data = templates.map((t) => t.toJson()).toList();
    await JsonStorage.writeList(_filename, data);
  }

  Future<List<QuestTemplate>> getTemplatesByFocusAreas(
    List<FocusArea> focusAreas,
  ) async {
    final templates = await _loadTemplates();
    return templates
        .where((template) => focusAreas.contains(template.focusAreaId))
        .toList();
  }

  Future<List<QuestTemplate>> getAllTemplates() async {
    return await _loadTemplates();
  }

  Future<QuestTemplate?> getTemplateById(String id) async {
    final templates = await _loadTemplates();
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTemplate(QuestTemplate template) async {
    final templates = await _loadTemplates();
    templates.add(template);
    await _saveTemplates(templates);
  }

  Future<void> updateTemplate(QuestTemplate template) async {
    final templates = await _loadTemplates();
    final index = templates.indexWhere((t) => t.id == template.id);
    if (index != -1) {
      templates[index] = template;
      await _saveTemplates(templates);
    }
  }

  Future<void> deleteTemplate(String id) async {
    final templates = await _loadTemplates();
    templates.removeWhere((template) => template.id == id);
    await _saveTemplates(templates);
  }
}
