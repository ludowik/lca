class 'Button' : extends(UI)

function Button:init(label, callback)
    UI.init(self, label, callback)
    
    self.styles.bgColor = blue
end
