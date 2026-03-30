--[=[
@class SignalConnection

A `SignalConnection` object exposes methods for managing a specific connection.

Basic Implementation:
```lua
local signal: Signal = Signal.new()

local connection: SignalConnection = signal:Connect(function(msg: string): ()
    print(msg)
end)

signal:Fire("Hello, world!")
connection:Disconnect()
```
]=]
local SignalConnection = {}
SignalConnection.__index = SignalConnection


--// TYPE DECLARATIONS
type SignalConnectionInternal = {
    connected: boolean,
    disconnectFunction: () -> (),
}

--[=[
@within SignalConnection
@interface SignalConnection

.Connected boolean
.Connect (SignalConnection) -> ()
]=]
export type SignalConnection = {
    Connected: boolean,
    Disconnect: (self: SignalConnection) -> ()
}


--[=[
Returns a constructed `Signal` object with the proper `disconnectFunction`.

@param disconnectFunction Function
@return SignalConnection
]=]
function SignalConnection.new(disconnectFunction: () -> ())
    local internal: SignalConnectionInternal = {
        connected = true,
        disconnectFunction = disconnectFunction
    }

    local meta = {
        __index = function(table: {}, key: any)
            if (key == "Connected") then
                return table["internal"]["connected"]
            end

            return SignalConnection[key]
        end,

        __newindex = function(table: {}, key: any, value: any)
            return nil
        end
    }

    local self = {
        internal = internal
    }

    return setmetatable(self, meta)
end


--[=[
Disconnects a `SignalConnection` from the signal.
]=]
function SignalConnection:Disconnect(): ()
    if (not self.internal.connected) then return end

    self.internal.connected = false
    self.internal.disconnectFunction()
end


--// CLASS END
return SignalConnection