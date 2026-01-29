setDefaultTab("Main")

local panelName = "codPanel"
local codPanel = setupUI([[
Panel
  id: codPanel
  height: 60
  margin-top: 0

  HorizontalSeparator
    id: sep1
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

  Label
    id: textLabel2
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 5
    height: 55
    text-align: center
    text-wrap: true
    text-auto-resize: true
    color: gray
    font: sans-bold-16px

  Button
    id: buttonDiscord
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    text: Acessar Discord
    color: orange
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-top: 4
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green

  Label
    id: iconDiscord
    anchors.left: prev.left
    anchors.top: prev.top
    margin-top: 1
    size: 20 20
    image-source: /images/ui/discord

  HorizontalSeparator
    id: sep2
    anchors.left: buttonDiscord.left
    anchors.right: buttonDiscord.right
    anchors.top: buttonDiscord.bottom
    margin-top: 5
]])
codPanel.textLabel2:setText("LNS Custom v1.0")

codPanel.buttonDiscord.onClick = function()
  modules.game_textmessage.displayGameMessage("Carregando convite ao Discord, aguarde...")
end

local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

setDefaultTab("Main")

local label = codPanel.textLabel2

-- cores alvo (RGB)
local colors = {
  {r = 160, g = 160, b = 160}, -- cinza
  {r = 255, g = 255, b = 255}, -- branco
  {r = 20,  g = 20,  b = 20},  -- preto
}

local currentColor = 1
local step = 0
local stepsTotal = 40      -- quanto maior, mais suave
local intervalMs = 50      -- velocidade da animação

local function rgbToHex(r, g, b)
  return string.format("#%02X%02X%02X", r, g, b)
end

local function animateLabelColor()
  local from = colors[currentColor]
  local to   = colors[currentColor % #colors + 1]

  step = step + 1
  local t = step / stepsTotal

  local r = math.floor(from.r + (to.r - from.r) * t)
  local g = math.floor(from.g + (to.g - from.g) * t)
  local b = math.floor(from.b + (to.b - from.b) * t)

  label:setColor(rgbToHex(r, g, b))

  if step >= stepsTotal then
    step = 0
    currentColor = currentColor % #colors + 1
  end
end

macro(intervalMs, function()
  if not label then return end
  animateLabelColor()
end)

MyConfigName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local count = 0
local function removeSeparators()
  for _, i in pairs(modules.game_bot.botWindow.contentsPanel:getChildren()) do
    if count >= 2 then break end
      if i:getStyleName() == "HorizontalSeparator" then
        i:destroy()
        count = count + 1
      end
  end
end
removeSeparators()

local function updateButtonsBot()
    modules.game_bot.contentsPanel.config:setImageColor("gray")
    modules.game_bot.contentsPanel.config:setOpacity(1.00)
    modules.game_bot.contentsPanel.config:setFont("verdana-9px")
    modules.game_bot.contentsPanel.editConfig:setImageColor("gray")
    modules.game_bot.contentsPanel.editConfig:setOpacity(1.00)
    modules.game_bot.contentsPanel.editConfig:setFont("verdana-9px")
    modules.game_bot.contentsPanel.enableButton:setImageColor("gray")
    modules.game_bot.contentsPanel.enableButton:setOpacity(1.00)
    modules.game_bot.contentsPanel.enableButton:setFont("verdana-9px")
    modules.game_bot.botWindow.closeButton:setImageColor("#363434")
    modules.game_bot.botWindow.minimizeButton:setImageColor("#363434")
    modules.game_bot.botWindow.lockButton:setImageColor("#363434")
    modules.game_bot.botWindow:setBorderWidth(1)
    modules.game_bot.botWindow:setImageColor("white")
    modules.game_bot.botWindow:setBorderColor("alpha")
end
updateButtonsBot()