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
        energy_production = "5W",
        energy_usage = "0kW",
        picture = empty_sprite,
        squeak_behaviour = false,
    }})

    data:extend({{
        type = "pipe",
        name = "fvma-pipe",
        icons = empty_icons,
        collision_box = { { -1.29, 0 }, { 1.29, 0 } },
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

    fvma.create_generator = function(args)
        if args.size < 3.0 then
            error("Size must be at least 3 tiles due to factorio limitations.")
        end

        local half_size = args.size / 2
        local full_name = "fvma-" .. args.name

        data:extend({{
            type = "assembling-machine",
            name = full_name,
            flags = { "placeable-neutral", "player-creation" },
            minable = { mining_time = args.mining_time or 1, result = full_name },
            icon = args.icon,
            icons = args.icons,
            icon_size = args.icon_size,
            mipmap_count = args.mipmap_count,
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
                        { type = "output", position = {1, half_size-0.1+0.5 } },
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
                        { type = "input" , position = {-0.5 - half_size%1.0, -half_size+0.1-0.5    } },
                        { type = "input" , position = {-0.5 - half_size%1.0,  half_size-0.1+0.5    } },
                        { type = "input" , position = {-half_size+0.1-0.5  ,  -0.5 - half_size%1.0 } },
                        { type = "input" , position = { half_size-0.1+0.5  ,  -0.5 - half_size%1.0 } },
                    },
                    secondary_draw_orders = { north = -1 }
                },
                off_when_no_fluid_recipe = true
            },
            collision_box = { { -half_size+0.1 , -half_size+0.1  }, { half_size-0.1,  half_size-0.1  } },
            selection_box = { { -half_size+0.05, -half_size+0.05 }, { half_size-0.05, half_size-0.05 } },
            selection_priority = 51,
            selectable_in_game = false,
            picture = args.picture,
            pictures = args.pictures,
            animations = args.animations,
            animation = args.animation,
            fixed_recipe = full_name .. "-steam",
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
            name = full_name .. "-steam",
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
            name = full_name .. "-steam",
            category = "fvma-recipes",
            flags = { "hidden" },
            enabled = true,
            energy_required = 1 / 60,
            ingredients = args.ingredients or {},
            results = {
                {
                    type = "fluid",
                    name = full_name .. "-steam",
                    amount = 60,
                    temperature = 1
                },
            },
            icons = empty_icons,
            allow_decomposition = false,
        }})

        data:extend({{
            type = "generator",
            name = full_name .. "-generator",
            icons = empty_icons,
            effectivity = 1,
            fluid_usage_per_tick = 1 / args.energy_required,
            maximum_temperature = 1,
            collision_box = { { -half_size+0.1 , -half_size+0.1  }, { half_size-0.1,  half_size-0.1  } },
            selection_box = { { -half_size+0.05, -half_size+0.05 }, { half_size-0.05, half_size-0.05 } },
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
                    { type = "input", position = {0, half_size-0.1+0.5} },
                },
                production_type = "input-output",
                filter = full_name .. "-steam",
                minimum_temperature = 0.0
            },
            energy_source =
            {
                type = "electric",
                usage_priority = "secondary-output"
            },
            horizontal_animation = empty_sprite,
            vertical_animation = empty_sprite,
            squeak_behaviour = false,
        }})

        data:extend({{
            type = "item",
            name = full_name,
            icon = args.icon,
            icons = args.icons,
            icon_size = args.icon_size,
            mipmap_count = args.mipmap_count,
            flags = args.flags or {},
            order = args.order or "a",
            place_result = full_name,
            stack_size = args.stack_size or 1,
        }})
    end
end

--[[

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
    size = 9,
    animation = animation,
    ingredients = { { type = "fluid", name = "water", amount = 123 } },
    energy_production_per_craft = "1MJ",
    energy_required = 1,
}

fvma.create_generator{
    icon = "__base__/graphics/icons/spidertron.png",
    icon_size = 64,
    name = "temp-generator-10",
    size = 10,
    animation = animation,
    ingredients = { { "wooden-chest", 1 } },
    energy_production_per_craft = "1MJ",
    energy_required = 2,
}

--]]--
