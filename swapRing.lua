local switchSwap = "swapButton"

if not storage[switchSwap] then
    storage[switchSwap] = { enabled = false }
end

swapButton = setupUI([[
Panel
  height: 20
  margin-top: -3
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 110
    text: Swap Ring/Amulet
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
swapButton:setId(switchSwap)
swapButton.title:setOn(storage[switchSwap].enabled)

swapButton.title.onClick = function(widget)
    newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchSwap].enabled = newState
end

panelSwap = setupUI([[  
UIWindow
  id: panelSwap
  size: 260 280
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
    !text: tr('LNS SCRIPT-BOT')
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
    id: abaRingAmulet
    anchors.top: prev.bottom
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 16
    margin-bottom: 10
    margin-left: 5
    margin-right: 5
    image-color: #363636
    layout: verticalBox

  Label
    id: labelRingAmulet
    anchors.verticalCenter: abaRingAmulet.top
    anchors.left: abaRingAmulet.left
    margin-left: 5
    width: 200
    text: SWAP RING & AMULET:
    font: verdana-9px-italic

  BotItem
    id: idRing1
    anchors.top: labelRingAmulet.bottom
    anchors.left: prev.left
    image-source: /images/ui/item-blessed
    margin-top: 5

  BotItem
    id: idEnergyRing
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    image-source: /images/ui/item-blessed

  HorizontalScrollBar
    id: equipEnergy
    anchors.left: idEnergyRing.right
    anchors.top: prev.top
    anchors.right: abaRingAmulet.right
    margin-right: 3
    margin-left: 5
    width: 85
    minimum: 0
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: desequipEnergy
    anchors.left: equipEnergy.left
    anchors.top: equipEnergy.bottom
    anchors.right: equipEnergy.right
    margin-top: 8
    width: 85
    minimum: 0
    maximum: 100
    step: 1

  BotSwitch
    id: labelEnergyRing
    anchors.left: idRing1.left
    anchors.right: desequipEnergy.right
    anchors.top: prev.bottom
    margin-top: 5
    font: verdana-9px
    height: 18
    color: white
    image-source: /images/ui/button_rounded
    $on:
      font: verdana-9px
      color: green

  BotItem
    id: idRing2
    anchors.top: labelEnergyRing.bottom
    anchors.left: idRing1.left
    image-source: /images/ui/item-blessed
    margin-top: 18

  BotItem
    id: idMightRing
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    image-source: /images/ui/item-blessed

  HorizontalScrollBar
    id: equipMight
    anchors.left: idMightRing.right
    anchors.top: prev.top
    anchors.right: abaRingAmulet.right
    margin-right: 3
    margin-left: 5
    width: 85
    minimum: 0
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: desequipMight
    anchors.left: equipMight.left
    anchors.top: equipMight.bottom
    anchors.right: equipMight.right
    margin-top: 8
    width: 85
    minimum: 0
    maximum: 100
    step: 1

  BotSwitch
    id: labelMightRing
    anchors.left: idRing2.left
    anchors.right: desequipEnergy.right
    anchors.top: prev.bottom
    margin-top: 5
    font: verdana-9px
    height: 18
    color: white
    image-source: /images/ui/button_rounded
    $on:
      font: verdana-9px
      color: green

  BotItem
    id: idAmulet1
    anchors.top: labelMightRing.bottom
    anchors.left: idRing1.left
    image-source: /images/ui/item-blessed
    margin-top: 18  

  BotItem
    id: idSSA
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    image-source: /images/ui/item-blessed

  HorizontalScrollBar
    id: equipSSA
    anchors.left: idSSA.right
    anchors.top: prev.top
    anchors.right: abaRingAmulet.right
    margin-right: 3
    margin-left: 5
    width: 85
    minimum: 0
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: desequipSSA
    anchors.left: equipSSA.left
    anchors.top: equipSSA.bottom
    anchors.right: equipSSA.right
    margin-top: 8
    width: 85
    minimum: 0
    maximum: 100
    step: 1

  BotSwitch
    id: labelSSA
    anchors.left: idAmulet1.left
    anchors.right: desequipSSA.right
    anchors.top: prev.bottom
    margin-top: 5
    font: verdana-9px
    height: 18
    color: white
    image-source: /images/ui/button_rounded
    $on:
      font: verdana-9px
      color: green

]], g_ui.getRootWidget())
panelSwap:hide()

local function makeScrollTextLabel(scroll)
  local lb = g_ui.createWidget('Label', scroll)
  lb:setId("txtOverlay")
  lb:setText("")
  lb:setTextAlign(AlignCenter)
  lb:setFont("verdana-9px")
  lb:setColor("white")
  lb:setPhantom(true) -- deixa clicar/arrastar na scrollbar mesmo com label em cima
  lb:fill("parent")
  return lb
end

swapButton.settings.onClick = function()
  panelSwap:setVisible(not panelSwap:isVisible())
end

panelSwap.closePanel.onClick = function()
  panelSwap:hide()
end

local panelSoftBoots = "config_swapping_v5"

local itemsToSave = {
  "idBoots1", "idBoots2",
  "idArmaSingle", "idArmaArea",
  "idArmaNormal", "idArmaLeech",
  "idHelmetNormal", "idHelmetLeech",
  "idRing1", "idEnergyRing",
  "idRing2", "idMightRing",
  "idAmulet1", "idSSA"
}

for _, id in ipairs(itemsToSave) do
    local widget = panelSwap[id]
    if widget then
        if storage[panelSoftBoots .. id] then
            widget:setItemId(storage[panelSoftBoots .. id])
        end
        widget.onItemChange = function(w)
            storage[panelSoftBoots .. id] = w:getItemId()
        end
    end
end

local switchesToSave = {
  "labelBootsMP", 
  "labelSwapArma",
  "labelManaArmaLeech",
  "labelManaHelmetLeech",
  "labelEnergyRing",
  "labelMightRing",
  "labelSSA"
}

for _, id in ipairs(switchesToSave) do
    local widget = panelSwap[id]
    if widget then
        if storage[panelSoftBoots .. id] ~= nil then
            widget:setOn(storage[panelSoftBoots .. id])
        end
        widget.onClick = function(w)
            w:setOn(not w:isOn())
            storage[panelSoftBoots .. id] = w:isOn()
        end
    end
end

local simpleScrolls = {
    {id="menorMPBoots", link="labelBootsMP", txt="MP < ", suf="%", default=75},
    {id="QntdMob", link="labelSwapArma", txt="Mobs >= ", suf="", default=3},
    {id="manaArmaLeech", link="labelManaArmaLeech", txt="Mana < ", suf="%", default=80},
    {id="manaHelmetLeech", link="labelManaHelmetLeech", txt="Mana < ", suf="%", default=60}
}

for _, config in ipairs(simpleScrolls) do
    local widget = panelSwap[config.id]
    local linkedSwitch = panelSwap[config.link]
    
    if widget and linkedSwitch then
        local savedValue = storage[panelSoftBoots .. config.id]
        if savedValue then
            widget:setValue(savedValue)
        else
            widget:setValue(config.default or 0)
        end
        
        local function updateSimpleText(val)
            linkedSwitch:setText(config.txt .. val .. config.suf)
        end

        updateSimpleText(widget:getValue())
        
        widget.onValueChange = function(w, value)
            storage[panelSoftBoots .. config.id] = value
            updateSimpleText(value)
        end
    end
end

local dualScrolls = {
    {
        switch="labelEnergyRing", 
        equipScroll="equipEnergy", 
        unequipScroll="desequipEnergy",
        defaultEq=70, 
        defaultUn=90,
        name="[Energy Ring]"
    },
    {
        switch="labelMightRing", 
        equipScroll="equipMight", 
        unequipScroll="desequipMight",
        defaultEq=70, 
        defaultUn=90,
        name="[Might Ring]"
    },
    {
        switch="labelSSA", 
        equipScroll="equipSSA", 
        unequipScroll="desequipSSA",
        defaultEq=70, 
        defaultUn=90,
        name="[SSA]"
    }
}

for _, group in ipairs(dualScrolls) do
  local swWidget = panelSwap[group.switch]
  local eqWidget = panelSwap[group.equipScroll]
  local unWidget = panelSwap[group.unequipScroll]

  if swWidget and eqWidget and unWidget then
    local savedEq = storage[panelSoftBoots .. group.equipScroll]
    local savedUn = storage[panelSoftBoots .. group.unequipScroll]

    eqWidget:setValue(savedEq or group.defaultEq)
    unWidget:setValue(savedUn or group.defaultUn)

    local eqLabel = eqWidget:recursiveGetChildById("txtOverlay") or makeScrollTextLabel(eqWidget)
    local unLabel = unWidget:recursiveGetChildById("txtOverlay") or makeScrollTextLabel(unWidget)

    local function updateDualText()
      local eqVal = eqWidget:getValue()
      local unVal = unWidget:getValue()

      -- BotSwitch vira só um "toggle", sem texto variável
      swWidget:setText(group.name)

      -- Texto aparece nas scrolls
      eqLabel:setText("            Eq: " .. eqVal .. "%")
      eqLabel:setFont("verdana-9px-italic")
      eqLabel:setColor("green")
      unLabel:setText("            Un: " .. unVal .. "%")
      unLabel:setFont("verdana-9px-italic")
      unLabel:setColor("yellow")
    end

    updateDualText()

    eqWidget.onValueChange = function(_, value)
      storage[panelSoftBoots .. group.equipScroll] = value
      updateDualText()
    end

    unWidget.onValueChange = function(_, value)
      storage[panelSoftBoots .. group.unequipScroll] = value
      updateDualText()
    end
  end
end

macro(200, function()
  if not storage[switchSwap] or storage[switchSwap].enabled ~= true then return end
    if not storage[panelSoftBoots .. "labelSwapArma"] then 
        return 
    end

    local idSingle = storage[panelSoftBoots .. "idArmaSingle"]
    local idArea   = storage[panelSoftBoots .. "idArmaArea"]
    local limitMob = storage[panelSoftBoots .. "QntdMob"] or 3
    local idLeech  = storage[panelSoftBoots .. "idArmaLeech"]
    local weaponSlot = player:getInventoryItem(InventorySlotLeft)
    local currentWeapon = weaponSlot and weaponSlot:getId() or 0

    if not idSingle or idSingle <= 100 or not idArea or idArea <= 100 then return end

    if storage[panelSoftBoots .. "labelManaArmaLeech"] then
        local manaLimit = storage[panelSoftBoots .. "manaArmaLeech"] or 80
        if manapercent() < manaLimit then
        end
    end

    local whitelistMonsters = {"Emberwing", "Skullfrost", "Groovebeast", "Thundergiant"}
    
    local specAmount = 0
    local playerPos = player:getPosition()

    for _, mob in ipairs(getSpectators()) do
        if mob:isMonster() and not mob:isPlayer() and getDistanceBetween(playerPos, mob:getPosition()) <= 5 then
            if not table.find(whitelistMonsters, mob:getName()) then
                specAmount = specAmount + 1
            end
        end
    end

    if g_game.isAttacking() then
        if currentWeapon == idLeech and storage[panelSoftBoots .. "labelManaArmaLeech"] then return end

        if specAmount >= limitMob then
            if currentWeapon ~= idArea then
                g_game.equipItemId(idArea)
            end
        else
            if currentWeapon ~= idSingle then
                g_game.equipItemId(idSingle)
            end
        end
    end
end)

macro(200, function()
  if not storage[switchSwap] or storage[switchSwap].enabled ~= true then return end
    local isAttacking = g_game.isAttacking()
    local manaPct = manapercent()

    if storage[panelSoftBoots .. "labelManaArmaLeech"] then
        local idNormal = storage[panelSoftBoots .. "idArmaNormal"]
        local idLeech  = storage[panelSoftBoots .. "idArmaLeech"]
        local limit    = storage[panelSoftBoots .. "manaArmaLeech"] or 80

        if idNormal and idNormal > 100 and idLeech and idLeech > 100 then
            local leftSlot = player:getInventoryItem(InventorySlotLeft)
            local currentId = leftSlot and leftSlot:getId() or 0

            if not isAttacking then
                if currentId ~= idNormal then
                    g_game.equipItemId(idNormal)
                end
            else
                if manaPct < limit then
                    if currentId ~= idLeech then g_game.equipItemId(idLeech) end
                else
                    if currentId ~= idNormal then g_game.equipItemId(idNormal) end
                end
            end
        end
    end

    if storage[panelSoftBoots .. "labelManaHelmetLeech"] then
        local idNormal = storage[panelSoftBoots .. "idHelmetNormal"]
        local idLeech  = storage[panelSoftBoots .. "idHelmetLeech"]
        local limit    = storage[panelSoftBoots .. "manaHelmetLeech"] or 60

        if idNormal and idNormal > 100 and idLeech and idLeech > 100 then
            local headSlot = player:getInventoryItem(InventorySlotHead)
            local currentId = headSlot and headSlot:getId() or 0

            if not isAttacking then
                if currentId ~= idNormal then
                    g_game.equipItemId(idNormal)
                end
            else
                if manaPct < limit then
                    if currentId ~= idLeech then g_game.equipItemId(idLeech) end
                else
                    if currentId ~= idNormal then g_game.equipItemId(idNormal) end
                end
            end
        end
    end
end)

macro(10, function()
  if not storage[switchSwap] or storage[switchSwap].enabled ~= true then return end

  if storage[panelSoftBoots .. "labelEnergyRing"] then

  local normalId  = storage[panelSoftBoots .. "idRing1"]
  local specialId = storage[panelSoftBoots .. "idEnergyRing"]
  local eq = storage[panelSoftBoots .. "equipEnergy"] or 70
  local un = storage[panelSoftBoots .. "desequipEnergy"] or 90

  local hp = hppercent()
  local mp = manapercent()
  local us = getSlot(SlotFinger) -- ring atual

  -- PZ: garante normal e sai
  if isInPz and isInPz() then
    if not us or us:getId() ~= normalId then
      g_game.equipItemId(normalId)
    end
    return
  end

  -- ✅ se NÃO tiver ring equipado, equipa o normal e sai (igual SSA)
  if not us then
    g_game.equipItemId(normalId)
    return
  end


  -- Equipar Energy (hp baixo + mana >= 15)
  if (hp <= eq and mp >= 15) and (us and us:getId() ~= 3088) then
    g_game.equipItemId(specialId)
    return delay(300)

  -- Voltar normal (hp alto OU mana <= 14)
  elseif (hp >= un or mp <= 14) and (us and us:getId() ~= normalId)  then
    g_game.equipItemId(normalId)
    return delay(300)
  end
end
end)

macro(10, function()
  if not storage[switchSwap] or storage[switchSwap].enabled ~= true then return end
  if storage[panelSoftBoots .. "labelMightRing"] then
  local normalId2 = storage[panelSoftBoots .. "idRing2"]
  local mightId   = storage[panelSoftBoots .. "idMightRing"]
  local eq2       = storage[panelSoftBoots .. "equipMight"] or 70
  local un2       = storage[panelSoftBoots .. "desequipMight"] or 90

  local hp = hppercent()
  local us3 = getSlot(SlotFinger)

  if isInPz and isInPz() then
    if not us3 or us3:getId() ~= normalId2 then
      g_game.equipItemId(normalId2)
    end
    return
  end

  -- ✅ se NÃO tiver ring equipado, equipa o normal e sai (igual SSA)
  if not us3 then
    g_game.equipItemId(normalId2)
    return
  end

  -- Equipar Might
  if (hp <= eq2) and (us and us:getId() ~= 3088) then
    g_game.equipItemId(mightId)
  end

  -- Voltar normal
  if (hp >= un2) and (us and us:getId() ~= normalId2) then
    g_game.equipItemId(normalId2)
  end
end
end)


macro(10, function()
  if not storage[switchSwap] or storage[switchSwap].enabled ~= true then return end
  if storage[panelSoftBoots .. "labelSSA"] then

  local equipPercent    = storage[panelSoftBoots .. "equipSSA"] or 70
  local desequipPercent = storage[panelSoftBoots .. "desequipSSA"] or 90
  local normalItem      = storage[panelSoftBoots .. "idAmulet1"]
  local customItem      = storage[panelSoftBoots .. "idSSA"]
    
  local us2 = getSlot(SlotNeck)
  local hp = hppercent()

  if isInPz and isInPz() then
    if not us2 or us2:getId() ~= normalItem then
      g_game.equipItemId(normalItem)
    end
    return
  end

  if not us2 then
    g_game.equipItemId(normalItem)
    return
  end

  if us2 and us2:getId() ~= customItem and us2:getId() ~= normalItem then
    g_game.equipItemId(normalItem)
  end

  if hp <= equipPercent then
    if not us2 or us2:getId() ~= customItem then
      g_game.equipItemId(customItem)
    end

  elseif hp >= desequipPercent or not us2 or us2:getId() <= 0 then
    if not us2 or us2:getId() ~= normalItem then
      g_game.equipItemId(normalItem)
    end
  end
end
end)