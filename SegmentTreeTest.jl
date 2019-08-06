include("SegmentTree.jl")

#test code
println("create a SegmentTree with the code:")
println("\tst = SegmentTree([1,2,3,4,5,6,7,8,9,10],+,0)")
st = SegmentTree([1,2,3,4,5,6,7,8,9,10],+,0)
println("index 1, index 2, index 3")
println(string(get_one(st,1))*" "*string(get_one(st,2))*" "*string(get_one(st,3)))
println("sum from index 1 to index 3")
println(get(st,1,3))
println("add 2 to index 1")
add!(st,1,2)
println("index 1, index 2, index 3")
println(string(get_one(st,1))*" "*string(get_one(st,2))*" "*string(get_one(st,3)))
println("sum from index 1 to index 3")
println(get(st,1,3))
println("sum from index 3 to index 7")
println(get(st,3,7))

println("")

println("choose max as an operator")
int64_min = -2^63
println("\tst = SegmentTree([1,2,3,4,5,6,7,8,9,10],max,int64_min)")
println("the identity element is -inf, but now we use -2^63 as the identity element because it is the minimum value of Int64")
st_max = SegmentTree([1,2,3,4,5,6,7,8,9,10],max,int64_min)
println("max from index 3 to index 7")
println(get(st_max,3,7))
println("add 5 to index 4")
add!(st_max,4,5)
println("now the base array is [1,2,3,9,5,6,7,8,9,10]")
println("index 4")
println(get_one(st_max,4))
println("max from index 3 to index 7")
println(get(st_max,3,7))