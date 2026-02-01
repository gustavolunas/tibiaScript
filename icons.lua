-- =========================
-- LNS ICONES (ROW TEMPLATE)
-- - Sem _G
-- - Sem select()
-- - Row por ícone: [Check] [Texto] X: [edit] Y: [edit]
-- - X/Y em % (0..100)
-- - CTRL + arrastar no PC (atualiza X/Y no row)
-- - ÍCONE: OFF/ON em cima + texto embaixo
-- - SALVA POR CONFIG + SALVA STATUS ON/OFF
-- =========================
setDefaultTab("Main")
local MyConfigName = modules.game_bot.contentsPanel.config:getCurrentOption().text

-- ✅ DB por config (evita colidir e "voltar ativo" do nada)
storage.lnsIconsDB = storage.lnsIconsDB or {}
storage.lnsIconsDB[MyConfigName] = storage.lnsIconsDB[MyConfigName] or {
  enabled = false,
  iconConfig = {},
  icons = {},        -- posições { [id] = {x=0..1,y=0..1} }
  status = {}        -- status ON/OFF { [id] = true/false }
}

local db = storage.lnsIconsDB[MyConfigName]
db.iconConfig = db.iconConfig or {}
db.icons = db.icons or {}
db.status = db.status or {}

local iconsWithoutPosition = 0

local function clamp(v, a, b)
  if v < a then return a end
  if v > b then return b end
  return v
end

local function v01ToPct(v)
  return math.floor((clamp(v or 0, 0, 1) * 100) + 0.5)
end

local function pctTo01(p)
  return clamp((p or 0) / 100, 0, 1)
end

local function normPct(text)
  local n = tonumber((text or ""):match("%-?%d+"))
  if not n then return nil end
  if n < 0 then n = 0 end
  if n > 100 then n = 100 end
  return math.floor(n)
end

local function applyRelativePos(widget, cfg)
  if not widget or not cfg then return end
  local parent = widget:getParent()
  if not parent then return end

  local r = parent:getRect()
  local w = r.width - widget:getWidth()
  local h = r.height - widget:getHeight()

  widget:setMarginTop(math.max(h * (-0.5) - parent:getMarginTop(), h * (-0.5 + (cfg.y or 0))))
  widget:setMarginLeft(w * (-0.5 + (cfg.x or 0)))
end

-- =========================
-- addIcone (estável + salva status)
-- =========================
local function addIcone(id, options, onPosChanged)
  local panel = modules.game_interface.gameMapPanel
  options = options or {}

  db.icons[id] = db.icons[id] or {}
  local cfg = db.icons[id]

  if type(cfg.x) ~= "number" or type(cfg.y) ~= "number" then
    cfg.x = 0.01 + math.floor(iconsWithoutPosition / 5) / 10
    cfg.y = 0.05 + (iconsWithoutPosition % 5) / 5
    iconsWithoutPosition = iconsWithoutPosition + 1
  end

  local w = g_ui.createWidget("BotIcon", panel)
  w.botWidget = true
  w.botIcon = true

  if options.imageSource then
    w.item:setImageSource(options.imageSource)
  end

  -- ✅ status OFF/ON em cima (SALVO)
  w.status:show()
  local savedStatus = db.status[id]
  if savedStatus == nil then
    savedStatus = (options.defaultOn == true)
  end
  w.status:setOn(savedStatus == true)

  -- ✅ Texto embaixo
  if options.text then
    w.text:setText(options.text)
    w.text:setFont("verdana-9px")
    w.text:setColor("white")
    w.text:setMarginBottom("0")
  else
    w.text:setText("")
  end

  w:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  w:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)

  w.onGeometryChange = function(widget)
    if widget:isDragging() then return end
    applyRelativePos(widget, cfg)
  end

  -- ✅ click alterna status E salva
  w.onClick = function()
    local newState = not w.status:isOn()
    w.status:setOn(newState)
    db.status[id] = newState
  end

  -- CTRL + drag
  if options.movable ~= false then
    w.onDragEnter = function(widget, mousePos)
      if not modules.corelib.g_keyboard.isCtrlPressed() then return false end
      widget:breakAnchors()
      widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
      return true
    end

    w.onDragMove = function(widget, mousePos)
      local pr = widget:getParent():getRect()
      local x = clamp(mousePos.x - widget.movingReference.x, pr.x, pr.x + pr.width - widget:getWidth())
      local y = clamp(mousePos.y - widget.movingReference.y, pr.y - widget:getParent():getMarginTop(), pr.y + pr.height - widget:getHeight())
      widget:move(x, y)
      return true
    end

    w.onDragLeave = function(widget)
      local parent = widget:getParent()
      local pr = parent:getRect()

      local x = widget:getX() - pr.x
      local y = widget:getY() - pr.y
      local width  = pr.width  - widget:getWidth()
      local height = pr.height - widget:getHeight()

      cfg.x = clamp(x / math.max(1, width), 0, 1)
      cfg.y = clamp(y / math.max(1, height), 0, 1)

      widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
      widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
      applyRelativePos(widget, cfg)

      if type(onPosChanged) == "function" then
        onPosChanged(cfg)
      end
      return true
    end
  end

  applyRelativePos(w, cfg)
  return w, cfg
end

-- =========================
-- ROW TEMPLATE (Check + Texto + X/Y)
-- =========================
local rowTemplate = [[
UIWidget
  id: root
  height: 20
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  CheckBox
    id: check
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    margin-top: 3
    width: 18
    height: 18

  Label
    id: text
    anchors.left: check.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    width: 150
    font: verdana-9px-bold
    color: white
    text: ""

  Label
    id: lblX
    anchors.left: text.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    width: 16
    font: verdana-9px
    color: white
    text: "X:"

  BotTextEdit
    id: editX
    anchors.left: lblX.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 3
    width: 36
    height: 18
    text: "0"

  Label
    id: lblY
    anchors.left: editX.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 10
    width: 16
    font: verdana-9px
    color: white
    text: "Y:"

  BotTextEdit
    id: editY
    anchors.left: lblY.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 3
    width: 36
    height: 18
    text: "0"
]]

-- =========================
-- BASE UI
-- =========================
local applyIconsVisibility = function() end

local iconButton = setupUI([[
Panel
  height: 20
  margin-top: -3
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 110
    text: Icones
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
iconButton.title:setOn(db.enabled == true)

iconButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  db.enabled = newState
  applyIconsVisibility()
end

iconsInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 327 360
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
    !text: tr('LNS Custom | Icones Control')
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

  TextEdit
    id: textpesquisarIcon
    anchors.top: topPanel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 8
    margin-right: 8
    margin-top: 5
    width: 240
    font: verdana-9px
    image-color: #363636
    placeholder: TEXTO DE PESQUISA ICON
    placeholder-font: verdana-9px

  TextList
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 2
    margin-right: 20
    margin-left: 8
    margin-bottom: 8
    height: 290
    image-color: #363636
    vertical-scrollbar: spellListScrollBar
    layout: verticalBox

  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    pixels-scroll: true
    image-color: #363636
    margin-top: 0
    margin-bottom: 0
    step: 10
]], g_ui.getRootWidget())
iconsInterface:hide()

iconsInterface.closePanel.onClick = function() iconsInterface:hide() end

iconButton.settings.onClick = function()
  if not iconsInterface:isVisible() then
    iconsInterface:show()
    iconsInterface:raise()
    iconsInterface:focus()
  end
end

-- =========================
-- LISTA
-- =========================
local ICON_LIST = {
  { id="lnsAttackBot",      label="ATTACK BOT",       iconText="ATTACK" },
  { id="lnsHealing",        label="HEALING",          iconText="HEALING" },
  { id="lnsConditions",     label="CONDITIONS",       iconText="CONDIT." },
  { id="lnsSwapRingAMulet", label="SWAP RING/AMULET", iconText="RING/AMULET" },
  { id="lnsFollow",         label="FOLLOW",           iconText="FOLLOW" },
  { id="lnsSwapEquips",     label="SWAP EQUIPS",      iconText="SWAP EQUIPS" },
  { id="lnsHaste",          label="AUTO HASTE",       iconText="HASTE" },
  { id="lnsBuff",           label="AUTO BUFF",        iconText="BUFF" },
  { id="lnsAntiLyze",       label="AUTO ANTI-LYZE",   iconText="ANTI-LYZE" },
  { id="lnsUturaGran",      label="AUTO UTURA GRAN",  iconText="UTURA GRAN" },
  { id="lnsCureStarus",     label="CURE STATUS",      iconText="CURE STATUS" },
  { id="lnsAutoUtamoVita",  label="AUTO UTAMO VITA",  iconText="UTAMO" },
  { id="lnsAutoUtanaVid",   label="AUTO UTANA VID",   iconText="UTANA VID" },
  { id="lnsExetaRes",       label="AUTO EXETA RES",   iconText="EXETA RES" },
  { id="lnsAmpRes",         label="AUTO AMP RES",     iconText="AMP RES" },
  { id="lnsExetaLoot",      label="AUTO EXETA LOOT",  iconText="EXETA LOOT" }
}

for _, it in ipairs(ICON_LIST) do
  it.key = "show_" .. it.id
  if db.iconConfig[it.key] == nil then db.iconConfig[it.key] = true end
end

-- =========================
-- CRIAÇÃO (ícones + rows)
-- =========================
local icons = {}
local rows  = {}

local function safeShow(w) if w and not w:isVisible() then w:show() end end
local function safeHide(w) if w and w:isVisible() then w:hide() end end

applyIconsVisibility = function()
  if db.enabled ~= true then
    for _, it in ipairs(ICON_LIST) do safeHide(icons[it.id]) end
    return
  end

  for _, it in ipairs(ICON_LIST) do
    if db.iconConfig[it.key] then safeShow(icons[it.id]) else safeHide(icons[it.id]) end
  end
end

-- limpa panelMain se recarregar
for _, child in ipairs(iconsInterface.panelMain:getChildren()) do
  child:destroy()
end

for _, it in ipairs(ICON_LIST) do
  local iconWidget, cfg = addIcone(it.id, {
    imageSource = "/bot/" .. MyConfigName .. "/vBot/text2.png",
    movable = true,
    text = it.iconText,
    defaultOn = false
  }, function(newCfg)
    local row = rows[it.id]
    if not row then return end
    row.editX._lnsBlock = true
    row.editY._lnsBlock = true
    row.editX:setText(tostring(v01ToPct(newCfg.x)))
    row.editY:setText(tostring(v01ToPct(newCfg.y)))
    row.editX._lnsBlock = false
    row.editY._lnsBlock = false
  end)

  icons[it.id] = iconWidget

  local row = g_ui.loadUIFromString(rowTemplate, iconsInterface.panelMain)
  row:setId("row_" .. it.id)

  row.text:setText(it.label)
  row.check:setChecked(db.iconConfig[it.key] == true)

  row.editX:setText(tostring(v01ToPct(cfg.x)))
  row.editY:setText(tostring(v01ToPct(cfg.y)))

  row.check.onCheckChange = function(_, checked)
    db.iconConfig[it.key] = checked
    applyIconsVisibility()
  end

  row.editX.onTextChange = function(w)
    if w._lnsBlock then return end
    local v = normPct(w:getText())
    if not v then return end
    cfg.x = pctTo01(v)
    applyRelativePos(iconWidget, cfg)
    w._lnsBlock = true
    w:setText(tostring(v))
    w._lnsBlock = false
  end

  row.editY.onTextChange = function(w)
    if w._lnsBlock then return end
    local v = normPct(w:getText())
    if not v then return end
    cfg.y = pctTo01(v)
    applyRelativePos(iconWidget, cfg)
    w._lnsBlock = true
    w:setText(tostring(v))
    w._lnsBlock = false
  end

  rows[it.id] = { root=row, editX=row.editX, editY=row.editY }
end

applyIconsVisibility()

-- =====================================================
-- PESQUISA / FILTRO (ROW LIST)
-- - procura por parcial/total em: label, iconText, id
-- - botão PROCURAR aplica
-- - texto vazio mostra tudo
-- =====================================================
local function normalizeText(s)
  s = tostring(s or "")
  s = s:lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "") -- trim simples
  return s
end

local function matchesIcon(it, q)
  if q == "" then return true end
  local a = normalizeText(it.label)
  local b = normalizeText(it.iconText)
  local c = normalizeText(it.id)
  return (a:find(q, 1, true) ~= nil) or (b:find(q, 1, true) ~= nil) or (c:find(q, 1, true) ~= nil)
end

local function filterIconRows(query)
  local q = normalizeText(query)

  for _, it in ipairs(ICON_LIST) do
    local rowPack = rows[it.id]
    if rowPack and rowPack.root then
      if matchesIcon(it, q) then
        rowPack.root:show()
      else
        rowPack.root:hide()
      end
    end
  end
end

-- (Opcional) Pesquisar "ao digitar":
-- se você quiser só no botão, pode comentar esse bloco.
iconsInterface.textpesquisarIcon.onTextChange = function(widget, text)
  -- se não quiser "ao digitar", apaga esse onTextChange inteiro
  filterIconRows(text)
end


-- =====================================================
-- BIND ÚNICO: ÍCONE <-> BotSwitch/CheckBox (MÃO DUPLA)
-- =====================================================
local function bindIconToToggle(iconId, toggleWidget, storageKey)
  if not icons or not icons[iconId] then return end
  local icon = icons[iconId]

  storage[storageKey] = storage[storageKey] or { enabled = false }

  local function apply(state)
    state = (state == true)

    -- fonte da verdade
    storage[storageKey].enabled = state
    db.status[iconId] = state

    -- ícone (na hora)
    if icon.status then
      icon.status:show()
      icon.status:setOn(state)
    end

    -- widget real
    if toggleWidget then
      if toggleWidget.setOn then
        toggleWidget:setOn(state)          -- BotSwitch
      elseif toggleWidget.setChecked then
        toggleWidget:setChecked(state)     -- CheckBox
      end
    end
  end

  -- 1) inicial: sempre puxa do storage do botão
  apply(storage[storageKey].enabled)

  -- 2) clique no ícone -> muda tudo
  icon.onClick = function()
    apply(not (storage[storageKey].enabled == true))
  end

  -- 3) clique no widget -> muda tudo
  if toggleWidget then
    if toggleWidget.setOn then
      toggleWidget.onClick = function(w)
        apply(not w:isOn())
      end
    elseif toggleWidget.setChecked then
      toggleWidget.onCheckChange = function(_, checked)
        apply(checked)
      end
    end
  end
end

-- =====================================================
-- ICON <-> CHECKBOX (SEM sobrescrever onCheckChange)
-- Exemplo: lnsHealing -> conditionsInterface.spellUtura
-- =====================================================
local function bindIconToConditionsCheck(iconId, panelName, checkId)
  if not icons or not icons[iconId] then return end
  local icon = icons[iconId]

  storage[panelName] = storage[panelName] or { checks = {}, combos = {}, texts = {} }
  storage[panelName].checks = storage[panelName].checks or {}

  local function getState()
    return storage[panelName].checks[checkId] == true
  end

  local function setState(state)
    state = (state == true)
    storage[panelName].checks[checkId] = state

    -- tenta refletir no checkbox da UI (se existir)
    if conditionsInterface and conditionsInterface[checkId] and conditionsInterface[checkId].setChecked then
      conditionsInterface[checkId]:setChecked(state)
    end

    -- reflete no ícone
    if icon.status then
      icon.status:show()
      icon.status:setOn(state)
    end
  end

  -- 1) inicial: puxa do storage
  setState(getState())

  -- 2) clique no ícone: alterna e manda pro checkbox
  icon.onClick = function()
    setState(not getState())
  end

  -- 3) sync leve: se o usuário clicar no checkbox no painel, o ícone acompanha
  macro(200, function()
    local s = getState()
    if icon.status and icon.status:isOn() ~= s then
      icon.status:setOn(s)
    end
  end)
end

bindIconToConditionsCheck("lnsHaste", "conditionsInterface", "spellHaste")
bindIconToConditionsCheck("lnsBuff", "conditionsInterface", "spellBuff")
bindIconToConditionsCheck("lnsAntiLyze", "conditionsInterface", "spellAntilyze")
bindIconToConditionsCheck("lnsAutoUtamoVita", "conditionsInterface", "spellUtamo")
bindIconToConditionsCheck("lnsAutoUtanaVid", "conditionsInterface", "spellUtana")
bindIconToConditionsCheck("lnsExetaRes", "conditionsInterface", "exetaRes")
bindIconToConditionsCheck("lnsAmpRes", "conditionsInterface", "exetaAmpRes")
bindIconToConditionsCheck("lnsUturaGran", "conditionsInterface", "spellUtura")
bindIconToConditionsCheck("lnsExetaLoot", "conditionsInterface", "exetaLoot")

bindIconToToggle("lnsHealing", healingButton.title, "healingButton")
bindIconToToggle("lnsAttackBot", comboButton.title, "comboButton")
bindIconToToggle("lnsConditions", conditionsButton.title, "conditionsButton")
bindIconToToggle("lnsFollow", followButton.title, "followButton")
bindIconToToggle("lnsSwapEquips", buttonSwapEquips.title, "buttonSwapEquips")
bindIconToToggle("lnsSwapRingAMulet", swapButton.title, "swapButton")
bindIconToToggle("lnsHealing", healingButton.title, "healingButton")
bindIconToToggle("lnsFastTravel", travelButton.title, switchTravel)




local cIcon = addIcon("cI",{text="Cave\nBot",switchable=false,moveable=true}, function()
  if CaveBot.isOff() then 
    CaveBot.setOn()
  else 
    CaveBot.setOff()
  end
end)
cIcon:setSize({height=30,width=55})
cIcon.text:setFont('verdana-11px-rounded')

local tIcon = addIcon("tI",{text="Target\nBot",switchable=false,moveable=true}, function()
  if TargetBot.isOff() then 
    TargetBot.setOn()
  else 
    TargetBot.setOff()
  end
end)
tIcon:setSize({height=30,width=55})
tIcon.text:setFont('verdana-9px')

macro(50,function()
  if CaveBot.isOn() then
    cIcon.text:setColoredText({"CaveBot\n","white","ON","green"})
  else
    cIcon.text:setColoredText({"CaveBot\n","white","OFF","red"})
  end
  if TargetBot.isOn() then
    tIcon.text:setColoredText({"Target\n","white","ON","green"})
  else
    tIcon.text:setColoredText({"Target\n","white","OFF","red"})
  end
end)
