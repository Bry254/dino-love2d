local cactus = { list = {}, timer = 1 }

---Genera un nuevo cactus
function cactus:new()
  table.insert(self.list, { x = 800 })
end

---Actualiza todos los cactus
---@param dt number
function cactus:update(dt)
  if self.timer > 0 then
    self.timer = self.timer - dt * speed
  else
    self.timer = math.random(1, 1.3)
    self:new()
  end

  for i, v in ipairs(self.list) do
    v.x = v.x - dt * 300 * speed
    if v.x < 0 then
      table.remove(self.list, i)
    end
  end
end

---Dibuja los cactus
function cactus:draw()
  for _, v in ipairs(self.list) do
    love.graphics.rectangle("line", v.x, 400, 30, 50)
  end
end

return cactus
