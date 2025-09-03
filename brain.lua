local algebra = require("linear_algebra")
local brain = { matriz = {}, pesos = {}, sesgo = {} }

---@param vector table
---@return table
function Relu(vector)
  local r = {}
  for _, v in ipairs(vector) do
    table.insert(r, math.max(0, v))
  end
  return r
end

---"Muta" un cerebro
---@param brain table
---@param mutacion number
---@return table
function brain.mutate(brain, mutacion)
  local r = {}

  r.matriz = {}
  for i, vector in ipairs(brain.matriz) do
    r.matriz[i] = {}
    for j, value in ipairs(vector) do
      if math.random() < mutacion then
        r.matriz[i][j] = value + math.random() * 0.2 - 0.1
      else
        r.matriz[i][j] = value
      end
    end
  end

  r.pesos = {}
  for i, matrix in ipairs(brain.pesos) do
    r.pesos[i] = {}
    for j, row in ipairs(matrix) do
      r.pesos[i][j] = {}
      for k, value in ipairs(row) do
        if math.random() < mutacion then
          r.pesos[i][j][k] = value + math.random() * 0.2 - 0.1
        else
          r.pesos[i][j][k] = value
        end
      end
    end
  end

  r.sesgo = {}
  for i, sesgo in ipairs(brain.sesgo) do
    r.sesgo[i] = {}
    for j, valor in ipairs(sesgo) do
      r.sesgo[i][j] = 0
      if math.random() < mutacion then
        r.sesgo[i][j] = valor + math.random() * 0.2 - 0.1
      else
        r.sesgo[i][j] = valor
      end
    end
  end
  return r
end

---Crea un nuevo cerebro
---@return table
function brain:new()
  local r = { matriz = {}, pesos = {}, sesgo = {} }
  r.matriz[1] = algebra.Zero_vector(4)
  r.pesos[1] = algebra.Zeroes_matriz(3, 4)
  r.sesgo[1] = algebra.Random_vector(3)

  r.matriz[2] = algebra.Zero_vector(3)
  r.pesos[2] = algebra.Zeroes_matriz(1, 3)
  r.sesgo[2] = algebra.Random_vector(1)

  r.matriz[3] = { 0 }
  return r
end

---Da parametros a un cerebro y retorna su respuesta
---@param xdino number
---@param ydino number
---@param xcactus number
---@param ycactus number
---@return number
function brain:update(xdino, ydino, xcactus, ycactus)
  self.matriz[1] = { xdino, ydino, xcactus, ycactus }
  self.matriz[2] = Relu(algebra.Suma_Vector(algebra.Matrix_vector_multiplication(self.pesos[1], self.matriz[1]),
    self.sesgo[1]))
  self.matriz[3] = Relu(algebra.Suma_Vector(algebra.Matrix_vector_multiplication(self.pesos[2], self.matriz[2]),
    self.sesgo[2]))
  return self.matriz[3][1]
end

local unpack = table.unpack or unpack
function brain:draw()
  if self.matriz then
    for y, matriz in ipairs(self.matriz) do
      for x, v in ipairs(matriz) do
        love.graphics.print(v, 150 * x - 7, 50 * y - 7 - 25)
        love.graphics.circle("line", 150 * x, 50 * y - 25, 15)
      end
    end
  end
end

---Guarda un cerebro en un archivo
---@param file string
function brain:save(file)
  love.filesystem.write(file, ser.to_str(self))
end

---Carga el cerebro guardado
---@param file string
---@return table
function brain.load(file)
  ---@diagnostic disable-next-line: redundant-parameter
  return ser.to_table(love.filesystem.read(file))
end

return brain
