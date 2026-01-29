UI.Separator()

local iconUtilitys = setupUI([[
Panel
  height: 16

  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 17
    text: Utilitarios
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

extrasButton = setupUI([[
Panel
  height: 15

  Button
    id: vBotExtras
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 17
    text: vBot Settings and Scripts
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

extrasButton.vBotExtras.onClick = function()
  extrasWindow:show()
  extrasWindow:raise()
  extrasWindow:focus()
end

utilityInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 408 300
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  Panel
    id: background
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    background-color: black
    opacity: 0.70

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 120 30
    text-align: center
    !text: tr('LNS Custom | Utilitys Setup')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray
  
  Panel
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
    margin-left: -15

  UIButton
    id: closePanel
    anchors.top: topPanel.top
    anchors.right: parent.right
    size: 18 18
    margin-top: 6
    margin-right: 10
    background-color: orange
    text: X
    color: white
    opacity: 1.00
    $hover:
      color: black
      opacity: 0.80

  ScrollablePanel
    id: content
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    vertical-scrollbar: contentScroll
    margin-left: 10
    margin-bottom: 5
    margin-top: 12
    margin-right: 10
    background-color: #363636

    FlatPanel
      id: leftMacros
      anchors.top: parent.top
      anchors.left: parent.left
      height: 350
      width: 190
      margin-top: -1
      image-color: #363636
      layout: verticalBox
      padding: 5

    FlatPanel
      id: rightMacros
      anchors.top: parent.top
      anchors.left: leftMacros.right
      height: 350
      margin-left: 10
      width: 190
      image-color: #363636
      layout: verticalBox
      padding: 5
      padding-right: 5

  VerticalScrollBar
    id: contentScroll
    anchors.top: content.top
    anchors.right: content.right
    anchors.bottom: content.bottom
    margin-right: 187
    image-color: #828282
    step: 40
    pixels-scroll: true
    visible: true

]], g_ui.getRootWidget())
utilityInterface:hide()

utilityInterface.closePanel.onClick = function()
  utilityInterface:hide()
end

iconUtilitys.settings.onClick = function()
    if not utilityInterface:isVisible() then
        utilityInterface:show()
        utilityInterface:raise()
        utilityInterface:focus()
    end
end

local destLeft = utilityInterface.content.leftMacros
local destRight = utilityInterface.content.rightMacros

-- =========================
-- PRESETS (estilo padrão)
-- =========================
local BotSwitchPresets = {
  default = {
    width = 110,
    height = 18,
    font = "verdana-9px",
    imageSource = "/images/ui/button_rounded",
    off = { textColor = "white"},
    on  = { textColor = "green"},
  },

}

local function applyState(sw, preset, isOn)
  local st = isOn and preset.on or preset.off
  if sw.setFont and preset.font then sw:setFont(preset.font) end
  if sw.setColor and st.textColor then sw:setColor(st.textColor) end
end

-- =========================
-- createBotSwitch("preset", parent, "Texto", storageTable, "key")
-- =========================
function createBotSwitch(presetName, parent, text, store, key)
  local preset = BotSwitchPresets[presetName or "default"] or BotSwitchPresets.default
  local sw = g_ui.createWidget("BotSwitch", parent)
  if not sw then return nil end

  if sw.setText then sw:setText(text or "") end
  if sw.setWidth and preset.width then sw:setWidth(preset.width) end
  if sw.setHeight and preset.height then sw:setHeight(preset.height) end
  if sw.setImageSource and preset.imageSource then sw:setImageSource(preset.imageSource) end

  -- storage opcional
  local initial = false
  if store and key then
    store[key] = (store[key] == true)
    initial = store[key]
  end

  if sw.setOn then sw:setOn(initial) end
  applyState(sw, preset, initial)

  sw.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    applyState(widget, preset, newState)
    if store and key then store[key] = newState end
  end

  return sw
end

storage.utilityToggles = storage.utilityToggles or {}

if not storage.proximaBpID then storage.proximaBpID = {{id=2854}} end
if type(storage.transformarCoin) ~= "table" then storage.transformarCoin = {3031, 3035, 3043} end
if type(storage.proximaBpID) == "table" then for i, v in ipairs(storage.proximaBpID) do if type(v) == "number" then storage.proximaBpID[i] = {id = v} end end end
if not storage.doorIds then storage.doorIds = { 5129, 5102, 5111, 5120, 11246 } end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t) do
      table.insert(r, entry.id)
  end
  return r
end

-- LADRO ESQUERDO
createBotSwitch("default", destLeft, "Hold Target", storage.utilityToggles, "holdTarget")
createBotSwitch("default", destLeft, "Summon Familiar", storage.utilityToggles, "summonFamiliar")
createBotSwitch("default", destLeft, "Super Dash", storage.utilityToggles, "superDash")
UI.Separator(destLeft)
createBotSwitch("default", destLeft, "Equip Full Might", storage.utilityToggles, "equipFullMight")
createBotSwitch("default", destLeft, "Equip Full SSA", storage.utilityToggles, "equipFullSSA")
UI.Separator(destLeft)
createBotSwitch("default", destLeft, "Esconder Sprites", storage.utilityToggles, "esconderSprites")
createBotSwitch("default", destLeft, "Esconder Textos", storage.utilityToggles, "esconderTextos")
createBotSwitch("default", destLeft, "Montar Automatico", storage.utilityToggles, "autoMont")
UI.Separator(destLeft)
createBotSwitch("default", destLeft, "Hold Position", storage.utilityToggles, "holdPosition")
createBotSwitch("default", destLeft, "Sleep Mode", storage.utilityToggles, "sleepMode")
-- LADO DIREITO
local nextBpContainer = UI.Container(function(widget, items) storage.proximaBpID = items end, true, destRight) nextBpContainer:setHeight(35) nextBpContainer:setItems(storage.proximaBpID)
createBotSwitch("default", destRight, "Abrir Proxima BP", storage.utilityToggles, "proximaBP")
local transformCoin = UI.Container(function(widget, items) storage.transformarCoin = items end, true, destRight) transformCoin:setHeight(35) transformCoin:setItems(storage.transformarCoin) transformCoin:setMarginTop(4)
createBotSwitch("default", destRight, "Transformar Coin", storage.utilityToggles, "transformCoin")
UI.Separator(destRight)
local doorContainer = UI.Container(function(widget, items) storage.doorIds = items doorId = properTable(storage.doorIds) end, true, destRight) doorContainer:setHeight(35) doorContainer:setItems(storage.doorIds) doorId = properTable(storage.doorIds)
createBotSwitch("default", destRight, "Abrir Portas", storage.utilityToggles, "abrirPortas")
UI.Separator(destRight)
UI.Label("Auto Loot Config", destRight):setFont("verdana-9px")
lootInput = UI.TextEdit("", function(widget, text) end, destRight) lootInput:setImageColor("#828282") lootInput:setFont("verdana-9px")
lootLog = UI.Label("Status: Nenhuma loot ainda", destRight) lootLog:setFont("verdana-9px")
addloot = UI.Button("Add Loot", function()
  local inputText = lootInput:getText()
  if inputText and inputText:len() > 0 then
    for item in inputText:gmatch("[^;]+") do
      item = item:match("^%s*(.-)%s*$")
      if #item > 0 then
        say("!autoloot add,acceptlist," .. item)
        lootLog:setText("Adicionado: " .. item)
      end
    end
    say("!autoloot itemlist,acceptlist")
  else
    warn("Digite ao menos um item.")
  end
end, destRight)
addloot:setImageSource("/images/ui/button_rounded") addloot:setFont("verdana-9px") addloot:setImageColor("#828282")
removeloot = UI.Button("Remove Loot", function()
  local inputText = lootInput:getText()
  if inputText and inputText:len() > 0 then
    for item in inputText:gmatch("[^;]+") do
      item = item:match("^%s*(.-)%s*$")
      if #item > 0 then
        say("!autoloot remove,acceptlist," .. item)
        lootLog:setText("Removido: " .. item)
      end
    end
    -- Mostra lista após remover
    say("!autoloot itemlist,acceptlist")
  else
    warn("Digite ao menos um item.")
  end
end, destRight)
removeloot:setImageSource("/images/ui/button_rounded") removeloot:setFont("verdana-9px") removeloot:setImageColor("#828282")

openctainer = UI.Button("Open Containers", function()
  say("!autoloot containers")
  lootLog:setText("Abrindo menu de containers...")
end, destRight)
openctainer:setImageSource("/images/ui/button_rounded") openctainer:setFont("verdana-9px") openctainer:setImageColor("#828282")
loostlist = UI.Button("Loot List", function()
  say("!autoloot itemlist,acceptlist")
  lootLog:setText("Listando itens do autoloot...")
end, destRight)
loostlist:setImageSource("/images/ui/button_rounded") loostlist:setFont("verdana-9px") loostlist:setImageColor("#828282")

local function getNextBpIdList() local ids = {} for _, entry in pairs(storage.proximaBpID or {}) do table.insert(ids, entry.id or entry) end return ids end

macro(1000, function()
  if storage.utilityToggles["proximaBP"] ~= true then return end
  local containerIds = getNextBpIdList()
  if #containerIds == 0 then return end
  for _, container in pairs(getContainers()) do
    local containerItem = container:getContainerItem()
    if containerItem and table.contains(containerIds, containerItem:getId()) then
      if container:getCapacity() == #container:getItems() then
        for _, item in ipairs(container:getItems()) do
          if table.contains(containerIds, item:getId()) then
            g_game.open(item, container)
            delay(200)
            break
          end
        end
      end
    end
  end
end)

macro(500, function()
  if storage.utilityToggles["transformCoin"] ~= true then return end
  if not storage.transformarCoin[1] then return end
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(storage.transformarCoin) do
            if item:getId() == moneyId.id then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

local targetID = nil

onKeyPress(function(keys)
    if keys == "Escape" and targetID then
        targetID = nil
    end
end)

macro(100, function()
  if storage.utilityToggles["holdTarget"] ~= true then return end

    if target() and target():getPosition().z == posz() and not target():isNpc() then
        targetID = target():getId()
    elseif not target() then
        if not targetID then return end

        for i, spec in ipairs(getSpectators()) do
            local sameFloor = spec:getPosition().z == posz()
            local oldTarget = spec:getId() == targetID
            
            if sameFloor and oldTarget then
                attack(spec)
            end
        end
    end
end)

local vocationsMap = {
  [1] = "Knight", [2] = "Paladin", [3] = "Sorcerer", [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight", [7] = "Royal Paladin", [8] = "Master Sorcerer", [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

local function getVocationType(player)
  if not player then return "knight" end
  local vocId = player:getVocation()
  local vocName = vocationsMap[vocId] or "Unknown"

  if vocName == "Knight" or vocName == "Elite Knight" then
    return "knight"
  elseif vocName == "Paladin" or vocName == "Royal Paladin" then
    return "paladin"
  elseif vocName == "Sorcerer" or vocName == "Master Sorcerer" then
    return "sorcerer"
  elseif vocName == "Druid" or vocName == "Elder Druid" then
    return "druid"
  elseif vocName == "Monk" or vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

local familiarSpellByVoc = {
  knight   = "utevo gran res eq",
  paladin = "utevo gran res sac",
  sorcerer= "utevo gran res ven",
  druid   = " utevo gran res dru",
  monk    = "utevo gran res tio"
}

local lastSummon = 0
local summonCooldown = 1 * 60 * 1000

macro(500, function()
  if storage.utilityToggles["summonFamiliar"] ~= true then return end
  if isInPz() then return; end

  local player = g_game.getLocalPlayer()
  if not player then return end

  if lastSummon > 0 and (now - lastSummon < summonCooldown) then return end

  local vocType = getVocationType(player)
  local spell = familiarSpellByVoc[vocType]
  if not spell or spell == "" then return end

  say(spell)
  delay(5000)
end)

BugMap = {}

local consoleTextEdit = g_ui.getRootWidget():recursiveGetChildById('consoleTextEdit')

local availableKeys = {
  ['W'] = { 0, -3 },
  ['S'] = { 0, 3 },
  ['A'] = { -3, 0 },
  ['D'] = { 3, 0 },
  ['C'] = { 3, 3 },
  ['Z'] = { -3, 3 },
  ['Q'] = { -3, -3 },
  ['E'] = { 3, -3 }
}

local mbKeys = {
  ['Numpad8'] = 0,
  ['Numpad6'] = 1,
  ['Numpad2'] = 2,
  ['Numpad4'] = 3,

  ['Numpad9'] = 4,
  ['Numpad3'] = 5,
  ['Numpad1'] = 6,
  ['Numpad7'] = 7,
}

for key, dir in ipairs(mbKeys) do
  modules.game_walking.unbindWalkKey(key, dir);
end

local mbCounter = 0;

onKeyDown(function(keys) 
  if (mbKeys[keys]) then
      g_game.walk(mbKeys[keys], false);
      mbCounter = 1;
  end
end);

macro(1, function()
  for key, dir in pairs(mbKeys) do
      if (modules.corelib.g_keyboard.isKeyPressed(key)) then
          if (mbCounter == 1) then 
              mbCounter = 0;
              return delay(10);
          end
          g_game.use(dir, false);
      end
  end
end);

macro(100, function() 
  if storage.utilityToggles["superDash"] ~= true or modules.corelib.g_keyboard.isCtrlPressed() then return; end
  if modules.game_console:isChatEnabled() then return; end
  local playerPos = pos()
  local tile
  for key, value in pairs(availableKeys) do
    if (modules.corelib.g_keyboard.isKeyPressed(key)) then
      playerPos.x = playerPos.x + value[1]
      playerPos.y = playerPos.y + value[2]
      tile = g_map.getTile(playerPos)
      break
    end
  end
  if (not tile) then return end
  g_game.use(tile:getTopUseThing())

  -- Adicione o código fornecido aqui
  local item = tile:getTopUseThing()
  if item then
    g_game.useWith(item, g_game.getLocalPlayer())
    g_game.use(item)
  end
end)

-- mais rápido que os convencionais que usam OnKeyPress()
local function checkPos(x, y)
 xyz = g_game.getLocalPlayer():getPosition()
 xyz.x = xyz.x + x
 xyz.y = xyz.y + y
 tile = g_map.getTile(xyz)
 if tile then
  return g_game.use(tile:getTopUseThing())
 else
  return false
 end
end

macro(200, function()
  if modules.corelib.g_keyboard.isKeyPressed('W') then
      turn(0)
  elseif modules.corelib.g_keyboard.isKeyPressed('S') then
      turn(2)
  elseif modules.corelib.g_keyboard.isKeyPressed('A') then
      turn(3)
  elseif modules.corelib.g_keyboard.isKeyPressed('D') then
      turn(1)
  end
end)

local config = {
  SSAID = 3081,
  MIGHTID = 3048,
  ENERGYID = 3088
}

local function isToggleOn(key)
  if not storage.utilityToggles then return false end
  local v = storage.utilityToggles[key]
  if type(v) == "table" then return v.enabled == true end
  return v == true
end

local function findItemInOpenContainers(itemId)
  for _, c in pairs(g_game.getContainers()) do
    if c and not c.lootContainer then
      for __, it in ipairs(c:getItems()) do
        if it and it:getId() == itemId then
          return it
        end
      end
    end
  end
  return nil
end

macro(200, function()
  if not isToggleOn("equipFullSSA") then return end

  local neck = getNeck()
  local hasSSA = neck and neck:getId() == config.SSAID
  if hasSSA then return end

  -- 1) tenta “arrastar” (move pro slot)
  local ssaItem = findItemInOpenContainers(config.SSAID)
  if ssaItem then
    g_game.move(ssaItem, {x = 65535, y = SlotNeck, z = 0}, 1)
    return
  end

  g_game.equipItemId(config.SSAID, SlotNeck)
end)

macro(200, function()
  if not isToggleOn("equipFullMight") then return end

  local finger = getFinger()
  local hasMight = finger and finger:getId() == config.MIGHTID
  if hasMight then return end

  -- 1) tenta arrastar o Might Ring pro SlotFinger
  local mightItem = findItemInOpenContainers(config.MIGHTID)
  if mightItem then
    g_game.move(mightItem, { x = 65535, y = SlotFinger, z = 0 }, 1)
    return
  end

  -- 2) fallback
  g_game.equipItemId(config.MIGHTID, SlotFinger)
end)

macro(500, function()
  if storage.utilityToggles["proximaBP"] ~= true then return end
  if isInPz() then return end
    local pOutifit = player:getOutfit()
    local isMounted = pOutifit.mount ~= nil and pOutifit.mount > 0
    if not isMounted then
        player:mount()
    end
end)

local moveTime = 2000     -- Wait time between Move, 2000 milliseconds = 2 seconds
local moveDist = 5        -- How far to Walk
local useTime = 2000     -- Wait time between Use, 2000 milliseconds = 2 seconds
local useDistance = 1

macro(200, function()
  if storage.utilityToggles["abrirPortas"] ~= true then return end
  for i, tile in ipairs(g_map.getTiles(posz())) do
      local item = tile:getTopUseThing()
      if item and table.find(doorId, item:getId()) then
          local tPos = tile:getPosition()
          local distance = getDistanceBetween(pos(), tPos)
          if (distance <= useDistance) then
              use(item)
              return delay(useTime)
          end

          if (distance <= moveDist and distance > useDistance) then
              if findPath(pos(), tPos, moveDist, { ignoreNonPathable = true, precision = 1 }) then
                  autoWalk(tPos, moveTime, { ignoreNonPathable = true, precision = 1 })
                  return delay(waitTime)
              end
          end
      end
  end
end, destRight)

onAddThing(function(tile, thing)
    if storage.utilityToggles["esconderSprites"] ~= true then return end
    if thing:isEffect() then
        thing:hide()
    end
end)

onStaticText(function(thing, text)
    if storage.utilityToggles["esconderTextos"] ~= true then return end
    if not text:find('says:') then
        g_map.cleanTexts()
    end
end);

onTextMessage(function(mode, text)
    if storage.utilityToggles["esconderTextos"] ~= true then return end
    modules.game_textmessage.clearMessages()
    g_map.cleanTexts()
end);
