--// CLASS DECLARATION
local SignalConnection = {}
SignalConnection.__index = SignalConnection


--// GENERAL VARIABLES


--// TYPE DECLARATIONS
type SignalConnectionBase = {
    connected: boolean,
    disconnectFunction: () -> (),
}

export type SignalConnection = typeof(setmetatable({}, SignalConnection))


--// CLASS CONSTRUCTOR
function SignalConnection.new(_disconnectFunction: () -> ()): SignalConnection
    local self: SignalConnectionBase = {
        connected = true,
        disconnectFunction = _disconnectFunction
    }

    return setmetatable(self, SignalConnection)
end


--// CLASS METHODS
function SignalConnection:Disconnect(): ()
    if (not self.connected) then return end

    self.connected = false
    self.disconnectFunction()
end


--// CLASS END
return SignalConnection