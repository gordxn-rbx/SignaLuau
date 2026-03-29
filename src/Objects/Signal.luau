--// DEPENDENCIES
local SignalConnection = require("./SignalConnection")


--// CLASS DECLARATION
local Signal = {}
Signal.__index = Signal


--// GENERAL VARIABLES



--// TYPE DECLARATIONS
export type SignalConnection = SignalConnection.SignalConnection

type SignalBase = {
    callbacks: {
        () -> ()
    },
    middleware: {
        () -> ()
    }
}

export type Signal = typeof(setmetatable({}, Signal))


--// CLASS CONSTRUCTOR
function Signal.new(): Signal
    local self = {
        callbacks = {},
        middleware = {}
    }

    return setmetatable(self, Signal)
end


--// CLASS METHODS
function Signal:Connect(callback: () -> ()): ()
    table.insert(self.callbacks, callback)

    local connection: SignalConnection = SignalConnection.new(function()
        for i: number, _callback: () -> () in pairs(self.callbacks) do
            if (_callback ~= callback) then continue end

            table.remove(self.callbacks, i)
            break
        end
    end)

    return connection
end

function Signal:Once(callback: () -> ()): ()
    local connection: SignalConnection
    connection = self:Connect(function(...)
        connection:Disconnect()
        pcall(callback, ...)
    end)

    return connection
end

function Signal:Fire(...: any): ()
    for _: any, callback: () -> () in pairs(self.callbacks) do
        pcall(callback, ...)
     end
end

function Signal:FireAsync(...: any): ()
    for _: any, callback: () -> () in pairs(self.callbacks) do
        task.spawn(pcall, callback, ...)
     end
end


--// CLASS END
return Signal