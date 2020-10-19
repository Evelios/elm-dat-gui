module List.Extra exposing (appendIf)

{-|

@docs appendIf

-}


{-| -}
appendIf : Bool -> a -> List a -> List a
appendIf value a list =
    if value then
        list ++ [ a ]

    else
        list
