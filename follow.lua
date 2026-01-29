local scriptsPanelName = "Scriptss"

if not storage[scriptsPanelName] then
    storage[scriptsPanelName] = {
        texts = {
            navAttack = "",
            navLeader = "",
            UELeader = "",
            UESpell = "",
            ropeID = "3003"
        },
        checkboxes = {
            attackCheck = false,
            followCheck = false,
            useUEcheck = false
        },
        -- IDs padrões
        useIDS = { 435 },
        ropeIDS = { 386 },
        stairIDS = { 484, 17394, 1977, 414 },
        buracoIDS = { 1959 },
        doorsIDS = { }
    }
end

storage[scriptsPanelName].texts = storage[scriptsPanelName].texts or {}
storage[scriptsPanelName].checkboxes = storage[scriptsPanelName].checkboxes or {}

local switchFollow = "followButton"

if not storage[switchFollow] then
    storage[switchFollow] = { enabled = false }
end

followButton = setupUI([[
Panel
  height: 20
  margin-top: -3
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 110
    text: Follow
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

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 0
    height: 17
    text: Config
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])
followButton:setId(switchFollow)
followButton.title:setOn(storage[switchFollow].enabled)

followButton.title.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchFollow].enabled = newState
end

local navPanel = setupUI([[  
UIWindow
  id: navPanel
  size: 390 335
  !text: tr('')
  text-align: top-left
  font: verdana-11px-rounded
  border: 1 black
  anchors.centerIn: parent
  color: white

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
    !text: tr('LNS Custom | Follow Control')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray
  
  Panel
    id: iconPanel
    anchors.top: topPanel.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -28
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
      
  FlatPanel
    id: navConfig
    anchors.top: prev.bottom
    anchors.left: parent.left
    image-color: #363636
    height: 150
    width: 180
    margin-top: 15
    margin-left: 10
    layout: verticalBox

  Label
    id: navLabel
    anchors.verticalCenter: navConfig.top
    anchors.left: navConfig.left
    margin-left: 5
    text: FOLLOW CONFIG:
    text-auto-resize: true
    font: verdana-9px-italic

  Label
    id: labelAttack
    anchors.top: navLabel.bottom
    anchors.left: navLabel.left
    margin-top: 10
    text: Leader Attack:
    font: verdana-11px-rounded
    text-auto-resize: true
    color: gray

  BotTextEdit
    id: navAttack
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navConfig.right
    margin-right: 5
    image-color: gray
    
  Label
    id: labelFollow
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    text: Player Follow:
    font: verdana-11px-rounded
    text-auto-resize: true
    color: gray

  BotTextEdit
    id: navLeader
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navConfig.right
    margin-right: 5
    image-color: gray

  CheckBox
    id: attackCheck
    anchors.top: prev.bottom
    anchors.left: prev.left
    text-auto-resize: true
    image-source: /images/ui/checkbox_round
    font: verdana-9px-italic
    color: gray
    margin-top: 12
    margin-left: 0
    text: ATTACK LEADER

  CheckBox
    id: followCheck
    anchors.top: prev.bottom
    anchors.left: prev.left
    text-auto-resize: true
    image-source: /images/ui/checkbox_round
    font: verdana-9px-italic
    color: gray
    margin-top: 7
    text: FOLLOW PLAYER

  FlatPanel
    id: navUEConfig
    anchors.top: navConfig.bottom
    anchors.left: parent.left
    height: 130
    width: 180
    image-color: #363636
    margin-left: 10
    margin-top: 10
    layout: verticalBox

  Label
    id: UELabel
    anchors.verticalCenter: navUEConfig.top
    anchors.left: navUEConfig.left
    margin-left: 5
    text: UE CONFIG:
    text-auto-resize: true
    font: verdana-9px-italic

  Label
    id: labelUELeader
    anchors.top: UELabel.bottom
    anchors.left: UELabel.left
    margin-top: 10
    text: Leader UE:
    text-auto-resize: true
    font: verdana-11px-rounded
    color: gray

  BotTextEdit
    id: UELeader
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navUEConfig.right
    margin-right: 5
    image-color: gray

  Label
    id: UESpellLabel
    anchors.top: UELeader.bottom
    anchors.left: UELeader.left
    margin-top: 10
    text: UE Spell:
    text-auto-resize: true
    font: verdana-11px-rounded
    color: gray
    visible: true

  BotTextEdit
    id: UESpell
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navConfig.right
    margin-right: 5
    image-color: gray

  CheckBox
    id: useUEcheck
    anchors.top: prev.bottom
    anchors.left: prev.left
    text-auto-resize: true
    image-source: /images/ui/checkbox_round
    font: verdana-9px-italic
    color: gray
    margin-top: 12
    margin-left: 0
    text: USAR UE

  FlatPanel
    id: toolsNav
    anchors.top: navConfig.top
    anchors.left: navConfig.right
    height: 289
    width: 180
    margin-left: 10
    image-color: #363636
    layout: verticalBox

  Label
    id: toolsNavLabel
    anchors.verticalCenter: toolsNav.top
    anchors.left: toolsNav.left
    margin-left: 5
    text: TOOLS FOLLOW CONFIG
    text-auto-resize: true
    font: verdana-9px-italic

  Label
    id: IDHOPE
    anchors.top: toolsNavLabel.bottom
    anchors.left: toolsNavLabel.left
    margin-top: 10
    text: ROPE ID:
    font: verdana-9px-italic
    
  BotTextEdit
    id: ropeID
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: toolsNav.right
    margin-right: 5
    image-color: gray

  Label
    id: RopeLabel
    anchors.top: prev.bottom
    anchors.left: toolsNavLabel.left
    margin-top: 10
    text: IDS CORDA:
    font: verdana-9px-italic

  BotContainer
    id: ropeIds
    anchors.top: prev.bottom
    anchors.left: toolsNavLabel.left
    anchors.right: toolsNav.right
    margin-left: -2
    margin-right: 2
    height: 34

  Label
    id: useLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    text: IDS USE:
    font: verdana-9px-italic

  BotContainer
    id: useIds
    anchors.top: prev.bottom
    anchors.left: toolsNavLabel.left
    anchors.right: toolsNav.right
    margin-left: -2
    margin-right: 2
    height: 34

  Label
    id: stairLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    text: IDS ESCADA:
    font: verdana-9px-italic

  BotContainer
    id: stairIds
    anchors.top: prev.bottom
    anchors.left: toolsNavLabel.left
    anchors.right: toolsNav.right
    margin-left: -2
    margin-right: 2
    height: 34

  Label
    id: buracoLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    text: IDS BURACOS & TELEPORTS:
    font: verdana-9px-italic

  BotContainer
    id: buracoIds
    anchors.top: prev.bottom
    anchors.left: toolsNavLabel.left
    anchors.right: toolsNav.right
    margin-left: -2
    margin-right: 2
    height: 34


]], g_ui.getRootWidget())
navPanel:hide()
navPanel:setId(scriptsPanelName)

followButton.settings.onClick = function()
  navPanel:show()
end

navPanel.closePanel.onClick = function()
  navPanel:hide()
end

local textEditDefaults = {
  navAttack = "",
  navLeader = "",
  UELeader = "",
  UESpell = "",
  ropeID = "3003"
}

local textEditIds = { "navAttack", "navLeader", "UELeader", "UESpell", "ropeID"}
for _, id in ipairs(textEditIds) do
  local textEdit = navPanel:getChildById(id)
  if textEdit then
    local savedText = storage[scriptsPanelName].texts[id]
    textEdit:setText(savedText or textEditDefaults[id])

    textEdit.onTextChange = function(widget, text)
      storage[scriptsPanelName].texts[id] = text
    end
  end
end

local checkBoxIds = { "attackCheck", "followCheck", "useUEcheck" }

for _, id in ipairs(checkBoxIds) do
  local checkbox = navPanel:getChildById(id)
  if checkbox then
    -- carregar valor salvo ou usar default (false)
    local savedValue = storage[scriptsPanelName].checkboxes[id]
    if savedValue ~= nil then
      checkbox:setChecked(savedValue)
    end

    -- toda vez que mudar, salvar no charStorage
    checkbox.onCheckChange = function(widget, checked)
      storage[scriptsPanelName].checkboxes[id] = checked
    end
  end
end

local useROPEContainer = navPanel:getChildById('ropeIds')
local useIDSContainer = navPanel:getChildById('useIds')
local stairIDSContainer = navPanel:getChildById('stairIds')
local buracoIDSContainer = navPanel:getChildById('buracoIds')

if not storage[scriptsPanelName] then
  storage[scriptsPanelName] = {
    useIDS   = { 435 },
    ropeIDS  = { 386 },
    stairIDS = { 484, 17394, 1977, 414 },
    buracoIDS = { 1959 },
    doorsIDS    = { }
  }
end

UI.Container(function()
  if useROPEContainer then
    storage[scriptsPanelName].ropeIDS = useROPEContainer:getItems()
  end
end, true, nil, useROPEContainer)
if useROPEContainer then
  useROPEContainer:setItems(storage[scriptsPanelName].ropeIDS or {})
end

UI.Container(function()
  if useIDSContainer then
    storage[scriptsPanelName].useIDS = useIDSContainer:getItems()
  end
end, true, nil, useIDSContainer)
if useIDSContainer then
  useIDSContainer:setItems(storage[scriptsPanelName].useIDS or {})
end

UI.Container(function()
  if stairIDSContainer then
    storage[scriptsPanelName].stairIDS = stairIDSContainer:getItems()
  end
end, true, nil, stairIDSContainer)
if stairIDSContainer then
  stairIDSContainer:setItems(storage[scriptsPanelName].stairIDS or {})
end

UI.Container(function()
  if buracoIDSContainer then
    storage[scriptsPanelName].buracoIDS = buracoIDSContainer:getItems()
  end
end, true, nil, buracoIDSContainer)
if buracoIDSContainer then
  buracoIDSContainer:setItems(storage[scriptsPanelName].buracoIDS or {})
end

-- =================================================================
-- PARTE 1: CONFIGURAÇÃO E STORAGE
-- =================================================================

-- Função Ajudante para ler o formato de storage {id, count}
local function containsId(list, id)
    if not list then return false end
    for _, entry in ipairs(list) do
        if tonumber(entry.id) == tonumber(id) then
            return true
        end
    end
    return false
end

leaderPositions = {}
leaderDirections = {}
leaderUsePositions = {}
local leader
local lastLeaderFloor
local ropeId = 3003
local standTime = now

-- =================================================================
-- PARTE 2: FUNÇÕES DE AÇÃO E LÓGICA PRINCIPAL
-- =================================================================

-- Ações que o personagem pode tomar
local function handleUse(pos)
    local tile = g_map.getTile(pos)
    if tile and tile:getTopUseThing() then g_game.use(tile:getTopUseThing()) end
end

local function handleRope(pos)
  local ropeIdd = storage[scriptsPanelName].texts["ropeID"]
    local tile = g_map.getTile(pos)
    if tile and tile:getTopUseThing() then useWith(tonumber(ropeIdd), tile:getTopUseThing()) end
end

-- <<-- NOVO: Ação de andar até o local (para escadas e buracos)
local function handleStep(pos)
    autoWalk(pos, 40, {ignoreNonPathable=true, precision=1})
end

-- Funções de Movimento e Utilidade
local function distance(pos1, pos2)
    pos2 = pos2 or player:getPosition()
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function executeClosest(possibilities)
    local closest, closestDistance = nil, 99
    for _, data in ipairs(possibilities) do
        local dist = distance(data.pos, leaderPositions[posz()] or player:getPosition())
        if dist < closestDistance then
            closest, closestDistance = data, dist
        end
    end
    if closest then closest.action(closest.pos); return true end
    return false
end

-- <<-- CORRIGIDO E UNIFICADO: Função principal para mudar de andar
local function handleFloorChange()
    local p = player:getPosition()
    local s = storage[scriptsPanelName]
    local possibleChangers = {}

    -- Mapeia cada lista de IDs do storage para a ação correta
    local actionMap = {
        { ids = s.useIDS,    action = handleUse  },
        { ids = s.ropeIDS,   action = handleRope },
        { ids = s.stairIDS,  action = handleStep },
        { ids = s.buracoIDS, action = handleStep }
    }

    -- Itera sobre cada tipo de ação e seus IDs
    for _, mapEntry in ipairs(actionMap) do
        if mapEntry.ids and #mapEntry.ids > 0 then
            -- Procura por tiles em volta do personagem
            for x = -2, 2 do
                for y = -2, 2 do
                    local checkPos = {x = p.x + x, y = p.y + y, z = p.z}
                    local tile = g_map.getTile(checkPos)
                    
                    if tile and tile:getTopUseThing() and containsId(mapEntry.ids, tile:getTopUseThing():getId()) then
                        table.insert(possibleChangers, {action = mapEntry.action, pos = checkPos})
                    end
                end
            end
        end
    end

    if #possibleChangers > 0 then return executeClosest(possibleChangers) end
    return false
end

local function levitate(dir)
    turn(dir); schedule(200, function() say('exani hur "down'); say('exani hur "up') end)
end
local function matchPos(p1, p2) return (p1.x == p2.x and p1.y == p2.y) end
local function handleUsing()
    local usePos = leaderUsePositions[posz()]
    if usePos then
        local useTile = g_map.getOrCreateTile(usePos)
        if useTile and useTile:getTopUseThing() then use(useTile:getTopUseThing()) end
    end
end
local function getStandTime() return now - standTime end

local function useRope(pos) -- Esta função pode ser útil se o handleFloorChange falhar
    pos = pos or player:getPosition()
    for x = -1, 1 do
        for y = -1, 1 do
            local tpos = {x = pos.x + x, y = pos.y + y, z = posz()}
            local tile = g_map.getTile(tpos)
            if tile and tile:getGround() then
                -- <<-- CORRIGIDO: Usando 'ropeIDS' (minúsculo)
                if containsId(storage[scriptsPanelName].ropeIDS, tile:getGround():getId()) then
                    handleRope(tpos)
                    delay(getDistanceBetween(player:getPosition(), tpos) * 60)
                    return true
                end
            end
        end
    end
    return false
end

local function handleDoors()
    if not leader then return false end
    -- <<-- CORRIGIDO: Usando 'doorsIDS' (minúsculo)
    local doorIds = storage[scriptsPanelName].useIDS or {}
    local lpos = leader:getPosition()
    for x = lpos.x - 1, lpos.x + 1 do
        for y = lpos.y - 1, lpos.y + 1 do
            local pos = {x = x, y = y, z = lpos.z}
            local tile = g_map.getTile(pos)
            if tile and tile:getTopUseThing() and containsId(doorIds, tile:getTopUseThing():getId()) then
                g_game.use(tile:getTopUseThing())
                delay(200)
                return true
            end
        end
    end
    return false
end

local function handleLeaderInteraction()
    if not leader then return false end
    local lpos = leader:getPosition()
    -- <<-- CORRIGIDO: Usando 'useIDS' (minúsculo)
    local useIds = storage[scriptsPanelName].useIDS or {}
    for x = -1, 1 do
        for y = -1, 1 do
            local tpos = {x = lpos.x + x, y = lpos.y + y, z = lpos.z}
            local tile = g_map.getTile(tpos)
            if tile and tile:getTopUseThing() and containsId(useIds, tile:getTopUseThing():getId()) then
                handleUse(tpos)
                delay(100)
                return true
            end
        end
    end
    return false
end

-- =================================================================
-- PARTE 3: MACRO E EVENTOS (SUA LÓGICA ORIGINAL)
-- =================================================================
local lastKnownPosition

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(300, 700))
        end
    end
end

local function checkTargetPos()
    local c = getCreatureByName(target)
    if c and c:getPosition().z == posz() then
        lastKnownPosition = c:getPosition()
    end
end
local function targetMissing()
    for _, n in ipairs(getSpectators(false)) do
        if n:getName() == target then
            return n:getPosition().z ~= posz()
        end
    end
    return true
end


macro(200, function()
  if not storage[switchFollow] or storage[switchFollow].enabled ~= true then return end
  local target = storage[scriptsPanelName].texts["navLeader"]
  if not navPanel.followCheck:isChecked() then return; end
  if not g_game.isAttacking() then
    local c = getCreatureByName(target)

    if g_game.isFollowing() then
        if g_game.getFollowingCreature() ~= c then
            g_game.cancelFollow()
            g_game.follow(c)
        end
    end

    if c and not g_game.isFollowing() then
        g_game.follow(c)
    elseif c and g_game.isFollowing() and getDistanceBetween(pos(), c:getPosition()) > 1 then
        g_game.cancelFollow()
        g_game.follow(c)
    end
    
    if not c then
        local leaderPos = leaderPositions[posz()]
        if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
            autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=5})
            delay(500)
        end
        if handleDoors() then return end

        if handleLeaderInteraction() then return end
        
        if handleFloorChange() then return end
        local dir = leaderDirections[posz()]
        if dir then levitate(dir) end
        local levitatePos = listenedLeaderPosDir
        if levitatePos and matchPos(player:getPosition(), levitatePos) then
            levitate(listenedLeaderDir)
        end
        if useRope(leaderPos) then return end
        handleUsing()
    end

    if not c then
        local leaderPos = leaderPositions[posz()]
        if leaderPos and getDistanceBetween(pos(), leaderPos) > 1 then
            if handleDoors() or handleLeaderInteraction() or handleFloorChange() or useRope(leaderPos) then
            end
        end
        return
    end

    local dist = getDistanceBetween(pos(), c:getPosition())
    if dist > 3 and not c then
        g_game.cancelFollow()
        if handleDoors() or handleLeaderInteraction() or handleFloorChange() or useRope(c:getPosition()) then
            -- nada a fazer aqui
        end
    end
  end
end)

macro(200, function()
  if not storage[switchFollow] or storage[switchFollow].enabled ~= true then return end
  if g_game.isAttacking() and navPanel.followCheck:isChecked() then
    if not leader then
        local leaderPos = leaderPositions[posz()]
        if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
            -- autoWalk sem delay pesado, apenas checagem rápida
            autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=1})
            return
        end

        -- Mantém todas as interações com portas, leader, floor change
        if handleDoors() then return end
        if handleLeaderInteraction() then return end
        if handleFloorChange() then return end

        local dir = leaderDirections[posz()]
        if dir then levitate(dir) end

        local levitatePos = listenedLeaderPosDir
        if levitatePos and matchPos(player:getPosition(), levitatePos) then
            levitate(listenedLeaderDir)
            return
        end

        if useRope(leaderPos) then return end
        handleUsing()
    else
        listenedLeaderPosDir, listenedLeaderDir = nil, nil
        local lpos = leader:getPosition()
        local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=true}
        local distance = getDistanceBetween(player:getPosition(), lpos)
        local path = findPath(player:getPosition(), lpos, 200, parameters)

        -- Se estiver longe e sem caminho, tenta interações
        if distance > 1 and not path then
            handleUsing()
            handleDoors()
        elseif distance > 2 then
            -- autoWalk direto sem delay
            if getStandTime() > 300 then
                autoWalk(lpos, 200, parameters)
            end
        end
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if not navPanel.followCheck:isChecked() then return; end
    if creature:getName() == player:getName() then standTime = now; return end
    if creature:getName():lower() ~= (storage[scriptsPanelName].texts["navLeader"] or ""):lower() then return end
    if newPos then
        leaderPositions[newPos.z] = newPos
        lastLeaderFloor = newPos.z
        if newPos.z == posz() then leader = creature else leader = nil end
    else
        leader = nil
    end
    if oldPos and newPos and oldPos.z ~= newPos.z then
        leaderDirections[oldPos.z] = creature:getDirection()
    end
end)

onCreatureAppear(function(creature)
    if not navPanel.followCheck:isChecked() then return; end
    if creature:getName():lower() == (storage[scriptsPanelName].texts["navLeader"] or ""):lower() and creature:getPosition().z == posz() then
        leader = creature
    end
end)

onCreatureDisappear(function(creature)
    if not navPanel.followCheck:isChecked() then return; end
    if creature:getName():lower() == (storage[scriptsPanelName].texts["navLeader"] or ""):lower() then
        leader = nil
    end
end)

function followLeader()
  local leaderToFollow = storage[scriptsPanelName].texts["navLeader"]

  if leaderToFollow and leaderToFollow ~= '' then
    local creature = Creature.find(leaderToFollow)
    if creature then
      g_game.follow(creature)
    end
  end
end

onMissle(function(missle)
  local src = missle:getSource()
  if src.z ~= posz() then return end
  
  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end
  
  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end
  
  local c1 = fromCreatures[1]
  local t1 = toCreatures[1]
  
  if t1:getName():lower() == storage[scriptsPanelName].texts["navAttack"]:lower() then return end
  
  if c1:getName():lower() == storage[scriptsPanelName].texts["navAttack"]:lower() then
    if navPanel.attackCheck:isChecked() then
    local target = g_game.getAttackingCreature()
      if not target or target ~= t1 then
        g_game.attack(t1)
      end
    end
  end
end)
