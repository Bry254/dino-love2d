local dino = { gravity = 1440, jumpHeight = 600 }

---Genera un nuevo dinosaurio
---@param brain table
---@return table
function dino.new(brain)
  return { y = 400, salto = 0, allow = true, width = 50, height = 50, x = math.random(70, 130), brain = brain }
end

function dino:jump()
  if self.allow then
    self.salto = 0.25
  end
end

---Actualiza un dino
---@param v table
---@param dt number
function dino:update(v, dt)
  if v.salto > 0 then
    v.salto = v.salto - dt * speed
    v.y = v.y - dt * self.gravity * speed
  end

  if v.y < 400 then
    v.allow = false
    v.y = v.y + dt * self.jumpHeight * speed
  else
    v.allow = true
    v.y = 400
  end
end

function dino:draw()
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return dino
