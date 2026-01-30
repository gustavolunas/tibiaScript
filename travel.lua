switchTravel = "travelButton"

storage[switchTravel] = storage[switchTravel] or { enabled = false }

travelButton = setupUI([[
Panel
  height: 20
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    width: 110
    text: Fast Travel
    font: verdana-9px
    color: white
    image-source: /images/ui/button_rounded
    $on:
      font: verdana-9px
      color: green
      image-color: gray
    $!on:
      image-color: gray
      color: white
]])
travelButton:setId(switchTravel)
travelButton.title:setOn(storage[switchTravel].enabled)

travelButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchTravel].enabled = newState
end


if panelNPC and not panelNPC:isDestroyed() then
  panelNPC:destroy()
end

panelNPC = setupUI([[
UIWindow
  id: panelNPC
  size: 380 250
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
    !text: tr('LNS Custom | Fast Travel')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray

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

  FlatPanel
    id: labelMSGNPC
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 18
    margin-left: 5
    margin-right: 5
    height: 70
    image-color: #363636
    layout: verticalBox

  FlatPanel
    id: botoesdeAcao
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-top: 6
    margin-left: 5
    margin-bottom: 6
    margin-right: 5
    image-color: #363636
    layout: verticalBox
]], g_ui.getRootWidget())

panelNPC:hide()

panelNPC.closePanel.onClick = function()
  panelNPC:hide()
end

-- label interno p/ msg do NPC
if panelNPC.labelMSGNPC and not panelNPC.labelMSGNPC.msg then
  local lbl = g_ui.createWidget("Label", panelNPC.labelMSGNPC)
  lbl:setId("msg")
  lbl:setText("")
  lbl:setTextWrap(true)
  lbl:setColor("white")
  lbl:setFont("verdana-11px-rounded")
  lbl:setMarginLeft(6)
  lbl:setMarginTop(6)
  lbl:setHeight(60)
end

-- =========================
-- NPC.talk (padrão)
-- =========================
NPC = NPC or {}
NPC.talk = function(text)
  if g_game.getClientVersion and g_game.getClientVersion() >= 810 then
    g_game.talkChannel(11, 0, text)
  else
    say(text)
  end
end

-- =========================
-- HELPERS
-- =========================
local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function myPos()
  local p = g_game.getLocalPlayer()
  if p and p.getPosition then return p:getPosition() end
  return nil
end

local function dist(a, b)
  if not a or not b then return 999 end
  if a.z ~= b.z then return 999 end
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function setNpcText(text)
  if panelNPC and panelNPC.labelMSGNPC and panelNPC.labelMSGNPC.msg then
    panelNPC.labelMSGNPC.msg:setText(text or "")
  end
end

-- =========================
-- GRID 3 COLUNAS
-- =========================
local GRID_COLS = 3
local gridRows = {}
local gridIndex = 0

local function ensureRow(row)
  if gridRows[row] and not gridRows[row]:isDestroyed() then
    return gridRows[row]
  end

  local p = setupUI([[
Panel
  height: 20
  margin-left: 4
  margin-top: 5
  layout:
    type: horizontalBox
]], panelNPC.botoesdeAcao)

  gridRows[row] = p
  return p
end

local function clearButtons()
  gridRows = {}
  gridIndex = 0
  for _, c in pairs(panelNPC.botoesdeAcao:getChildren()) do
    c:destroy()
  end
end

local function sanitizeCityText(city)
  city = tostring(city or "")
  city = city:gsub("[{}]", "")
  city = city:gsub("%s+", " ")
  city = trim(city)
  return city
end

local function baseWidth()
  local w = panelNPC.botoesdeAcao:getWidth() or 360
  return (w - 12)
end

local function buttonWidth()
  return math.floor(baseWidth() / GRID_COLS)
end

-- =========================
-- BOTÃO (setupUI com text-align center)
-- =========================
local function addCityButton(city)
  city = sanitizeCityText(city)
  if city == "" then return end

  gridIndex = gridIndex + 1
  local row = math.floor((gridIndex - 1) / GRID_COLS) + 1
  local rowPanel = ensureRow(row)
  if not rowPanel then return end

  local btn = setupUI([[
Button
  height: 20
  text-align: center
  image-source: /images/ui/button_rounded
  image-color: #363636
  color: white
  font: verdana-11px-rounded
]], rowPanel)

  btn:setText(city)
  btn:setWidth(buttonWidth()) -- ✅ sempre padrão, inclusive última linha

  btn.onClick = function()
    schedule(120, function() NPC.talk(city) end)
    schedule(320, function() NPC.talk("yes") end)
  end
end

-- =========================
-- EXTRAÇÃO DE CIDADES
-- =========================
local function extractCities(text)
  if type(text) ~= "string" then return nil end

  local list =
      text:match("[Ww]here do you want to go%??%s*[Tt]o%s+(.+)%?") or
      text:match("[Ww]here do you want to go%s*[-:%–]%s*(.+)%?") or
      text:match("[Ww]here do you want to go%s*[-:%–]%s*(.+)$") or
      text:match("[Ii] can take you to%s+(.+)%.*") or
      text:match("[Yy]ou can travel to%s+(.+)%.*") or
      text:match("[Pp]assages? to%s+(.+)%.*")

  if not list then return nil end

  list = list:gsub("%s+and%s+", ", ")
  list = list:gsub("%s+or%s+", ", ")
  list = list:gsub("%s+e%s+", ", ")

  local out, seen = {}, {}
  for part in list:gmatch("([^,]+)") do
    local city = tostring(part):gsub("[%?%.!]+$", "")
    city = sanitizeCityText(city)
    if city:lower() == "kick" then city = "" end

    if city ~= "" and not seen[city:lower()] then
      seen[city:lower()] = true
      table.insert(out, city)
    end
  end

  return (#out > 0) and out or nil
end

-- =========================
-- STATE
-- =========================
local lastNpcText = ""
local lastNpcPos = nil

-- =========================
-- HOOK: onTalk
-- =========================
onTalk(function(name, level, mode, text, channelId, creaturePos)
  if not storage[switchTravel].enabled then return end
  if not panelNPC or panelNPC:isDestroyed() then return end
  if type(name) ~= "string" or type(text) ~= "string" then return end
  if not creaturePos then return end

  local cities = extractCities(text)
  if not cities then return end

  local me = myPos()
  if dist(me, creaturePos) > 2 then return end

  if text == lastNpcText then return end
  lastNpcText = text
  lastNpcPos = creaturePos

  clearButtons()
  local cleanLabel = (name .. ": " .. text):gsub("[{}]", "")
  setNpcText(cleanLabel)

  for _, city in ipairs(cities) do
    addCityButton(city)
  end

  panelNPC:show()
end)

-- =========================
-- Auto-hide ao afastar
-- =========================
macro(200, function()
  if not panelNPC or panelNPC:isDestroyed() then return end
  if not panelNPC:isVisible() then return end
  if not lastNpcPos then return end

  local me = myPos()
  if dist(me, lastNpcPos) > 4 then
    lastNpcText = ""
    lastNpcPos = nil
    setNpcText("")
    clearButtons()
    panelNPC:hide()
  end
end)

onAttackingCreatureChange(function(creature, OldCreature)
    if creature and creature:isNpc() and distanceFromPlayer(creature:getPosition()) <= 3 then
        CaveBot.Conversation("hi", "sail")
        CaveBot.Conversation("hi", "trade")
    end

end)

UI.Separator()

