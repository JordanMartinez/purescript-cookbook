module Service.HTTP where

import Control.Monad.Except.Checked (ExceptV)
import Data.Variant (SProxy(..), Variant, inj)
import Prelude (class Monad, Unit, pure, unit)
import Type.Row (type (+))

-- | This module is an empty definition for an exception raising monadic interface to Http service

-- | Here's the fake HTTP monad for demonstration purposes
class (Monad m) <= MonadHttp m

-- | we wish to export this checked-exception wrapper for some underlying HTTP operation
get ∷ ∀ r m.
  MonadHttp m ⇒ 
  String ->
  ExceptV (HttpError + r) m String
-- | NB this is the point where you'd connect to the underlying GET, POST etc
get url = pure "dummy result from getHttp"


-- Typed exceptions that can arise in MonadHttp
type HttpServerError r = (httpServerError ∷ String | r)
type HttpNotFound    r = (httpNotFound ∷ Unit | r)
type HttpOther       r = (httpOther ∷ { status ∷ Int, body ∷ String } | r)

httpServerError ∷ ∀ r. String → Variant (HttpServerError + r)
httpServerError = inj (SProxy ∷ SProxy "httpServerError")

httpNotFound ∷ ∀ r. Variant (HttpNotFound + r)
httpNotFound = inj (SProxy ∷ SProxy "httpNotFound") unit

httpOther ∷ ∀ r. Int → String → Variant (HttpOther + r)
httpOther status body = inj (SProxy ∷ SProxy "httpOther") { status, body }

-- | Open row of exceptions that can be raised here, allowing for unification with
-- | other open rows such as, in this recipe, the FsError row
type HttpError r =
  ( HttpServerError
  + HttpNotFound
  + HttpOther
  + r
  )
