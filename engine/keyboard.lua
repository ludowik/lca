function showKeyboard()
    love.keyboard.setTextInput(true)
end

function hideKeyboard()
    love.keyboard.setTextInput(false)
end

function isKeyboardShowing()
    return love.keyboard.hasTextInput()
end
