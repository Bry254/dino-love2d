local code, dino, cactus, brain, dinos, mutate, colision, copy, encode, random_dino

function love.load()
  print("RUTA DE GUARDADO", love.filesystem.getSaveDirectory())
  math.randomseed(os.time())
  code = require("lib.tools.code")
  ser = require("lib.tools.ser")

  dino = require("dino")
  cactus = require("enemy")
  brain = require("brain")
  
  --Genera una tabla para guardar a los dinos
  dinos = {}
  --Genera a 1000 dinos con valores al azar
  for i = 1, 1000 do
    table.insert(dinos, dino.new(brain:new()))
  end

  random_dino = math.random(1, #dinos)
  timer = 0
  cerebro = {}
  generaciones = 0
  score = 0

  speed = 1.8
  mutate = brain.mutate
  colision = code.colision
  copy = table.clone
  encode = ser.to_str
end

---Regenera a los dinos con cerebros de los mejores puntajes
---@param num number
---@param cant number
local function Regenerar(num, cant)
  collectgarbage("collect")
  for _ = 1, cant do
    table.insert(dinos, dino.new(mutate(cerebro[num], 0.5)))
  end
  random_dino = math.random(1, #dinos)
end

function love.update(dt)
  --Guarda los cerebros con mejor puntaje
  if #dinos <= 10 and cerebro[1] == nil then
    for _, v in ipairs(dinos) do
      table.insert(cerebro, copy(v.brain))
    end
  end
  --Regenera los dinos de forma automaticatica
  if #dinos == 0 then
    score = math.max(timer, score)
    generaciones = generaciones + 1
    for _ = 1, 4 do
      Regenerar(#cerebro, math.ceil(1500 / #cerebro))
    end
    cerebro = {}
    cactus.list = {}
    timer = 0
  end

  ---Actualiza a los dinosaurios
  timer = timer + dt
  for i, v in ipairs(dinos) do
    dino:update(v, dt)
    if #cactus.list > 0 then
      local decision = brain.update(v.brain, v.x, v.y, cactus.list[1].x, 400)
      if decision > 0 then
        dino.jump(v)
      end
      if colision(v, { x = cactus.list[1].x, y = 400, width = 30, height = 50 }) then
        table.remove(dinos, i)
      end
    end
  end
  --Actualiza los 'cactus'
  cactus:update(dt)
end

function love.draw()
  for i, v in ipairs(dinos) do
    dino.draw(v)
  end

  --Muestra el cerebro de un dinosaurio al azar
  if dinos[random_dino] then
    brain.draw(dinos[random_dino].brain)
  else
    random_dino = math.random(1, #dinos)
  end

  --Muestra datos importantes
  love.graphics.print(string.format(
    "Puntaje: %s\nDinos: %s\nGeneraciones: %s\nMejor puntaje: %s\nFps: %s\nCerebro de dino: %s\nPresione escape para mas opciones",
    math.ceil(timer), #dinos, generaciones, math.ceil(score), love.timer.getFPS(), random_dino))
  cactus:draw()
end

function love.keypressed(key)
  if key == 'escape' then
    local res = love.window.showMessageBox('OPCIONES', 'Opciones',
      { 'salir', 'Exportar dino', 'Cargar dino', 'Cancelar', escapebutton = 4 })
    if res == 1 then
      love.event.quit()
    elseif res == 2 then
      love.filesystem.write('cerebro.data', encode(copy(dinos[1].brain)))
      local r = love.window.showMessageBox("GUARDADO",
        string.format('Guardado en %s', love.filesystem.getSaveDirectory()),
        { 'Abrir Carpeta', 'Aceptar', escapebutton = 2 })
      if r == 1 then
        os.execute(string.format('explorer.exe "%s"', love.filesystem.getSaveDirectory()))
      end
    elseif res == 2 then
      table.insert(dinos, dino:new("CARGADO", ser.to_table(love.filesystem.read("cerebro.data"))))
    end
  end
end
