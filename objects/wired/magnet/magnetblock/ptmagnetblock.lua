function init(args)
  if not args then
    storage.usesEnergy = entity.configParameter("energyAllowConnection", false)
    if storage.usesEnergy then
      energy.init()
    end
    storage.magnetOnAnim = entity.configParameter("chargeStrength") > 0 and "positive" or "negative"
    storage.magnetOffAnim = "neutral"
  
    storage.charge = clamp(entity.configParameter("chargeStrength"), -magnets.limit, magnets.limit)
    
    killData()
	
    entity.setInteractive(true)
    entity.setColliding(false)
    if storage.state == nil then
      output(not storage.usesEnergy)
    else
      output(storage.state)
    end
  end
end

function die()
  if storage.usesEnergy then 
    energy.die()
  end
  killData()
end

function killData()
  if storage.dataID ~= nil then
    world.callScriptedEntity(storage.dataID, "kill")
    storage.dataID = nil
  end
end

function onInteraction(args)
  output(not storage.state)
end

function onInboundNodeChange(args)
  output(not storage.state)
end

function output(state)
  if storage.state ~= state then
    storage.state = state
    entity.setAllOutboundNodes(state)
	
    updateMagnetData()
	
    if state then
      entity.setAnimationState("magnetState", storage.magnetOnAnim)
      entity.playSound("onSounds")
    else
      entity.setAnimationState("magnetState", storage.magnetOffAnim)
      entity.playSound("offSounds")
    end
  end
end

function main()
  if storage.usesEnergy then
    energy.update()
  end
  if (storage.dataID == nil or (storage.dataID ~= nil and not world.entityExists(storage.dataID))) then
    updateMagnetData()
  end
  
  local charge = storage.charge
  if storage.state then -- Magnet is active
    if storage.usesEnergy and not energy.consumeEnergy(getEnergyUsage()) then
      output(false)
      return
    end
    
    -- Push monsters/npcs
    local radius = magnets.radius
    local pos = entity.position()
    local ents = world.entityQuery(pos, radius, { withoutEntityId = storage.dataID, notAnObject = true })
    for key,value in pairs(ents) do
      if magnets.shouldAffect(value) then
        local ent = entityProxy.create(value)
        magnets.applyForce(ent, magnets.vecSum(pos, { 0.5, 0.5 }), charge)
      end
    end
  end
end

-- Function for other magnets to overwrite
function getEnergyUsage()
  return nil
end

function updateMagnetData()
  killData()
  
  -- 13/9 Is the level the monster needs for the health to scale by 1
  if storage.state then
    local pos = entity.position()
    pos = magnets.vecSum(pos, { 0.5, 0.5 })
    -- This dummy monster is needed for the magnetize tech to interact with magnets
    storage.dataID = world.spawnMonster("ptmagnetdata", pos, { level = (13/9), statusParameters = { baseMaxHealth = storage.charge }})
  else
    storage.dataID = nil
  end
  
  entity.setGlobalTag("charge", roundCharge(storage.charge))
end

function roundCharge(charge)
  charge = charge / 10
  if charge >= 0 then
    charge = math.ceil(charge)
  else
    charge = math.floor(charge)
  end
  return charge * 10
end

function clamp(num, minimum, maximum)
  if num < minimum then
    return minimum
  elseif num > maximum then
    return maximum
  else
    return num
  end
end