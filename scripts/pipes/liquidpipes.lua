liquidPipe = {
  pipeName = "liquid",
  nodesConfigParameter = "liquidNodes",
  tiles = "metalpipe",
  hooks = {
    put = "onLiquidPut",  --Should take whatever argument get returns
    get = "onLiquidGet", --Should return whatever argument you want to plug into the put hook, can take whatever argument you want like a filter or something
    peekPut = "beforeLiquidPut", --Should return true if object will put the item
    peekGet = "beforeLiquidGet" --Should return true if object will get the item
  }
}

--- Pushes liquid
-- @param nodeId the node to push from
-- @param liquid the liquid to push, specified as array {liquidId, amount}
-- @returns true if successful, false if unsuccessful
function pushLiquid(nodeId, liquid)
  return pipes.push("liquid", nodeId, liquid)
end

--- Pulls liquid
-- @param nodeId the node to push from
-- @param filter array of filters of liquids {liquidId = {minAmount,maxAmount}, otherLiquidId = {minAmount,maxAmount}}
-- @returns liquid if successful, false if unsuccessful
function pullLiquid(nodeId, filter)
  return pipes.pull("liquid", nodeId, liquid)
end

--- Peeks a liquid push, does not go through with the transfer
-- @param nodeId the node to push from
-- @param liquid the liquid to push, specified as array {liquidId, amount}
-- @returns true if successful, false if unsuccessful
function peekPushLiquid(nodeId, liquid)
  return pipes.peekPush("liquid", nodeId, liquid)
end

--- Peeks a liquid pull, does not go through with the transfer
-- @param nodeId the node to push from
-- @param filter array of filters of liquids {liquidId = {minAmount,maxAmount}, otherLiquidId = {minAmount,maxAmount}}
-- @returns liquid if successful, false if unsuccessful
function peekPullLiquid(nodeId, filter)
  return pipes.peekPull("liquid", nodeId, liquid)
end

function isLiquidNodeConnected(nodeId)
  if pipes.nodeEntities["liquid"] == nil then return false end
  if #pipes.nodeEntities["liquid"] > 0 then
    return pipes.nodeEntities["liquid"]
  else
    return false
  end
end

function filterLiquids(filter, liquids)
  if filter then
    for i,liquid in ipairs(liquids) do
      if filter[tostring(liquid[1])] and liquid[2] >= filter[tostring(liquid[1])][1]then
        if liquid[2] <= filter[tostring(liquid[1])][2] then
          return liquid, i
        else
          return {liquid[1], filter[tostring(liquid[1])][2]}, i
        end
      end
    end
  else
    return items[1], 1
  end
end