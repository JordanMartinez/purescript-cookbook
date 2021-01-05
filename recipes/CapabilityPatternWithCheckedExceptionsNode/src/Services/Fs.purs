module Service.FS where

import Prelude (class Monad, Unit, pure, unit)

import Type.Row (type (+))
import Control.Monad.Except.Checked (ExceptV)
import Data.Variant (SProxy(..), inj, Variant)
import Node.Path (FilePath)

-- | This module is an empty definition for an exception raising monadic interface to a file system

-- | Here's the fake file system monad for demonstration purposes
class (Monad m) <= MonadFs m

-- | we wish to export this checked-exception wrapper for some underlying FS operation
write ∷ ∀ r m. MonadFs m ⇒ 
  FilePath → String → ExceptV (FsError + r) m Unit
-- | NB this is the point where you'd connect to the underlying infrastructure such as NodeFS
write filePath string = pure unit 

-- | Typed exceptions that can arise in MonadFS
type FsPermissionDenied r = (fsPermissionDenied ∷ Unit | r)
type FsFileNotFound r     = (fsFileNotFound ∷ FilePath | r)

fsPermissionDenied ∷ ∀ r. Variant (FsPermissionDenied + r)
fsPermissionDenied = inj (SProxy ∷ SProxy "fsPermissionDenied") unit

fsFileNotFound ∷ ∀ r. FilePath → Variant (FsFileNotFound + r)
fsFileNotFound = inj (SProxy ∷ SProxy "fsFileNotFound")

-- | Open row of exceptions that can be raised here, allowing for unification with
-- | other open rows such as, in this recipe, the HttpError row
type FsError r =
  ( FsPermissionDenied
  + FsFileNotFound
  + r
  )

