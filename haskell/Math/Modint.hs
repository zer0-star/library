newtype Modint (m :: Nat) = Modint Int
  deriving (Eq)
  deriving newtype (Unboxable, Show)
 
getmod :: forall m. KnownNat m => Modint m -> Int
getmod = fromInteger . natVal
 
instance KnownNat m => Num (Modint m) where
  t@(Modint x) + (Modint y) = Modint $ (x + y) `mod` modulus
   where
    modulus = getmod t
 
  t@(Modint x) * (Modint y) = Modint $ (x * y) `mod` modulus
   where
    modulus = getmod t
 
  abs = id
 
  signum = Modint . fromEnum . (/= 0)
 
  negate 0 = 0
  negate t@(Modint x) = Modint $ modulus - x where modulus = getmod t
 
  fromInteger n = Modint $ n' `mod` modulus
   where
    n' = fromInteger n
    modulus = getmod (fromInteger n :: Modint m)
 
instance KnownNat m => Fractional (Modint m) where
  recip t@(Modint x) = Modint $ aux x modulus 1 0 `mod` modulus
   where
    modulus = getmod t
    aux _ 0 u _ = u
    aux a b u v = let t = a `div` b in aux b (a - t * b) v (u - t * v)
 
  fromRational r = x / y
   where
    x = fromInteger (numerator r)
    y = fromInteger (denominator r)
