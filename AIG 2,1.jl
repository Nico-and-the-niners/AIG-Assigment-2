import Pkg
Pkg.add("OffsetArrays")

# retunrs max value of items in bag
Sack(W, wt, val, n)= 

# Base Case 

if n == 0  W == 0
 return 0

#if the nth item is baigger then capacity it wont be in optimal soultion

    
    elseif (wt[n-1] > W) 
return Sack(W, wt, val, n-1)
    
    
	# return the maximum of two cases
else 
  totalv = max(val[n-1] + Sack(W-wt[n-1], wt, val, n-1), Sack(W, wt, val, n-1))
 totalw =  wt
		return totalv
        return totalw
   
   
    
end
# end of function knapSack 






using OffsetArrays
val = OffsetVector([40, 60, 80, 120], 0:3)
wt = OffsetVector([15, 10, 20, 30], 0:3)
W = 50
n = length(val)

TotalValue = Sack(W, wt, val, n) 

 println("Items in the bag")
for i in ((val) )
         #@show i
  cont =  Sack(W, wt, val, n) - i
   # @show cont
   if   cont in (val)
       item = findall(val -> val == cont,val)
        @show item
    end
    
       end
 println("")
 println("The total value of items in bag")
@show TotalValue



  














