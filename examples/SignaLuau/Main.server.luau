local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SignaLuau = require(ReplicatedStorage.Modules.SignaLuau)
type SignalConnection = SignaLuau.SignalConnection
type Signal<T...> = SignaLuau.Signal<T...>

local Object = require(script.Parent.Object)
type Object = Object.Object

local testObject: Object = Object.new("Test", "")

local testConn: SignalConnection = testObject.ValueUpdated:Connect(function(newValue: string)
    print(newValue)
    print(testObject.Value)
end)

testObject:UpdateValue("testValue1")
testConn:Disconnect()
testObject:UpdateValue("testValue2")