function init(args)
  entity.setInteractive(true)
  
  if args == false then
    pipes.init({itemPipe})
    storageApi.init(3, 16, true)
    entity.scaleGroup("invbar", {1, 1})
  end
end

function onInteraction(args)
end

function main(args)
  pipes.update(entity.dt())
  
  --Scale inventory bar
  entity.scaleGroup("invbar", {1, storageApi.getCount() / storageApi.getCapacity()})
end

function onItemPut(item, nodeId)
  if item then
    return storageApi.storeItem(item[1], item[2], item[3])
  end
  
  return false
end

function onItemGet(filter, nodeId)
  local storageIndices = storageApi.getStorageIndices()
  world.logInfo("Storage indices: %s", storageIndices)
  if filter then
    for _,i in ipairs(storageIndices) do
      for _, filterString in ipairs(filter) do
        if storageApi.peekItem(i)[1] == filterString then return storage.returnItem(i) end
      end
    end
  else
    for _,i in ipairs(storageIndices) do
      world.logInfo(i)
      return storageApi.returnItem(i)
    end
  end
  return false
end


--Generator
function main(args)
  local remainingEnergy = energyapi.currentEnergy
  for _, node in ipairs(nodes)
    local visited = {entity.id()}
    remainingEnergy = pushEnergy(node, remainingEnergy, visited) --Gives energy to the node if specified, and calls onRecieveEnergy
  end
end

--Node
function onRecieveEnergy(energy, visited)
  local remainingEnergy = energy
  for _, node in ipairs(nodes)
    visited[#visited+1] = entity.id()
    local willSend = true
    for _,visitedId in ipairs(visited) do
      if node == visitedId then willSend = false end
    end
    if willSend then
      remainingEnergy = pushEnergy(node, remainingEnergy, visited) --Gives energy to the node if specified, and calls onRecieveEnergy
    end
  end
end

--Machine using energy (this can be done internally)
function energyapi.recieveEnergy(energy, visited)
  if energy < energyapi.maxEnergy - energyapi.curEnergy then
    energyapi.curEnergy = energyapi.curEnergy + energy
  else
    energyapi.curEnergy = energyApi.
  end


end