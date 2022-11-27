class 'UISpace' : extends(UI)

function UISpace:init(nw, nh)
    UI.init(self)
    
    self.nw = nw or 1
    self.nh = nh or 1
    
    self:setstyles{bgColor = transparent}
end

function UISpace:computeSize()
    UI.computeSize(self)
	self.size.x = ws(self.nw)
--	self.size.y = hs(self.nw)
end
