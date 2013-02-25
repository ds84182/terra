function failit(match,fn)
	local success,msg = pcall(fn)
	if success then
		error("failed to fail.",2)
	elseif not string.match(msg,match) then
		error("failed wrong: "..msg,2)
	end
end
local test = require("test")
local erd = "Errors reported during"

local terra f1()
	return test
end

failit(erd,function()
f1:compile()
end)
failit("attempting to compile a function which already has an error",function()
f1:compile()
end)
failit(erd,function()
	local terra foo()
		f1()
	end
	foo()
end)


local struct A {
	a : int
}

A.metamethods.__finalizelayout = function(self)
	error("I AM BAD")
end

failit(erd,function()
	A:freeze()
end)

failit(erd,function()
	local terra foo()
		var a : A
	end
	foo()
end)
