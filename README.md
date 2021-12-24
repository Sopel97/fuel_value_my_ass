# Generator creation API

## **`fvma.create_generator(args)`**

Used to create all required entities/recipes/fluids for a generator. All parameters are given in a parameter object `args`. The following parameters available for Prototype/Generator can/must be specified:

Additional fields

- `name` :: `string` - the name to use for the generator entity
- `size` :: `double` - the width and height of the composite entity. See below for detail.
- `width` :: `double` (optional if size specified) - the width in tiles of the composite entity. Must be at least 5. Use integers to be safe. Takes precedence over size.
- `height` :: `double` (optional if size specified) - the height in tiles of the composite entity. Must be at least 3. Use integers to be safe. Takes precedence over size.
- `ingredients` :: `table` of `IngredientPrototype` - the ingredients for a single craft. Can have up to 4 unique fluids.
- `energy_production_per_craft` :: `Energy` - the amount of energy generated per craft
- `energy_required` :: double - the time required per craft (actual crafting speed will be different, but this value will reflect the energy output)

Prototype/Generator — `generator`

- `horizontal_animation`    ::  `Animation`
- `vertical_animation`  ::  `Animation`
- `min_perceived_performance`   ::  `double` (optional)
- `performance_to_sound_speedup`    ::  `double` (optional)
- `smoke`   ::  `table` of `SmokeSource` (optional)

Inherited from `Prototype/EntityWithHealth`

- `alert_when_damaged`  ::  `bool` (optional)
- `attack_reaction` ::  `AttackReaction` (optional)
- `corpse`  ::  `string` or `table` of `strings` (optional)
- `create_ghost_on_death`   ::  `bool` (optional)
- `damaged_trigger_effect`  ::  `TriggerEffect` (optional)
- `dying_explosion` ::  `ExplosionDefinition` or `table` of `ExplosionDefinition` (optional)
- `dying_trigger_effect`    ::  `TriggerEffect` (optional)
- `healing_per_tick`    ::  `float` (optional)
- `hide_resistances`    ::  `bool` (optional)
- `integration_patch`   ::  `Sprite4Way` (optional)
- `integration_patch_render_layer`  ::  `RenderLayer` (optional)
- `loot`    ::  `Loot` (optional)
- `max_health`  ::  `float` (optional)
- `random_corpse_variation` ::  `bool` (optional)
- `repair_sound`    ::  `Sound` (optional)
- `repair_speed_modifier`   ::  `float` (optional)
- `resistances` ::  `Resistances` (optional)

Inherited from Prototype/Entity

- `icons`, `icon`, `icon_size` (`IconSpecification`)  ::  `IconSpecification`
- `alert_icon_scale`    ::  `float` (optional)
- `alert_icon_shift`    ::  `vector` (optional)
- `allow_copy_paste`    ::  `bool` (optional)
- `build_sound` ::  `Sound` (optional)
- `close_sound` ::  `Sound` (optional)
- `collision_mask`  ::  `CollisionMask` (optional)
- `created_effect`  ::  `Trigger` (optional)
- `created_smoke`   ::  `CreateTrivialSmokeEffectItem` (optional)
- `drawing_box` ::  `BoundingBox` (optional)
- `emissions_per_second`    ::  `double` (optional)
- `enemy_map_color` ::  `Color` (optional)
- `friendly_map_color`  ::  `Color` (optional)
- `hit_visualization_box`   ::  `BoundingBox` (optional)
- `map_color`   ::  `Color` (optional)
- `mined_sound` ::  `Sound` (optional)
- `mining_sound`    ::  `Sound` (optional)
- `open_sound`  ::  `Sound` (optional)
- `radius_visualisation_specification`  ::  `RadiusVisualisationSpecification` (optional)
- `remains_when_mined`  ::  `string` or `table` of `string` (optional)
- `remove_decoratives`  ::  `string` (optional)
- `selectable_in_game`  ::  `bool` (optional)
- `shooting_cursor_size`    ::  `double` (optional)
- `sticker_box` ::  `BoundingBox` (optional)
- `trigger_target_mask` ::  `TriggerTargetMask` (optional)
- `vehicle_impact_sound`    ::  `Sound` (optional)
- `water_reflection`    ::  `WaterReflectionDefinition` (optional)
- `working_sound`   ::  `WorkingSound` (optional)

Inherited from PrototypeBase

- `localised_description`   ::  `LocalisedString` (optional)
- `localised_name`  ::  `LocalisedString` (optional)

## `fvma.get_composite_entity_names(name)`

Returns a dictionary with names of entities/recipes/fluids created by the `fvma.create_generator` function for `args.name==name`. The returned dictionary has the following key:

- `["item"]` - the expected name of the item that places the generator (not created by `fvma.create_generator`), guaranteed to be just `name`
- `["generator"]` - the name of the generator entity, guaranteed to be just `name`
- `["assembling-machine"]` - the name of the assembling machine entity that's used for the gui interface and crafting recipe
- `["fluid"]` - the name of the fluid used for energy generation
- `["recipe"]` - the name of the recipe the assembling machine gets fixed to
