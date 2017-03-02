Design `anyReq`, `allReq`
====

-- any 0101 0000 = True : there are no request
-- any 0101 0100 = True : there is a intersection
-- any 0101 1000 = False : there is no intersection
-- any 0101 1100 = True : there is a intersection
-- any 0101 1111 = True : there are intersections
-- non-intersection : No meaning, but no request is meaning(True)
-- intersection : True when exist

anyReq f1 f2 = (f2 == zeroBits) || (f1 .&. f2) /= zeroBits



-- all : (obj .&. req) == req -> eqAbout req obj req

allReq f1 f2 = ()
