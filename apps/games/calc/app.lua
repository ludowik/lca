-- AppCalc

App('AppCalc')

function AppCalc.setup()
    supportedOrientations(PORTRAIT)
end

function AppCalc:init()
    Application.init(self)

    setupUnit()

    self.unites = unites[readProjectData("unite", "devise")] or unites[1]

    self.unites.uniteSaisie = readProjectData("uniteSaisie", self.unites.uniteSaisie)
    if self.unites[self.unites.uniteSaisie] == nil then
        self.unites.uniteSaisie = self.unites.uniteDeBase
    end

    self.unites.uniteConvertie = readProjectData("uniteConvertie", self.unites.uniteConvertie)
    if self.unites[self.unites.uniteConvertie] == nil then
        self.unites.uniteConvertie = self.unites.uniteDeBase
    end

    self.ui.alignment = 'v-center,h-center'

    self.calc = Calc()

    self:initUI()
    self:ac()

    parameter.watch('app.calc.acc1')
    parameter.watch('app.calc.acc2')
    parameter.watch('app.calc.accOperator')
    parameter.watch('app.calc.intPart')
end

function AppCalc:initUI()
    self.uiCalc = Node(Layout.column)

    self.ui:add(self.uiCalc)	

    function setProperties(node, id)
        local row = Node(Layout.row)
        node:add(row)

        local unite = Button()
        row:add(unite)

        unite.fixedSize = size(1, 0.5)
        unite.callback = function ()
            self:pushUI(ChoiceList("unite?", self.unites, function (unite)
                        self.unites[id] = unite.abrev
                        saveProjectData(id, unite.abrev)
                        self:setResult(self.valeurSaisie)
                        self:popUI()
                    end))
        end

        local valeur = Label()
        row:add(valeur)

        valeur.fixedSize = size(2, 0.55)
        valeur.alignmentMode = 'right'
        valeur.unite = unite

        return valeur
    end

    self.uniteLabel = Button('unite'):attribs{
        fixedSize = size(4, 1),
        callback = function ()
            self:pushUI(ChoiceList("unites?", unites, function (unite)
                        self.unites = unite
                        saveProjectData("unite", unite.abrev)
                        self:setResult(self.valeurSaisie)
                        self:popUI()
                    end))
        end
    }
    self.uiCalc:add(self.uniteLabel)

    self.conversion = setProperties(self.uiCalc, "uniteConvertie")
    self.result = setProperties(self.uiCalc, "uniteSaisie")

    local Button = function (label, textColor, bgColor, w, h, object, f)
        local button = Button(label, callback(object, f))
        button.styles.bgColor = bgColor
        button.styles.textColor = textColor
        button.styles.fontSize = 60
        button.fixedSize = vec2(w, h)
        return button
    end

    self.buttons = Node():setLayoutFlow(Layout.grid, 4)
    self.uiCalc:add(self.buttons)

    local w = WIDTH > HEIGHT and hs(1, 5) or ws(1, 5)

    self.buttons:add(
        Button('AC' , white, darkgray, w, w, self, self.ac),
        Button('+/-', white, darkgray, w, w, self, self.sign),
        Button('%', white, darkgray,   w, w, self, self.percent),
        Button('/', white, orange, w, w, self, self.operator),

        Button('7', white, gray, w, w, self, self.number),
        Button('8', white, gray, w, w, self, self.number),
        Button('9', white, gray, w, w, self, self.number),
        Button('X', white, orange, w, w, self, self.operator),

        Button('4', white, gray,  w, w, self, self.number),
        Button('5', white, gray,  w, w, self, self.number),
        Button('6', white, gray,  w, w, self, self.number),
        Button('-', white, orange, w, w, self, self.operator),

        Button('1', white, gray,  w, w, self, self.number),
        Button('2', white, gray,  w, w, self, self.number),
        Button('3', white, gray,  w, w, self, self.number),
        Button('+', white, orange, w, w, self, self.operator),

        Button('0', white, gray,  w*2+Layout.innerMarge, w, self, self.number),
        Button(',', white, gray,  w, w, self, self.decimal),
        Button('=', white, orange, w, w, self, self.operator)
    )

    self:setResult(0)

    parameter.watch('app.calc.acc1')
    parameter.watch('app.calc.acc2')
    parameter.watch('app.calc.accOperator')
end

function AppCalc:setResult(vs)
    local us = self.unites.uniteSaisie
    local uc = self.unites.uniteConvertie

    local vc = vs * self.unites[uc].coef / self.unites[us].coef

    self.valeurSaisie = vs
    self.valeurConvertie = vc

    self.uniteLabel.label = self.unites.name

    self.result.label = tostring(vs)
    self.result.unite.label = self.unites[us].abrev

    self.conversion.label = tostring(vc)
    self.conversion.unite.label = self.unites[uc].abrev
end

function AppCalc:ac()
    self.calc:ac()
    self:setResult(self.calc.acc1)
end

function AppCalc:number(button)
    self.calc:number(tonumber(button.label))
    self:setResult(self.calc.acc1)
end

function AppCalc:decimal()
    self.calc:decimal()
end

function AppCalc:sign()
    self.calc:sign()
    self:setResult(self.calc.acc1)
end

function AppCalc:percent()
end

function AppCalc:operator(button)
    self.calc:operator(button.label)
    self:setResult(self.calc.acc2)
end