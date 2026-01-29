switchConditions = "conditionsButton"
local panelName = "conditionsInterface"

if not storage[panelName] then
  storage[panelName] = {
    checks = {},
    combos = {},
    texts  = {}
  }
end

if not storage[switchConditions] then
    storage[switchConditions] = { enabled = false }
end

conditionsButton = setupUI([[
Panel
  height: 20
  margin-top: -3
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 110
    text: Conditions
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
conditionsButton:setId(switchConditions)
conditionsButton.title:setOn(storage[switchConditions].enabled)

conditionsButton.title.onClick = function(widget)
    newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchConditions].enabled = newState
end

conditionsInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 310 340
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
    !text: tr('LNS Custom | Perfect Conditions')
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

  FlatPanel
    id: panelSpeed
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 15
    margin-right: 8
    margin-left: 8
    height: 105
    image-color: #363636
    layout: verticalBox

  Label
    id: labelSpeed
    anchors.top: prev.top
    anchors.left: panelMain.left
    text: SPEED & BUFFS:
    text-auto-resize: true
    font: verdana-9px-italic
    margin-top: -5
    margin-left: 10

  CheckBox
    id: spellHaste
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    width: 90
    text: Haste:
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  ComboBox
    id: comboHaste
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: panelSpeed.right
    margin-right: 10
    width: 130
    image-color: #828282
    @onSetup: |
      self:addOption("")
      self:addOption("Utani Hur")
      self:addOption("Utani Gran Hur")
      self:addOption("Utani Tempo Hur")

  CheckBox
    id: spellBuff
    anchors.top: prev.bottom
    anchors.left: spellHaste.left
    margin-top: 8
    width: 90
    text: Buff:
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  ComboBox
    id: comboBuff
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: panelSpeed.right
    margin-right: 10
    width: 130
    image-color: #828282
    @onSetup: |
      self:addOption("")
      self:addOption("Utito Tempo")
      self:addOption("Utito Tempo San")
      
  CheckBox
    id: spellAntilyze
    anchors.top: prev.bottom
    anchors.left: spellBuff.left
    margin-top: 8
    width: 90
    text: AntiLyze:
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  BotTextEdit
    id: comboAntilyze
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: panelSpeed.right
    margin-right: 10
    width: 130
    image-color: #828282

  CheckBox
    id: spellUtura
    anchors.top: prev.bottom
    anchors.left: spellAntilyze.left
    anchors.right: panelSpeed.right
    margin-top: 8
    text: Utura Gran
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  FlatPanel
    id: panelMain
    anchors.top: panelSpeed.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 10
    margin-right: 8
    margin-left: 8
    height: 55
    image-color: #363636
    layout: verticalBox

  Label
    id: labelHealing
    anchors.top: prev.top
    anchors.left: panelMain.left
    text: CURE STATUS:
    text-auto-resize: true
    font: verdana-9px-italic
    margin-top: -5
    margin-left: 10

  CheckBox
    id: curePoison
    anchors.top: prev.bottom
    anchors.left: labelHealing.left
    margin-top: 8
    width: 110
    text: Poison
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  CheckBox
    id: cureFire
    anchors.top: prev.top
    anchors.left: prev.right
    width: 100
    text: Burn
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  CheckBox
    id: cureEnergy
    anchors.top: prev.top
    anchors.left: prev.right
    width: 110
    text: Energy
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  CheckBox
    id: cureCurse
    anchors.top: curePoison.bottom
    anchors.left: labelHealing.left
    margin-top: 12
    width: 110
    text: Curse
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  CheckBox
    id: cureBleeding
    anchors.top: prev.top
    anchors.left: prev.right
    width: 100
    text: Bleed
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  FlatPanel
    id: abaSelfBuffs
    anchors.top: panelMain.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 10
    margin-right: 8
    margin-left: 8
    height: 120
    image-color: #363636
    layout: verticalBox

  Label
    id: labelCureStatus
    anchors.top: prev.top
    anchors.left: abaSelfBuffs.left
    text: TOOLS CONFIGURATIONS:
    text-auto-resize: true
    font: verdana-9px-italic
    margin-top: -5
    margin-left: 10

  CheckBox
    id: spellUtamo
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    text-auto-resize: true
    text: Auto Magic Shield
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  CheckBox
    id: spellUtana
    anchors.top: prev.bottom
    anchors.left: spellHaste.left
    margin-top: 8
    text: Auto Invisible
    text-auto-resize: true
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  CheckBox
    id: exetaRes
    anchors.top: prev.bottom
    anchors.left: spellHaste.left
    margin-top: 8
    text: Exeta Res
    text-auto-resize: true
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round
    
  CheckBox
    id: exetaAmpRes
    anchors.top: prev.bottom
    anchors.left: spellHaste.left
    margin-top: 8
    text: Amp Res:
    width: 90
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

  BotTextEdit
    id: textAmpRes
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: panelSpeed.right
    margin-right: 10
    width: 130
    height: 18
    image-color: #828282

  CheckBox
    id: exetaLoot
    anchors.top: exetaAmpRes.bottom
    anchors.left: spellHaste.left
    margin-top: 8
    text: Exeta Loot
    text-auto-resize: true
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/checkbox_round

]], g_ui.getRootWidget())
conditionsInterface:hide();

conditionsInterface.closePanel.onClick = function()
  conditionsInterface:hide()
end

conditionsButton.settings.onClick = function()
    if not conditionsInterface:isVisible() then
        conditionsInterface:show()
        conditionsInterface:raise()
        conditionsInterface:focus()
    end
end

local function bindCheck(id)
  local w = conditionsInterface[id]
  if not w then return end

  if storage[panelName].checks[id] ~= nil then
    w:setChecked(storage[panelName].checks[id] and true or false)
  else
    storage[panelName].checks[id] = w:isChecked() and true or false
  end

  w.onCheckChange = function(widget, checked)
    storage[panelName].checks[id] = checked and true or false
  end
end

local function bindCombo(id)
  local combo = conditionsInterface[id]
  if not combo then return end

  if storage[panelName].combos[id] ~= nil then
    combo:setCurrentOption(storage[panelName].combos[id])
  else
    storage[panelName].combos[id] = combo:getCurrentOption()
  end

  combo.onOptionChange = function(widget, option)
    storage[panelName].combos[id] = option
  end
end

local function bindText(id)
  local w = conditionsInterface[id]
  if not w then return end

  if storage[panelName].texts[id] ~= nil then
    w:setText(tostring(storage[panelName].texts[id]))
  else
    storage[panelName].texts[id] = w:getText() or ""
  end

  w.onTextChange = function(widget, text)
    storage[panelName].texts[id] = tostring(text or "")
  end
end

bindCheck("spellHaste")
bindCombo("comboHaste")

bindCheck("spellBuff")
bindCombo("comboBuff")

bindCheck("spellAntilyze")
bindText("comboAntilyze")

bindCheck("spellUtura")

bindCheck("curePoison")
bindCheck("cureFire")
bindCheck("cureEnergy")
bindCheck("cureCurse")
bindCheck("cureBleeding")

bindCheck("spellUtamo")
bindCheck("spellUtana")
bindCheck("exetaRes")
bindCheck("exetaAmpRes")
bindText("textAmpRes")
bindCheck("exetaLoot")

local userUturaTimer = 0
local userBuffTimer = 0

onTalk(function(name, level, mode, text, channelId, pos)
    if name ~= g_game.getLocalPlayer():getName() then return end
    text = text:lower()
    if text == 'utura gran' then
       userUturaTimer = now + 60500 
    end
    if text == 'utito tempo' or text == 'utito tempo san' then
        userBuffTimer = now + 10500
    end
end)

local _lastMovePos = nil
local _lastMoveMs  = 0

local function isMovingRecently(ms)
  ms = ms or 250
  local p = pos()
  if not p then return false end

  if not _lastMovePos then
    _lastMovePos = {x=p.x, y=p.y, z=p.z}
    return false
  end

  if p.x ~= _lastMovePos.x or p.y ~= _lastMovePos.y or p.z ~= _lastMovePos.z then
    _lastMovePos = {x=p.x, y=p.y, z=p.z}
    _lastMoveMs = now
    return true
  end

  return (_lastMoveMs > 0 and (now - _lastMoveMs) <= ms)
end

macro(200,  function()
    if not storage["conditionsButton"] or not storage["conditionsButton"].enabled then return end
    
    local player = g_game.getLocalPlayer()
    if not player then return end
    if player:isNpc() then return end

    local cfg = storage["conditionsInterface"]
    if not cfg then return end

    if cfg.checks["spellAntilyze"] then
        if isParalyzed() then
            local spell = cfg.texts["comboAntilyze"]
            if spell and spell ~= "" then
                say(spell)
                return
            end
        end
    end

    if cfg.checks["spellHaste"] then
      if not hasHaste() and not isParalyzed() then
        if isInPz() then return end

        -- SÓ CASTA HASTE SE ESTIVER EM MOVIMENTO
        if not isMovingRecently(250) then return end

        local spell = cfg.combos["comboHaste"]
        if spell and spell ~= "" then
          say(spell)
        end
      end
    end

    if cfg.checks["spellBuff"] then
        if g_game.isAttacking() and not hasPartyBuff() and (now > userBuffTimer) then
            local spell = cfg.combos["comboBuff"]
            if spell and spell ~= "" then
                say(spell)
                userBuffTimer = now + 1000 
            end
        end
    end

    if cfg.checks["spellUtura"] then
        if player:getMana() >= 200 and (now > userUturaTimer) then
          say("utura gran")
          userUturaTimer = now + 2000 
        end
    end
end)

macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end
  if not storage[panelName] or not storage[panelName].checks then return end

  local checks = storage[panelName].checks

  if checks.curePoison and isPoisioned() then
    say('exana pox')
    return
  end

  if checks.cureFire and isBurning() then
    say('exana flam')
    return
  end

  if checks.cureEnergy and isEnergized() then
    say('exana vis')
    return
  end

  if checks.cureCurse and isCursed() then
    say('exana mort')
    return
  end

  if checks.cureBleeding and isBleeding() then
    say('exana kor')
    return
  end
end)

macro(200, function()
  if not storage["conditionsButton"] or not storage["conditionsButton"].enabled then return end
  if not storage["conditionsInterface"] or not storage["conditionsInterface"].checks then return end
  if not storage["conditionsInterface"].checks.spellUtamo then return end

  if not hasManaShield() then
    say("utamo vita")
  end
end)

local utanaCast = 0
macro(200, function()
  if not storage["conditionsButton"] or not storage["conditionsButton"].enabled then return end
  if not storage["conditionsInterface"] or not storage["conditionsInterface"].checks then return end
  if not storage["conditionsInterface"].checks.spellUtana then return end

  if mana() < 441 then return end
  if utanaCast > 0 and (now - utanaCast < 120000) then return end

  say("utana vid")
  utanaCast = now
end)

local lastExetaRes = 0
local exetaResCooldown = 2000
macro(200, function()
  if not storage["conditionsButton"] or not storage["conditionsButton"].enabled then return end
  if not storage["conditionsInterface"] or not storage["conditionsInterface"].checks then return end
  if not storage["conditionsInterface"].checks.exetaRes then return end
  if isInPz() then return end
  if not g_game.isAttacking() then return end
  if now - lastExetaRes < exetaResCooldown then return end

  say("exeta res")
  lastExetaRes = now
end)

local lastExetaAmpRes = 0
local exetaAmpResCooldown = 6000
macro(200, function()
  if not storage["conditionsButton"] or not storage["conditionsButton"].enabled then return end
  if not storage["conditionsInterface"] or not storage["conditionsInterface"].checks then return end
  if not storage["conditionsInterface"].checks.exetaAmpRes then return end
  if isInPz() then return end
  if not g_game.isAttacking() then return end
  if now - lastExetaAmpRes < exetaAmpResCooldown then return end

  local spell = storage["conditionsInterface"].texts and storage["conditionsInterface"].texts["textAmpRes"]
  spell = tostring(spell or "")
  spell = spell:gsub("^%s+", ""):gsub("%s+$", "")

  if spell == "" then
    spell = "exeta amp res"
  end

  say(spell)
  delay(3000)
end)

local function countMonstersAround(range)
  local me = pos()
  if not me then return 0 end

  local count = 0
  for _, c in ipairs(getSpectators(false)) do
    if c and c.isMonster and c:isMonster() then
      local p = c:getPosition()
      if p and p.z == me.z then
        local dx = math.abs(p.x - me.x)
        local dy = math.abs(p.y - me.y)
        if math.max(dx, dy) <= range then
          count = count + 1
        end
      end
    end
  end
  return count
end


local lastExetaLoot = 0
local exetaLootCooldown = 2000
local rangeCheck = 3

local lastMobsAround = 0
local lastHadTarget = 0
local fightGraceMs = 2000

macro(200, function()
  if not storage["conditionsButton"] or not storage["conditionsButton"].enabled then return end
  if not storage["conditionsInterface"] or not storage["conditionsInterface"].checks then return end
  if not storage["conditionsInterface"].checks.exetaLoot then return end
  if isInPz() then return end
  if now - lastExetaLoot < exetaLootCooldown then return end

  if g_game.isAttacking() then
    lastHadTarget = now
  end

  local mobsAround = 0
  local me = pos()
  if not me then return end

  for _, c in ipairs(getSpectators(false)) do
    if c and c.isMonster and c:isMonster() then
      local p = c:getPosition()
      if p and p.z == me.z then
        local dx = math.abs(p.x - me.x)
        local dy = math.abs(p.y - me.y)
        if math.max(dx, dy) <= rangeCheck then
          mobsAround = mobsAround + 1
        end
      end
    end
  end

  local hadRealFight = (lastHadTarget > 0 and (now - lastHadTarget) <= fightGraceMs)

  if lastMobsAround > 0 and mobsAround == 0 and not g_game.isAttacking() and hadRealFight then
    delay(200)
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    lastExetaLoot = now
  end

  lastMobsAround = mobsAround
end)

