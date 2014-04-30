// =================================================================================
//
// lua\ModelScaleMixin.lua
//
//    Created by:   Andy 'Soul Rider' Wilson for GorgeCraft
//
//  This mixin is used to scale models.  
//
//  Requirements:
//  Globals.lua - Expects kGameScale to exist and have a value > 0
//  
//  Note: This mixin scales the models coords, but you will have to manually adjust viewoffsets etc.  
//  This is why I recommend a global for simple consistency.
//
//  Example for adding to Gorge.lua:
//  Script.Load("lua/ModelScaleMixin")
//  
//  add to Gorge:OnCreate()
//  InitMixin(self, ModelScaleMixin)
//  If you want to override the global scale, then create a SetScaleOverride function in the object to change it.
//  e.g. for a gorge you would create in Gorge.lua:
//  function Gorge:SetScaleOverride()
//      local newScale = 0.75
//      return newScale
//  end
//  This will scale the model based on the actual model size, and not on the game scale size.
//
//  The ScaleCoords function can be used independently of models, so other coords based objects can be scaled, but this mixin
//  is designed to work with model based objects.  To create a more flexible system, it would be simple to create a ScaleMixin
//  and make a model scaling mixin extend that.
//
// =================================================================================

Script.Load("lua/Globals.lua")

local globalScale = kGameScale

ModelScaleMixin = CreateMixin( ModelScaleMixin )
ModelScaleMixin.type = "ModelScale"

ModelScaleMixin.optionalCallbacks =
{
    SetScaleOverride = "Sets a value to override the default gamescale for an object",
}

function ModelScaleMixin:__initmixin() 
end

local function GetGlobalScale()
    //Check globalScale is greater than 0.  If this assertion error 
    //appears check kGameScale is set in Globals.lua
    assert(globalScale > 0)
    return globalScale
end

function ModelScaleMixin:GetOverrideScale()
    //Check overrideScale is greater than 0.  If this assertion error 
    //appears check the values in the object:SetScaleOverride() function 
    overrideScale = self:SetScaleOverride()
    assert(overrideScale > 0)
    return overrideScale
end

function ModelScaleMixin:ScaleCoords(scalingCoords)
    
    local coords = scalingCoords
    //Check coords have been sent through
    assert(coords)
    //if coords exist and no scale override scale according to global amount
    if coords and not self.SetScaleOverride then
        local scale = GetGlobalScale()
        coords.xAxis = coords.xAxis * scale
        coords.yAxis = coords.yAxis * scale
        coords.zAxis = coords.zAxis * scale
        return coords
    //if coords exist and scale override exists scale according to override amount
    elseif coords and self.SetScaleOverride then      
        local scale = self:GetOverrideScale()        
        coords.xAxis = coords.xAxis * scale
        coords.yAxis = coords.yAxis * scale
        coords.zAxis = coords.zAxis * scale
        return coords
    else        
        //for testing enable print to pick up any exceptions that come to this point
        //PrintToLog("ScaleCoords could not scale item")
        //for any other case, just return the original coords
        return coords
    end
end
    
function ModelScaleMixin:OnAdjustModelCoords(modelCoords)

    local scaledCoords = self:ScaleCoords(modelCoords)
    return scaledCoords
    
end