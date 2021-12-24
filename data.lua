fvma = {}

do
    local empty_sprite = {
        filename = "__fuel_value_my_ass__/graphics/nothing.png",
        priority = "extra-high",
        width = 1,
        height = 1,
    }

    local empty_pictures = {
        filename = "__fuel_value_my_ass__/graphics/nothing.png",
        priority = "extra-high",
        width = 1,
        height = 1,
        direction_count = 1,
    }

    local empty_icons = {
        {
            icon = "__fuel_value_my_ass__/graphics/nothing.png",
            icon_size = 1,
        }
    }

    data:extend({{
        type = "recipe-category",
        name = "fvma-recipes",
    }})

    data:extend({{
        type = "electric-energy-interface",
        name = "fvma-1w-interface",
        icons = empty_icons,
        collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
        gui_mode = "none",
        allow_copy_paste = true,
        energy_source = {
          type = "electric",
          buffer_capacity = "10W",
          usage_priority = "tertiary"
        },
        order = "a-fvma",
        energy_production = "5W",
        energy_usage = "0kW",
        picture = empty_sprite,
        squeak_behaviour = false,
    }})

    data:extend({{
        type = "pipe",
        name = "fvma-pipe",
        icons = empty_icons,
        collision_box = { { -0.1, 0 }, { 1.1, 0 } },
        order = "a-fvma",
        fluid_box = {
            base_area = 1,
            base_level = 100,
            height = 1,
            pipe_connections =
            {
                { position = { 0, -0.5 } },
                { position = { 1, -0.5 } },
            }
        },
        pictures = {
            straight_vertical_single = empty_sprite,
            straight_vertical = empty_sprite,
            straight_vertical_window = empty_sprite,
            straight_horizontal = empty_sprite,
            straight_horizontal_window = empty_sprite,
            corner_up_right = empty_sprite,
            corner_up_left = empty_sprite,
            corner_down_right = empty_sprite,
            corner_down_left = empty_sprite,
            t_up = empty_sprite,
            t_down = empty_sprite,
            t_right = empty_sprite,
            t_left = empty_sprite,
            cross = empty_sprite,
            ending_up = empty_sprite,
            ending_down = empty_sprite,
            ending_right = empty_sprite,
            ending_left = empty_sprite,
            horizontal_window_background = empty_sprite,
            vertical_window_background = empty_sprite,
            fluid_background = empty_sprite,
            low_temperature_flow = empty_sprite,
            middle_temperature_flow = empty_sprite,
            high_temperature_flow = empty_sprite,
            gas_flow = empty_sprite,
        },
        horizontal_window_bounding_box = { { -0.25, -0.28125 }, { 0.25, 0.15625 } },
        vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } },
    }})

    data:extend({{
        type = "electric-pole",
        name = "fvma-1w-pole",
        icons = empty_icons,
        order = "a-fvma",
        collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
        maximum_wire_distance = 0.3,
        supply_area_distance = 0.3,
        pictures = empty_pictures,
        connection_points = {
            {
                shadow =
                {
                    copper = util.by_pixel(98.5, 2.5),
                    red = util.by_pixel(111.0, 4.5),
                    green = util.by_pixel(85.5, 4.0)
                },
                wire =
                {
                    copper = util.by_pixel(0.0, -82.5),
                    red = util.by_pixel(13.0, -81.0),
                    green = util.by_pixel(-12.5, -81.0)
                }
            },
        },
        radius_visualisation_picture = empty_sprite,
        squeak_behaviour = false,
    }})

    fvma.get_composite_entity_names = function(name)
        return {
            ["item"] = name,
            ["generator"] = name,
            ["assembling-machine"] = name .. "-fvma-assembling-machine",
            ["fluid"] = name .. "-fvma-steam",
            ["recipe"] = name .. "-fvma-steam",
        }
    end

    fvma.create_generator = function(args)
        local half_size_width = (args.width or args.size) / 2
        local half_size_height = (args.height or args.size) / 2
        local full_names = fvma.get_composite_entity_names(args.name)

        if half_size_width < 2.5 then
            error("Width must be at least 5 tiles due to how this is implemented. Trying to fit all the required fluid boxes.")
        end

        if half_size_height < 1.5 then
            error("Height must be at least 3 tiles due to fluid box stuff.")
        end

        data:extend({{
            type = "assembling-machine",
            name = full_names["assembling-machine"],
            icon = args.icon,
            icons = args.icons,
            icon_size = args.icon_size,
            mipmap_count = args.mipmap_count,
            order = (args.order or "") .. "a-fvma",
            localised_name = { "generator." .. args.name },
            flags = { "placeable-neutral", "player-creation", "not-rotatable", "not-blueprintable" },
            minable = { mining_time = args.mining_time or 1, result = full_names["item"] },
            placeable_by = { { item = full_names["item"], count = 1 } },
            fluid_boxes = {
                {
                    production_type = "output",
                    pipe_covers = {
                        north = empty_sprite,
                        east = empty_sprite,
                        south = empty_sprite,
                        west = empty_sprite,
                    },
                    base_area = 10,
                    base_level = 100,
                    height = 1,
                    pipe_connections = {
                        { type = "output", position = { 2.0 - half_size_width%1.0, half_size_height-0.1+0.5 } },
                    },
                    secondary_draw_orders = { north = -1 }
                },
                {
                    production_type = "input",
                    pipe_picture = assembler2pipepictures(),
                    pipe_covers = pipecoverspictures(),
                    base_area = 10,
                    base_level = -1,
                    pipe_connections = {
                        { type = "input" , position = { 0.5 - half_size_width%1.0, -half_size_height+0.1-0.5    } },
                        { type = "input" , position = { 0.5 - half_size_width%1.0,  half_size_height-0.1+0.5    } },
                        { type = "input" , position = {-half_size_width+0.1-0.5  ,   0.5 - half_size_height%1.0 } },
                        { type = "input" , position = { half_size_width-0.1+0.5  ,   0.5 - half_size_height%1.0 } },
                    },
                    secondary_draw_orders = { north = -1 }
                },
                off_when_no_fluid_recipe = true
            },
            collision_box = { { -half_size_width+0.1 , -half_size_height+0.1  }, { half_size_width-0.1,  half_size_height-0.1  } },
            selection_box = { { -half_size_width+0.05, -half_size_height+0.05 }, { half_size_width-0.05, half_size_height-0.05 } },
            selection_priority = 51,
            selectable_in_game = false,
            fixed_recipe = full_names["recipe"],
            crafting_categories = { "fvma-recipes" },
            crafting_speed = 1,
            energy_source = {
                type = "electric",
                usage_priority = "secondary-input",
                emissions_per_minute = 3
            },
            energy_usage = "1W",
            module_specification = {
                module_slots = 0
            },
            allowed_effects = {},
            subgroup = args.subgroup or nil,
            squeak_behaviour = false,
        }})

        data:extend({{
            type = "fluid",
            name = full_names["fluid"],
            localised_name = { "" },
            flags = { "hidden" },
            default_temperature = 0,
            max_temperature = 1,
            base_color = { 0, 0, 0, 0 },
            flow_color = { 0, 0, 0, 0 },
            heat_capacity = util.parse_energy(args.energy_production_per_craft) / 60 .. "J",
            icons = empty_icons,
            gas_temperature = 1,
            auto_barrel = false
        }})

        data:extend({{
            type = "recipe",
            name = full_names["recipe"],
            localised_name = { "" },
            category = "fvma-recipes",
            flags = { "hidden" },
            enabled = true,
            energy_required = 1 / 60,
            ingredients = args.ingredients or {},
            results = {
                {
                    type = "fluid",
                    name = full_names["fluid"],
                    amount = 60,
                    temperature = 1
                },
            },
            icons = empty_icons,
            allow_decomposition = false,
        }})

        data:extend({{
            type = "generator",
            name = full_names["generator"],
            localised_name = { "generator." .. args.name },
            flags = { "placeable-neutral", "player-creation", "not-rotatable", "hide-alt-info", "not-selectable-in-game" },
            icon = args.icon,
            icons = args.icons,
            icon_size = args.icon_size,
            mipmap_count = args.mipmap_count,
            order = (args.order or "") .. "a-fvma",
            effectivity = 1,
            fluid_usage_per_tick = 1 / args.energy_required,
            maximum_temperature = 1,
            collision_box = { { -half_size_width+0.1 , -half_size_height+0.1  }, { half_size_width-0.1,  half_size_height-0.1  } },
            selection_box = { { -half_size_width+0.05, -half_size_height+0.05 }, { half_size_width-0.05, half_size_height-0.05 } },
            selection_priority = 0,
            selectable_in_game = false,
            fluid_box = {
                base_area = 1,
                height = 1,
                base_level = 100,
                pipe_covers = {
                    north = empty_sprite,
                    east = empty_sprite,
                    south = empty_sprite,
                    west = empty_sprite,
                },
                pipe_connections = {
                    { type = "input", position = { 1.0 - half_size_width%1.0, half_size_height-0.1+0.5 } },
                },
                production_type = "input-output",
                filter = full_names["fluid"],
                minimum_temperature = 0.0
            },
            energy_source =
            {
                type = "electric",
                usage_priority = "secondary-output"
            },
            vertical_animation = args.vertical_animation,
            horizontal_animation = args.horizontal_animation,
            squeak_behaviour = false,
        }})
    end
end

---[[

-- Examples

local animation =
{
    layers =
    {
        {
            filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1.png",
            priority="high",
            width = 108,
            height = 114,
            frame_count = 32,
            line_length = 8,
            shift = util.by_pixel(0, 2),
            scale = 3,
        },
        {
            filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1-shadow.png",
            priority="high",
            width = 95,
            height = 83,
            frame_count = 1,
            line_length = 1,
            repeat_count = 32,
            draw_as_shadow = true,
            shift = util.by_pixel(8.5, 5.5),
            scale = 3,
        }
    }
}

fvma.create_generator{
    icon = "__base__/graphics/icons/spidertron.png",
    icon_size = 64,
    name = "temp-generator-9",
    width = 6,
    height = 3,
    vertical_animation = animation,
    horizontal_animation = animation,
    ingredients = { { type = "fluid", name = "water", amount = 123 } },
    energy_production_per_craft = "1MJ",
    energy_required = 1,
}

data:extend({{
    type = "item",
    name = "temp-generator-9",
    localised_name = { "generator.temp-generator-9" },
    icon = "__base__/graphics/icons/spidertron.png",
    icon_size = 64,
    place_result = "temp-generator-9",
    order = "a",
    stack_size = 10,
}})

fvma.create_generator{
    icon = "__base__/graphics/icons/spidertron.png",
    icon_size = 64,
    name = "temp-generator-10",
    width = 5,
    height = 3,
    vertical_animation = animation,
    horizontal_animation = animation,
    ingredients = { { "wooden-chest", 1 } },
    energy_production_per_craft = "1MJ",
    energy_required = 2,
}

data:extend({{
    type = "item",
    name = "temp-generator-10",
    localised_name = { "generator.temp-generator-10" },
    icon = "__base__/graphics/icons/spidertron.png",
    icon_size = 64,
    place_result = "temp-generator-10",
    order = "a",
    stack_size = 10,
}})

--]]--
