module HeterogeneousLog.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Console (log)
import Heterogeneous.Folding (class Folding, class FoldingWithIndex, class HFoldl, class HFoldlWithIndex, hfoldl, hfoldlWithIndex)
import Heterogeneous.Mapping (class HMap, class HMapWithIndex, class Mapping, class MappingWithIndex, hmap, hmapWithIndex)
import Prim.Row as Row
import Prim.RowList as RL
import Prim.Symbol (class Append)
import Prim.TypeError (class Fail, Text)
import Record as Record
import Type.Proxy (Proxy(..))

main :: Effect Unit
main = do
  demoMapping
  demoMappingWithIndex
  demoFolding
  demoFoldingWithIndex

printSection :: String -> Effect Unit -> Effect Unit
printSection header runSection = do
  log "======================"
  log header
  log "======================"
  runSection
  log ""

demoMapping :: Effect Unit
demoMapping = do
  printSection "Mapping" do
    let
      recordValue =
        { field1: Tuple 1 true
        , field2: Tuple true 1
        , field3: Tuple "a value" unit
        , field4: Tuple (Just [ 1 ]) (Just [ 2 ])
        }
    log $ append "GetFirst: " $ show $ getFirst recordValue

    -- this won't compile since the field type is `Int`, not `Tuple`:
    -- log $ append "GetFirst: " $ show $ getFirst { fieldName: 2 }

    log $ append "OverwriteValues 1: " $ show $ overwriteValues (OverwriteValues 1) recordValue
    log $ append "OverwriteValues 2: " $ show $ overwriteValues (OverwriteValues "something else") recordValue

data GetFirst = GetFirst

instance Mapping GetFirst (Tuple a b) a where
  mapping GetFirst (Tuple a _) = a

-- Provide a better error message if we pass in a record with the wrong field type(s).
else instance Fail (Text "This only works on fields whose types are Tuple") => Mapping GetFirst ignored ignored where
  mapping GetFirst a = a

-- | Converts `{ foo: Tuple 1 true }` to `{ foo: 1 }`
getFirst
  :: forall rowsIn rowsInRL rowsOut
   . RL.RowToList rowsIn rowsInRL
  => HMap GetFirst { | rowsIn } { | rowsOut }
  => { | rowsIn }
  -> { | rowsOut }
getFirst r = hmap GetFirst r

data OverwriteValues a = OverwriteValues a

instance Mapping (OverwriteValues a) fieldTypeIgnored a where
  mapping (OverwriteValues a) _ = a

-- | Converts `{ foo: Tuple 1 true }` to `{ foo: overrideValue }`
overwriteValues
  :: forall rowsIn rowsInRL a rowsOut
   . RL.RowToList rowsIn rowsInRL
  => HMap (OverwriteValues a) { | rowsIn } { | rowsOut }
  => OverwriteValues a
  -> { | rowsIn }
  -> { | rowsOut }
overwriteValues newValueForEachLabel r = hmap newValueForEachLabel r

--------------------------------------------------------------------

demoMappingWithIndex :: Effect Unit
demoMappingWithIndex = do
  printSection "MappingWithIndex" do
    let
      recordValue =
        { field1: Tuple 1 true
        , field2: Tuple true 1
        , field3: Tuple "a value" unit
        , field4: Tuple (Just [ 1 ]) (Just [ 2 ])
        }
    log $ append "ReflectFieldLabels: " $ show $ reflectFieldLabels recordValue

data ReflectFieldLabels = ReflectFieldLabels

instance (IsSymbol fieldName) => MappingWithIndex ReflectFieldLabels (Proxy fieldName) fieldTypeIgnored String where
  mappingWithIndex ReflectFieldLabels proxy _ = reflectSymbol proxy

-- | Converts `{ foo: Tuple 1 true }` to `{ foo: "foo" }`
reflectFieldLabels
  :: forall rowsIn rowsInRL rowsOut
   . RL.RowToList rowsIn rowsInRL
  => HMapWithIndex ReflectFieldLabels { | rowsIn } { | rowsOut }
  => { | rowsIn }
  -> { | rowsOut }
reflectFieldLabels r = hmapWithIndex ReflectFieldLabels r

--------------------------------------------------------------------

demoFolding :: Effect Unit
demoFolding = do
  printSection "Folding" do
    log $ append "AsNestedTuple - FieldCount 0: " $ show $ asNestedTuple {}
    log $ append "AsNestedTuple - FieldCount 1: " $ show $ asNestedTuple { singleValue: 1 }
    log $ append "AsNestedTuple - FieldCount 2: " $ show $ asNestedTuple { multi: 1, value: 2 }
    log $ append "AsNestedTuple - FieldCount 4: " $ show $ asNestedTuple { a: 1, b: unit, c: "stuff", d: Just 4 }

data AsNestedTuple = AsNestedTuple

instance Folding AsNestedTuple Unit fieldType (Tuple fieldType Unit) where
  folding AsNestedTuple u next = Tuple next u

else instance Folding AsNestedTuple tupleAcc fieldType (Tuple fieldType tupleAcc) where
  folding AsNestedTuple acc next = Tuple next acc

-- | Converts a record into a heterogeneous list using Tuples
asNestedTuple
  :: forall rowsIn rowsInRL nestedTuple
   . RL.RowToList rowsIn rowsInRL
  => HFoldl AsNestedTuple Unit { | rowsIn } nestedTuple
  => { | rowsIn }
  -> nestedTuple
asNestedTuple r = hfoldl AsNestedTuple unit r

--------------------------------------------------------------------

demoFoldingWithIndex :: Effect Unit
demoFoldingWithIndex = do
  printSection "FoldingWithIndex" do
    let
      prefix = RenameFields :: RenameFields (Prepend "prefix-")
      suffix = RenameFields :: RenameFields (Append "-suffix")

    log $ append "Prefix: " $ show (renameFields prefix { one: 1, two: "foo" })
    log $ append "Suffix: " $ show (renameFields suffix { one: 1, two: "foo" })

data RenameFields :: FieldRenamer -> Type
data RenameFields renamer = RenameFields

-- define our custom kind
foreign import data FieldRenamer :: Type
foreign import data Prepend :: Symbol -> FieldRenamer
foreign import data Append :: Symbol -> FieldRenamer

instance
  ( Append prefix fieldName newName
  , IsSymbol newName
  , Row.Lacks newName withoutNewField
  , Row.Cons newName fieldType withoutNewField withNewField
  ) =>
  FoldingWithIndex (RenameFields (Prepend prefix)) (Proxy fieldName) { | withoutNewField } fieldType { | withNewField } where
  foldingWithIndex RenameFields _ acc next =
    Record.insert (Proxy :: Proxy newName) next acc

else instance
  ( Append fieldName suffix newName
  , IsSymbol newName
  , Row.Lacks newName withoutNewField
  , Row.Cons newName fieldType withoutNewField withNewField
  ) =>
  FoldingWithIndex (RenameFields (Append suffix)) (Proxy fieldName) { | withoutNewField } fieldType { | withNewField } where
  foldingWithIndex RenameFields _ acc next =
    Record.insert (Proxy :: Proxy newName) next acc

-- | Converts `{ foo: Tuple 1 true }` into either
-- | 1. `{ "prefix-foo": Tuple 1 true }`
-- | 2. `{ "foo-suffix": Tuple 1 true }`
renameFields
  :: forall rowsIn rowsInRL modification rowsOut
   . RL.RowToList rowsIn rowsInRL
  => HFoldlWithIndex (RenameFields modification) {} { | rowsIn } { | rowsOut }
  => RenameFields modification
  -> { | rowsIn }
  -> { | rowsOut }
renameFields renamer r = hfoldlWithIndex renamer {} r
