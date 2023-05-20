function _generateRngCacheKey(r)
	return string.format('%s-%s-%s', r.Rng1, r.Rng2, r.FrameCount)
end

RngCache = {
	_addrList = nil, -- Address list dependency
	_rngCache = {},	
	Clear = function(self)
		self.rngCache = {}
	end,
	Add = function(self)
		local r = {
			Rng1 = self._addrList.Rng1:Read(),
			Rng2 = self._addrList.Rng2:Read(),
			FrameCount= emu.framecount()
		}
		local key = _generateRngCacheKey(r)
		if self._rngCache[key] == nil then
			self._rngCache[key] = r
			return true
		end

		return false
	end,
	Length = function(self)
		local count = 0
		for _ in pairs(self._rngCache) do
			count = count + 1
		end
		return count
	end,
	Log = function(self)
		console.log(string.format('RNG: %s', self:Length()))
	end
}

function RngCache:new(addrList)
	if not addrList then
		error('RngCache requires an address object')
	end
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj._addrList = addrList
    return obj
end
