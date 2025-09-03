local algebra = {}

---Multiplica 2 matrices
---@param matrix table
---@param vector table
---@return table
function algebra.Matrix_vector_multiplication(matrix, vector)
  local result = {}
  for i = 1, #matrix do
    local sum = 0
    for j = 1, #matrix[1] do
      sum = sum + matrix[i][j] * vector[j]
    end
    result[i] = sum
  end
  return result
end

---Genera una matriz con numeros aleatorios
---@param rows number
---@param cols number
---@return table
function algebra.Zeroes_matriz(rows, cols)
  local matrix = {}
  for i = 1, rows do
    matrix[i] = {}
    for j = 1, cols do
      matrix[i][j] = math.random() * 2 - 1
    end
  end
  return matrix
end

---Genera un vector con numeros aleatorios
---@param size number
---@return table
function algebra.Random_vector(size)
  local vector = {}
  for i = 1, size do
    vector[i] = love.math.random() * 2 - 1
  end
  return vector
end

---Genera un vector con valores 0
---@param size number
---@return table
function algebra.Zero_vector(size)
  local vector = {}
  for i = 1, size do
    vector[i] = 0
  end
  return vector
end

---Permite sumar vectores
---@param vector1 table
---@param vector2 table
---@return table
function algebra.Suma_Vector(vector1, vector2)
  if #vector1 == #vector2 then
    local resultado = {}
    for i = 1, #vector1 do
      resultado[i] = vector1[i] + vector2[i]
    end
    return resultado
  else
    error("Error: Los vectores tienen diferentes longitudes.")
  end
end

return algebra
