-- Ensure there is an active sprite
local originalSprite = app.activeSprite
assert(originalSprite, "There is no active sprite")

-- Create a new sprite with the same dimensions and color mode
local copySprite = Sprite(originalSprite.width, originalSprite.height, originalSprite.colorMode)

-- Copy all layers and frames from the original sprite to the new sprite
for _, originalLayer in ipairs(originalSprite.layers) do
    -- Create a new layer in the copy sprite
    local copiedLayer = copySprite:newLayer()
    copiedLayer.name = originalLayer.name

    -- Copy cels (frames) from the original layer to the new layer
    for frameIndex = 1, #originalSprite.frames do
        local cel = originalLayer:cel(frameIndex)
        if #copySprite.frames < frameIndex then
          copySprite:newFrame()
        end
        if cel then
            local copiedCel = copySprite:newCel(copiedLayer, frameIndex)
            copiedCel.image:drawImage(cel.image, cel.position)
        end
    end
end

-- Set active sprite to the copy to perform flattening and outline
app.activeSprite = copySprite

-- Flatten all visible layers in the copy
app.command.FlattenLayers{ visibleOnly=true }

-- Now, there should be only one layer in the copy
local flattenedLayer = copySprite.layers[1]

-- Step 3: Prompt user to select a pixel color for the outline
local dlg = Dialog("Select Outline Color")
dlg:color{ id="color", label="Outline Color", color=Color{ r=0, g=0, b=0 } }
dlg:button{ id="ok", text="OK" }
dlg:button{ id="cancel", text="Cancel" }
dlg:show()

local data = dlg.data
if data.cancel then
    app.alert("Operation canceled.")
    copySprite:close()
    return
end

local outlineColor = data.color.rgbaPixel

for frameIndex = 1, #copySprite.frames do
-- Create the outline with the specified color and disable UI interaction
  app.frame = copySprite.frames[frameIndex]
  local outlineCommand = app.command.Outline {
      color=outlineColor,
      size=1,
      position="outside",
      ui=false
  }
end

-- Step 4: Extract the outline into its own layer

local outlineLayer = copySprite:newLayer()
outlineLayer.name = "Outline Layer"

-- Iterate over flattened layer pixels to copy outline pixels
for frameIndex = 1, #copySprite.frames do
  local outlineImage = Image(copySprite.width, copySprite.height, copySprite.colorMode)
  outlineImage:clear()
  for y = 0, copySprite.height - 1 do
      for x = 0, copySprite.width - 1 do
          local img = flattenedLayer:cel(frameIndex).image
          if img ~= nil then
            local pixel = flattenedLayer:cel(frameIndex).image:getPixel(x, y)
            -- local pixelColor = Color{ r=pixel.red, g=pixel.green, b=pixel.blue }

            -- Check if the pixel matches the outline color (with a tolerance)
            -- if pixelColor:isEqual(outlineColor, 10) then
            if pixel == outlineColor then
                outlineImage:putPixel(x, y, pixel)
            end
          end
      end
  end
  local outlineCel = copySprite:newCel(outlineLayer, frameIndex)
  outlineCel.image:drawImage(outlineImage)
  outlineCel.position = flattenedLayer:cel(frameIndex).position -- Maintain the position
end

-- Create a new layer in the original sprite
app.activeSprite = originalSprite
local newOutlineLayer = originalSprite:newLayer()
newOutlineLayer.name = "Outline"

-- Step 5: Copy the colored outline back to the original asset
for frameIndex = 1, #copySprite.frames do
  local outlineFinalImage = outlineLayer:cel(frameIndex).image:clone()
  local outlinePosition = outlineLayer:cel(frameIndex).position -- Get the position

  -- Paste the outline image into the new layer
  local newOutlineCel = originalSprite:newCel(newOutlineLayer, frameIndex)
  newOutlineCel.image:drawImage(outlineFinalImage, outlinePosition)
end
-- Cleanup
copySprite:close()
app.refresh()
app.alert("Colored outline created successfully on its own layer")

