module App.Layer.Four where -- Layers 4 & 3 common to Production and Test

-- | Layer 4
-- | Strong types & pure, total functions on those types
newtype Name = Name String

getName :: Name -> String
getName (Name s) = s


-- NB this is the smallest file in this skeletal example
-- but if you can you'd like to have as much of your code
-- as you possibly can in this Layer!!
