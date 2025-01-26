local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vFishyTurtle/SN-Lib/main/src'))()
local lib = Library:CreateWindow({Title = "YunexHub"})

-- Variables for Webhook Setup
local webhookURL = "" -- To be set in the UI
local recipientName = ""
local amountToGive = 0

-- Function to send a test message to the webhook
local function sendTestMessage()
    if webhookURL == "" then
        lib:Notify({
            Title = "Error",
            Content = "Webhook URL is not set!",
            Duration = 5,
        })
        return
    end

    local HttpService = game:GetService("HttpService")
    local data = {
        ["username"] = "Test Bot",
        ["content"] = "This is a test message to verify your webhook.",
    }

    local success, error = pcall(function()
        HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        lib:Notify({
            Title = "Success",
            Content = "Test message sent successfully!",
            Duration = 5,
        })
    else
        lib:Notify({
            Title = "Error",
            Content = "Failed to send test message: " .. tostring(error),
            Duration = 5,
        })
    end
end

-- Function to log money transaction to webhook
local function logTransaction(admin, recipient, amount)
    if webhookURL == "" then
        lib:Notify({
            Title = "Error",
            Content = "Webhook URL is not set!",
            Duration = 5,
        })
        return
    end

    local HttpService = game:GetService("HttpService")
    local data = {
        ["username"] = "Money Logger",
        ["embeds"] = {
            {
                ["title"] = "Money Given",
                ["description"] = string.format("**Admin:** %s\n**Recipient:** %s\n**Amount:** %d", admin.Name, recipient.Name, amount),
                ["color"] = 0x00FF00, -- Green color
            }
        },
    }

    local success, error = pcall(function()
        HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        lib:Notify({
            Title = "Error",
            Content = "Failed to log transaction: " .. tostring(error),
            Duration = 5,
        })
    end
end

-- Create Money Giver UI
local t1 = lib:NewTab({Name = "Money Giver"})

-- Adding a Section for Webhook Setup
local s1 = t1:NewSection({Name = "Webhook Setup"})

-- Webhook URL Input
s1:NewTextBox({
    Name = "Webhook URL",
    PlaceholderText = "Enter Webhook URL",
    Callback = function(text)
        webhookURL = text
        lib:Notify({
            Title = "Webhook Set",
            Content = "Webhook URL has been updated!",
            Duration = 5,
        })
    end,
})

-- Test Webhook Message Button
s1:NewButton({
    Name = "Test Webhook",
    Callback = function()
        sendTestMessage()
    end,
})

-- Adding a Section for Money Giving
local s2 = t1:NewSection({Name = "Give Money"})

-- Recipient Username Input
s2:NewTextBox({
    Name = "Recipient Username",
    PlaceholderText = "Enter Recipient Username",
    Callback = function(text)
        recipientName = text
    end,
})

-- Amount Input
s2:NewTextBox({
    Name = "Amount to Give",
    PlaceholderText = "Enter Amount",
    Callback = function(text)
        amountToGive = tonumber(text)
    end,
})

-- Give Money Button
s2:NewButton({
    Name = "Give Money",
    Callback = function()
        local player = game.Players.LocalPlayer

        -- Admin check (you can replace this logic with your own permission system)
        if player.UserId ~= 12345678 then -- Replace with your UserId
            lib:Notify({
                Title = "Permission Denied",
                Content = "You are not authorized to use this tool.",
                Duration = 5,
            })
            return
        end

        -- Check for valid input
        if webhookURL == "" then
            lib:Notify({
                Title = "Error",
                Content = "Webhook URL is not set!",
                Duration = 5,
            })
            return
        end

        local recipient = game.Players:FindFirstChild(recipientName)
        if not recipient then
            lib:Notify({
                Title = "Error",
                Content = "Recipient not found!",
                Duration = 5,
            })
            return
        end

        if not amountToGive or amountToGive <= 0 then
            lib:Notify({
                Title = "Error",
                Content = "Invalid amount to give!",
                Duration = 5,
            })
            return
        end

        -- Give the money to the recipient
        local leaderstats = recipient:FindFirstChild("leaders
