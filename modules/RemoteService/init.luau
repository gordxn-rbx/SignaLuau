--[[
@module

RemoteService is a robust and secure networking utility aimed at reducing boilerplate for setting up client-server communications.
RemoteService also handles local client-client and server-client communication.
]]
local RemoteService = {}


--// DEPENDENCIES 
local Error = require("@self/Utils/Error")
local Subscription = require("@self/Core/Subscription")
local Registry = require("@self/Core/Registry")


--// VARIABLES
local RunService = game:GetService("RunService")


--// LOCAL FUNCTIONS


--[[
@param eventName
]]
RemoteService.On = function(eventName: string, callback: any): (boolean, string | 'function')
	if (eventName == nil) or (type(eventName) ~= "string") then
		return false, Error.Throw(Error.UndefinedException, "'eventName' must not be nil and must be a valid 'string'.")	
	end
	
	if (callback == nil) or (typeof(callback) ~= "function") then
		return false, Error.Throw(Error.UndefinedException, "'callback' must not be nil and must be a valid 'function'.")	
	end

	local disconnectCallback = Subscription.Subscribe(eventName, callback)
	
	return true, disconnectCallback
end

if (RunService:IsServer()) then
	Registry.ValidateRegistry()

	local Wrapper = require("@self/Server/Wrapper")
	require("@self/Server/Dispatch")
	require("@self/Core/Dispatch")
	
	RemoteService.FireClient = Wrapper.FireClient
	RemoteService.FireAllClients = Wrapper.FireAllClients
	RemoteService.FireLocal = Wrapper.FireLocal
elseif (RunService:IsClient()) then
	local Wrapper = require("@self/Client/Wrapper")
	require("@self/Client/Dispatch")
	
	RemoteService.FireServer = Wrapper.FireServer
	RemoteService.FireLocal = Wrapper.FireLocal
	RemoteService.FireAllLocal = Wrapper.FireAllLocal
else
	Error.Throw(Error.UndefinedException, "Unable to determine client/server status")
end


--// MODULE END
return RemoteService
