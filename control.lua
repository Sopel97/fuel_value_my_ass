do
    function on_built(event)
        local proxy_entity = event.created_entity or event.entity
        local surface = proxy_entity.surface
        local force = proxy_entity.force
        if proxy_entity.type == "generator" and string.find(proxy_entity.prototype.order, "-fvma") then
            local pipe_position = {
                math.floor(proxy_entity.position.x + 1.1),
                proxy_entity.bounding_box.right_bottom.y + 0.5
            }

            local assembler_entity = surface.create_entity{
                name = proxy_entity.name .. "-fvma-assembling-machine",
                position = proxy_entity.position,
                force = force,
            }

            local interface_entity = surface.create_entity{
                name = "fvma-1w-interface",
                position = proxy_entity.position,
                force = force,
            }
            interface_entity.minable = false
            interface_entity.destructible = false

            local pole_entity = surface.create_entity{
                name = "fvma-1w-pole",
                position = proxy_entity.position,
                force = force,
            }
            pole_entity.minable = false
            pole_entity.destructible = false

            local pipe = surface.create_entity{
                name = "fvma-pipe",
                position = pipe_position,
                force = force,
            }
            pipe.minable = false
            pipe.destructible = false

            proxy_entity.minable = false
            proxy_entity.destructible = false
        end
    end

    function on_mined(event)
        local proxy_entity = event.created_entity or event.entity
        if proxy_entity.type == "assembling-machine" and string.find(proxy_entity.prototype.order, "-fvma") then
            local proxy_bb = proxy_entity.bounding_box
            local surface = proxy_entity.surface

            local entities = surface.find_entities_filtered{
                area = {
                    { proxy_bb.left_top.x     - 0.05, proxy_bb.left_top.y     + 0.05 },
                    { proxy_bb.right_bottom.x - 0.05, proxy_bb.right_bottom.y + 0.05 }
                },
            }
            local pipe_entities = surface.find_entities_filtered{
                area = {
                    { proxy_entity.position.x       , proxy_bb.right_bottom.y       },
                    { proxy_entity.position.x + 2.0 , proxy_bb.right_bottom.y + 1.0 }
                },
            }

            for _, entity in ipairs(entities) do
                if string.find(entity.prototype.order, "-fvma") and entity.name ~= "fvma-pipe" then
                    entity.destroy()
                end
            end

            for _, entity in ipairs(pipe_entities) do
                if entity.valid and entity.name == "fvma-pipe" then
                    entity.destroy()
                end
            end
        end
    end

    script.on_event({
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.script_raised_built,
        defines.events.script_raised_revive
    }, on_built)

    script.on_event({
        defines.events.on_player_mined_entity,
        defines.events.on_robot_mined_entity,
        defines.events.script_raised_destroy
    }, on_mined)
end